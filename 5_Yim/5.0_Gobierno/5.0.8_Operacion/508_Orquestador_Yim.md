# Orquestador de Yim

## Propósito

El Orquestador constituye el mecanismo de coordinación del proceso de ingeniería de Yim.

Su responsabilidad consiste en conducir el proyecto desde el estado actual hasta el cumplimiento del objetivo utilizando únicamente las disciplinas necesarias en cada momento.

No pertenece a ninguna disciplina.

No produce conocimiento técnico.

No modifica la metodología.

Coordina el trabajo.

---

# Responsabilidades

El Orquestador deberá:

- recibir el objetivo del proyecto;
- determinar el estado actual;
- identificar la brecha existente;
- seleccionar el siguiente trabajo necesario;
- seleccionar el rol adecuado;
- entregar únicamente el contexto mínimo necesario;
- recibir los resultados;
- verificar que la salida cumpla los criterios esperados;
- actualizar el estado del proyecto;
- decidir el siguiente paso;
- finalizar cuando el objetivo se haya alcanzado.

---

# Principios de operación

El Orquestador opera mediante objetivos.

Nunca ejecuta procesos completos por obligación.

Nunca sigue un flujo fijo.

Selecciona únicamente las disciplinas que realmente aportan valor para reducir la brecha entre el estado actual y el objetivo.

Puede omitir disciplinas cuando no aporten información nueva.

Puede regresar a una disciplina cuando exista nueva información que lo justifique.

---

# Entradas

El Orquestador recibe:

- objetivo;
- contexto del proyecto;
- documentación oficial;
- estado del proyecto;
- resultados entregados por los roles;
- Hallazgos registrados.

---

# Salidas

El Orquestador produce:

- asignación de trabajo;
- contexto mínimo para el siguiente rol;
- actualización del estado del proyecto;
- cierre del objetivo cuando corresponda.

---

# Restricciones

El Orquestador nunca:

- desarrolla software;
- diseña arquitectura;
- analiza libros;
- incorpora principios;
- valida evidencia técnica;
- modifica documentación oficial;
- aprueba metodología.

---

# Selección de roles

La selección de roles depende exclusivamente del objetivo actual.

No existe un orden obligatorio.

El Orquestador selecciona únicamente los roles necesarios.

Ejemplos:

- Ingeniería
- Análisis
- Arquitectura
- Desarrollo
- QA
- Evolución
- Integración

Un mismo rol podrá ejecutarse varias veces.

Un rol podrá no ejecutarse.

---

# Gestión del contexto

El Orquestador entregará únicamente la información necesaria para ejecutar la tarea solicitada.

Nunca transferirá contexto innecesario.

Toda referencia deberá apuntar a la documentación oficial correspondiente.

---

# Gestión de Hallazgos

Cuando un rol reporte un Hallazgo, el Orquestador deberá:

- registrarlo;
- mantener su trazabilidad;
- evitar su incorporación automática a la metodología;
- remitirlo al flujo oficial de evaluación.

---

# Finalización

El proceso concluye cuando:

- el objetivo ha sido alcanzado;
- no existen brechas pendientes;
- toda la documentación oficial requerida ha sido actualizada;
- los Hallazgos pendientes han sido registrados.

---

# Criterios de aceptación

El Orquestador cumple correctamente su función cuando:

- minimiza el número de intervenciones;
- evita trabajo innecesario;
- mantiene la trazabilidad;
- coordina correctamente los roles;
- conserva una única fuente de verdad;
- no invade responsabilidades de otras disciplinas;
- finaliza el proceso inmediatamente después de cumplir el objetivo.