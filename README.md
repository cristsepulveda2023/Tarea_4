# T4 — Portafolio de visualización con ggplot2

Fundamentos de Programación para Análisis Económico (136280) · UdeC · 2026-2
Autor: Cristóbal Sepúlveda

## Estructura

```
Tarea_4/
├── T4.Rproj
├── data/raw/          casen_reducido.csv · salario_minimo_chile.csv · ene-2026-06-mjj.csv
├── scripts/           t4.R (Parte 1 y Parte 2)
└── output/figuras/    figuras exportadas a 300 dpi
```

Para reproducir: abrir `T4.Rproj` y correr `scripts/t4.R` completo.

## Parte 1 — Figuras

| Figura | Qué muestra | Hallazgo |
|---|---|---|
| `t4p1_g1_casen.png` | Ingreso según años de escolaridad, con una recta por género (CASEN) | La brecha de ingreso por género se achica con más años de estudio. |
| `t4p1_g2_salario.png` | Ingreso mínimo nominal y real (pesos de 2010), 2014-2025 | Desde 2021, la inflación se come buena parte del alza del salario mínimo. |
| `t4p1_g3_ene.png` | Composición de los ocupados por categoría ocupacional, según sexo (ENE ponderada) | El servicio doméstico es casi exclusivo de las mujeres (5,1 % contra 0,1 %). |

## Parte 2 — Figuras

| Figura | Qué muestra | Hallazgo |
|---|---|---|
| `t4p2_g1_casen.png` | Ingreso según escolaridad y género (gráfico de referencia de estilo) | La brecha de ingreso por género se achica con más años de estudio. |
| `t4p2_g2_horas.png` | Distribución de horas habituales por sexo, en violín (ENE ponderada) | Las mujeres trabajan jornadas más variadas; los hombres, más jornadas completas. |
| `t4p2_g3_habituales_efectivas.png` | Horas habituales contra horas efectivas, con diagonal y = x (ENE) | La mayoría trabajó sus horas habituales; los que se apartan trabajaron menos. |
| `t4p2_g4_informalidad_region.png` | Tasa de informalidad por región con IC 95 % y promedio nacional (ENE ponderada) | La informalidad es mayor en el sur: Ñuble y La Araucanía superan el 34 %. |
| `t4p2_g5_informalidad_edad.png` | Tasa de informalidad por tramo de edad con IC 95 % (ENE ponderada) | La informalidad forma una U: más alta en jóvenes y, sobre todo, en mayores de 65. |
| `t4p2_figura.png` / `.pdf` | Figura compuesta: informalidad por región (A), horas por sexo (B) e informalidad por edad (C) | La informalidad laboral en Chile depende de dónde vives y de tu edad. |

## Declaración de autoría y uso de IA
- **Herramienta utilizada:** Claude (Anthropic).
- **Para qué la usé:**
  - Interpretar la pauta y la rúbrica de la tarea, ya que en Canvas no estaban los esqueletos de la T4.
  - Generar la estructura base del script, con los espacios por completar y comentarios por línea.
  - Resolver errores (ruta de trabajo, signos `+` faltantes, `label_percent()`, llaves de la función del tema).
  - Ordenar la redacción de las respuestas a partir de las ideas que le dicté por voz.
- **Qué hice yo:**
  - Completé el código de la Parte 1 y de los gráficos de la Parte 2.
  - Leí cada gráfico y propuse sus hallazgos.
  - Elegí el violín para el gráfico de horas, la pregunta del gráfico 5 (informalidad por edad) y los tres paneles de la figura.
  - Revisé las cifras y armé el repositorio con commits por avance.
- **Prompts clave (bitácora):**
  - "Analiza lo que dice la pauta y dime qué scripts necesito."
  - "Hazme un formato base para rellenarlo con los gráficos."
  - "¿Qué se gana usando color y tipo de línea al mismo tiempo?"

