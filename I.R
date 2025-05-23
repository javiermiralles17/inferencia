# TEMA 2 : CONTRASTES NO PARAMÉTRICOS CLÁSICOS ----
# T2 - CONTRASTE DE SIGNOS PARA LA MEDIANA ----

# Ejemplo: Los tiempos de supervivencia, en semanas, de n = 10 pacientes con un tipo de linfoma
# fueron 49, 58, 75, 110, 112, 132, 151, 276, 281, 362. Contrastar si puede suponerse que la
# mediana del tiempo de supervivencia es de m_0 = 200 semanas.

library(DescTools)
tiempos <- c(49, 58, 75, 110, 112, 132, 151, 276, 281, 362) ; tiempos
SignTest(x=tiempos, mu=200, alternative="two.sided")

### LA MEDIANA DE LAS DIFERENCIAS SE PUEDE CALCULAR A MANO; ES LA MEDIANA DE LOS TIEMPOS

### FORMA ALTERNATIVA:
binom.test(x=3, n=10, p=0.5, alternative="two.sided")

# Ejemplo: Se somete a 7 pacientes con temor al vómito a cierto tratamiento. El efecto que se
# desea obtener con esta terapia es la reducción de la ansiedad causada por el vómito. Cada
# paciente pasó un test, antes y después del tratamiento, que evaluaba su sensación de temor
# (valores altos indican más temor). ¿Puede afirmarse que el tratamiento tuvo los efectos
# deseados?

## COMO SE TOMAN 2 MEDICIONES SOBRE LOS MISMOS INDIVIDUOS EN DIFERENTES ESPACIOS DE TIEMPO,
## TENEMOS MUESTRAS APAREADAS Y PODEMOS USAR EL CONTRASTE DE SIGNOS

antes <- c(10.6, 7.9, 12.4, 16.8, 13.2, 14.7, 18.34) ; antes
despues <- c(7.15, 9.36, 6.27, 7.19, 5.45, 6.21, 8) ; despues
SignTest(x=antes, y=despues, mu=0, alternative="greater")

# T2 - CONTRASTE DE RANGOS ASIGNADOS PARA LA MEDIANA DE WILCOXON ----

# Cuando la distribución es simétrica
# Ejemplo: Aplicar el contraste de rangos signados a los datos del vómito.

wilcox.test(x=antes, y=despues, mu=0, paired=TRUE, alternative="greater")

## V ES LA SUMA DE RANGOS POSITIVOS ; POR DEFECTO LA FUNCIÓN UTILIZA LA CORRECCIÓN Y NO DA EL
## P-VALOR EXACTO, SI QUEREMOS EXACTO USAMOS exact=true, PERO PARA DATOS GRANDES NO CONVIENE

# T2 - CONTRASTE DE DESPLAZAMIENTO DE MEDIANAS (MANN-WHITNEY) ----

# Ejemplo: Supongamos que tenemos muestras X=(1.69, 1.67, 1.74, 1.63, 1.65) e
# Y=(1.73, 1.92, 1.85, 1.8) independientes, que provienen de distribuciones que sólo difieren
# en un desplazamiento de medianas. Contrastar H_0: m_X = m_Y frente a H_1: m_X < m_Y.

m_x <- c(1.69, 1.67, 1.74, 1.63, 1.65) ; m_x
m_y <- c(1.73, 1.92, 1.85, 1.8) ; m_y
wilcox.test(x=m_x, y=m_y, mu=0, paired=FALSE, alternative="less")

## COMO ESTAMOS COMPARANDO SI LAS DOS MEDIANAS SON IGUALES, LO QUE INDICAMOS EN LA VARIABLE mu
## ES LA DIFERENCIA DE DICHAS MEDIANAS

# T2 - CONTRASTE PARA MÁS DE DOS MEDIANAS DE MUESTRAS INDEPENDIENTES (KRUSKAL-WALLIS) ----

# Ejemplo: Disponemos de 4 métodos de cultivo del maíz ensayados en n = 74 parcelas de cultivo
# experimental. Tenemos una variable respuesta de tipo continuo que mide el rendimiento del
# cultivo, de la cual se han observado los siguientes datos. Contrastar la hipótesis
# H_0: m_1 = m_2 = m_3 = m_4.

rendimientos <- c(
  83, 91, 94, 89, 89, 96, 91, 92, 90, 93, 91, 95, 86, 91, 89, 92, 90,
  91, 90, 81, 83, 84, 83, 88, 91, 89, 84, 82, 86, 84, 84, 91, 89, 90, 91, 83,
  101,100,91, 93, 96, 95, 94, 98, 95, 92, 80, 79, 82,
  78, 82, 81, 77, 79, 81, 80, 81, 81, 81, 94, 96, 101,81, 78
)

## Pasamos los rendimientos a 4 vectores, cada vector corresponde al rendimiento de uno de los
## cuatro métodos
r1 <- c(83, 91, 94, 89, 89, 96, 91, 92, 90, 93, 91, 95, 86, 91, 89, 92, 90)
r2 <- c(91, 90, 81, 83, 84, 83, 88, 91, 89, 84, 82, 86, 84, 84, 91, 89, 90, 91, 83)
r3 <- c(101,100,91, 93, 96, 95, 94, 98, 95, 92, 80, 79, 82)
r4 <- c(78, 82, 81, 77, 79, 81, 80, 81, 81, 81, 94, 96, 101,81, 78)

## Lamamos a la función que aplica el test de Kruskal-Wallis para más de dos muestras indep.
kruskal.test(x = list(r1, r2, r3, r4))

## El contraste resulta significativo y por tanto realizamos las comparaciones múltiples; vamos
## a usar el contraste de Conover-Iman

