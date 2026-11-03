# =============================================================================
# T4 - PORTAFOLIO DE VISUALIZACIÓN CON ggplot2
# Parte 1 (Semana 10, 7 %) y Parte 2 (Semana 11, 7 %)
#
# Curso:  Fundamentos de Programación para Análisis Económico (136280)
#         Universidad de Concepción, sede Chillán - Segundo semestre 2026
# Autor:  Cristóbal Sepúlveda
# Fecha:  [FECHA]
# =============================================================================
#
# OBJETIVO
#   Construir gráficos que respondan preguntas económicas, sean honestos y se
#   lean sin explicación oral.
#
#   Parte 1: tres gráficos, tres bases distintas.
#   Parte 2: ¿cómo se distribuyen el ingreso (CASEN) y la informalidad laboral
#            (ENE) en Chile, y qué gráfico lo comunica mejor?
#
# BASES DE DATOS
#   1. data/raw/casen_reducido.csv       CASEN, 60 personas (5 NA en ingreso)
#   2. data/raw/salario_minimo_chile.csv Ingreso mínimo nominal e IPC, 2014-2025
#   3. data/raw/ene-2026-06-mjj.csv      ENE, trimestre mayo-julio 2026
#
# CONVENCIONES DE ESTE DOCUMENTO
#   ____                 Espacio por completar.
#   [COMPLETAR]          Bloque que debe escribirse completo.
#   [DECIDIR]            Decisión propia que debe justificarse por escrito.
#   [RESULTADO ESPERADO] Valor que se debería obtener al ejecutar el código.
#   [PREGUNTA]           Pregunta de la rúbrica. Se responde con palabras
#                        propias y con cifras.
#   [COMMIT SUGERIDO]    Punto recomendado para registrar el avance en GitHub.
#
# INSTRUCCIONES DE EJECUCIÓN
#   Abrir el proyecto desde T4.Rproj y ejecutar el script completo.
#   No utilizar setwd(): las rutas son relativas a la carpeta del proyecto.
#
# PUNTAJE (200 pts, rúbrica de Canvas)
#   Parte 1: Gráfico 1: 15 | Gráfico 2: 20 | Gráfico 3: 20 | Respuestas: 25
#            Checklist: 10 | Script y commits: 10
#   Parte 2: Gráficos 2, 3, 4 y 5: 12 c/u | Tema propio: 6
#            Figura compuesta: 12 | Checklist: 6 | Reflexión: 18
#            Script y commits: 10
# =============================================================================



# -----------------------------------------------------------------------------
# 0. PAQUETES Y CONFIGURACIÓN GENERAL
# -----------------------------------------------------------------------------

library(dplyr)       # Manipulación de datos: filter(), mutate(), select()
library(tidyr)       # Reorganización de datos: pivot_longer()
library(ggplot2)     # Construcción de los gráficos
library(scales)      # Formato de los ejes: pesos y porcentajes
library(patchwork)   # Composición de varios gráficos en una figura


pesos <- label_currency(big.mark = ".",       # Separador de miles chileno (punto)
                        decimal.mark = ",")   # Separador decimal chileno (coma)


azul <- "#0072B2"                             # Color principal (Okabe-Ito)
naranjo <- "#E69F00"                          # Color de resalte (Okabe-Ito)
gris <- "grey75"                              # Color de contexto


dir.create("output/figuras",                  # Carpeta donde se guardan las figuras
           recursive = TRUE,                  # Crea también las carpetas intermedias
           showWarnings = FALSE)              # No avisa si la carpeta ya existe




# #############################################################################
#
#                    PARTE 1 - TRES GRÁFICOS, TRES BASES
#                          (Semana 10 - 100 pts)
#
# #############################################################################



# =============================================================================
# 1. PARTE 1, GRÁFICO 1 - CASEN: EDUCACIÓN E INGRESO POR GÉNERO              (15 pts)
# =============================================================================
#
# Criterios de evaluación:
#   - Herencia de aes() correcta: una recta de regresión por género.
#   - Título que exprese el hallazgo.
#   - Eje en pesos, legible.
# -----------------------------------------------------------------------------


# 1.1 Carga y limpieza de datos
# -----------------------------------------------------------------------------

casen <- read.csv("data/raw/casen_reducido.csv") |>   # Lee la base CASEN
  filter(!is.na(ingreso))                                        # Elimina las filas con NA en ingreso


nrow(casen)                                           # Cuenta las personas que quedan

# [RESULTADO ESPERADO] 55 personas.



# 1.2 Construcción del gráfico
# -----------------------------------------------------------------------------
#
# Nota sobre la herencia de aes():
#   Si "color = genero" se escribe dentro del aes() de ggplot(), todas las
#   capas lo heredan (puntos y rectas), y se obtiene una recta por género.
#   Si se escribe solo dentro de geom_point(), la recta no lo hereda y se
#   obtiene una sola recta para todos. Se recomienda probar ambas versiones.

