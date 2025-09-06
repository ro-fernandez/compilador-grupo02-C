%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

#define INT_MAX_VALUE 32768
#define INT_MIN_VALUE -32768
#define FLOAT_MAX_VALUE 2147483648
#define FLOAT_MIN_VALUE -2147483648
#define MAX_STR_LEN 50

int yylval;
char *yyltext;


FILE *yyin;
int yyerror(void);

void validateStringLength(char* str);
void validateFloatRange(char* str);
void validateIntRange(char* str);

%}

%option noyywrap
%option yylineno

/* Conjuntos */
DIGITO              [0-9]
DIGITO_NO_CERO      [1-9]
LETRA               [a-zA-Z]

/* Caracteres */
PAR_A               "("
PAR_C               ")"
COR_A               "["
COR_C               "]"
LLA_A               "{"
LLA_C               "}"
PUNTO               "."
COMA                ","
PyC                 ";"
DOS_PUNTOS          ":"
GUION_BAJO          "_"
COMILLAS            "\""

/* Operadores Aritméticos */
OP_AS               "->"
OP_SUM              "+"
OP_MUL              "*"
OP_RES              "-"
OP_DIV              "/"

/* Operadores Lógicos */
OP_AND              "AND"
OP_OR               "OR"
OP_NOT              "NOT"

/* Comparadores */
CMP_EQ              "=="
CMP_NE              "<>"
CMP_LT              "<"
CMP_LE              "<="
CMP_GT              ">"
CMP_GE              ">="

/* Comentarios Tipo #+ ... +# */
COM_A               "#+"
COM_C               "+#"
COMENTARIO          {COM_A}.*{COM_C}
COMENTARIO_ANID     {COM_A}.*{COMENTARIO}.*{COM_C}


