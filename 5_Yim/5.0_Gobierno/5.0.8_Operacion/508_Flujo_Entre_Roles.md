# Flujo entre Roles

## Propósito

Definir cómo intercambian información los roles de Yim.

---

# Principio fundamental

Los roles nunca se comunican directamente.

Toda interacción ocurre mediante el Orquestador.

---

# Flujo

Rol A

↓

Orquestador

↓

Rol B

---

# Reglas

Un rol nunca solicita trabajo a otro.

Un rol nunca modifica el trabajo producido por otro rol.

Un rol únicamente entrega su salida al Orquestador.

El Orquestador valida la salida antes de asignarla al siguiente rol.

---

# Información transferible

Solo podrá transferirse:

- documentación oficial;
- decisiones aprobadas;
- estado del proyecto;
- Hallazgos registrados;
- contexto mínimo.

---

# Información no transferible

- conversaciones;
- hipótesis;
- borradores;
- opiniones;
- información sin validar.

---

# Devolución

Si una salida presenta inconsistencias, únicamente el Orquestador podrá devolverla al rol correspondiente.

Nunca a un tercero.

---

# Criterios de aceptación

El flujo será correcto cuando:

- ningún rol coordine otros roles;
- toda comunicación pase por el Orquestador;
- exista trazabilidad completa.