library(PMCMRplus)
kwAllPairsConoverTest(x = list(r1, r2, r3, r4))

# Encontramos diferencias significativas entre los métodos: 1-4 ; 2-3 ; 3-4 ; y ninguna más

# T2 - CONTRASTE PARA MÁS DE DOS MEDIANAS DE MUESTRAS RELACIONADAS (FRIEDMAN) ----

# Ejemplo: Se quiere comparar la velocidad de 3 impresoras midiendo el tiempo de impresión de 5
# documentos. Contrastar la hipótesis de que las 3 impresoras son igualmente rápidas.

datos_impresora <- matrix(
  data = c(4.7, 6.8, 9.0, 3.8, 8.5, 9.5, 8.0, 13.0, 12.9, 13.6, 16.8, 17.7, 18.1, 26.7, 23.6),
  nrow = 5,
  ncol = 3,
  byrow = TRUE,
  dimnames = list(
    c("Doc1", "Doc2", "Doc3", "Doc4", "Doc5"),
    c("Impr1", "Impr2", "Impr3")
  )
)

# Mostramos la matriz para comprobar que la hemos escrito de forma adecuada
datos_impresora

# Aplicamos el test de Friedman a los datos
friedman.test(datos_impresora)

# Como se observan diferencias significativas entre las impresoras, realizamos las comparaciones
# múltiples usando el contraste exacto de Elsinga-Heskes-Pelzer-Grotenhuis (EHPG)

frdAllPairsExactTest(datos_impresora)

# Vemos que sólo hay diferencias significativas entre la impresora 1 y la impresora 3

# T2 - FUNCIÓN DE DISTRIBUCIÓN EMPÍRICA ----

# Simulamos una muestra de una distribución normal de tamaño 100
set.seed(123)
muestra <- rnorm(100)

# Calulamos la función de distribución empírica
Fn <- ecdf(muestra)
Fn

# Representamos dicha función
{
  windows()                                  # para mostrar en una ventana nueva
  plot(Fn)                                   # dibujamos la función
  rug(muestra)                               # añadimos las marcas de valores (alfombra)
  curve(pnorm, lwd=2, add=TRUE, col="blue")  # dibujamos la curva de la función
}

# T2 - CONTRASTE DE BONDAD DE AJUSTE DE KOLMOGOROV-SMIRNOV (H0 SIMPLE) ----

# Ejemplo: contrastemos si la muestra de tamaño 100 proviene de una distribución N(0,1), de una
# t-Student con 3 grados de libertad o de una Cauchy(0,1).

# 1 - ¿proviene de una N(0,1)?
ks.test(x=muestra, y=pnorm)

# 2 -¿proviene de una t-Student con 3 grados de libertad?
ks.test(x=muestra, y=pt, df=3)

# 3 - ¿proviene de una Cauchy(0,1)?
ks.test(x=muestra, pcauchy, location=0, scale=1)

# T2 - CONTRASTE DE BONDAD DE AJUSTE DE CRAMÉR-VON MISES (H0 SIMPLE) ----
 
# Ejemplo: repetir los contrastes anteriores utilizando el contraste de Cramér-von Mises
library(goftest)

# 1 - ¿proviene de una N(0,1)?
cvm.test(x=muestra, pnorm)
# 2 -¿proviene de una t-Student con 3 grados de libertad? 
cvm.test(x=muestra, pt, df=3)
# 3 - ¿proviene de una Cauchy(0,1)?
cvm.test(x=muestra, pcauchy, location=0, scale=1)

# T2 - CONTRASTE DE BONDAD DE AJUSTE DE ANDERSON-DARLING (H0 SIMPLE) ----

# Ejemplo: repetir los contrastes anteriores utilizando el contraste de Anderson-Darling

# 1 - ¿proviene de una N(0,1)?
ad.test(x=muestra, pnorm)
# 2 -¿proviene de una t-Student con 3 grados de libertad? 
ad.test(x=muestra, pt, df=3)
# 3 - ¿proviene de una Cauchy(0,1)?
ad.test(x=muestra, pcauchy, location=0, scale=1)

# T2 - CONTRASTE DE BONDAD DE AJUSTE DE NORMALIDAD DE LILLIEFORS (H0 COMPUESTA) ----

library(DescTools)
LillieTest(x=muestra)

# Realizamos el QQ-plot
{
  windows()
  qqnorm(muestra)
  abline(a=mean(muestra), b=sd(muestra), col="red")
}

# T2 - CONTRASTE DE NORMALIDAD DE SHAPIRO-FRANCIA ----

library(nortest)
sf.test(muestra)

# T2 - CONTRASTE DE NORMALIDAD DE SHAPIRO-WILK ----

shapiro.test(muestra)

# T2 - CONTRASTE DE LA CHI-CUADRADO DE PEARSON ----

# Compara por defecto si los datos provienen de una distribución uniforme
freq_obs <- c(105, 107, 89, 103, 111, 85)
chisq.test(x = freq_obs)

# Para otra distribución, tenemos que calcular el estadístico de contraste y luego el p-valor
# manualmente para utilizar el número correcto de grados de libertad

# Ejemplo: Contrastar si los datos de goles de un equipo de fútbol provienen de una distribución
# de Poisson

freq_obs <- c(8, 6, 11, 5, 8)
media <- (1*6 + 2*11 + 3*5 + 4*5 + 5*1 + 6*2)/38
probabilidades <- c(dpois(0:3, lambda=media), 1 - ppois(3, lambda=media))
estadistico <- chisq.test(x=freq_obs, p=probabilidades)$statistic ; estadistico
valor_chi <- qchisq(p=1-0.05, df=5-1-1) ; valor_chi

