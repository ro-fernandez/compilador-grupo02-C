%{
#include <stdio.h>
#include <stdlib.h>

#include "y.tab.h"
FILE  *yyin;
int yylval;
char *yyltext;


int yyerror(void);

%}

%option noyywrap  
%option yylineno 

// Conjuntos

DIGITO      [0-9]
DIGITO_NO_CERO  [1-9]
LETRA      [a-zA-Z]

// Caracteres

PAR_A      "("
PAR_C      ")"
COR_A      "["
COR_C      "]"
LLA_A      "{"
LLAV_C      "}"
PUNTO           "."
COMA            ","
PyC             ";"
DOS_PUNTOS      ":"

// Operadores Aritméticos

OP_AS       "->"
OP_SUM        "+"
OP_MUL          "*"
OP_RES        "-"
OP_DIV          "/"

// Operadores Lógicos

OP_AND          "AND"
OP_OR           "OR"
OP_NOT          "NOT"

// Comparadores

CMP_EQ          "=="
CMP_NE          "<>"
CMP_LT          "<"
CMP_LE          "<="
CMP_GT          ">"
CMP_GE          ">="

// Comentarios

COM_A             "#+"
COM_C             "+#"

// Regex

CTE_REAL        [-+]?{DIGITO}*{PUNTO}{DIGITO}*
CTE_INT         [-+]?{DIGITO}+
CTE_STRING      \"([^\\"]|\\.)*\"
ID          "_"({LETRA}({LETRA}|{DIGITO})*)
COMENTARIO      {COM_A}[^COM_C]*{COM_C}
COMENTARIO_ANID // A DEFINIR

// Palabras Reservadas



%%

{ID}      {printf("\nIdentificador: %s\n", yytext);return ID;}
{OP_SUM}    {printf("\nSuma: %s\n", yytext);return OP_SUM;}
{OP_AS}      {printf("\nAsignacion: %s\n", yytext);return OP_AS;}
{OP_MUL}    {printf("\nMultiplicacion: %s\n", yytext);return OP_MUL;}
{OP_RES}    {printf("\nResta: %s\n", yytext);return OP_RES;}
{OP_DIV}    {printf("\nDivision: %s\n", yytext);return OP_DIV;}
{PA}      {printf("\nParAbre: %s\n", yytext);return PA;}
{PC}      {printf("\nParCierra: %s\n", yytext);return PC;}
"\n"          
"\t"
"\n\t"
" "                 
"\r\n"
.       { printf( "ERROR LEXICO : Caracter no reconocido: %s\n", yytext ); exit (0);}