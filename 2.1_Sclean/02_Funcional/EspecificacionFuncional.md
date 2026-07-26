# Especificación Funcional

## Objetivo

Sclean transforma archivos documentales en documentos individuales preparados para Vive.

El usuario únicamente proporciona los archivos de entrada.

El sistema ejecuta automáticamente el resto del proceso.

---

## Flujo General

Recepción

↓

Análisis

↓

Restauración (si aplica)

↓

Extracción de texto

↓

Clasificación

↓

Segmentación

↓

Nomenclatura

↓

Validación

↓

Exportación

---

## Principios Funcionales

- Automatizar siempre que sea posible.
- Nunca modificar el contenido documental.
- Nunca inventar información.
- Conservar siempre el documento original.
- Solicitar validación únicamente cuando exista incertidumbre.

---

## Resultado Esperado

Cada documento generado deberá:

- corresponder a un único documento documental;
- mantener íntegramente su contenido;
- ser legible;
- estar correctamente clasificado;
- poseer nomenclatura oficial;
- quedar listo para Vive.