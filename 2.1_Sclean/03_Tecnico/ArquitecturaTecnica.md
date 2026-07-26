# Arquitectura Técnica

## Objetivo

Implementar una aplicación completamente local capaz de preparar documentos automáticamente antes de su incorporación a Vive.

La arquitectura prioriza:

- simplicidad;
- mantenibilidad;
- reproducibilidad;
- independencia de servicios externos.

---

# Principios

La arquitectura se basa en módulos independientes.

Cada módulo posee una única responsabilidad.

La comunicación entre módulos se realiza mediante objetos de datos bien definidos.

Ningún módulo conoce la implementación interna de otro.

---

# Arquitectura General

```
Usuario

↓

Interfaz

↓

Motor de Procesamiento

├── Ingesta
├── Restauración
├── OCR
├── Clasificación
├── Segmentación
├── Nomenclatura
├── Validación
└── Exportación

↓

SQLite

↓

Documentos finales
```

---

# Componentes

## Interfaz

Responsable de la interacción con el usuario.

No contiene lógica documental.

---

## Motor de Procesamiento

Coordina el flujo completo.

No implementa reglas.

Únicamente orquesta módulos.

---

## Base de Datos

Almacena:

- catálogos;
- reglas;
- configuraciones;
- inventario;
- registros.

Nunca almacena los documentos originales.

---

## Sistema de Archivos

Conserva:

- originales;
- temporales;
- documentos generados.

---

# Dependencias

OpenCV

Procesamiento de imágenes.

OCRmyPDF

Generación de OCR.

Tesseract

Reconocimiento óptico.

Ghostscript

Procesamiento PDF.

qpdf

Optimización y manipulación PDF.

SQLite

Persistencia.

PyInstaller

Distribución.