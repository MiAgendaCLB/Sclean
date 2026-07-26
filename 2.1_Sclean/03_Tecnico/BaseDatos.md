# Base de Datos

## Objetivo

Persistir únicamente la información necesaria para el funcionamiento de Sclean.

Los documentos permanecen en el sistema de archivos.

---

# Tablas principales

## personas

Catálogo de miembros.

---

## entidades

Instituciones.

---

## especialidades

Especialidades.

---

## tipos_documentales

Siglas oficiales.

---

## reglas_clasificacion

Motor de reglas.

Permite:

- reglas generales;
- reglas por institución;
- extracción de valores;
- catálogo;
- texto libre.

---

## documentos

Inventario de documentos.

### texto_extraido

Almacena el texto obtenido del documento.

Este campo permite:

- evitar OCR innecesario;
- ejecutar nuevamente reglas de clasificación;
- detectar duplicados por contenido;
- mejorar búsquedas futuras.

El texto almacenado nunca reemplaza al documento original.
---

## paginas

Información por página.

---

## procesamiento

Registro del pipeline.

---

## configuracion

Parámetros generales.

---

## logs

Auditoría del sistema.

---

# Relaciones

Un documento:

↓

tiene páginas

↓

cada página posee clasificación

↓

la clasificación produce metadatos

↓

los metadatos generan la nomenclatura.