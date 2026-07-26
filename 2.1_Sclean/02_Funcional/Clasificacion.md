# Clasificación Documental

## Objetivo

Identificar automáticamente el tipo documental y sus principales metadatos.

---

# Principios

La clasificación se realiza sobre el contenido documental.

Nunca sobre:

- nombre del archivo;
- ubicación;
- carpeta;
- formato.

---

# Motor de Clasificación

El proceso utiliza reglas deterministas.

Orden de ejecución:

1. Texto embebido.
2. OCR (si es necesario).
3. Reglas generales.
4. Reglas específicas por institución.
5. Clasificación.
6. No procesado.

No se utilizan modelos generativos para clasificar documentos.

---

# Resultado

Cada documento puede quedar en uno de los siguientes estados:

- Clasificado.
- No procesado.

---

# Información obtenida

Cuando sea posible se identifica:

- tipo documental;
- fecha;
- entidad;
- especialidad o asunto;
- paciente;
- profesional;
- demás metadatos disponibles.

---

# Incertidumbre

Si las reglas no permiten resolver la clasificación con la información disponible, el documento queda como No procesado.

El sistema nunca inventa clasificaciones.

Nunca realiza suposiciones.