# Control Inteligente de un Sistema de Calefacción Doméstico con Aerotermia y Energía Solar

Este repositorio contiene el desarrollo de un proyecto de simulación y control aplicado a una vivienda equipada con sistema de aerotermia y paneles solares fotovoltaicos. El objetivo es analizar y reducir el consumo energético mediante distintas estrategias de control en Simulink.

## 📋 Contenido del Proyecto

El proyecto incluye:

- Un modelo térmico adaptado de una vivienda basado en el ejemplo oficial de Simulink: *Thermal Model of a House*.
- Definición física del sistema, incluyendo geometría, aislamiento y propiedades térmicas.
- Implementación de un sistema de calefacción basado en aerotermia (bomba de calor).
- Incorporación de generación solar (modelo simplificado) utilizando datos de SolarWeb (Fronius).
- Simulación de distintas estrategias de control:
  - Controlador **On/Off** clásico (termostato con histéresis).
  - Controlador **PID** optimizado por algoritmo de *Particle Swarm Optimization* (PSO).
  - Estrategia **greedy** de autoconsumo solar, utilizando la vivienda como batería térmica.

## 📈 Principales Resultados

| Estrategia de control                 | Coste energético semanal |
|--------------------------------------|---------------------------|
| Termostato On/Off                    | 41,50 €                   |
| PID                                  | 35,59 €                   |
| PID + Generación solar               | 21,86 €                   |
| Greedy + Generación solar            | **18,19 €**               |

El uso de una estrategia de control adaptada a la generación renovable reduce el coste energético semanal en más del 55 %.

## 🔍 Conclusiones

- El controlador **PID** tiende a saturar debido a la alta inercia térmica del sistema, funcionando de forma similar a un controlador On/Off.
- La estrategia **greedy** permite aprovechar mejor la energía solar y reduce el coste energético, aunque con una regulación térmica menos precisa.
- Utilizar la **vivienda como batería térmica** (sobrecalentándola durante horas de sol) es una solución viable cuando los precios de venta de energía a red son bajos.

## 🚀 Líneas Futuras de Desarrollo

- Sustituir el controlador PID por un **controlador predictivo (MPC)** que considere dinámicas futuras, restricciones y precios de energía.
- Incorporar un **modelo de modulación del COP** en función de la temperatura exterior.
- Realizar un análisis coste-beneficio para:
  - Ampliar la capacidad de generación solar.
  - Evaluar la instalación de **baterías eléctricas reales** frente al uso de la masa térmica como almacenamiento pasivo.

## 📁 Estructura de Carpetas
📦 HEATING_CONTROLLER
┣ 📂 assets
┣ 📂 documentation
┃ ┗ 📂 graphs
┃   ┗ 📜 Proyecto_Control_Inteligente.pdf
┣ 📂 lib
┣ 📂 models
┃ ┗ 📜 sldemo_househeat_non_linear.slx
┣ 📂 optimization
┣ 📂 scripts
┗ 📜 README.md

## 📚 Créditos

- Modelo base: [Simulink Thermal Model of a House](https://www.mathworks.com/help/simulink/slref/thermal-model-of-a-house.html)
- Datos solares: Plataforma [SolarWeb de Fronius](https://www.solarweb.com/)