# Estados del Documento

Cada documento procesado por Sclean posee un único estado funcional.

---

# Recibido

El documento fue incorporado al sistema y se encuentra pendiente de procesamiento.

---

# En Proceso

El documento está siendo analizado automáticamente.

Incluye:

- restauración;
- OCR;
- clasificación;
- segmentación;
- nomenclatura.

---

# Pendiente de Validación

El sistema requiere confirmación del usuario antes de continuar.

Las causas pueden incluir:

- clasificación ambigua;
- segmentación dudosa;
- datos insuficientes.

---

# Clasificado

El documento fue identificado correctamente.

Puede continuar hacia la exportación.

---

# No Procesado

El sistema no dispone de información suficiente para completar el procesamiento automático.

El documento permanece íntegro.

Requiere revisión manual.

---

# Exportado

El documento fue generado correctamente y cumple todos los criterios de salida.

Se encuentra listo para ser incorporado a Vive.

---

# Error

Ocurrió un problema técnico durante el procesamiento.

Ejemplos:

- archivo corrupto;
- formato no soportado;
- error de lectura;
- error de OCR;
- error interno.

El error queda registrado sin afectar el procesamiento del resto del lote.