# Como el valor de la chi cuadrado es mayor que el estadístico de contraste, los datos no
# descartan la distribución de Poisson.

# Calculemos el p-valor
pvalor <- 1 - pchisq(estadistico, df=5-1-1) ; pvalor

# T2 - CONTRASTE DE HOMOGENEIDAD ----

# Ejemplo: comparar las frecuencias de las palabras a, an, this, that, with, without en varios
# escritos de Austen y en uno de un imitador.

freq_imitador <- c(83, 29, 15, 22, 43, 4)
freq_austen <- c(434, 62, 86, 236, 161, 38)
tabla_contingencia <- matrix(
  c(freq_imitador, freq_austen),
  nrow = 2,
  byrow = TRUE,
  dimnames = list(
    c("Imitador", "Austen"),                         # nombre filas
    c("a", "an", "this", "that", "with", "without")  # nombre columnas
  )
)
chisq.test(tabla_contingencia)

# T2 - CONTRASTE DE INDEPENDENCIA ----

# Igual que antes

tabla_contingencia <- matrix(
  c(68, 56, 32, 52, 72, 20),
  nrow=2, 
  byrow=TRUE,
  dimnames = list(
    c("Mujer", "Hombre"),
    c("Demócrata", "Republicano", "Independiente")
  )
) ; tabla_contingencia
chisq.test(tabla_contingencia)

# -----------------------------------------------------------------------
# TEMA 3 : ESTIMACIÓN NO PARAMÉTRICA DE LA DENSIDAD ----

f1 <- faithful$eruptions

# T3 - REGLA DE STURGES (POR DEFECTO) ----
nclass.Sturges(f1)
{
  windows()
  hist(
    x=f1,
    probability=TRUE,
    xlab="Tiempo de erupción",
    ylab="Densidad",
    main="Regla de Sturges",
    xlim=c(1, 6),
    ylim=c(0, 0.7)
  )
  rug(f1)
}

# T3 - REGLA DE SCOTT ----
nclass.scott(f1)
{
  windows()
  h <- hist(
    x=f1,
    breaks="Scott",
    probability=TRUE,
    xlab="Tiempo de erupción",
    ylab="Densidad",
    main="Regla de Scott",
    xlim=c(1, 6),
    ylim=c(0, 0.7)
  )
  rug(f1)
}

# T3 - REGLA DE WAND ----
library(KernSmooth)

# Ancho de caja
b <- dpih(x=f1)

# Definimos las cajas
cajas <- seq(min(f1), max(f1)+b, by=b)
{
  windows()
  h <- hist(
    x=f1,
    breaks=cajas,
    probability=TRUE,
    xlab="Tiempo de erupción",
    ylab="Densidad",
    main="Regla de Wand",
    xlim=c(1, 6),
    ylim=c(0, 0.7)
  )
  rug(f1)
}

## Cogemos el triple de cajas que antes (veremos que son demasiadas cajas y no es correcto)
cajas <- seq(min(f1), max(f1)+b, by=b/3)
{
  windows()
  h <- hist(
    x=f1,
    breaks=cajas,
    probability=TRUE,
    xlab="Tiempo de erupción",
    ylab="Densidad",
    main="Regla de Wand",
    xlim=c(1, 6),
    ylim=c(0, 0.7)
  )
  rug(f1)
}

# T3 - ESTIMACIÓN NÚCLEO DE LA DENSIDAD ----

# bw por defecto es la referencia normal de Silverman
# el núcleo (kernel) por defecto es el gaussiano o normal

d <- density(x=f1, bw=0.2)
{
  windows()
  plot(
    d,
    t="l",
    xlab="Tiempo de erupción",
    ylab="Densidad",
    main="h=0.2",
    xlim = c(1, 6),
    ylim = c(0, 0.7)
  )
  rug(f1)
}

# T3 - SELECTORES DE ANCHOS DE BANDA PARA EL ESTIMADOR NÚCLEO DE LA DENSIDAD ----

library(ks)

# Ancho de banda por referencia normal
h1 <- hns(f1)

# Ancho de banda por validación cruzada
h2 <- hlscv(f1)

# Ancho de banda por plug-in
h3 <- hpi(f1)

{
  windows()
  plot(
    density(f1, bw=h2),
    t="l", lwd=2, col="red",
    xlab="Tiempo de erupción", ylab="Densidad", main="Selectores",
    xlim = c(1, 6),
    ylim = c(0, 0.7)
  )
  lines(density(f1, bw=h1), lwd=2, col="orange")
  lines(density(f1, bw=h3), lwd=2, col="blue")
  rug(f1)
}

# En la estimación de la densidad por validación cruzada (curva roja) se aprecia un aumento del
# suavizado del valle, lo que indica que el ancho de banda es pequeño; deberíamos aumentarlo al
# menos para eliminar esa subida que parece demasiado artificial.

# Ejemplo por simulación: generamos una muestra de tamaño 100 de la densidad
# (3/4) N(0,1) + (1/4) N(1.5,1/3^2) y pintamos el estimador núcleo con el selector plug-in de
# ancho de banda, y añadimos la verdadera densidad

set.seed(1)
muestra <- c(rnorm(n=75, mean=0, sd=1), rnorm(n=25, mean=1.5, sd=1/3))
h1 <- hns(muestra)
h2 <- hlscv(muestra)
h3 <- hpi(muestra)
d <- density(muestra, bw=h3)
{
  windows()
  plot(d$x, 0.75*dnorm(d$x, mean=0, sd=1) + 0.25*dnorm(d$x, mean=1.5, sd=1/3), 
    t="l", lwd=3,
    xlab="x", ylab="f(x)", main="")
  lines(d, lwd=2, col="blue")
  lines(density(muestra, bw=h2), lwd=2, col="red")
}

