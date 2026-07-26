# Especificación consolidada — App de gestión documental (basada en Anexo de Restauración + Reglas de Documentos)

## Objetivo del producto
No es un gestor documental genérico ni un editor de imagen. Es una herramienta de **captura, clasificación y mejora de calidad de documentos escaneados**, diseñada para minimizar pasos manuales y decisiones técnicas del usuario (contexto: usuario con ACV, prioridad = fricción mínima).

Alcance explícito: NO reemplaza el modelo de casos de BDVive. Esta app resuelve la etapa previa — "tengo un documento escaneado, necesito que quede bien nombrado, clasificado y legible" — antes de que ese documento entre a un caso.

---

## 1. Modelo de nomenclatura general (confirmado y cerrado tras pruebas reales)

Fórmula única para todo documento, independiente del dominio (médico o correspondencia):

`AAAAMMDD_SIGLA_EspecialidadOAsunto_Entidad_Miembro.ext`

Justificación de cada campo (fija, no cambia entre siglas):

| Campo | Responde | Obligatorio | Notas |
|---|---|---|---|
| Fecha (AAAAMMDD) | ¿Cuándo? | Sí | Prioriza fecha leída del contenido sobre fecha de escaneo/impresión |
| Sigla | ¿Qué es? | **Sí, siempre** | Es el único campo que determina la clasificación. Sin sigla no hay documento válido |
| Especialidad o asunto | ¿De qué trata? | Según sigla | Campo flexible: cada sigla decide qué dato cumple mejor esta función (ver ejemplos abajo) |
| Entidad | ¿Con quién se trató? | Según sigla | Institución prestadora/emisora, no aseguradora/EPS (aseguradora es metadato secundario) |
| Miembro (paciente o persona) | ¿De quién es? | Sí | Iniciales del miembro del grupo familiar (catálogo Personas: CLB, YHM, OLF, o los que se creen) |

Todos los campos vienen de selects sobre catálogos Glosario, nunca de texto libre. El nombre de archivo se genera automáticamente; el usuario nunca lo escribe a mano.

### Catálogo de siglas (Glosario, editable, con opción "Otro")

| Sigla | Significado | Ejemplo de uso del campo "especialidad o asunto" |
|---|---|---|
| HC | Historia Clínica — registro del médico en la consulta | Especialidad del médico |
| OS | Orden de Servicio — lo que el médico ordena (consultas, imágenes, laboratorios, procedimientos); un evento clínico consolida todas sus órdenes en un solo documento OS | Especialidad del médico que ordena |
| FM | Fórmula Médica — siempre documento propio, tiene número de trámite independiente de la OS | Especialidad del médico que prescribe |
| IS | Insumos — poco común, mismo nivel que FM/OS | Especialidad o tipo de insumo |
| CI | Incapacidad Médica | Rango de fechas del periodo (`AAAAMMDD_a_AAAAMMDD`), no especialidad — responde "de qué trata" mejor que repetir "incapacidad" |
| EM | Correspondencia/comunicaciones (correos, cartas) — dominio distinto al médico | Asunto sin espacios, sin conectores, capitalizado |

Si el tipo documental no existe en el catálogo, el sistema NO inventa sigla: ofrece la opción **"Otro"**, que abre un popup para crear la nueva entrada directamente en el catálogo Glosario correspondiente (mismo patrón ya usado en Personas/Instituciones de BDVive).

### Corrección masiva de nombres

La app debe permitir cargar N archivos a la vez y proponer/corregir todos los nombres en una sola operación (inventario tipo tabla, no archivo por archivo). Todo documento que la app no logre clasificar automáticamente (sigla desconocida, contenido ambiguo, tipo no médico no previsto) se separa en un grupo de **"No procesados"**: no se renombra ni se toca, queda visible para clasificación manual posterior por el usuario. Este estado es la generalización de `PENDIENTE DE CLASIFICAR` a cualquier motivo de no-clasificación, no solo sigla faltante.

---

## 2. Flujo de captura y restauración (del Anexo de Restauración, ajustado)

Pipeline técnico determinista (no un LLM interpretando la imagen — librerías reales: OpenCV / OCRmyPDF / Tesseract):

1. **Análisis automático**: resolución, orientación, inclinación, contraste, ruido, nitidez, calidad estimada de OCR.
2. **Corrección geométrica**: deskew, rotación, recorte, alineación — solo si el análisis lo justifica.
3. **Limpieza**: ruido, manchas, artefactos JPEG — nunca eliminar información.
4. **Corrección de iluminación**: sombras, balance de blancos.
5. **Mejora visual**: contraste adaptativo, nitidez — con umbral mínimo, para no degradar páginas ya buenas.
6. **Aumento de resolución**: SOLO interpolación clásica (bicúbica/Lanczos) o modelo entrenado específicamente en texto documental. **Prohibido usar modelos de súper-resolución generativos de propósito general** — inventan textura, lo cual viola la regla de fidelidad. Esta es una corrección respecto al anexo original, que pedía "nunca inventar detalles" y "super resolución" en la misma fase sin resolver la contradicción.
7. **Optimización OCR + OCR oculto**: el texto reconocido se embebe oculto en el PDF, nunca reemplaza la imagen.
8. **Generación del PDF final**: se conserva el original sin tocar; la versión mejorada es siempre un archivo nuevo.
9. **Validación automática**: comparar contra el original — ninguna página perdida/duplicada, ninguna fecha/número/firma/sello alterado.

