# Plan de Implementación — MVP App de Preparación Documental (proyecto Vive)

Basado en la especificación funcional y la arquitectura técnica ya congeladas. Este documento no modifica ninguna decisión previa; únicamente organiza su construcción.

---

# 1. Objetivo del desarrollo

Construir una aplicación local y portable que reciba PDFs escaneados, extraiga su texto, clasifique cada página según el modelo de siglas ya definido (HC, OS, FM, IS, CI, EM), separe los documentos que correspondan, aplique la nomenclatura oficial una vez el usuario confirme los metadatos, y los deje organizados en una carpeta de salida como `LISTO_PARA_IMPORTAR`, sin administrar expedientes ni casos.

---

# 2. Estrategia de implementación

El desarrollo se ordena siguiendo la cadena real de dependencias de datos, no por módulo "importante primero":

1. Sin esquema de base de datos no hay dónde registrar nada — es la base de todo lo demás.
2. Sin texto extraído no hay nada que clasificar — la clasificación no puede construirse antes que la extracción.
3. Sin clasificación por página no se puede segmentar correctamente — segmentar antes es exactamente el error que ya se corrigió en la arquitectura.
4. Sin segmentación y clasificación no hay nada que mostrarle al usuario para confirmar.
5. Sin confirmación del usuario no hay metadatos definitivos para construir el nombre de archivo.
6. Sin nombre de archivo no se puede ejecutar la operación de archivo (mover/renombrar).
7. El módulo de restauración de imagen es opcional y no bloquea nada de lo anterior; se integra al final para no arriesgar el flujo principal mientras se estabiliza.
8. El empaquetado portable es lo último, porque solo tiene sentido empaquetar un sistema que ya funciona de punta a punta.

Esta cadena garantiza que cada módulo se pueda probar con datos reales de los que ya dispone (los PDFs usados en las pruebas de la especificación), en vez de con datos simulados.

---

# 3. Roadmap del MVP

### Fase 0 — Fundamentos de datos
- **Objetivo**: tener el esquema de base de datos creado y los catálogos (Glosario) precargados con lo ya validado (siglas HC/OS/FM/IS/CI/EM, especialidades e instituciones vistas en las pruebas, personas CLB/YHM/OLF).
- **Módulos involucrados**: capa de base de datos (tablas de la arquitectura).
- **Dependencias**: ninguna.
- **Criterio de terminada**: se puede insertar y consultar un registro de cada tabla sin error, y los catálogos tienen al menos los valores ya confirmados en las pruebas.

### Fase 1 — Ingesta y extracción de texto
- **Objetivo**: cargar uno o varios PDFs, validarlos, y obtener el texto de cada página (nativo u OCR).
- **Módulos involucrados**: `ingest.py`, `text_extraction.py`, `ocr.py`.
- **Dependencias**: Fase 0 (necesita la tabla `documentos` para registrar cada archivo cargado).
- **Criterio de terminada**: dado cualquiera de los PDFs ya usados en las pruebas, el sistema obtiene el texto completo de cada página, ya sea por capa nativa o por OCR, sin intervención manual.

### Fase 2 — Motor de clasificación
- **Objetivo**: aplicar el orden de reglas ya decidido (SQL generales → institución → sin resolver) sobre el texto de cada página.
- **Módulos involucrados**: `classification/engine.py`, `classification/rules_repository.py`.
- **Dependencias**: Fase 0 (tabla `reglas_clasificacion` y catálogos) y Fase 1 (texto disponible).
- **Criterio de terminada**: los documentos ya usados en las pruebas (Imbanaco, Oportunidad de Vida, Neurólogos de Occidente, el correo) quedan clasificados correctamente por sigla y miembro con reglas cargadas para esas instituciones.

### Fase 3 — Segmentación
- **Objetivo**: agrupar páginas contiguas con la misma sigla en un solo sub-documento.
- **Módulos involucrados**: `segmentation.py`.
- **Dependencias**: Fase 2 (necesita la clasificación por página ya resuelta).
- **Criterio de terminada**: el PDF de 11 páginas de Neurólogos de Occidente se separa correctamente en HC (4 páginas) y OS (6 páginas), dejando la incapacidad (CI) aparte.

### Fase 4 — Detección de duplicados
- **Objetivo**: identificar coincidencias por hash y por contenido de texto.
- **Módulos involucrados**: `duplicates.py`.
- **Dependencias**: Fase 1 (hash del archivo) y Fase 2 (texto para comparación de contenido).
- **Criterio de terminada**: dos copias del mismo documento con bytes distintos se marcan como duplicado por contenido, no solo por hash.

