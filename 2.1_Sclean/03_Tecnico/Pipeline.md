# Pipeline Técnico

## Objetivo

Procesar todos los documentos siguiendo siempre el mismo orden.

El pipeline es determinista.

Nunca modifica el flujo según interpretaciones.

---

# Etapas

## 1. Recepción

Validación del archivo.

↓

## 2. Extracción de texto

Obtención del texto:

- capa PDF;
- OCR.

↓
## Obtención del texto

Sclean siempre intentará reutilizar el texto existente del documento antes de ejecutar OCR.

Orden de prioridad:

1. Capa de texto nativa del PDF.
2. OCR sobre el documento restaurado.

Si el documento ya contiene una capa de texto válida, no se ejecutará OCR nuevamente.

Este comportamiento reduce el tiempo de procesamiento y evita generar OCR innecesario.
## 3. Clasificación

Cada página se clasifica utilizando reglas.

↓
## Propagación de metadatos

Una vez clasificadas las páginas individualmente, Sclean podrá completar información faltante utilizando el contexto documental.

La propagación únicamente podrá realizarse cuando exista certeza objetiva de continuidad documental.

La propagación nunca modificará una clasificación ya confirmada.

Su único propósito consiste en completar metadatos ausentes dentro de un mismo documento.
## 4. Segmentación

Con la clasificación realizada se determinan los límites documentales.

↓

## 5. Restauración

Cada documento independiente se restaura cuando sea necesario.

↓

## 6. Nomenclatura

Generación automática del nombre.

↓

## 7. Validación

Confirmación únicamente cuando exista incertidumbre.

↓

## 8. Exportación

Generación de PDFs independientes.

---

# Propiedades

Cada etapa:

- recibe entradas definidas;
- produce salidas definidas;
- no modifica etapas anteriores;
- puede registrarse individualmente.

---

# Recuperación

Si ocurre un error:

- el procesamiento se detiene únicamente para el documento afectado;
- el resto del lote continúa.

Todos los errores quedan registrados.