g1 <- ggplot(casen, aes(x = educ,                     # Eje X: años de escolaridad
                        y = ingreso,                  # Eje Y: ingreso mensual
                        color=genero)) +                      # Variable que define el color

  geom_point(alpha = 0.7,                             # Puntos semitransparentes
             size = 2) +                              # Tamaño de los puntos

  geom_smooth(method = "lm",                          # Recta de regresión lineal
              se = FALSE) +                           # Sin banda de error

  scale_color_manual(values = c(F = "#E69F00",        # Color para mujeres (Okabe-Ito)
                                M = "#0072B2"),       # Color para hombres (Okabe-Ito)
                     labels = c(F = "Mujeres",        # Texto de la leyenda para F
                                M = "Hombres")) +     # Texto de la leyenda para M

  scale_y_continuous(labels = pesos) +                 # Formato del eje Y en pesos

  labs(title    = "La brecha de ingreso por genero se achica con años de estudio",                             # Título: el hallazgo del gráfico
       subtitle = "Recta de regresión lineal por género",
       x        = "Años de escolaridad",              # Nombre del eje X
       y        = "Ingreso mensual",                  # Nombre del eje Y
       color    = NULL,                               # Leyenda sin título
       caption  = "Fuente: CASEN (muestra del curso, n = 55). Sin ponderar.") +

  theme_minimal() +                                   # Tema limpio, sin fondo gris

  theme(panel.grid.minor = element_blank(),           # Elimina la grilla secundaria
        legend.position  = "top")                     # Ubica la leyenda arriba


g1                                                    # Muestra el gráfico



# 1.3 Exportación
# -----------------------------------------------------------------------------

ggsave("output/figuras/t4p1_g1_casen.png",            # Ruta y nombre del archivo
       g1,                                            # Gráfico que se guarda
       width = 8, height = 5,                         # Tamaño en pulgadas
       dpi = 300)                                    # Resolución exigida por la tarea



# 1.4 Pregunta
# -----------------------------------------------------------------------------
#
# ¿Qué pregunta responde este gráfico que no respondería la versión
# con una sola recta?
#
# Con una sola recta no se vería la brecha de ingreso entre hombres y mujeres. 
# Al separar por género, se observa que con menos años de escolaridad la 
# diferencia de ingreso es mayor, y que a medida que aumentan los años de 
# estudio, la brecha se achica.
#
#
#
# -----------------------------------------------------------------------------




# =============================================================================
# 2. PARTE 1, GRÁFICO 2 - INGRESO MÍNIMO: NOMINAL CONTRA REAL                (20 pts)
# =============================================================================
#
# Criterios de evaluación:
#   - Datos en formato largo (pivot_longer).
#   - Etiquetas directas al final de cada línea, sin leyenda.
#   - Series diferenciadas por color y por tipo de línea.
# -----------------------------------------------------------------------------


# 2.1 Carga de datos y cálculo del salario real
# -----------------------------------------------------------------------------

salario <- read.csv("data/raw/salario_minimo_chile.csv")   # Lee la base de salario mínimo

head(salario)                                              # Revisa las primeras filas


# Salario real en pesos de 2010: nominal x 100 / IPC (el IPC vale 100 en 2010).

salario <- salario |>
  mutate(real = (salario_minimo*100/ipc))    # Crea la columna del salario real



# 2.2 Transformación a formato largo
# -----------------------------------------------------------------------------
#
# Se pasa de dos columnas (nominal y real) a una columna "serie" que indica
# el tipo de salario y una columna "valor" con el monto.

salario_largo <- salario |>
  select(anio,                                     # Conserva el año
         nominal = salario_minimo,                 # Renombra el salario nominal
         real) |>                                  # Conserva el salario real
  pivot_longer(cols = c(nominal, real),            # Columnas que se apilan
               names_to  = "serie",                # Columna con el nombre de la serie
               values_to = "valor") |>             # Columna con el monto
  mutate(serie = ifelse(serie == "nominal",        # Nombres legibles para las etiquetas
                        "Nominal",
                        "Real (pesos de 2010)"))


salario_largo                        # Muestra la tabla resultante

# [RESULTADO ESPERADO] 24 filas (12 años por 2 series).


etiquetas <- salario_largo |>
  filter(anio == max(anio))     # Solo el último año, para ubicar las etiquetas



# 2.3 Construcción del gráfico
# -----------------------------------------------------------------------------

