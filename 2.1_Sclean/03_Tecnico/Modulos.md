# Módulos

# Motores principales

La arquitectura de Sclean está compuesta por dos motores independientes.

## Motor de Procesamiento Documental

Responsable de todas las operaciones sobre el documento.

Incluye:

- restauración;
- OCR;
- generación de PDF;
- optimización.

No interpreta el contenido.

---

## Motor de Reglas Documentales

Responsable de interpretar la información obtenida del documento.

Incluye:

- clasificación;
- segmentación;
- nomenclatura;
- validación;
- detección de duplicados;
- aplicación de reglas.

No modifica el documento.

Ambos motores son independientes y se comunican únicamente mediante los datos generados durante el procesamiento.

## Ingesta

### Responsabilidad

Recibir documentos.

### Entrada

Archivos.

### Salida

Documentos validados.

---

## Restauración

### Responsabilidad

Mejorar calidad documental.

### Entrada

Documento.

### Salida

Documento restaurado.

---

## OCR

### Responsabilidad

Extraer texto.

### Entrada

Documento.

### Salida

Texto estructurado.

---

## Clasificación

### Responsabilidad

Determinar tipo documental.

### Entrada

Texto.

### Salida

Metadatos.

---

## Segmentación

### Responsabilidad

Separar documentos.

### Entrada

Páginas clasificadas.

### Salida

Documentos independientes.

---

## Nomenclatura

### Responsabilidad

Construir el nombre oficial.

### Entrada

Metadatos.

### Salida

Nombre de archivo.

---

## Validación

### Responsabilidad

Resolver incertidumbres.

### Entrada

Propuesta automática.

### Salida

Confirmación del usuario.

---

## Exportación

### Responsabilidad

Generar los documentos finales.

### Entrada

Documento validado.

### Salida

PDF listo para Vive.