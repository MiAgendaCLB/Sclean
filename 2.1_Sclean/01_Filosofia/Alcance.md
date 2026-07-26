# Alcance

## Responsabilidad

Sclean es responsable exclusivamente de la preparación documental.

Su responsabilidad comienza cuando el usuario selecciona uno o varios archivos.

Finaliza cuando entrega documentos individuales preparados para ser incorporados a Vive.

---

## Incluye

- Recepción de archivos.
- Validación de formatos.
- Análisis documental.
- Restauración.
- OCR.
- Extracción de texto.
- Clasificación.
- Segmentación documental.
- Nomenclatura.
- Validación.
- Exportación.

---

## No Incluye

Sclean no realiza:

- Gestión documental.
- Organización de expedientes.
- Interpretación clínica.
- Diagnósticos.
- Resúmenes médicos.
- Análisis de contenido.
- Organización de carpetas.
- Administración de pacientes.
- Administración de casos.

Estas responsabilidades pertenecen a Vive.

---

## Entradas

El sistema podrá recibir uno o varios archivos documentales.

Ejemplos:

- PDF
- JPG
- PNG
- TIFF

Los formatos soportados podrán ampliarse sin modificar la arquitectura.

---

## Salidas

El resultado del proceso será uno o varios documentos independientes.

Cada documento incluirá:

- calidad optimizada;
- OCR cuando aplique;
- clasificación;
- nomenclatura oficial;
- metadatos;
- registro de procesamiento.

Estos documentos constituyen la entrada oficial para Vive.

---

## Límite del Proyecto

Sclean termina su responsabilidad cuando los documentos quedan listos para ser importados.

Toda operación posterior corresponde exclusivamente a Vive.
---

# Principio HarneSS

Sclean adopta el principio HarneSS como criterio para organizar su documentación, arquitectura e implementación.

Todo componente del proyecto deberá tener una única responsabilidad claramente definida.

Esto aplica a:

- documentos;
- módulos;
- clases;
- funciones;
- tablas;
- procesos;
- reglas.

Cada elemento debe responder una única pregunta y cumplir un único propósito.

Cuando un elemento comience a asumir responsabilidades diferentes deberá dividirse en componentes más pequeños y especializados.

La evolución del proyecto se realizará mediante especialización y no mediante acumulación de funcionalidades.

Este principio busca mantener un sistema:

- simple;
- comprensible;
- mantenible;
- escalable;
- fácil de validar.

Antes de crear un nuevo componente deberá verificarse si realmente representa una responsabilidad independiente.

Antes de ampliar un componente existente deberá verificarse si la nueva funcionalidad pertenece a su responsabilidad original.

HarneSS será el criterio principal para decidir la organización interna del proyecto.