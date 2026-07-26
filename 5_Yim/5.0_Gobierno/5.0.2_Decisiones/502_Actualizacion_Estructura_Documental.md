# Actualización de la Estructura Documental Operativa

## Estado

Aprobada.

## Motivo

La estructura documental inicial organiza correctamente las disciplinas de Yim.

Sin embargo, no dispone de una ubicación oficial para la documentación que define el funcionamiento operativo del motor metodológico.

Como consecuencia, comenzaron a aparecer documentos sin una ubicación oficial definida, como:

- Orquestador
- Ciclo de Operación
- Estados
- Gestión de Contexto

Esta situación genera una inconsistencia con la Convención Documental.

## Decisión

Se incorpora un nuevo bloque dentro de Gobierno denominado:

5.0.8_Operacion

Su finalidad es contener exclusivamente la documentación que define el funcionamiento operativo de Yim.

## Alcance

La carpeta 5.0.8_Operacion contendrá únicamente documentos relacionados con:

- Orquestador
- Ciclo de operación
- Gestión del contexto
- Flujo entre roles
- Estados de trabajo
- Gestión de Hallazgos
- Criterios de finalización
- Reglas operativas generales

No contendrá documentación específica de ninguna disciplina.

## Roles

Cada disciplina dispondrá de una carpeta denominada:

5.x.5_Roles

La finalidad de estas carpetas será documentar exclusivamente la operación del rol correspondiente.

Cada documento describirá:

- propósito;
- responsabilidades;
- entradas;
- salidas;
- criterios de aceptación;
- criterios de devolución;
- interacción con el Orquestador;
- Hallazgos;
- prácticas obligatorias.

## Resultado

La estructura oficial evoluciona a:

5.0_Gobierno
├──5.0.1_Metodologia_Oficial
├──5.0.2_Decisiones
├──5.0.3_Hallazgos
├──5.0.4_Trazabilidad
├──5.0.5_Glosario
├──5.0.6_Plantillas
├──5.0.7_Roadmap
└──5.0.8_Operacion

5.1_Ingenieria
└──5.1.5_Roles

5.2_Analisis
└──5.2.5_Roles

5.3_Arquitectura
└──5.3.5_Roles

5.4_Desarrollo
└──5.4.5_Roles

5.5_QA
└──5.5.5_Roles

5.6_Evolucion
└──5.6.5_Roles

5.7_Integracion
└──5.7.5_Roles

## Impacto

Esta decisión incorpora oficialmente el modelo operativo de Yim sin modificar la responsabilidad de las disciplinas existentes.

No introduce duplicidad.

Mantiene una única fuente de verdad.

Preserva la trazabilidad documental.

Respeta la Convención Documental.