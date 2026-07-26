# Estados de Trabajo

## Propósito

Definir el modelo único de estados utilizado por Yim para controlar el avance de cualquier objetivo.

Los estados representan la situación del trabajo.

No representan disciplinas.

No representan responsables.

---

# Principios

Todo trabajo posee un único estado vigente.

Los estados son mutuamente excluyentes.

Los estados son independientes del rol que ejecuta el trabajo.

---

# Estados oficiales

## Pendiente

El trabajo existe pero aún no ha sido asignado.

---

## En preparación

El Orquestador está recopilando el contexto necesario.

---

## En ejecución

Existe un rol ejecutando el trabajo.

---

## En validación

La salida está siendo revisada.

---

## Devuelto

La salida no cumple los criterios de aceptación.

Debe regresar únicamente al rol responsable.

---

## Aprobado

La salida cumple completamente los criterios.

Puede utilizarse como entrada de otros trabajos.

---

## Incorporado

La salida ya forma parte de la documentación oficial.

---

## Finalizado

El objetivo asociado ha sido completamente cumplido.

---

# Reglas

No podrá existir más de un estado simultáneo.

Todo cambio de estado deberá ser trazable.

No podrán omitirse estados cuando exista validación pendiente.

---

# Criterios de aceptación

El modelo será correcto cuando:

- cualquier trabajo tenga un único estado;
- sea posible conocer su situación sin ambigüedad;
- permita auditar completamente su evolución.