Regla dura: si una página ya tiene buena calidad, se conserva casi sin cambios. Intensidad de corrección se ajusta por página, no de forma global.

---

## 3. Detección de duplicados (del Playbook, aplicado)

Dos niveles, no uno:
- **Hash MD5**: detecta duplicado exacto (mismo archivo, distinto nombre/carpeta).
- **Comparación de contenido (texto OCR)**: detecta duplicado semántico — mismo documento exportado dos veces con bytes distintos. Esto requiere comparar el texto extraído, no solo el hash.

Si se detecta duplicado: se conserva un "documento oficial" y el resto se marca (no se borra automáticamente).

---

## 4. Reglas de seguridad para cualquier operación de archivo (del Playbook — arquitectura, no parche)

Estas reglas aplican a cualquier función que mueva, renombre o borre archivos dentro de la app. La causa raíz de los errores del Playbook fue generar scripts `.bat` para que un humano los ejecutara manualmente en Windows — eso se elimina de raíz si la app ejecuta la operación directamente. Lo que sí se conserva:

- **Idempotencia**: antes de mover/renombrar, verificar si el destino ya existe con el nombre final; si existe, saltar sin marcar error.
- **Modo prueba (dry-run) por defecto** en toda acción destructiva (borrar). El usuario debe confirmar explícitamente el paso a modo real, después de revisar qué se afectaría.
- **Log persistente con resumen final verificable**: cada acción (encontrado / movido / ya existía / error) queda registrada. Si el log no llega al bloque de resumen, la operación se cortó a medias — señal de fallo que el usuario no tiene que diagnosticar manualmente.
- **Verificación de nombre real**: si el documento viene de una fuente que puede alterar codificación (ej. extracción de ZIP), comparar contra el nombre real del sistema de archivos antes de cerrar cualquier cambio, para no perder tildes/ñ.

---

## 5. Estados del documento (tabla de inventario, adaptada a UI)

En vez de una tabla de Excel, esto es el estado visible de cada documento en la app:

- `OK` — nombre y metadatos correctos.
- `RENOMBRAR` — metadatos completos pero nombre de archivo desactualizado; la app puede corregirlo con un clic.
- `DUPLICADO` — contenido igual a otro documento ya existente; se muestra cuál es el oficial.
- `NO PROCESADO` — no se pudo clasificar (sigla desconocida, contenido ambiguo, tipo no previsto); requiere decisión humana. Único estado de "sin clasificar" — reemplaza cualquier referencia anterior a `PENDIENTE DE CLASIFICAR`.
- `LISTO PARA IMPORTAR` — documento terminado según el contrato de salida (ver sección 7).

---

## 7. Decisiones de cierre del MVP (especificación funcional aprobada)

**Clasificación — modelo híbrido, en este orden:**
1. Reglas SQL (generales).
2. Reglas por institución.
3. OCR (cuando el texto no está disponible de otra forma).
4. Si no se resuelve con confianza suficiente → estado `NO PROCESADO` automático.
La IA no es parte del flujo principal; solo disponible bajo demanda como herramienta de apoyo puntual, no como paso del pipeline.

**Contrato de salida — un documento se considera terminado (`LISTO PARA IMPORTAR`) cuando:**
- está separado correctamente (segmentación aplicada);
- fue restaurado si era necesario;
- tiene OCR incorporado;
- posee metadatos confirmados por el usuario;
- tiene nomenclatura oficial aplicada.
La aplicación entrega el documento en este estado y se detiene ahí: no administra expedientes ni casos, esa responsabilidad es del gestor documental principal (fuera de alcance).

**Entrada:** la primera versión soporta únicamente PDF. Soporte para imágenes (JPG, PNG, TIFF) queda diferido, no bloquea el MVP.

**Diferido a evolución futura (no bloquea el desarrollo inicial):**
- Criterios avanzados de consolidación de eventos clínicos (el MVP usa una regla mínima, ver arquitectura técnica).
- Selección automática del documento oficial entre duplicados.
- Carga incremental sobre inventario existente.
- Edición posterior de documentos ya procesados.

**Estado de la especificación funcional: cerrada y aprobada para iniciar arquitectura técnica.**

---

---

## 6. Principio rector de accesibilidad (no estaba en ninguno de los dos documentos originales)

Toda función de esta app se diseña bajo un criterio: **mínimo de decisiones y pasos manuales por documento**. Por defecto:
- Un documento entra por captura/escaneo → el pipeline de restauración corre automático → la app propone metadatos (fecha/tipo/entidad detectados por OCR) → el usuario solo confirma o corrige, no escribe desde cero.
- Ninguna acción destructiva ocurre sin confirmación explícita y visible, pero la confirmación debe ser un solo clic, no un formulario.
