# Criterios de Aceptación

## Objetivo

Definir cuándo Sclean puede considerarse terminado para su primera versión.

---

# Funcionales

Debe ser capaz de:

- recibir documentos;
- restaurarlos cuando sea necesario;
- ejecutar OCR;
- clasificar automáticamente;
- segmentar correctamente;
- generar nomenclatura oficial;
- exportar documentos independientes.

---

# Calidad

Nunca debe:

- inventar información;
- eliminar contenido;
- modificar el significado del documento;
- sobrescribir el original.

---

# Rendimiento

Debe procesar documentos de manera estable y reproducible.

Los errores de un documento nunca deben detener el procesamiento del resto del lote.

---

# Usabilidad

El usuario debe completar el proceso mediante confirmaciones mínimas.

No debe reconstruir manualmente información que el sistema pueda obtener automáticamente.

---

# Técnicos

La aplicación deberá:

- funcionar completamente local;
- no depender de Internet;
- mantener trazabilidad completa;
- registrar todas las operaciones.

---

# Criterio Final

Sclean será considerado terminado cuando cualquier usuario pueda convertir un conjunto de documentos de entrada en documentos correctamente preparados para Vive, manteniendo la integridad documental y requiriendo únicamente intervención cuando exista incertidumbre objetiva.