# Restauración Documental

## Objetivo

Mejorar la calidad visual del documento sin modificar su contenido.

La restauración busca aumentar la legibilidad para las personas y optimizar el procesamiento automático.

---

# Principios

Toda restauración debe cumplir las siguientes reglas:

- No inventar información.
- No eliminar información.
- No modificar números.
- No modificar fechas.
- No modificar firmas.
- No modificar sellos.
- Conservar la geometría documental.
- Mantener el documento original sin modificaciones.

---

# Análisis Inicial

Antes de restaurar, Sclean analiza automáticamente:

- resolución;
- orientación;
- inclinación;
- contraste;
- iluminación;
- sombras;
- ruido;
- nitidez;
- compresión;
- calidad del texto;
- calidad estimada para OCR.

---

# Restauraciones posibles

Dependiendo del análisis podrán aplicarse una o varias técnicas:

- corrección de inclinación;
- corrección de perspectiva;
- rotación;
- recorte automático;
- eliminación de bordes;
- reducción de ruido;
- corrección de iluminación;
- mejora de contraste;
- mejora de nitidez;
- aumento de resolución documental;
- optimización para OCR.

Cada técnica se aplica únicamente cuando representa una mejora objetiva.

---

# Intensidad

Las mejoras son independientes por página.

Un documento puede contener páginas:

- restauradas;
- parcialmente restauradas;
- sin modificaciones.

---

# OCR

Cuando el documento requiera OCR, éste se ejecutará sobre la versión restaurada.

El texto OCR se incorpora como una capa oculta.

La imagen original permanece como representación oficial del documento.

---

# Resultado

Toda restauración genera un nuevo documento.

Nunca sobrescribe el original.

Toda mejora debe poder repetirse obteniendo el mismo resultado.