/* Literales y Otros */
CTE_REAL            ({DIGITO}*{PUNTO}{DIGITO}+)|(\(-{DIGITO}*{PUNTO}{DIGITO}+\))
CTE_INT             {DIGITO}+
CTE_STRING          {COMILLAS}([^"\\]|\\.)*{COMILLAS}
ID                  {GUION_BAJO}({LETRA}({LETRA}|{DIGITO})*)

/* Palabras Reservadas */
IF                  "if"
ELSE                "else"
WHILE               "while"
FOR                 "for"
T_INT               "Int"
T_FLOAT             "Float"
T_STRING            "String"
READ                "read"
WRITE               "write"
TRI_AR_MAX          "triangleAreaMaximum"
CONV_D              "convDate"
INIT                "init"

%%

{ID}                { printf("\nIdentificador: %s\n", yytext); return ID; }
{CTE_INT}           { validateIntRange(yytext);printf("\nConstante Entera: %s\n", yytext); return CTE_INT; }
{CTE_REAL}          { validateFloatRange(yytext);printf("\nConstante Flotante: %s\n", yytext); return CTE_REAL; }
{CTE_STRING}        { validateStringLength(yytext);printf("\nConstante String: %s\n", yytext); return CTE_STRING; }
{PAR_A}             { printf("\nApertura de Parentesis: %s\n", yytext); return PAR_A; }
{PAR_C}             { printf("\nCierre de Parentesis: %s\n", yytext); return PAR_C; }
{COR_A}             { printf("\nApertura de Corchetes: %s\n", yytext); return COR_A; }
{COR_C}             { printf("\nCierre de Corchetes: %s\n", yytext); return COR_C; }
{LLA_A}             { printf("\nApertura de Llaves: %s\n", yytext); return LLA_A; }
{LLA_C}             { printf("\nCierre de Llaves: %s\n", yytext); return LLA_C; }
{PUNTO}             { printf("\nPunto: %s\n", yytext); return PUNTO; }
{COMA}              { printf("\nComa: %s\n", yytext); return COMA; }
{PyC}               { printf("\nPunto y Coma: %s\n", yytext); return PyC; }
{DOS_PUNTOS}        { printf("\nDos Puntos: %s\n", yytext); return DOS_PUNTOS; }
{OP_SUM}            { printf("\nOperador de Suma: %s\n", yytext); return OP_SUM; }
{OP_AS}             { printf("\nOperador de Asignacion: %s\n", yytext); return OP_AS; }
{OP_MUL}            { printf("\nOperador de Multiplicacion: %s\n", yytext); return OP_MUL; }
{OP_RES}            { printf("\nOperador de Resta: %s\n", yytext); return OP_RES; }
{OP_DIV}            { printf("\nOperador de Division: %s\n", yytext); return OP_DIV; }
{OP_AND}            { printf("\nOperador de AND: %s\n", yytext); return OP_AND; }
{OP_OR}             { printf("\nOperador de OR: %s\n", yytext); return OP_OR; }
{OP_NOT}            { printf("\nOperador de NOT: %s\n", yytext); return OP_NOT; }
{CMP_EQ}            { printf("\nComparador Igual: %s\n", yytext); return CMP_EQ; }
{CMP_NE}            { printf("\nComparador Distinto: %s\n", yytext); return CMP_NE; }
{CMP_LT}            { printf("\nComparador Menor: %s\n", yytext); return CMP_LT; }
{CMP_LE}            { printf("\nComparador Menor o Igual: %s\n", yytext); return CMP_LE; }
{CMP_GT}            { printf("\nComparador Mayor: %s\n", yytext); return CMP_GT; }
{CMP_GE}            { printf("\nComparador Mayor o Igual: %s\n", yytext); return CMP_GE; }
{IF}                { printf("\nIf: %s\n",yytext); return IF; }
{ELSE}              { printf("\nElse: %s\n",yytext); return ELSE; }
{WHILE}             { printf("\nWhile: %s\n",yytext); return WHILE; }
{FOR}               { printf("\nFor: %s\n",yytext); return FOR; }
{T_INT}             { printf("\nTipo Numero Entero: %s\n",yytext); return T_INT; }
{T_FLOAT}           { printf("\nTipo Numero Real: %s\n",yytext); return T_FLOAT; }
{T_STRING}          { printf("\nTipo String: %s\n",yytext); return T_STRING; }
{READ}              { printf("\nRead: %s\n",yytext); return READ; }
{WRITE}             { printf("\nWrite: %s\n",yytext); return WRITE; }
{TRI_AR_MAX}        { printf("\nTrianguloAreaMax: %s\n",yytext); return TRI_AR_MAX; }
{CONV_D}            { printf("\nConvDate: %s\n",yytext); return CONV_D; }
{INIT}              { printf("\nInit: %s\n",yytext); return INIT; }
{COMENTARIO}        { printf("\nComentario: %s\n", yytext); }
{COMENTARIO_ANID}   { printf("\nComentario Anidado: %s\n", yytext); }
{COM_A}
{COM_C}
"\n"
"\t"
"\n\t"
" "
"\r\n"
.                   { printf("ERROR LEXICO : Caracter no reconocido: %s\n", yytext); exit(0); }

%%

void validateIntRange(char* str){
    int val = atoi(str);
    if(val < INT_MIN_VALUE || val > INT_MAX_VALUE){
        printf("\nERROR: Constante entera %s fuera de rango\n", yytext);
        exit(1);
    }
}

void validateFloatRange(char* str){
    float val = atof(str);
    if(val < FLOAT_MIN_VALUE || val > FLOAT_MAX_VALUE){
        printf("\nERROR: Constante flotante %s fuera de rango\n", yytext);
        exit(1);
    }
}

void validateStringLength(char* str){
        if(strlen(str) - 2 > MAX_STR_LEN) {
        printf("\nERROR: String %s tiene longitud mayor a la permitida de %d caracteres\n", yytext, MAX_STR_LEN);
        exit(1);
    }
}