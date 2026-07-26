# Convención Documental de Yim

## Objetivo

Definir una convención única para organizar carpetas y documentos dentro del proyecto Yim y de cualquier proyecto que adopte posteriormente esta metodología.

La convención busca:

- facilitar la navegación;
- mantener la trazabilidad;
- evitar duplicidad;
- permitir la automatización;
- identificar el origen de cualquier documento sin depender de su ubicación física.

---

# 1. Organización física

La organización física corresponde a la estructura de carpetas del proyecto.

Cada carpeta posee un identificador jerárquico.

Ejemplo:

```text
5_Yim
│
├──5.0_Gobierno
├──5.1_Ingenieria
├──5.2_Analisis
├──5.3_Arquitectura
├──5.4_Desarrollo
├──5.5_QA
├──5.6_Evolucion
└──5.7_Integracion
```

Las subcarpetas heredan completamente el identificador de su carpeta padre.

Ejemplos:

```text
5.0.1_Metodologia_Oficial

5.1.1_Principios

5.1.2_Evidencias

5.3.2_Patrones

5.6.2_Deuda_Tecnica
```

La estructura física está diseñada para que cualquier persona pueda comprender el proyecto recorriendo únicamente las carpetas.

---

# 2. Organización lógica

La organización lógica corresponde a los documentos.

Cada documento utiliza como prefijo el identificador compacto de la carpeta donde pertenece.

La conversión consiste en eliminar los puntos del identificador jerárquico.

Ejemplos:

| Carpeta | Prefijo documental |
|----------|--------------------|
| 5.0.6 | 506 |
| 5.1.1 | 511 |
| 5.1.2 | 512 |
| 5.3.2 | 532 |
| 5.6.1 | 561 |

Ejemplos de documentos:

```text
506_Prompt_Base

511_Responsabilidad_Unica

512_Clean_Architecture

532_Arquitectura_Hexagonal

561_Refactorizacion
```

El prefijo identifica el origen lógico del documento.

El nombre identifica su contenido.

La extensión del archivo no forma parte del nombre del documento.

---

# 3. Relación entre carpetas y documentos

Toda carpeta puede contener uno o varios documentos.

Todo documento pertenece a una única carpeta oficial.

La carpeta determina:

- ubicación física;
- responsabilidad;
- contexto.

El prefijo documental determina:

- origen lógico;
- trazabilidad;
- referencias cruzadas.

---

# 4. Nomenclatura de documentos

Todo documento oficial deberá cumplir la siguiente estructura:

```text
PPP_Nombre_Documento
```

Donde:

- **PPP** corresponde al identificador compacto de la carpeta.
- **Nombre_Documento** describe el contenido del documento.

Ejemplos:

```text
501_Metodologia_Oficial

502_Decision_Arquitectura

503_Hallazgo_Acoplamiento

511_Principios_Ingenieria

541_Practicas_Desarrollo
```

---

# 5. Principios de organización

La organización física y la organización lógica representan responsabilidades diferentes.

La estructura de carpetas organiza el repositorio.

La nomenclatura documental organiza el conocimiento.

La estructura física nunca deberá diseñarse únicamente pensando en la nomenclatura documental.

La nomenclatura documental nunca deberá sustituir la estructura física.

Ambas evolucionan conjuntamente y deberán mantenerse sincronizadas.

---

# 6. Reglas generales

Toda carpeta nueva deberá poseer un identificador jerárquico.

Todo documento nuevo deberá utilizar el identificador compacto de su carpeta como prefijo.

No se crearán documentos oficiales fuera de esta convención.

No existirán dos documentos oficiales con el mismo propósito.

Cada tema tendrá un único documento oficial.

---

# 7. Formato de entrega de documentos

Cuando cualquier rol genere un documento destinado al repositorio oficial de Yim, deberá entregarlo siempre en el siguiente orden:

1. Nombre del documento (sin extensión).
2. Ruta completa donde pertenece.
3. Contenido completo del documento.

Ejemplo:

```text
506_Convencion_Documental
```

```text
5_Yim
└──5.0_Gobierno
    └──5.0.6_Plantillas
```

```markdown
# Convención Documental de Yim

...
```

No deberán incluirse encabezados adicionales como:

- Documento
- Ruta
- Contenido
- Archivo
- Nombre

La separación entre estos elementos se realizará únicamente mediante bloques independientes para facilitar el copiado.

---

# 8. Validación antes de la entrega

Antes de entregar cualquier documento oficial deberá verificarse que:

- el nombre del documento cumple la nomenclatura establecida;
- la ruta corresponde a la estructura oficial del proyecto;
- el contenido pertenece a esa ubicación;
- no existe otro documento oficial con el mismo propósito;
- la entrega respeta esta Convención Documental.

Si durante la revisión se detecta una inconsistencia que pueda corregirse sin cambiar el alcance solicitado, deberá corregirse antes de entregar el documento.

Nunca deberá entregarse una versión que ya se sabe que incumple esta convención.