# Aumentemos el tamaño a 1000, puesto que los estimadores núcleo con ambos anchos de banda no
# están estimando lala verdadera función de manera adecuada.

muestra <- c(rnorm(n=750, mean=0, sd=1), rnorm(n=250, mean=1.5, sd=1/3))
h1 <- hns(muestra)
h2 <- hlscv(muestra)
h3 <- hpi(muestra)
d <- density(muestra, bw=h3)
{
  windows()
  plot(d$x, 0.75*dnorm(d$x, mean=0, sd=1) + 0.25*dnorm(d$x, mean=1.5, sd=1/3), 
    t="l", lwd=3, xlab="x", ylab="f(x)", main="")
  lines(d, lwd=2, col="blue")
  lines(density(muestra, bw=h2), lwd=2, col="red")
}

# Se presentan oscilaciones que son un poco artificiales, por lo tanto podría mejorarse el ancho
# de banda

# T3 - BANDAS DE VARIABILIDAD ----

# Con la opción panel=TRUE en sm.density se controla el suavizado de manera manual e interactiva,
# podemos ver a ojo cuál es el que mejor nos conviene de la mejor manera posible.
library(sm)
{
  windows()
  sm.density(
    f1,
    h=hpi(f1),
    se=TRUE,
    xlim=c(1, 6), ylim=c(0, 0.7)
  )
}

# Con panel interactivo
sm.density(f1, panel=TRUE)

# En este caso, si tuviéramos que seleccionar el ancho de banda a ojo, la mejor opción sería
# 0.16 o incluso un poco más.

# El estimador núcleo También está implementado en la función kde del paquete ks
# Con la opción positive=TRUE podemos especificar que se aplique una transformación logarítmica
# para estimar la densidad de datos positivos

library(densEstBayes)
y <- log(incomeUK)
hy <- hpi(y)
fhat <- kde(x=incomeUK, h=hy, positive=TRUE) # positive=TRUE indica que los valores son > 0

{
  windows()
  plot(fhat, lwd=2, xlab="Sueldos relativos", ylab="Densidad", xlim=c(0,4))
  rug(incomeUK)
}

# T3 - ESTIMADOR NÚCLEO MULTIVARIANTE ----

datos <- iris[,1:2]
{
  windows()
  plot(datos, xlim=c(4,8), ylim=c(1,5))
}

# Usamos ahora Hpi, con la h mayúscula para calcular la matriz de ancho de banda tipo plug-in
# ya que hpi, con h minúscula, es para datos univariantes.
H <- Hpi(datos, pilot="unconstr") # pilot="unconstr" para que lo haga sin restricciones
fhat <- kde(x=datos, H=H)
{
  windows()
  plot(fhat, lwd=2, drawlabels=FALSE, col=1, xlim=c(4,8), ylim=c(1,5), cont=10*(1:9))
  points(datos, pch=21, bg="blue")
}

# T3 - ANÁLISIS DISCRIMINANTE NO PARAMÉTRICO BASADO EN ESTIMADORES NÚCLEO ----

etiquetas <- iris[,5]
clas <- kda(datos, etiquetas)
{
  windows()
  plot(clas, drawlabels=FALSE, xlim=c(4,8), ylim=c(1,5), cont=0)
  points(datos, bg="blue", pch=as.numeric(etiquetas))
}

# T3 - ANÁLISIS CLÚSTER NO PARAMÉTRICO BASADO EN LA DENSIDAD ----

{
  windows()
  plot(faithful)
  H <- Hpi(faithful)
  fhat <- kde(faithful, H=H)
  kms.faith <- kms(faithful, H=H, verbose=TRUE)
  plot(kms.faith, pch=19, col=c("blue","red"))
  plot(fhat, add=TRUE, drawlabels=FALSE, col="black", cont=10*(1:9))
}

# -----------------------------------------------------------------------
# TEMA 4 - ESTIMACIÓN DE LA CURVA DE REGRESIÓN ----

# T4 - ESTIMADOR NÚCLEO DE LA REGRESIÓN ----

# kernel="normal" para el núcleo normal, bandwidth y x.points (la rejilla de puntos donde
# calcula el estimador).

# Construyamos un ejemplo donde la función de regresión va a ser m(x)=sin(x), el error va a ser
# una N(0,0.25^2), la distribución de X es uniforme en [0, 2*pi]

set.seed(1)
m <- function(x){ sin(x) }       # función de regresión
x <- runif(100, min=0, max=2*pi) # los datos x
e <- rnorm(100, mean=0, sd=0.25) # el error
y <- m(x) + e                    # construimos las imágenes de x
{
  windows()
  plot(x,y)
}

# Calculamos el estimador núcleo con h=1 y lo pintamos
mhat <- ksmooth(x, y, bandwidth=1, kernel="normal")
lines(mhat, col="blue", lwd=2)

# Añadimos la verdadera función de regresión (si no se especifica la rejilla, usa una de 100
# puntos entre min(x) y max(x)
rejilla <- mhat$x
lines(rejilla, m(rejilla), lwd=2)

# T4 - ANCHO DE BANDA POR VALIDACIÓN CRUZADA PARA EL ESTIMADOR DE REGRESIÓN ----

# Primera opción
library(locpol)
h1 <- regCVBwSelC(x=x, y=y, deg=0)

# Segunda opción
library(np)
h2 <- npregbw(xdat=x, ydat=y, regtype="lc", bwmethod="cv.ls")

