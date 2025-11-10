#ifndef UTILITARIOS_H
#define UTILITARIOS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum
{
    FALSO, VERDADERO
} booleano;

typedef enum
{
    ASIG_EXPRESION, ASIG_TRIANGLE, ASIG_CONVDATE, ASIG_STRING
} TipoAsignacion;

typedef enum
{
    SIMBOLO_ID,
    SIMBOLO_INT,
    SIMBOLO_REAL,
    SIMBOLO_STRING,
    SIMBOLO_FECHA
} TipoSimbolo;

#define TAM_MAX 200

#define INT_MAX_VALUE 32768
#define INT_MIN_VALUE -32768
#define FLOAT_MAX_VALUE 2147483648
#define FLOAT_MIN_VALUE -2147483648
#define MAX_STR_LEN 50
#define MIN_YEAR 1900
#define MAX_YEAR 2100

#define TIPO_INT "INT"
#define TIPO_FLOAT "FLOAT"
#define TIPO_STRING "STRING"
#define TIPO_DATE_CONV "DATE_CONV"

#define archivo_tabla_simbolos "symbol-table.txt"
#define archivo_polaca "intermediate-code.txt"
#define archivo_asm_temp "final.temp"
#define archivo_asm "final.asm"

void removeChar(char *s, char c);
void replaceChar(char *s, char c, char r);

#endif /* UTILITARIOS_H */