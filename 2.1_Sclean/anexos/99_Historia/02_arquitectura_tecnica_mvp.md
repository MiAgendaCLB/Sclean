# Arquitectura Técnica — MVP App de Preparación Documental (proyecto Vive)

Basado en la especificación funcional cerrada (`prompt_app_gestion_documental.md`). No modifica requisitos funcionales, solo define cómo se implementan.

---

## 1. Principio de portabilidad (restricción de diseño, no negociable)

Requisito del usuario: portable, local, sin mantenimiento. Toda decisión técnica de aquí en adelante se filtra por esto:
- Sin servidor externo, sin nube, sin base de datos que administrar.
- Un solo ejecutable/carpeta que corre con doble clic.
- Cero dependencia de internet en el flujo principal (la IA bajo demanda es la única excepción, y es opcional).

---

## 2. Stack

| Capa | Elección | Justificación |
|---|---|---|
| Lenguaje/backend | Python | Todo el ecosistema de PDF/OCR necesario (`pikepdf`, `OCRmyPDF`, `pytesseract`) es nativo de Python. |
| Base de datos | SQLite (archivo único `.db`) | Cero servidor, cero configuración, terreno conocido del usuario (SQL). |
| Manejo de PDF (segmentar/unir) | `pikepdf` | Manipula páginas sin recomprimir ni degradar. |
| OCR | `OCRmyPDF` (envuelve Tesseract) | Ya incluye deskew y limpieza básica; evita reimplementarántiguas fases del pipeline de restauración. |
| Restauración de imagen (módulo opcional, desactivado por defecto) | `OpenCV` | Solo se invoca si el análisis de calidad lo justifica; no corre por defecto. |
| Interfaz | HTML/JS servido en `localhost` por el propio backend | Sin build, sin framework, el usuario abre una pestaña. |
| Empaquetado | `PyInstaller --onefile` para el código Python + binarios de Tesseract, Ghostscript y qpdf incluidos explícitamente en la carpeta de distribución (no dependen de instalación previa en el equipo destino) | Un solo paquete portable; el empaquetado del código por sí solo no incluye estos binarios externos, deben añadirse aparte para cumplir "sin mantenimiento". |

---

## 3. Estructura de módulos

```
/app
  main.py                  → arranca servidor local + abre navegador
  /core
    ingest.py               → carga y valida PDFs de entrada
    segmentation.py          → separa un PDF en documentos (pikepdf)
    text_extraction.py       → obtiene texto: capa nativa del PDF si existe, si no dispara OCR
    ocr.py                   → wrapper de OCRmyPDF, embebe texto oculto
    classification/
      engine.py              → orquesta el orden: reglas SQL → reglas institución → sin resolver
      rules_repository.py    → lee/escribe reglas_clasificacion en SQLite
    naming.py                → arma el nombre de archivo desde metadatos confirmados
    duplicates.py            → hash + comparación de texto
    file_ops.py              → mover/renombrar con idempotencia, dry-run, log
    restoration.py           → módulo opcional de OpenCV, desactivado por defecto
  /web
    index.html, app.js       → interfaz de revisión/confirmación
  /data
    vive_docs.db             → base SQLite
    /logs                    → logs persistentes de operaciones
```

---

## 4. Pipeline técnico (orden de ejecución real)

Resuelve la dependencia detectada en la revisión anterior: las reglas necesitan texto para evaluarse, así que la extracción de texto va primero, antes de aplicar cualquier regla — esto no contradice el orden funcional decidido (SQL → institución → OCR), solo aclara que "OCR" en ese orden significa "si la extracción nativa no bastó, se refuerza con OCR completo antes de reintentar las reglas".

1. **Ingesta**: valida que el PDF abre correctamente. Si falla → estado `NO PROCESADO`, motivo "archivo corrupto".
2. **Extracción de texto por página (paso técnico, no funcional)**:
   - Intenta leer la capa de texto nativa de cada página del PDF.
   - Si no hay texto o es insuficiente, ejecuta OCR completo (`OCRmyPDF`) sobre el documento para obtener texto por página y a la vez dejarlo embebido oculto en el PDF final.