### Fase 5 — Interfaz de confirmación humana
- **Objetivo**: mostrar al usuario, por documento, la clasificación y segmentación propuestas, permitiéndole confirmar o corregir antes de continuar.
- **Módulos involucrados**: `web/index.html`, `web/app.js`, endpoints del backend que exponen resultados de las Fases 1-4.
- **Dependencias**: Fases 1 a 4 (necesita algo que mostrar).
- **Criterio de terminada**: el usuario puede ver el resultado de un lote cargado y confirmar/corregir cada documento con un clic, sin editar texto libre salvo donde la arquitectura lo permite (CI, EM).

### Fase 6 — Nomenclatura
- **Objetivo**: construir el nombre de archivo oficial a partir de los metadatos ya confirmados.
- **Módulos involucrados**: `naming.py`.
- **Dependencias**: Fase 5 (metadatos confirmados, no propuestos).
- **Criterio de terminada**: los nombres generados coinciden exactamente con los ya validados manualmente en las pruebas (ej. `20260515_HC_Psiquiatria_OportunidadDeVida_CLB.pdf`).

### Fase 7 — Operación de archivo
- **Objetivo**: mover/renombrar el archivo de forma segura, con idempotencia, modo prueba y log.
- **Módulos involucrados**: `file_ops.py`.
- **Dependencias**: Fase 6 (nombre ya definido).
- **Criterio de terminada**: ejecutar el proceso dos veces sobre el mismo archivo no produce error ni duplica la operación; el log queda completo con su resumen final.

### Fase 8 — Marcado de estado final y carpeta de salida
- **Objetivo**: dejar el documento en `Listos_para_importar` y su registro en `LISTO_PARA_IMPORTAR`.
- **Módulos involucrados**: orquestación entre `file_ops.py` y la tabla `documentos`.
- **Dependencias**: Fase 7.
- **Criterio de terminada**: un documento procesado de punta a punta queda visible en la carpeta de salida con el estado correcto en base de datos.

### Fase 9 — Restauración condicional (módulo opcional)
- **Objetivo**: aplicar mejora de imagen solo cuando el análisis de calidad lo justifique.
- **Módulos involucrados**: `restoration.py`.
- **Dependencias**: Fase 1 (necesita el PDF ya ingresado); no depende de las Fases 2-8, se integra como paso intermedio antes de la Fase 6.
- **Criterio de terminada**: una página de mala calidad (si aparece en pruebas futuras) se corrige sin alterar una página ya buena de otro documento del mismo lote.

### Fase 10 — Empaquetado portable
- **Objetivo**: distribuir la aplicación como carpeta/ejecutable único, con los binarios de Tesseract, Ghostscript y qpdf incluidos.
- **Módulos involucrados**: todo el proyecto + binarios externos.
- **Dependencias**: Fases 0 a 9 funcionando de punta a punta.
- **Criterio de terminada**: copiar la carpeta a otro equipo sin Python ni Tesseract instalados y el flujo completo funciona igual.

---

# 4. Módulos

**`ingest.py`**
- Responsabilidad: recibir PDFs, validar que abren correctamente, registrar en `documentos`.
- Entradas: ruta(s) de archivo(s) PDF.
- Salidas: registros iniciales en `documentos` con estado provisional, o marca de "archivo corrupto".
- Dependencias: base de datos (Fase 0).
- Archivos principales: `core/ingest.py`.

**`text_extraction.py` / `ocr.py`**
- Responsabilidad: obtener el texto de cada página, priorizando capa nativa, recurriendo a OCR si falta, embebiendo el texto oculto en el PDF.
- Entradas: PDF validado.
- Salidas: texto por página, PDF con capa OCR embebida.
- Dependencias: `ingest.py`.
- Archivos principales: `core/text_extraction.py`, `core/ocr.py`.

**`classification/engine.py` + `rules_repository.py`**
- Responsabilidad: aplicar reglas generales, luego por institución, sobre el texto de cada página; determinar sigla, miembro y especialidad/asunto (catálogo o extraído).
- Entradas: texto por página, tabla `reglas_clasificacion`, catálogos.
- Salidas: clasificación propuesta por página (o marca de sin resolver).
- Dependencias: `text_extraction.py`, catálogos de la Fase 0.
- Archivos principales: `core/classification/engine.py`, `core/classification/rules_repository.py`.

