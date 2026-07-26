# Flujo de Trabajo

## Objetivo

Transformar automáticamente uno o varios archivos documentales en documentos independientes preparados para Vive.

---

# Flujo General

Recepción

↓

Análisis documental

↓

Restauración (si aplica)

↓

Extracción de texto

↓

Clasificación documental

↓

Segmentación

↓

Nomenclatura

↓

Validación

↓

Exportación

---

# 1. Recepción

El usuario selecciona uno o varios archivos.

Sclean valida automáticamente:

- formato;
- integridad;
- accesibilidad.

Si un archivo no puede abrirse se marca como Error de Entrada y continúa el procesamiento del resto del lote.

---

# 2. Análisis

Sclean analiza automáticamente cada página.

Entre otros:

- resolución;
- orientación;
- inclinación;
- contraste;
- ruido;
- sombras;
- nitidez;
- existencia de texto;
- calidad estimada del OCR.

Este análisis determina si la página requiere restauración.

---

# 3. Restauración

La restauración únicamente se aplica cuando mejora objetivamente la calidad documental.

Las páginas que ya poseen calidad adecuada permanecen prácticamente sin modificaciones.

Las mejoras pueden incluir:

- deskew;
- rotación;
- recorte;
- limpieza;
- corrección de iluminación;
- contraste;
- nitidez;
- optimización para OCR.

Nunca se modifica el contenido documental.

---

# 4. Extracción de texto

Sclean intenta obtener el texto siguiendo este orden:

1. Texto embebido en el PDF.
2. OCR sobre la página restaurada.

El OCR únicamente se ejecuta cuando la página no dispone de una capa de texto utilizable.

---

# 5. Clasificación

Cada página se clasifica mediante el motor de reglas.

Las reglas determinan:

- tipo documental;
- entidad;
- especialidad o asunto;
- fecha;
- demás metadatos disponibles.

Cuando la información es insuficiente el documento pasa al estado No procesado.

### Herencia de metadatos

Durante la segmentación, una página podrá heredar metadatos de páginas contiguas cuando exista continuidad documental claramente identificable.

La herencia únicamente completa información faltante.

Nunca modifica información previamente determinada.

La decisión siempre depende del contexto del documento completo y no únicamente de una página aislada.
## Clasificación Conservadora

Sclean nunca intentará adivinar la clasificación de un documento.

Cuando las reglas disponibles no permitan identificar correctamente el tipo documental, el documento pasará al estado **No Procesado**.

Es preferible solicitar intervención del usuario que generar una clasificación incorrecta.

Toda clasificación automática debe estar respaldada por reglas objetivas.
---

# 6. Segmentación

Una vez clasificadas todas las páginas, Sclean determina los límites documentales.

La separación siempre es documental.

Nunca física.

No se utiliza como criterio:

- cambio de diseño;
- cambio de formulario;
- cambio de encabezado;
- cambio de página.

La clasificación determina la segmentación.

---

# 7. Nomenclatura

Cada documento recibe automáticamente su nombre oficial.

La nomenclatura utiliza exclusivamente información presente en el documento.

Nunca se inventan datos.

---

# 8. Validación

Cuando exista incertidumbre el sistema presenta una propuesta al usuario.

El usuario únicamente confirma o corrige.

No debe reconstruir manualmente el documento.

---

# 9. Exportación

Cada documento aprobado se exporta de forma independiente.

Se conserva siempre el archivo original.

La salida queda lista para ser incorporada a Vive.