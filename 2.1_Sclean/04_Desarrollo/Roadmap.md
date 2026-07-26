# Roadmap de Desarrollo

## Objetivo

Implementar Sclean mediante incrementos funcionales completos, minimizando dependencias entre fases y permitiendo validar el sistema desde las primeras etapas.

Cada fase debe producir un sistema ejecutable.

---

# Fase 1 — Infraestructura

## Objetivo

Construir la base técnica del proyecto.

## Incluye

- estructura del proyecto;
- configuración;
- SQLite;
- configuración de rutas;
- sistema de logs;
- configuración general;
- carga de catálogos.

## Finaliza cuando

La aplicación inicia correctamente y puede acceder a la base de datos.

---

# Fase 2 — Ingesta

## Objetivo

Permitir la carga de documentos.

## Incluye

- selección de archivos;
- validación;
- lectura de PDF;
- lectura de imágenes;
- inventario temporal.

## Finaliza cuando

Los documentos pueden incorporarse correctamente al sistema.

---

# Fase 3 — Restauración

## Objetivo

Implementar el procesamiento documental.

## Incluye

- análisis de calidad;
- OpenCV;
- restauración;
- OCR;
- generación de PDF optimizado.

## Finaliza cuando

Se obtiene un documento restaurado sin alterar su contenido.

---

# Fase 4 — Clasificación

## Objetivo

Implementar el motor de reglas.

## Incluye

- extracción de texto;
- reglas;
- clasificación;
- metadatos.

## Finaliza cuando

Cada página puede clasificarse automáticamente.

---

# Fase 5 — Segmentación

## Objetivo

Separar correctamente los documentos.

## Incluye

- identificación documental;
- agrupación;
- generación de documentos.

## Finaliza cuando

Cada documento queda separado correctamente.

---

# Fase 6 — Nomenclatura

## Objetivo

Generar automáticamente el nombre oficial.

## Incluye

- construcción del nombre;
- validaciones;
- resolución de conflictos.

## Finaliza cuando

Cada documento posee una nomenclatura válida.

---

# Fase 7 — Interfaz

## Objetivo

Implementar la experiencia del usuario.

## Incluye

- inventario;
- revisión;
- validación;
- exportación.

## Finaliza cuando

El usuario puede completar el flujo completo.

---

# Fase 8 — Liberación

## Objetivo

Preparar la distribución.

## Incluye

- empaquetado;
- pruebas;
- documentación;
- versión inicial.

## Finaliza cuando

Sclean puede distribuirse como MVP.