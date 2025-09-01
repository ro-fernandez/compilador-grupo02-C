%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

#define INT_MAX 32768
#define INT_MIN -32768
#define FLOAT_MAX 2147483648
#define FLOAT_MIN -2147483648
#define MAX_STR_LEN 50

int yylval;
char *yyltext;


FILE *yyin;
int yyerror(void);

int validateStringLength(char* str);
int validateFloatRange(char* str);
int validateIntRange(char* str);

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
CTE_REAL        ({DIGITO}*{PUNTO}{DIGITO}+)|(\(-{DIGITO}*{PUNTO}{DIGITO}+\))
CTE_INT         {DIGITO}+
CTE_STRING      \"([^\\"]|\\.)*\"
ID              "_"({LETRA}({LETRA}|{DIGITO})*)

/* COMENTARIO_ANID: a definir más adelante */

/* Palabras reservadas */
IF              "if"
ELSE            "else"
WHILE           "while"
FOR             "for"
T_INT           "int"
T_FLOAT         "float"
T_STRING        "string"
READ            "read"
WRITE           "write"
TRI_AR_MAX      "triangleAreaMaximum"
CONV_D          "convDate"

%%

{ID}            { printf("\nIdentificador: %s\n", yytext); return ID; }
{CTE_INT}       { if(validateIntRange(yytext)){printf("\nConstanteEntera: %s\n", yytext); return CTE_INT;}}
{CTE_REAL}      { if(validateFloatRange(yytext)){printf("\nConstanteFlotante: %s\n", yytext); return CTE_REAL;}}
{CTE_STRING}    { if(validateStringLength(yytext)){printf("\nConstanteString: %s\n", yytext); return CTE_STRING;}}
{PAR_A}         { printf("\nParAbre: %s\n", yytext); return PAR_A; }
{PAR_C}         { printf("\nParCierra: %s\n", yytext); return PAR_C; }
{COR_A}         { printf("\nCorAbre: %s\n", yytext); return COR_A; }
{COR_C}         { printf("\nCorCierra: %s\n", yytext); return COR_C; }
{LLA_A}         { printf("\nLlaAbre: %s\n", yytext); return LLA_A; }
{LLA_C}         { printf("\nLlaCierra: %s\n", yytext); return LLA_C; }
{PUNTO}         { printf("\nPunto: %s\n", yytext); return PUNTO; }
{COMA}          { printf("\nComa: %s\n", yytext); return COMA; }
{PyC}           { printf("\nPuntoYComa: %s\n", yytext); return PyC; }
{DOS_PUNTOS}    { printf("\nDosPuntos: %s\n", yytext); return DOS_PUNTOS; }
{OP_SUM}        { printf("\nSuma: %s\n", yytext); return OP_SUM; }
{OP_AS}         { printf("\nAsignacion: %s\n", yytext); return OP_AS; }
{OP_MUL}        { printf("\nMultiplicacion: %s\n", yytext); return OP_MUL; }
{OP_RES}        { printf("\nResta: %s\n", yytext); return OP_RES; }
{OP_DIV}        { printf("\nDivision: %s\n", yytext); return OP_DIV; }
{OP_AND}        { printf("\nOpAnd: %s\n", yytext); return OP_AND; }
{OP_OR}         { printf("\nOpOr: %s\n", yytext); return OP_OR; }
{OP_NOT}        { printf("\nOpNot: %s\n", yytext); return OP_NOT; }
{CMP_EQ}        { printf("\nCompIgual: %s\n", yytext); return CMP_EQ; }
{CMP_NE}        { printf("\nCompNOIgual: %s\n", yytext); return CMP_NE; }
{CMP_LT}        { printf("\nCompMenor: %s\n", yytext); return CMP_LT; }
{CMP_LE}        { printf("\nCompMenorIgual: %s\n", yytext); return CMP_LE; }
{CMP_GT}        { printf("\nCompMayor: %s\n", yytext); return CMP_GT; }
{CMP_GE}        { printf("\nCompMayorIgual: %s\n", yytext); return CMP_GE; }
{IF}            { printf("\nIf\n",yytext); return IF;}
{ELSE}          { printf("\nElse\n",yytext); return ELSE;}
{WHILE}         { printf("\nWhile\n",yytext); return WHILE;}
{FOR}           { printf("\nFor\n",yytext); return FOR;}
{T_INT}         { printf("\nTipoInt\n",yytext); return T_INT;}
{T_FLOAT}       { printf("\nTipoFloat\n",yytext); return T_FLOAT;}
{T_STRING}      { printf("\nTipoString\n",yytext); return T_STRING;}
{READ}          { printf("\nRead\n",yytext); return READ;}
{WRITE}         { printf("\nWrite\n",yytext); return WRITE;}
{TRI_AR_MAX}    { printf("\nTrianguloAreaMax\n",yytext); return TRI_AR_MAX;}
{CONV_D}        { printf("\nConvDate\n",yytext); return CONV_D;}
{COM_A}    { /* ignorar comentarios */ }
{COM_C}    { /* ignorar comentarios */ }
{COMENTARIO}    { /* ignorar comentarios */ }
[ \t\r\n]+      { /* ignorar */ }
.               { printf("ERROR LEXICO : Caracter no reconocido: %s\n", yytext); exit(0); }

%%


int validateIntRange(char* str){
    int value = atoi(str);
    return (value >= INT_MIN && value <= INT_MAX);
}

int validateFloatRange(char* str){
    float value = atof(str);
    return (value >= FLOAT_MIN && value <= FLOAT_MAX);
}

int validateStringLength(char* str){
    return (strlen(str) - 2 <= MAX_STR_LEN);
}