%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

int yylval;
char *yyltext;


FILE *yyin;
int yyerror(void);

%}

%option noyywrap
%option yylineno

/* Conjuntos */
DIGITO          [0-9]
DIGITO_NO_CERO  [1-9]
LETRA           [a-zA-Z]

/* Caracteres */
PAR_A           "("
PAR_C           ")"
COR_A           "["
COR_C           "]"
LLA_A           "{"
LLA_C          "}"
PUNTO           "."
COMA            ","
PyC             ";"
DOS_PUNTOS      ":"

/* Operadores aritméticos */
OP_AS           "->"
OP_SUM          "+"
OP_MUL          "*"
OP_RES          "-"
OP_DIV          "/"

/* Operadores lógicos */
OP_AND          "AND"
OP_OR           "OR"
OP_NOT          "NOT"

/* Comparadores */
CMP_EQ          "=="
CMP_NE          "<>"
CMP_LT          "<"
CMP_LE          "<="
CMP_GT          ">"
CMP_GE          ">="

/* Comentarios tipo #+ ... +# */
COM_A           \#\+
COM_C           \+\#
COMENTARIO      {COM_A}([^+]|\+[^#])*{COM_C}

/* Literales y otros */
CTE_REAL        [-+]?{DIGITO}*{PUNTO}{DIGITO}+
CTE_INT         {DIGITO}+
CTE_STRING      \"([^\\"]|\\.)*\"
ID              "_"({LETRA}({LETRA}|{DIGITO})*)

/* COMENTARIO_ANID: a definir más adelante */

%%

{ID}            { printf("\nIdentificador: %s\n", yytext); return ID; }
{CTE_INT}       { printf("\nConstanteEntera: %s\n", yytext); return CTE_INT; }
{PAR_A}         { printf("\nParAbre: %s\n", yytext); return PAR_A; }
{PAR_C}         { printf("\nParCierra: %s\n", yytext); return PAR_C; }
{OP_SUM}        { printf("\nSuma: %s\n", yytext); return OP_SUM; }
{OP_AS}         { printf("\nAsignacion: %s\n", yytext); return OP_AS; }
{OP_MUL}        { printf("\nMultiplicacion: %s\n", yytext); return OP_MUL; }
{OP_RES}        { printf("\nResta: %s\n", yytext); return OP_RES; }
{OP_DIV}        { printf("\nDivision: %s\n", yytext); return OP_DIV; }
{COMENTARIO}    { /* ignorar comentarios */ }
[ \t\r\n]+      { /* ignorar */ }
.               { printf("ERROR LEXICO : Caracter no reconocido: %s\n", yytext); exit(0); }

%%