3. **Clasificación por página** (motor `classification/engine.py`), en el orden funcional decidido, evaluado página por página con el texto ya disponible:
   a. Reglas SQL generales (`entidad_id IS NULL`).
   b. Reglas por institución (`entidad_id` específico), evaluadas si las generales no resolvieron todos los campos obligatorios.
   c. Si tras (a) y (b) no quedan resueltos los campos obligatorios (sigla + miembro) para una página → esa página queda marcada como sin clasificar.
4. **Segmentación**: con la clasificación de cada página ya resuelta, se agrupan las páginas contiguas que comparten tipo documental (sigla) en un solo sub-documento (`pikepdf`). Las páginas sin clasificar se separan aparte y el sub-documento resultante pasa a estado `NO PROCESADO`.
5. **Confirmación humana (obligatoria, no salteable)**: el usuario revisa y confirma o corrige antes de continuar. Este paso faltaba explícito en el flujo anterior — queda fijado aquí como paso obligatorio del pipeline, no solo como principio de UX.
6. **Restauración condicional**: solo si el análisis de calidad de la página lo amerita (regla ya fijada: página buena no se toca).
7. **Nomenclatura**: aplica la fórmula ya cerrada (`AAAAMMDD_SIGLA_EspecialidadOAsunto_Entidad_Miembro.ext`).
8. **Operación de archivo**: mover/renombrar con idempotencia + dry-run + log (reglas ya definidas).
9. **Marcado como `LISTO PARA IMPORTAR`** según el contrato de salida ya cerrado, y colocación en la carpeta de salida (ver sección 6).

---

## 5. Modelo de datos (SQLite)

```sql
-- Catálogos (Glosario), todos con soporte "Otro → crear nuevo"
CREATE TABLE glosario_siglas (
  id INTEGER PRIMARY KEY,
  codigo TEXT UNIQUE NOT NULL,       -- HC, OS, FM, IS, CI, EM, ...
  nombre TEXT NOT NULL,
  activo INTEGER DEFAULT 1
);

CREATE TABLE glosario_especialidades (
  id INTEGER PRIMARY KEY,
  nombre TEXT NOT NULL,
  activo INTEGER DEFAULT 1
);

CREATE TABLE glosario_entidades (
  id INTEGER PRIMARY KEY,
  nombre TEXT NOT NULL,
  tipo TEXT CHECK(tipo IN ('prestador','aseguradora')) NOT NULL,
  activo INTEGER DEFAULT 1
);

CREATE TABLE personas (
  id INTEGER PRIMARY KEY,
  iniciales TEXT UNIQUE NOT NULL,     -- CLB, YHM, OLF, ...
  nombre_completo TEXT,
  activo INTEGER DEFAULT 1
);

-- Motor de reglas: una sola tabla, entidad_id NULL = regla general
CREATE TABLE reglas_clasificacion (
  id INTEGER PRIMARY KEY,
  entidad_id INTEGER REFERENCES glosario_entidades(id),  -- NULL = regla general (SQL), no NULL = regla por institución
  patron_texto TEXT NOT NULL,          -- patrón a buscar en el texto extraído
  sigla_id INTEGER REFERENCES glosario_siglas(id),
  modo_especialidad_asunto TEXT CHECK(modo_especialidad_asunto IN ('catalogo','extraido')) NOT NULL DEFAULT 'catalogo',
  especialidad_id INTEGER REFERENCES glosario_especialidades(id),  -- usado si modo_especialidad_asunto = 'catalogo'
  patron_extraccion TEXT,              -- usado si modo_especialidad_asunto = 'extraido' (ej. patrón de fecha para CI, línea de asunto para EM)
  prioridad INTEGER DEFAULT 100,
  activo INTEGER DEFAULT 1
);

-- Agrupación por evento (regla mínima de MVP: misma fecha + misma entidad + mismo miembro)
CREATE TABLE eventos (
  id INTEGER PRIMARY KEY,
  fecha TEXT NOT NULL,
  entidad_id INTEGER REFERENCES glosario_entidades(id),
  miembro_id INTEGER REFERENCES personas(id)
);

CREATE TABLE documentos (
  id INTEGER PRIMARY KEY,
  hash TEXT,
  ruta_original TEXT NOT NULL,
  nombre_original TEXT NOT NULL,
  ruta_actual TEXT,
  nombre_propuesto TEXT,
  fecha_documental TEXT,
  sigla_id INTEGER REFERENCES glosario_siglas(id),
  especialidad_asunto TEXT,
  entidad_id INTEGER REFERENCES glosario_entidades(id),
  miembro_id INTEGER REFERENCES personas(id),
  evento_id INTEGER REFERENCES eventos(id),
  estado TEXT CHECK(estado IN ('OK','RENOMBRAR','DUPLICADO','NO_PROCESADO','LISTO_PARA_IMPORTAR')) NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT
);

CREATE TABLE duplicados (
  id INTEGER PRIMARY KEY,
  documento_id INTEGER REFERENCES documentos(id),
  documento_oficial_id INTEGER REFERENCES documentos(id),
  tipo_deteccion TEXT CHECK(tipo_deteccion IN ('hash','contenido')) NOT NULL
);

CREATE TABLE log_operaciones (
  id INTEGER PRIMARY KEY,
  documento_id INTEGER REFERENCES documentos(id),
  accion TEXT NOT NULL,               -- 'movido','ya_existia','error','ocr','clasificado', etc.
  resultado TEXT NOT NULL,
  detalle TEXT,
  timestamp TEXT DEFAULT CURRENT_TIMESTAMP
);
```