**`segmentation.py`**
- Responsabilidad: agrupar páginas contiguas con la misma sigla en un sub-documento.
- Entradas: clasificación por página.
- Salidas: uno o más sub-documentos PDF, cada uno con su clasificación asociada.
- Dependencias: `classification/engine.py`.
- Archivos principales: `core/segmentation.py`.

**`duplicates.py`**
- Responsabilidad: detectar coincidencias exactas (hash) y por contenido (texto).
- Entradas: hash del archivo, texto extraído.
- Salidas: registros en `duplicados`.
- Dependencias: `ingest.py`, `text_extraction.py`.
- Archivos principales: `core/duplicates.py`.

**Interfaz de confirmación (`web/`)**
- Responsabilidad: mostrar resultados propuestos, capturar confirmación/corrección del usuario.
- Entradas: resultados de clasificación, segmentación, duplicados.
- Salidas: metadatos confirmados por el usuario.
- Dependencias: todos los módulos anteriores.
- Archivos principales: `web/index.html`, `web/app.js`.

**`naming.py`**
- Responsabilidad: construir el nombre de archivo oficial según la fórmula ya cerrada.
- Entradas: metadatos confirmados.
- Salidas: nombre de archivo propuesto/definitivo.
- Dependencias: interfaz de confirmación.
- Archivos principales: `core/naming.py`.

**`file_ops.py`**
- Responsabilidad: mover/renombrar de forma idempotente, modo prueba, logging.
- Entradas: nombre definitivo, ruta actual del archivo.
- Salidas: archivo en su ubicación final, entradas en `log_operaciones`.
- Dependencias: `naming.py`.
- Archivos principales: `core/file_ops.py`.

**`restoration.py`**
- Responsabilidad: mejora condicional de imagen, desactivada por defecto.
- Entradas: PDF ingresado, resultado del análisis de calidad.
- Salidas: PDF restaurado (si aplica).
- Dependencias: `ingest.py`; se integra antes de `naming.py` en el flujo, pero se desarrolla de forma independiente.
- Archivos principales: `core/restoration.py`.

---

# 5. Base de datos

**Tablas y responsabilidad:**

- `glosario_siglas` — catálogo de tipos documentales (HC, OS, FM, IS, CI, EM, y los que se agreguen vía "Otro").
- `glosario_especialidades` — catálogo de especialidades médicas, usado cuando `modo_especialidad_asunto = catalogo`.
- `glosario_entidades` — catálogo de instituciones (prestador o aseguradora).
- `personas` — miembros del grupo familiar (CLB, YHM, OLF, y los que se agreguen).
- `reglas_clasificacion` — reglas de clasificación, generales (`entidad_id` nulo) o por institución, con soporte para valor de catálogo o valor extraído del texto.
- `eventos` — agrupación mínima de documentos por fecha + entidad + miembro, usada para consolidar OS de un mismo evento clínico.
- `documentos` — registro central de cada documento procesado: rutas, metadatos, sigla, especialidad/asunto, entidad, miembro, evento, estado.
- `duplicados` — relación entre un documento y el documento oficial con el que coincide, y el tipo de coincidencia detectada.
- `log_operaciones` — historial de acciones de archivo (mover, renombrar, error) por documento, con resumen por lote.

**Relaciones:**

- `documentos` referencia a `glosario_siglas`, `glosario_entidades`, `personas` y `eventos`.
- `reglas_clasificacion` referencia opcionalmente a `glosario_entidades` (institución) y a `glosario_siglas`/`glosario_especialidades` según el modo de resolución.
- `eventos` referencia a `glosario_entidades` y `personas`.
- `duplicados` referencia dos veces a `documentos` (el duplicado y el oficial).
- `log_operaciones` referencia a `documentos`.

(El SQL de creación ya existe en la arquitectura técnica congelada; no se repite aquí.)

---

# 6. Flujo interno

```
Usuario carga uno o varios PDFs
        │
        ▼
[Ingesta] ¿el PDF abre correctamente?
        │
   No ──┴── Sí
   │           │
   ▼           ▼
Estado:    [Extracción de texto por página]
"archivo   (nativo, o OCR si falta)
corrupto"       │
                ▼
        [Clasificación por página]
        Reglas generales → Reglas institución
                │
      ┌─────────┴─────────┐
      │                   │
  Sigla + miembro      No se resuelve
  resueltos            sigla/miembro
      │                   │
      ▼                   ▼
[Segmentación por      Estado:
sigla contigua]        "NO_PROCESADO"
      │                   │
      ▼                   ▼
[Detección de          (queda en espera
duplicados]             de clasificación manual)
      │
      ▼
[Confirmación humana]
Usuario revisa/corrige
      │
      ▼
[Restauración condicional]
(solo si la calidad lo amerita)
      │
      ▼
[Nomenclatura]
Construye nombre oficial
      │
      ▼
[Operación de archivo]
Mover/renombrar (idempotente, con log)
      │
      ▼
Estado: "LISTO_PARA_IMPORTAR"
      │
      ▼
Archivo queda en /Listos_para_importar
```

