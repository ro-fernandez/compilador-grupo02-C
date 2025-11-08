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

#define TAM_MAX 200

void removeChar(char *s, char c);

#endif /* UTILITARIOS_H */