mhat2 <- ksmooth(x, y, bandwidth=h1, kernel="normal")
lines(mhat2, lwd=2, col="red")

# Ancho de banda de manera interactiva opción 1
library(sm)
sm.regression(x=x, y=y, panel=TRUE)

# Ancho de banda de manera interactiva opción 2
library(manipulate)
manipulate({
  plot(x, y)
  mhat <- ksmooth(x, y, bandwidth=h, kernel="normal")
  lines(mhat, col="blue", lwd=2)
  rejilla <- mhat$x
  lines(rejilla, m(rejilla), lwd=2)
}, h = slider(min = 0.01, max = 2, initial = 0.5, step = 0.01))

# Utilicemos el estimador núcleo de la regresión con los datos de Boston, donde x=lstat e y=rm
library(MASS)

data(Boston)
{
  windows()
  plot(Boston$lstat, Boston$rm)
}
h <- regCVBwSelC(x=Boston$lstat, y=Boston$rm, deg=0)
mhat <- ksmooth(x=Boston$lstat, y=Boston$rm, bandwidth=h, kernel="normal")
lines(mhat, col="red", lwd=2)
mhat2 <- ksmooth(x=Boston$lstat, y=Boston$rm, bandwidth=3, kernel="normal")
lines(mhat2, col="blue", lwd=2)
# por mi cuenta, busco el mejor h a mano
manipulate::manipulate(
  {
    plot(Boston$lstat, Boston$rm)
    mhat <- ksmooth(Boston$lstat, Boston$rm, bandwidth=h, kernel="normal")
    lines(mhat, col="blue", lwd=2)
    rejilla <- mhat$x
    lines(rejilla, m(rejilla), lwd=2)
  },
  h = slider(min = 0.01, max = 10, initial = 0.5, step = 0.01)
)

# T4 - ESTIMADOR LINEAL LOCAL - SELECTOR POR VALIDACIÓN CRUZADA ----

hcv1 <- npregbw(xdat=x, ydat=y, regtype="ll", bwmethod="cv.ls")
hcv2 <- regCVBwSelC(x=x, y=y, deg=1, kernel=gaussK)

# T4 - ESTIMADOR LINEAL LOCAL - SELECTOR PLUG-IN ----

library(KernSmooth)

# Opción 1 (más fiable)
hpi1 <- dpill(x=x, y=y) ; hpi1

# Opción 2
hpi2 <- pluginBw(x=x, y=y, deg=1, kernel=gaussK) ; hpi2

# Pintamos los estimadores lineales locales
llcv <- npreg(bws=hcv2, txdat=x, tydat=y, exdat=rejilla)
llpi <- npreg(bws=hpi1, txdat=x, tydat=y, exdat=rejilla)
{
  windows()
  plot(x, y)
  lines(llcv$eval[,1], llcv$mean, lwd=2, col="red")
  lines(llpi$eval[,1], llpi$mean, lwd=2, col="blue")
}

# Pintemos ahora los estimadores lineales locales para los datos de Boston
hc <- regCVBwSelC(x=Boston$lstat, y=Boston$rm, deg=1, kernel=gaussK)
hp <- dpill(x=Boston$lstat, y=Boston$rm)

boston.llcv <- npreg(bws=hc, txdat=Boston$lstat, tydat=Boston$rm, 
  exdat=mhat$x)
boston.llpi <- npreg(bws=hp, txdat=Boston$lstat, tydat=Boston$rm, 
  exdat=mhat$x)

{
  windows()
  plot(Boston$lstat, Boston$rm)
  lines(boston.llcv$eval[,1], boston.llcv$mean, lwd=2, col="red")
  lines(boston.llpi$eval[,1], boston.llpi$mean, lwd=2, col="blue")
  lines(mhat2, col="orange", lwd=2)
}

# T4 - REGRESOGRAMA ----

library(HoRM)
r <- regressogram(x=x, y=y, nbins=8)
{
  windows()
  plot(r)
}

# Función más actual permite elegir el número de cajas a partir de los datos binsreg::binsreg
library(binsreg)

{
  windows()
  b <- binsreg(y, x)
}

{
  windows()
  bb <- binsreg(rm, lstat, data=Boston)
}

# Selectores automáticos del número de cajas
binsregselect(y, x)

# T4 - REGRESIÓN LOGÍSTICA LOCAL ----

# Vamos a analizar unos datos reales en los que registra si unos bebés recién nacidos presentaban
# displasia broncopulmonar o no (variable BPD) en función de su peso al nacer, en gramos
# (birthweight). Los datos los podemos conseguir con:

bpd <- read.table(file="http://www.stat.cmu.edu/~larry/all-of-nonpar/=data/bpd.dat", header=TRUE)
bpd <- as.data.frame(bpd)

# Comparamos el modelo de regresión logística global (función stats::glm) con el local (locfit)

# Modelo de regresión logística global
rlg <- glm(BPD~birthweight, data=bpd, family=binomial)
{
  windows()
  plot(bpd, pch="|")
  rej <- seq(min(bpd$birthweight), max(bpd$birthweight), length=100)
  y.rlg <- predict(rlg, newdata=data.frame(birthweight=rej), type="resp")
  lines(rej, y.rlg, col="blue", lwd=2)
}

# Modelo de regresión logística local 
library(locfit)
rll <- locfit(BPD~birthweight, data=bpd)
lines(rll, col="red", lwd=2)

# Para evaluar el estimador en nuevos puntos hay que usar predict

# -----------------------------------------------------------------------
# TEMA 5 - ESTIMACIÓN POR SPLINES ----