---

# 7. Orden recomendado de desarrollo

1. Esquema de base de datos + catálogos precargados (Fase 0).
2. Ingesta de PDF + extracción de texto/OCR (Fase 1).
3. Motor de clasificación con reglas cargadas para las instituciones ya probadas (Fase 2).
4. Segmentación por sigla (Fase 3).
5. Detección de duplicados (Fase 4).
6. Interfaz mínima de confirmación humana (Fase 5).
7. Nomenclatura (Fase 6).
8. Operación de archivo con idempotencia y log (Fase 7).
9. Marcado de estado final y carpeta de salida (Fase 8).
10. Restauración condicional (Fase 9).
11. Empaquetado portable con binarios incluidos (Fase 10).

Cada paso depende exclusivamente de los anteriores; ninguno requiere adelantar trabajo de un paso posterior.

---

# 8. Riesgos de implementación

- **Riesgo**: el OCR puede leer mal una fecha o un nombre, y ese error quedaría embebido en el nombre de archivo oficial si se generara sin revisión.
  **Mitigación**: la Fase 5 (confirmación humana) es obligatoria antes de la Fase 6 (nomenclatura); el pipeline no debe permitir saltarla.

- **Riesgo**: reglas de clasificación insuficientes para instituciones nuevas no vistas en las pruebas dejarían documentos válidos cayendo en `NO_PROCESADO` de forma sistemática.
  **Mitigación**: cargar en la Fase 0/2 las reglas de las instituciones ya confirmadas (Imbanaco, Oportunidad de Vida, Neurólogos de Occidente, SOS) como set inicial mínimo, ampliable después sin tocar código (son datos, no lógica).

- **Riesgo**: los binarios externos (Tesseract, Ghostscript, qpdf) pueden comportarse distinto entre sistemas operativos si el desarrollo y el uso final ocurren en entornos distintos.
  **Mitigación**: probar el paquete final (Fase 10) en un equipo limpio, sin herramientas de desarrollo instaladas, antes de darlo por terminado.

- **Riesgo**: la segmentación por sigla contigua puede fallar si dos documentos del mismo tipo pero de eventos distintos quedan adyacentes en el PDF de entrada.
  **Mitigación**: la regla mínima de evento (fecha + entidad + miembro) ya definida en la arquitectura debe aplicarse también como criterio de corte en la segmentación, no solo para agrupar OS.

---

# 9. Criterios de aceptación del MVP

El MVP se considera terminado cuando, sin intervención de código:

1. Se puede cargar cualquiera de los PDFs ya usados en las pruebas (Imbanaco, Oportunidad de Vida, Neurólogos de Occidente, el correo) y el sistema los clasifica, segmenta y nombra igual que se validó manualmente en la conversación de análisis.
2. Un documento no reconocido por ninguna regla queda en `NO_PROCESADO`, visible y sin renombrar.
3. Ejecutar el proceso dos veces sobre el mismo lote no duplica archivos ni genera error (idempotencia verificada).
4. Un documento terminado aparece en `/Listos_para_importar` con estado `LISTO_PARA_IMPORTAR` en base de datos.
5. La aplicación corre en un equipo limpio (sin Python ni Tesseract preinstalados) solo copiando la carpeta de distribución.

---

# 10. Backlog (fuera del MVP)

Lo siguiente queda explícitamente fuera de esta versión, sin modificar la arquitectura para acomodarlo:

- Criterios avanzados de consolidación de eventos clínicos (más allá de fecha + entidad + miembro).
- Selección automática del documento oficial entre duplicados (hoy requiere decisión manual).
- Carga incremental sobre un inventario ya procesado.
- Edición posterior de documentos ya marcados como `LISTO_PARA_IMPORTAR`.
- Soporte de entrada para imágenes sueltas (JPG, PNG, TIFF).
- Uso de IA como apoyo de clasificación bajo demanda (fuera del flujo principal).
- Integración automática con el gestor documental principal (hoy es entrega manual desde la carpeta de salida).