g2 <- ggplot(salario_largo, aes(x = anio,                  # Eje X: año
                                y = valor,                 # Eje Y: monto del salario
                                color = serie,             # Un color por serie
                                linetype = serie)) +        # Un tipo de línea por serie

  geom_line(linewidth = 1) +                               # Grosor de la línea (linewidth, no size)

  geom_text(data = etiquetas,                              # Usa solo la tabla del último año
            aes(label = serie),                            # Texto: el nombre de la serie
            hjust = 0,                                     # Alinea el texto a la izquierda
            nudge_x = 0.2) +                               # Lo separa un poco del final de la línea

  scale_color_manual(values = c("#0072B2",                 # Color serie nominal (Okabe-Ito)
                                "#D55E00")) +              # Color serie real (Okabe-Ito)

  scale_x_continuous(breaks = 2014:2025,                   # Muestra todos los años en el eje
                     expand = expansion(mult = c(0.02,     # Margen izquierdo pequeño
                                                 0.25))) + # Margen derecho para las etiquetas

  scale_y_continuous(labels = pesos) +                     # Eje Y en pesos chilenos

  labs(title   = "Desde 2021 la inflación se come buena parte del alza del salario minimo",                                   # Título: el hallazgo del gráfico
       x       = NULL,                                     # Eje X sin nombre (son años)
       y       = "Ingreso mínimo mensual",                 # Nombre del eje Y
       caption = "Fuente: ingreso mínimo nominal e IPC, 2014-2025 (material del curso).") +

  theme_minimal() +                                        # Tema limpio

  theme(legend.position  = "none",                         # Oculta la leyenda
        panel.grid.minor = element_blank())                # Elimina la grilla secundaria


g2                                                         # Muestra el gráfico



# 2.4 Exportación
# -----------------------------------------------------------------------------

ggsave("output/figuras/t4p1_g2_salario.png",               # Ruta y nombre del archivo
       g2,                                                 # Gráfico que se guarda
       width = 8, height = 5,                              # Tamaño en pulgadas
       dpi = 300)                                          # Resolución de impresión



# 2.5 Preguntas
# -----------------------------------------------------------------------------
#
# ¿Por qué en este gráfico el eje Y no necesita partir en 0 y en
# un gráfico de barras sí?
#
# En un gráfico de líneas no es necesario que el eje Y parta en cero, porque 
# lo que importa no es el valor desde el inicio, sino ver cómo la línea sube y 
# baja en el tiempo. Además, en este caso el eje Y muestra ingresos, y 
# no existen ingresos mínimos cercanos a cero. En cambio, en un gráfico de barras 
# el largo de la barra representa el dato, por lo que si el eje no parte en cero 
# se exageran las diferencias
#
#
#
# ¿Qué se gana usando color y tipo de línea al mismo tiempo?
#
# Usar color y tipo de línea al mismo tiempo es una codificación redundante: 
# las dos series se distinguen por dos señales distintas. Si se usara el mismo color 
# y el mismo tipo de línea, el gráfico sería más difícil de leer. Además, si las series 
# se diferenciaran solo por color, una persona daltónica o alguien que imprime en blanco 
# y negro no podría distinguirlas, pero con el tipo de línea igual puede hacerlo.
#
#
#
# -----------------------------------------------------------------------------




# =============================================================================
# 3. PARTE 1, GRÁFICO 3 - ENE: EN QUÉ TRABAJAN HOMBRES Y MUJERES             
# =============================================================================
#
# Criterios de evaluación:
#   - Ponderado con fact_cal.
#   - Barras en proporción (position = "fill").
#   - Paleta accesible y eje en porcentaje.
#
# Códigos de la ENE (manual codigos-ene-2020.pdf):
#   sexo                 1 = hombre, 2 = mujer
#   categoria_ocupacion  1 = empleador, 2 = cuenta propia,
#                        3 = asalariado privado, 4 = asalariado público,
#                        5 y 6 = servicio doméstico, 7 = familiar no remunerado
# -----------------------------------------------------------------------------


# 3.1 Carga y preparación de datos
# -----------------------------------------------------------------------------

ocupados <- read.csv2("data/raw/ene-2026-06-mjj.csv") |>   # read.csv2: separador ";"
  filter(activ == 1) |>                                 # Conserva solo a los ocupados
  mutate(
    sexo = ifelse(sexo == 1,                               # Convierte el código en texto
                  "Hombres",
                  "Mujeres"),
    categoria = case_when(                                 # Asigna nombre a cada código
      categoria_ocupacion == 1     ~ "Empleador",
      categoria_ocupacion == 2     ~ "Cuenta propia",
      categoria_ocupacion == 3     ~ "Asalariado privado",
      categoria_ocupacion == 4     ~ "Asalariado público",
      categoria_ocupacion %in% 5:6 ~ "Servicio doméstico",
      categoria_ocupacion == 7     ~ "Familiar no remunerado")
  )