# T5 - REGRESIÓN POR SPLINES ----

# El valor spar del parámetro de suavizado (que no es exactamente igual que el lambda de teoría).
# Si no se especifica spar, lo coge por validación cruzada generalizada (GCV), aunque también se
# puede especificar lambda

# Generamos los datos del modelo de regresión de la práctica anterior y pintamos el estimador
# núcleo inicial calculado, junto con la verdadera regresión
set.seed(1)
m <- function(x){ sin(x) }
x <- runif(100, min=0, max=2*pi)
e <- rnorm(100, mean=0, sd=0.25)
y <- m(x) + e

{
  windows()
  plot(x,y)
  # estimador núcleo inicial
  mhat <- ksmooth(x, y, bandwidth=1, kernel="normal")
  lines(mhat, col="red", lwd=2)                  
  rejilla <- mhat$x
  lines(rejilla, m(rejilla), lwd=2) # verdadero estimador
}

# Calculamos el spline de suavizado
ss <- smooth.spline(x=x, y=y)
lines(ss, lwd=2, col="blue")

# El valor de lambda utilizado puede recuperarse del objeto creado
ss$lambda #0.001075831

# Podemos explorar el resultado para distintos valores de lambda
lines(smooth.spline(x,y,lambda=1e-7), lwd=2, col="pink")
lines(smooth.spline(x,y,lambda=1), lwd=2, col="orange")

# Para calcular el estimador por splines en una rejilla, o en vector de valores x utilizamos
# predict
predict(ss, x = c(0,0.2,0.8))

# Veamos el resultado para los datos de Boston
library(MASS)
data(Boston)
ss2 <- smooth.spline(Boston$lstat, Boston$rm)
{
  windows()
  plot(Boston$lstat, Boston$rm)
  lines(ss2, lwd=2, col="blue")
}

# T5 - ESTIMACIÓN DE LA DENSIDAD MEDIANTE SPLINES ----

# Recuperemos la estimación de la densidad de eruptions mediante un histograma
f1 <- faithful$eruptions

library(KernSmooth)
b <- dpih(x = f1)
cajas <- seq(min(f1), max(f1)+b, by=b)

{
  windows()
  h <- hist(
    x=f1,
    breaks=cajas,
    probability=TRUE,
    xlab="Tiempo de erupción", ylab="Densidad", main="",
    xlim=c(1, 6), ylim=c(0, 1) 
  )
  rug(f1)
}

# Opción 1: logspline
library(logspline)
f1.spline <- logspline(f1)
plot(f1.spline, add=TRUE, n=1000, lwd=3)

# Valor del estimador en un punto concreto se utiliza dlogspline
punto <- 2.1
dlogspline(q=punto, fit=f1.spline)

# Opción 2: gss, que necesitamos especificar un modelo de predicción sin respuesta
library(gss)
f1.gss <- ssden(~f1)

xx <- seq(1.6, 5.1, length=1000)
fhat <- dssden(f1.gss, xx)
lines(xx, fhat, lwd=3, col="blue")

# Comparamos con un estimador núcleo con ancho de banda pequeño
h <- dpik(f1) # 0.165
lines(density(f1, bw=0.05), col="red",lwd=3)

# -----------------------------------------------------------------------
# TEMA 6 - MODELOS ADITIVOS GENERALIZADOS ----

# T6 - REGRESIÓN MÚLTIPLE ----

# El paquete np permite obtener los estimadores por regresión tipo núcleo o tipo lineal local
# con varios predictores. Basta especificar las variables predictoras en el modelo de regresión.
# El estimador núcleo se obtiene con regtype="lc" y el estimador lineal local con regtype="ll"

library(np)
library(MASS)
data(Boston)

bw <- npregbw(rm ~ lstat + age, data=Boston, regtype = "ll")
boston.ll <- npreg(bw)

# Al pintar el objeto anterior se obtiene un gráfico dinámico
windows()
plot(boston.ll)

# Para pintar el estimador también podemos utilizar una rejilla de 20 x 20 puntos respecto a las
# variables predictoras lstat y age, donde evaluamos el estimador
xs <- seq(0, 40, by = 2)
ys <- seq(0, 100, by = 5)
xys <- expand.grid(xs, ys)

boston.ll2 <- npreg(bws=bw$bw, txdat=cbind(Boston$lstat, Boston$age),
  tydat=Boston$rm, regtype="ll", exdat=xys)

zs <- matrix(boston.ll2$mean, nrow=length(xs), ncol=length(ys))

{
  windows()
  persp(xs, ys, zs, theta=40, d=4, xlab="lstat", ylab="age", zlab="rm",
    ticktype="detailed", lwd=2, main="regresión lineal local")
}

# T6 - MODELOS ADITIVOS GENERALIZADOS ----

# Existen dos paquetes muy elaborados para trabajar con modelos aditivos generalizados: gam
# (de Trevor Hastie, uno de sus inventores) y mgcv (de Simon Wood, uno de los investigadores
# recientes)

# En el paquete gam, la función principal también se llama gam. Se utiliza la fórmula habitual
# de la forma respuesta~predictores, pero hay que indicar qué tipo de método de suavizado se
# quiere utilizar con cada predictor: lo (lineal local) o s (spline). Se puede especificar el
# parámetro de suavizado con lo(x, h) o s(x, lambda) o utilizar los valores por defecto (no por
# GCV)

# Para modelos aditivos (no generalizados) se especifica family=gaussian (o nada)

library(gam)
boston.gam <- gam(rm~lo(lstat)+lo(age), data=Boston)
{
  windows()
  plot(boston.gam, ask=TRUE)
}

