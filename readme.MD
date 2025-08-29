# Compilador en C

## Universidad Nacional de La Matanza

Departamento de Ingeniería e Investigaciones Tecnológicas

## Integrantes del Proyecto

- Coronati, Augusto Martin
- Fernández, Rocío Belén
- Garin, Matías
- Guardati, Francisco
- Portillo, Jonathan Leonel

## Descripción del Proyecto

El siguiente repositorio contiene el desarrollo de un compilador en C.

### Temas del Proyecto

#### Temas Comunes del Proyecto

- While
- If / if - else
- Asignaciones
- Operaciones Aritméticas
- Tipos de datos: Float (32 bits), Int (16 bits), String
- Declaración de variables
- Comentarios
- Entrada y Salida
- Condiciones
- Tabla de Símbolos

#### Temas Especiales del Proyecto

- triangleAreaMaximum: Se desea implementar una función llamada triangleAreaMaximum que, dadas las coordenadas de dos triángulos en el plano cartesiano, determine cuál de los dos tiene mayor área y devuelva dicho valor numérico.
- convDate: Se desea implementar una función llamada convDate que convierta una fecha representada por tres números enteros (día, mes y año) en un único valor numérico con el formato YYYYMMDD.

### Entregas del Proyecto

#### Primera Entrega

**Objetivo**: Realizar un analizador léxico y sintáctico con las herramientas provistas.

La entrega 1.0.0 incluirá:

- El archivo lexer con la definición de todos los componentes léxicos.
- El archivo parser con la definición de la gramática del lenguaje y la lógica de generación de la tabla de símbolos.
- El archivo symbol-table.txt deberá contener la lista de variables y constantes con sus respectivos atributos.
- El archivo ejecutable lyc-compiler-1.0.0.

#### Segunda Entrega

**Objetivo:** Realizar un generador de código intermedio utilizando el archivo parser generado en la primera entrega.

La entrega 2.0.0 incluirá:

- El archivo lexer con la definición de todos los componentes léxicos.
- El archivo parser con la definición de la gramática del lenguaje y la lógica de generación de la tabla de símbolos.
- El archivo symbol-table.txt deberá contener la lista de variables y constantes con sus respectivos atributos.
- El archivo intermediate-code.txt y que contiene el código intermedio generado.
- El archivo ejecutable lyc-compiler-2.0.0.

#### Entrega Final

**Objetivo**: Realizar un compilador utilizando el archivo generado en la segunda entrega. 
El programa ejecutable deberá procesar el archivo de entrada (test.txt), compilarlo y ejecutarlo.

La entrega 3.0.0 incluirá:

- El archivo lexer con la definición de todos los componentes léxicos.
- El archivo parser con la definición de la gramática del lenguaje y la lógica de generación de la tabla de símbolos.
- El archivo symbol-table.txt deberá contener la lista de variables y constantes con sus respectivos atributos.
- El archivo intermediate-code.txt y que contiene el código intermedio generado.
- El archivo ejecutable lyc-compiler-3.0.0.