table(ocupados$categoria, useNA = "ifany")                 # Verifica que no queden NA



# 3.2 Construcción del gráfico
# -----------------------------------------------------------------------------

g3 <- ggplot(ocupados, aes(x = sexo,                       # Una barra por sexo
                           fill = categoria,               # Color según categoría ocupacional
                           weight = fact_cal)) +               # Factor de expansión (ponderación)

  geom_bar(position = "fill",                              # Cada barra suma 100 %
           width = 0.6) +                                  # Ancho de las barras

  scale_fill_viridis_d() +                                 # Paleta accesible para daltonismo

  scale_y_continuous(labels = label_percent()) +       # Eje Y en porcentaje

  labs(title   = "El servicio domestico es casi exclusivo de las mujeres",                                   # Título: el hallazgo del gráfico
       x       = NULL,                                     # Eje X sin nombre
       y       = "Porcentaje de ocupados",                 # Nombre del eje Y
       fill    = NULL,                                     # Leyenda sin título
       caption = "Fuente: INE, ENE mayo-julio 2026. Ocupados, ponderado con fact_cal.") +

  theme_minimal() +                                        # Tema limpio

  theme(panel.grid.minor = element_blank())                # Elimina la grilla secundaria


g3                                                         # Muestra el gráfico



# 3.3 Exportación
# -----------------------------------------------------------------------------

ggsave("output/figuras/t4p1_g3_ene.png",                   # Ruta y nombre del archivo
       g3,                                                 # Gráfico que se guarda
       width = 8, height = 5,                              # Tamaño en pulgadas
       dpi = 300)                                          # Resolución de impresión



# 3.4 Tabla de apoyo para responder con cifras
# -----------------------------------------------------------------------------
#
# Tabla con el porcentaje ponderado de ocupados por sexo y
# categoría. Funciones sugeridas: count(sexo, categoria,
# wt = fact_cal), group_by(sexo) y mutate().


tabla_g3 <- ocupados |>
  count(sexo, categoria, wt = fact_cal) |> # Suma ponderada por sexo y categoría
  group_by(sexo) |>                        # Calcula dentro de cada sexo
  mutate(pct = round(100 * n / sum(n), 1)) # Porcentaje de cada categoría

tabla_g3


# 3.5 Preguntas
# -----------------------------------------------------------------------------
#
# ¿En qué categoría está la mayor diferencia entre hombres y
# mujeres, y en cuál casi no hay diferencia? Indicar las cifras.
#
# La mayor diferencia entre hombres y mujeres está en la categoría asalariado 
# privado: 64,9 % de los hombres ocupados trabaja en ella, contra 53,9 % de las 
# mujeres, lo que equivale a 11 puntos porcentuales. En cambio, en cuenta propia 
# casi no hay diferencia: 21,1 % de los hombres y 21,2 % de las mujeres
#
#
#
# ¿Qué cambiaría si se elimina weight = fact_cal?
# (Se sugiere repetir el gráfico sin ponderar y comparar.)
#
# Comparación: la misma tabla, pero SIN ponderar

   tabla_sin_peso <- ocupados |>
  count(sexo, categoria) |> # Cuenta personas, sin fact_cal
  group_by(sexo) |>
  mutate(pct = round(100 * n / sum(n), 1)) # Porcentaje sin ponderar

   tabla_sin_peso
#
# Si se elimina weight = fact_cal, cada persona encuestada cuenta lo mismo y 
# los porcentajes cambian entre 1 y 3 puntos. Por ejemplo, las mujeres asalariadas
# privadas pasan de 53,9 % a 50,4 %, y la brecha en esa categoría sube de 11 a 12,5 
# puntos. El panorama general se mantiene, pero las cifras sin ponderar solo describen 
# a la muestra, no a los ocupados de Chile, porque el factor de expansión corrige 
# que algunos grupos estén sobrerrepresentados en la encuesta.
#
# -----------------------------------------------------------------------------





# =============================================================================
# 4. CHECKLIST FINAL PARTE 1 
# =============================================================================
#
# Revisar antes de entregar:
#
# [x] El título de cada gráfico expresa el hallazgo, no las variables.
# [x] Las barras parten desde 0 (gráfico 3). No se usó ylim().
# [x] Paletas accesibles (Okabe-Ito, viridis). Sin rojo contra verde.
# [x] Etiquetas directas en el gráfico 2, sin leyenda.
# [x] Ejes con unidades: pesos en los gráficos 1 y 2, porcentaje en el 3.
# [x] Fuente en la caption, indicando si los datos están ponderados.
# [x] Las tres figuras exportadas con ggsave() a 300 dpi.
# [x] El script se ejecuta completo al abrir T4.Rproj, sin modificaciones.
#
# =============================================================================