**Regla mínima de consolidación de evento (MVP, ya acordado como no bloqueante pero necesario para que el pipeline corra):** un documento se asocia a un `evento` existente si coincide en fecha + entidad + miembro; si no hay coincidencia, se crea un evento nuevo. El refinamiento (ej. por médico o por rango horario) queda diferido, como ya se decidió.

**Definición operativa de "confianza suficiente" (necesaria para que el motor de reglas sea programable):** una clasificación se considera resuelta cuando una regla (general o por institución) determina valor para los dos campos obligatorios de la fórmula de nomenclatura (`sigla` y `miembro`). Si tras aplicar reglas generales y por institución alguno de los dos sigue sin valor, el documento pasa a `NO_PROCESADO`.

---

## 6. Carpeta de salida (contrato de salida, ubicación física)

```
/salida
  /Listos_para_importar
    20260515_HC_Psiquiatria_OportunidadDeVida_CLB.pdf
    20260515_OS_Psiquiatria_OportunidadDeVida_CLB.pdf
    ...
  /No_procesados
    (archivos que no se pudieron clasificar, sin tocar)
  /originales
    (copia de los PDFs de entrada, sin modificar, preservados siempre)
```

No hay integración automática con el gestor documental principal en esta versión: la entrega es dejar los archivos terminados en `Listos_para_importar`, con su registro correspondiente en `documentos.estado = 'LISTO_PARA_IMPORTAR'`. La importación al gestor principal es un paso manual o de una versión futura, fuera de este alcance.

---

## 7. Seguridad de operaciones de archivo (ya definida funcionalmente, aquí su implementación)

- Antes de mover/renombrar: `file_ops.py` verifica si el destino ya existe con el nombre final exacto; si existe, marca `ya_existia` en el log y no repite la operación.
- Modo prueba por defecto: toda operación de borrado corre primero en modo simulación (solo escribe en el log qué haría), requiere una confirmación explícita del usuario para ejecutar en modo real.
- Cada operación se registra en `log_operaciones`, con un registro final de resumen por lote procesado.
