# Intérprete de Expresiones 

Este proyecto implementa un intérprete para la gramatica definida, utilizando las herramientas **Flex** (análisis léxico) y **Bison** (análisis sintáctico y semántico).

## 🛠 Tecnologías utilizadas

- [Flex]: generador de analizadores léxicos.
- [Bison]: generador de analizadores sintácticos.
- Lenguaje: **C**
- Entorno: **[MSYS2](https://www.msys2.org/)** (Para trabajar en Windows, como se realizo en este caso).

## 📁 Estructura del Proyecto

- `tarea2.l` — Archivo de análisis léxico.
- `tarea2.y` — Archivo de análisis sintáctico y semántico.
- `expected_outputs.txt`  — Archivo con las salidas esperadas de las expresiones.
- `testi.txt` — Archivo con la expresion de prueba i.

## 🔍 Descripción

Este programa lee expresiones desde un archivo de texto y evalúa su resultado según su tipo:

- **Numéricas**: sumas, multiplicaciones, negación, y longitud de strings `|`.
- **Booleanas**: `\true`, `\false`, `\and`, `\not`, comparaciones `<`, `=`.
- **Strings**: literales alfanuméricos, concatenación con `.`.

Además, soporta expresiones **condicionales** con `\if`, evaluadas según una expresión booleana y dos expresiones del mismo tipo (numericas, booleanas o strings).

## ▶️ Ejecución

Compila y ejecuta el programa desde terminal:

```bash
flex calc.l
bison -d calc.y
gcc -o calc calc.tab.c lex.yy.c -lfl
./calc test.txt
```