zs2 <- predict(boston.gam, newdata=data.frame(lstat=xys[,1], age=xys[,2]))
zs2 <- matrix(zs2, nrow=length(xs), ncol=length(ys))

{
  windows()
  persp(xs, ys, zs2, theta=40, d=4, xlab="lstat", ylab="age", zlab="rm",
    ticktype="detailed", lwd=2, main="Modelo aditivo lineal local")
}

# En el paquete mgcv la función también se llama gam, pero tiene distintas posibilidades: sólo
# admite ajuste de las componentes por splines y utiliza  por defecto GCV para escoger los
# parámetros de suavizado

library(mgcv)
g <- gam(rm~s(lstat)+s(age), data=Boston)

{
  windows()
  plot(g, se=FALSE, lwd=2)
}

# podríamos pintar la superficie de regresión en 3D como en el caso anterior, utilizando predict

# Para ajustar un modelo aditivo logístico tenemos que especificar family=binomial. Veamos cómo
# realizar el análisis de los datos de pacientes diabéticos
library(gss)
data(wesdr)

lg <- gam(ret~s(dur)+s(gly)+s(bmi), data=wesdr, family=binomial)

windows();
plot(lg, pages=3, se=FALSE, lwd=2)

# -----------------------------------------------------------------------
# 2023 MAYO ----

# EJERCICIO 1

# El conjunto de datos tempb del paquete ks contiene la variable tmax, que registra las
# temperaturas máximas registradas a lo largo de n=21908 días en Badajoz, en grados centígrados.

# En primer lugar, cargaremos los datos mencionados
library(ks)
data(tempb)
tmax <- tempb$tmax

# Realizamos un histograma con la regla de Scott para hacernos una idea de cómo son los datos
{
 windows()
 hist(
  x=tmax,
  breaks="Scott",
  probability=TRUE,
  main="Histograma con la regla de Scott",
  xlab="Temperatura máxima",
  ylab="Densidad"
 )
}

# EJ 1 A)
# Representa gráficamente la estimación de la densidad de dichos datos mediante un estimador
# núcleo, utilizando el método de validación cruzada para elegir el ancho de banda. ¿Te parece
# que la estimación de la densidad así obtenida está suficientemente suavizada?

# Calculamos el ancho de banda mediante el método de validación cruzada
h_vc <- hlscv(x=tmax)

# Estimamos la densidad mediante el estimador núcleo (núcleo Gaussiano es el que usa por defecto)
# y con el ancho de banda calculado por validación cruzada
d1 <- density(
 x=tmax,
 bw=h_vc
)

# Representamos el estimador núcleo de la densidad
{windows()
 plot(
  d1,
  main = "Estimador núcleo, ancho de banda VC", xlab="Temperatura máxima", ylab="Densidad"
 )}

# Respuesta: No. Creo que la estimación de la densidad mediante el estimador núcleo y con el
# ancho de banda calculado por validación cruzada no está suficientemente suavizada, puesto que
# presenta mucha rugosidad, lo que sugiere que el ancho de banda es demasiado pequeño y está
# sobreajustando la densidad.

# EJ 1 B)
# Repite el apartado anterior, pero esta vez utilizando el método plug-in para elegir el ancho
# de banda. El estimador resultante, ¿parece que está demasiado suavizado?

# Calculamos el ancho de banda mediante el método plug-in
h_pi <- hpi(x=tmax)

# Estimamos la densidad mediante el estimador núcleo (núcleo Gaussiano es el que usa por defecto)
# y con el ancho de banda calculado por validación cruzada
d2 <- density(
 x=tmax,
 bw=h_pi
)

# Representamos el estimador núcleo de la densidad
{windows()
 plot(
  d2,
  main = "Estimador núcleo, ancho de banda plug-in", xlab="Temperatura máxima", ylab="Densidad"
 )}

# EJ 1 C)
# Aparte de estos dos valores de ancho de banda, ¿qué valor escogerías tú a mano para obtener
# una estimación de la densidad que quizás mejore un poco las anteriores?

# Para ver qué ancho de banda escogería, usamos la función manipulate::manipulate para crear
# un gráfico interactivo que dependa del ancho de banda, incluyendo las estimaciones de la
# densidad con los anchos de banda anteriormente calculado
library(manipulate)
manipulate(
  {
    plot(
      density(x=tmax, bw=h),
      main="Estimador núcleo, ancho de banda h",
      xlab="Temperatura máxima", ylab="Densidad",
      col="red", lwd=2
    )
    lines(density(x=tmax, bw=h_pi), col="black", lwd=2)
    legend("topright",                     
      legend=c("h", "h_vc"),
      col=c("red", "black"),
      lwd=2
      )
  },
 h=slider(min=0.1, max=3, initial=h_pi)
)

# A la vista de cómo va variando el suavizado de la estimación a medida que cambia el ancho
# de banda, creo que un buen ajuste podría considerarse con un ancho de banda de
h_ojo <- 1.15

# Representémoslo frente a los anteriores para comparar
{
 windows()
 plot(
  density(x=tmax, bw=h_ojo),
  main="Estimador núcleo, ancho de banda h=1.15", xlab="Temperatura máxima", ylab="Densidad",
  lwd=2,
 )
 # lines(density(x=tmax, bw=h_vc), col="red", lwd=2)
 lines(density(x=tmax, bw=h_pi), col="blue", lwd=2)
 legend("topright",                     
  legend=c("h=1.15", "plug-in"),
  col=c("black", "blue"),
  lty=1,
  lwd=2
 )
}