# #############################################################################
#
#                 PARTE 2 - PORTAFOLIO Y FIGURA COMPUESTA
#                          (Semana 11 - 100 pts)
#
# #############################################################################



# =============================================================================
# 5. TEMA PROPIO                                                     
# =============================================================================
#
# Criterios de evaluación:
#   - Definido como función.
#   - Con al menos dos cambios respecto del tema base.
#   - Activado para todos los gráficos con theme_set().
# -----------------------------------------------------------------------------

  tema_t4 <- function(base = 12) { # Función con un argumento: tamaño de letra
    
    theme_minimal(base_size = base) + # Tema de partida
      
      theme(
        plot.title = element_text(face = "bold"), # Cambio 1: título en negrita
        panel.grid.minor = element_blank(), # Cambio 2: sin grilla secundaria
        legend.position = "top" # Cambio 3: leyenda arriba
      )
  }
   
   
   theme_set(tema_t4()) # Activa el tema para todo el script
   ```



# =============================================================================
# 6. PREPARACIÓN DE DATOS PARA LA PARTE 2
# =============================================================================


# 6.1 Variables adicionales de la ENE
# -----------------------------------------------------------------------------
#
# Se reutilizan las bases "casen" y "ocupados" cargadas en la Parte 1.
# Aquí solo se agregan las variables que necesita la Parte 2.
#
# Códigos de la ENE (manual codigos-ene-2020.pdf):
#   ocup_form    1 = formal, 2 = informal
#   region       1 a 16, en el orden del vector "regiones"
#   habituales   horas habituales semanales (888 y 999 = centinelas)
#   efectivas    horas efectivas semanales  (888 y 999 = centinelas)

regiones <- c("Tarapacá", "Antofagasta", "Atacama", "Coquimbo", "Valparaíso",
              "O'Higgins", "Maule", "Biobío", "La Araucanía", "Los Lagos",
              "Aysén", "Magallanes", "Metropolitana", "Los Ríos",
              "Arica y Parinacota", "Ñuble")      # Nombres en el orden del código 1 a 16


ocupados <- ocupados |>
  mutate(
    informal   = ocup_form == ____,                       # TRUE si es informal
    region_txt = regiones[region]                         # Código de región a nombre
  )


nrow(ocupados)                                            # Número de ocupados en la muestra

# [RESULTADO ESPERADO] 41.850 ocupados.



# 6.2 Revisión de centinelas y del código 9
# -----------------------------------------------------------------------------
#
# La rúbrica pide excluir el "código 9" y limpiar los centinelas. Antes de
# filtrar, revisar en qué variables aparecen.

table(ocupados$habituales >= 888)                         # Cuántos centinelas hay en habituales
table(ocupados$efectivas  >= 888)                         # Cuántos centinelas hay en efectivas


# Revisar con table() si alguna variable que se use en los
#             gráficos tiene el código 9 (no sabe / no responde) y anotar
#             aquí cuál es:


 table(ocupados$categoria_ocupacion, useNA = "ifany") # Códigos de categoría ocupacional
 
 table(ocupados$ocup_form, useNA = "ifany") # Códigos de formal / informal
 
 
#             Variable con código 9: ____________________
 
 
# Variable con código 9: ninguna. Se revisaron categoria_ocupacion (códigos 1 a 7) 
# y ocup_form (1 y 2), y no presentan el código 9 ni valores NA en este trimestre. 
# Los únicos valores a limpiar son los centinelas 888 y 999 en habituales y efectivas.

# 103 casos con 888 y 8 con 999, en ambas variables.




# =============================================================================
# 7. PARTE 2, GRÁFICO 1 - CASEN: MODELO DE REFERENCIA DE ESTILO
# =============================================================================
#
# Este gráfico no tiene puntaje propio. Sirve como referencia de estilo para
# los demás. Puede reutilizarse el gráfico g1 de la Parte 1.
# -----------------------------------------------------------------------------

p2_g1 <- ggplot(casen, aes(x = educ,                         # Eje X: años de escolaridad
                        y = ingreso,                      # Eje Y: ingreso mensual
                        color = genero)) +                # Un color por género

  geom_point(alpha = 0.7, size = 2) +                     # Puntos semitransparentes

  geom_smooth(method = "lm", se = FALSE) +                # Una recta por género

  scale_color_manual(values = c(F = naranjo, M = azul),   # Colores accesibles
                     labels = c(F = "Mujeres", M = "Hombres")) +

  scale_y_continuous(labels = pesos) +                    # Eje Y en pesos

  labs(title   = "La brecha de ingreso por género se achica con más años de estudio",                                  # Título: el hallazgo
       x       = "Años de escolaridad",
       y       = "Ingreso mensual",
       color   = NULL,
       caption = "Fuente: CASEN (muestra del curso, n = 55). Sin ponderar.")


p2_g1                                                        # Muestra el gráfico


ggsave("output/figuras/t4p2_g1_casen.png", p2_g1,            # Exporta a 300 dpi
       width = 8, height = 5, dpi = 300)




# =============================================================================
# 8. PARTE 2, GRÁFICO 2 - ENE: DISTRIBUCIÓN DE HORAS HABITUALES POR SEXO     
# =============================================================================
#
# Criterios de evaluación:
#   - Código 9 excluido y centinelas limpios.
#   - Ponderado con fact_cal.
#   - Geom elegido y justificado (densidad, boxplot o violín).
# -----------------------------------------------------------------------------


# 8.1 Limpieza
# -----------------------------------------------------------------------------

horas <- ocupados |>
  filter(habituales  < 888)                                      # Elimina los centinelas 888 y 999


nrow(horas)                                               # Ocupados que quedan

# [RESULTADO ESPERADO] 41.739 ocupados.



# 8.2 Construcción del gráfico
# -----------------------------------------------------------------------------
#
# Elegir UN geom: geom_density(), geom_boxplot() o geom_violin().
# Los tres aceptan aes(weight = fact_cal).

p2_g2 <- ggplot(horas, aes(x = sexo,                   # Eje X (depende del geom elegido)
                        y = habituales,                      # Eje Y (depende del geom elegido)
                        fill = sexo,                   # Un color por sexo
                        weight = fact_cal)) +              # Ponderación

  geom_violin() +                                 # Geom elegido y sus argumentos

  scale_fill_manual(values = c(Hombres = azul,            # Colores accesibles
                               Mujeres = naranjo)) +

  labs(title   = "las mujeres trabajan jornadas más variadas, los hombres más completas",                                  # Título: el hallazgo
       x       = NULL,
       y       = "horas habituales en semana",
       fill    = NULL,
       caption = "Fuente: INE, ENE mayo-julio 2026. Ocupados, ponderado con fact_cal.")


p2_g2                                                        # Muestra el gráfico


ggsave("output/figuras/t4p2_g2_horas.png", p2_g2,            # Exporta a 300 dpi
       width = 8, height = 5, dpi = 300)



# 8.3 Justificación del geom
# -----------------------------------------------------------------------------
#
# ¿Por qué se eligió este geom y no los otros dos?
#
# Se eligió el violín porque muestra la forma completa de la distribución de 
# horas de cada sexo, uno al lado del otro. Esto permite ver que los hombres se 
# concentran en jornada completa, mientras que las mujeres tienen más presencia 
# en jornadas parciales. Un boxplot solo mostraría la mediana y los cuartiles, y 
# escondería ese grupo de jornadas cortas. Una densidad superpondría las dos 
# curvas y una taparía a la otra. Además, con más de 40.000 ocupados, la forma 
# que muestra el violín es confiable
#
#
#
# -----------------------------------------------------------------------------





# =============================================================================
# 9. PARTE 2, GRÁFICO 3 - ENE: HORAS HABITUALES CONTRA HORAS EFECTIVAS       (12 pts)
# =============================================================================
#
# Criterios de evaluación:
#   - Centinelas limpios en las DOS variables.
#   - Sin "mancha" de puntos: usar alpha o geom_bin_2d().
#   - Diagonal y = x como referencia.
#   - Ceros interpretados con el manual de la ENE.
# -----------------------------------------------------------------------------


# 9.1 Limpieza
# -----------------------------------------------------------------------------

horas2 <- ocupados |>
  filter(habituales < 888,                                # Centinelas en habituales
         ____ < 888)                                      # Centinelas en efectivas


sum(horas2$efectivas == 0)                                # Cuántos ocupados tienen 0 horas efectivas

# [RESULTADO ESPERADO] alrededor de 2.100 personas con 0 horas efectivas.



# 9.2 Construcción del gráfico
# -----------------------------------------------------------------------------
#
# [DECIDIR] geom_point() con alpha bajo, o geom_bin_2d(). Con más de 40.000
#           personas, los puntos opacos forman una mancha que oculta la
#           densidad.

p2_g3 <- ggplot(horas2, aes(x = habituales,                  # Eje X: horas habituales
                         y = efectivas)) +                # Eje Y: horas efectivas

  ____(____) +                                            # alpha bajo o geom_bin_2d()

  geom_abline(intercept = 0,                              # Diagonal y = x:
              slope = ____,                               # sobre ella, efectivas = habituales
              linetype = "dashed",
              color = "grey40") +

  coord_equal() +                                         # Misma escala en ambos ejes

  labs(title   = "____",                                  # Título: el hallazgo
       x       = "Horas habituales por semana",
       y       = "Horas efectivas por semana",
       caption = "Fuente: INE, ENE mayo-julio 2026. Ocupados, sin centinelas 888 y 999.")


p2_g3                                                        # Muestra el gráfico


ggsave("output/figuras/t4p2_g3_habituales_efectivas.png", p2_g3,
       width = 7, height = 7, dpi = 300)                  # Cuadrado, por coord_equal()



# 9.3 Interpretación de los ceros
# -----------------------------------------------------------------------------
#
# [PREGUNTA] Según el manual de la ENE, ¿quiénes son los ocupados con 0 horas
#            efectivas? ¿Qué significan los puntos sobre y bajo la diagonal?
#
# Respuesta:
#
#
#
# -----------------------------------------------------------------------------
# [COMMIT SUGERIDO] "T4 P2: gráfico 3, horas habituales vs efectivas"




# =============================================================================
# 10. PARTE 2, GRÁFICO 4 - ENE: INFORMALIDAD POR REGIÓN CON INTERVALOS        (12 pts)
# =============================================================================
#
# Criterios de evaluación:
#   - Intervalo de confianza calculado correctamente.
#   - geom_pointrange().
#   - Limitación del intervalo reconocida.
#
# Fórmula (proporción):
#   p  = tasa de informalidad ponderada
#   se = raíz( p * (1 - p) / n )
#   IC = p +/- 1,96 * se
# -----------------------------------------------------------------------------


# 10.1 Cálculo del intervalo
# -----------------------------------------------------------------------------

ic_region <- ocupados |>
  group_by(____) |>                                       # Una fila por región
  summarise(
    n    = n(),                                           # Personas encuestadas
    p    = weighted.mean(informal, ____),                 # Tasa ponderada
    se   = sqrt(____),                                    # Error estándar
    bajo = p - 1.96 * se,                                 # Límite inferior
    alto = ____                                           # Límite superior
  )


ic_region |> arrange(p)                                   # Revisa la tabla ordenada


nacional <- weighted.mean(ocupados$informal,              # Tasa nacional, para la
                          ocupados$fact_cal)              # línea de referencia



# 10.2 Construcción del gráfico
# -----------------------------------------------------------------------------

p2_g4 <- ggplot(ic_region, aes(x = p,                        # Eje X: tasa de informalidad
                            y = reorder(region_txt, p),   # Regiones ordenadas por tasa
                            color = region_txt == "Ñuble")) +  # Resalta una región

  geom_vline(xintercept = ____,                           # Línea del promedio nacional
             linetype = "dashed",
             color = "grey40") +

  geom_pointrange(aes(xmin = ____,                        # Inicio del intervalo
                      xmax = ____)) +                     # Fin del intervalo

  scale_color_manual(values = c(gris, naranjo),           # Gris contexto, naranjo resalte
                     guide = "none") +                    # Sin leyenda

  scale_x_continuous(labels = label_percent()) +          # Eje X en porcentaje

  labs(title   = "____",                                  # Título: el hallazgo
       x       = "Tasa de informalidad (IC 95 %)",
       y       = NULL,
       caption = "Fuente: INE, ENE mayo-julio 2026. Ponderado con fact_cal. Línea: promedio nacional.")


p2_g4                                                        # Muestra el gráfico


ggsave("output/figuras/t4p2_g4_informalidad_region.png", p2_g4,
       width = 8, height = 6, dpi = 300)



# 10.3 Limitación
# -----------------------------------------------------------------------------
#
# [PREGUNTA] ¿Qué limitación tiene este intervalo? (Pista: la ENE no es una
#            muestra aleatoria simple; tiene estratos y conglomerados.)
#
# Respuesta:
#
#
#
# -----------------------------------------------------------------------------
# [COMMIT SUGERIDO] "T4 P2: gráfico 4, informalidad por región con IC"




# =============================================================================
# 11. PARTE 2, GRÁFICO 5 - PREGUNTA PROPIA CON INTERVALOS                     (12 pts)
# =============================================================================
#
# Criterios de evaluación:
#   - Intervalo de confianza calculado correctamente.
#   - geom_pointrange().
#   - Limitación del intervalo reconocida.
#
# [DECIDIR] Pregunta propia, con CASEN o ENE. Ideas:
#   - Informalidad por tramo de edad (la "U" de la informalidad).
#   - Horas habituales promedio por categoría ocupacional.
#   - Ingreso medio por sector en la CASEN.
#
# Fórmula (media):
#   se = desviación estándar / raíz(n)
#   IC = media +/- t * se,   con t = qt(0.975, df = n - 1)
#
# Mi pregunta: ________________________________________________________________
# -----------------------------------------------------------------------------


# 11.1 Cálculo del intervalo
# -----------------------------------------------------------------------------
#
# [COMPLETAR] Tabla con una fila por grupo y las columnas n, media (o p),
#             se, bajo y alto.

ic_propio <- ____ |>
  group_by(____) |>
  summarise(
    n     = n(),
    media = ____,
    se    = ____,
    bajo  = ____,
    alto  = ____
  )


ic_propio                                                 # Revisa la tabla



# 11.2 Construcción del gráfico
# -----------------------------------------------------------------------------

p2_g5 <- ggplot(ic_propio, aes(x = ____,                     # Variable de grupo o valor
                            y = ____)) +

  geom_pointrange(aes(____ = bajo,                        # xmin/ymin según orientación
                      ____ = alto),
                  color = azul) +

  labs(title   = "____",                                  # Título: el hallazgo
       x       = "____",
       y       = "____",
       caption = "Fuente: ____.")


p2_g5                                                        # Muestra el gráfico


ggsave("output/figuras/t4p2_g5_propio.png", p2_g5,
       width = 8, height = 5, dpi = 300)



# 11.3 Limitación
# -----------------------------------------------------------------------------
#
# [PREGUNTA] ¿Qué limitación tiene este intervalo?
#
# Respuesta:
#
#
#
# -----------------------------------------------------------------------------
# [COMMIT SUGERIDO] "T4 P2: gráfico 5, pregunta propia con IC"




# =============================================================================
# 12. FIGURA COMPUESTA                                               (12 pts)
# =============================================================================
#
# Criterios de evaluación:
#   - Tres paneles rotulados A, B, C.
#   - Título general que exprese el hallazgo de la figura completa.
#   - Fuente en la caption.
#   - Exportada en PNG (300 dpi) y PDF.
#
# Precedencia de operadores: en R, "+" se evalúa antes que "|" y "/".
# Por eso la composición va entre paréntesis EXTERNOS antes de plot_layout()
# y plot_annotation(). Sin ellos, el título y los rótulos no aparecen.
#
# [DECIDIR] Qué tres gráficos combinar y en qué disposición.
# -----------------------------------------------------------------------------

figura <- (____ | (____ / ____)) +                        # Izquierda | (arriba / abajo)

  plot_layout(widths = c(1, 1.3)) +                       # Ancho relativo de las columnas

  plot_annotation(
    title      = "____",                                  # Hallazgo de la figura completa
    caption    = "Fuente: ____.",                         # Fuente de los datos
    tag_levels = "____"                                   # Rótulos de los paneles
  )


figura                                                    # Muestra la figura


ggsave("output/figuras/t4p2_figura.png", figura,          # Versión PNG (imagen)
       width = 12, height = 7, dpi = ____)

ggsave("output/figuras/t4p2_figura.pdf", figura,          # Versión PDF (vectorial)
       width = 12, height = 7)

# -----------------------------------------------------------------------------
# [COMMIT SUGERIDO] "T4 P2: figura compuesta en PNG y PDF"




# =============================================================================
# 13. REFLEXIÓN (media página)                                       (18 pts)
# =============================================================================
#
# Responder con el vocabulario de la Semana 9 (chart junk, color con función,
# honestidad, claridad, etc.), argumentando con conceptos y no con gustos.
#
# [PREGUNTA 1] De los cinco gráficos, ¿cuál comunica mejor su hallazgo y por qué?
#
# Respuesta:
#
#
#
# [PREGUNTA 2] En el gráfico 2 de la Parte 2, ¿por qué se eligió ese geom y no otro?
#
# Respuesta:
#
#
#
# [PREGUNTA 3] ¿Qué agrega la figura compuesta que no dan los gráficos por separado?
#
# Respuesta:
#
#
#
# [PREGUNTA 4] La rúbrica de Canvas pide cuatro preguntas, pero el enunciado
#              solo trae tres. Confirmar cuál es la cuarta.
#              ____________________________________________________________
#
# Respuesta:
#
#
#
# -----------------------------------------------------------------------------
# [COMMIT SUGERIDO] "T4 P2: reflexión"




# =============================================================================
# 14. CHECKLIST FINAL PARTE 2 (6 pts)
# =============================================================================
#
# Revisar antes de entregar:
#
# [ ] El título de cada gráfico expresa el hallazgo, no las variables.
# [ ] Las barras y áreas parten desde 0. No se usó ylim().
# [ ] Paletas accesibles (Okabe-Ito, viridis). Sin rojo contra verde.
# [ ] El color tiene función: gris para el contexto, un color para el mensaje.
# [ ] Ejes con unidades: pesos, horas o porcentaje.
# [ ] Fuente en la caption, indicando si los datos están ponderados.
# [ ] Cifras de la ENE ponderadas con fact_cal.
# [ ] Todas las figuras exportadas con ggsave() a 300 dpi; la compuesta también en PDF.
# [ ] El script se ejecuta completo al abrir T4.Rproj, sin modificaciones.
#
# =============================================================================