# EJ 1 D)
# A la vista de las distintas estimaciones de la densidad, describe la distribución de los datos
# es decir, describe cómo están distribuidas las temperaturas máximas en la ciudad de Badajoz.
# Por ejemplo, en base a esos datos de temperaturas máximas, ¿en cuántas categorías parecen estar
# divididos los tipos de días de Badajoz?

# A la vista de las distintas estimaciones de la densidad, se observa que la distribución de las
# temperaturas máximas presenta una distribución bimodal, lo que indica que los días pueden
# agruparse en dos categorías diferentes según la temperatura:
# Primera: días más fríos, quizás de invierno/otoño, con datos concentrados en torno a 15 grados.
# Segunda: días más calurosos, los de verano, con datos concentrados en torno a 35 grados celsius.
# No se aprecian colas largas, por lo que las temperaturas extremas no son frecuentes.

# FIN EJ 1

# EJERCICIO 2

# El conjunto de datos bonions del paquete sm contiene n=84 pares de observaciones de las
# variables (Density, Yield), correspondientes a plantaciones de ciertos tipos de cebollas. Se
# quiere estudiar cómo la cosecha de cada plantación (variable Yield, medida en gramos por
# planta) depende de la concentración de plantas existentes por metro cuadrado (var. Density).

# Cargamos los datos
library(sm)
bonions
summary(bonions)

# Antes de nada, representaré el regresograma para hacernos una idea de los datos que tenemos
library(binsreg)
binsreg(
  y=Yield,
  x=Density,
  data=bonions
)

# En base al regresograma, se aprecia que a medida que aumenta la concentración de plantas
# existentes por metro cuadrado, disminuye (logaritmo) la cosecha de cada plantación.

# EJ 2 A)
# Dibuja el estimador núcleo de la regresión, utilizando el ancho de banda sugerido por la
# validación cruzada y también otros valores que tú selecciones visualmente. ¿Qué valor de ancho
# de banda elegirías como más adecuado para estos datos?

# Selector de ancho de banda mediante validación cruzada
library(np)
h_VC <- npregbw(Yield~Density, data=bonions, regtype="lc")
h_VC$bw

# Ahora representamos el estimador núcleo para la regresión utilizando el ancho de banda
# calculado
m_vc <- ksmooth(
  x=bonions$Yield,
  y=bonions$Density,
  kernel="normal",
  bandwidth=h_VC$bw
)
plot(m_vc)
lines(m_vc, lwd=2, col="red")

# Selector de ancho de banda de manera interactiva
library(manipulate)
manipulate(
  {
    plot(bonions$Yield, bonions$Density, col="black", lwd=2)
    lines(
      ksmooth(x=bonions$Yield, bonions$Density, kernel="normal", bandwidth=h),
      col="red", lwd=2
    )
    lines(m_vc, lwd=2, col="blue")
    legend(
      x="topright",
      legend=c("h","h_VC"),
      col=c("red", "blue"),
      lwd=2
    )
  },
  h=slider(min=0.01, max=50, initial=2)
)

# En base del gráfico interactivo, yo elegiría como ancho de banda para estos datos de 15 más
# o menos 

# EJ 2 B)
# Calcula el selector de ancho de banda tipo plug-in para el estimador lineal local, y pinta en
# otro gráfico dicho estimador con ese ancho de banda.

# Selector de ancho de banda tipo plug-in para el estimador lineal local
library(KernSmooth)
h_pi_ll <- dpill(bonions$Yield, bonions$Density)

# Calculamos el estimador lineal local
m_pi_ll <- ksmooth(
  x=bonions$Yield,
  y=bonions$Density,
  kernel="normal",
  bandwidth=h_pi_ll
)

# Lo representamos en un nuevo gráfico
plot(m_pi_ll)
lines(m_pi_ll, lwd=2, col="red")

# EJ 2 C)
# Pinta en otro gráfico el estimador por splines de suavizado.

# Calculamos el estimador por splines de suavizado
ss <- smooth.spline(
  x=bonions$Density,
  y=bonions$Yield
)

# Lo representamos
plot(x=ss, lwd=2)
lines(x=ss, col="blue", lwd=2)

# EJ 2 D)
# Comenta las similitudes y diferencias entre los tres estimadores de la regresión (estimador
# núcleo, lineal local y por splines) obtenidos para estos datos. ¿Cuál crees que es el más
# adecuado en este caso?

# Representemos todos juntos para poder hacer una mejor comparación
{
  windows()
  plot(bonions$Density, bonions$Yield, col="black", lwd=2)
  lines(m_vc, lwd=2, col="red")
  lines(m_pi_ll, lwd=2, col="darkgreen")
  lines(x=ss, lwd=2, col="blue")
  legend(
    x="topright",
    legend=c("constante", "lineal local", "splines"),
    col=c("red", "darkgreen", "blue"),
    lwd=2
  )
}

# Los estimadores núcleo y lineal local son muy parecidos, ya que tienen similares anchos de
# banda y el estimador mediante splines sería el que mejor se ajusta a este caso.

# No necesario pero así esta mas completo
manipulate(
  {
    plot(bonions$Density, bonions$Yield, col="black", lwd=2)
    lines(ksmooth(x=bonions$Yield, bonions$Density, kernel="normal", bandwidth=h), col="purple", lwd=2)
    lines(m_vc, lwd=2, col="red")
    lines(m_pi_ll, lwd=2, col="darkgreen")
    lines(x=ss, lwd=2, col="blue")
    legend(
      x="topright",
      legend=c("constante", "lineal local", "splines"),
      col=c("red", "darkgreen", "blue"),
      lwd=2
    )
  },
  h=slider(min=0.01, max=150, initial=2)
)

# FIN EJ 2

# -----------------------------------------------------------------------
