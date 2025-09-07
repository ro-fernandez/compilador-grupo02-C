%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "Tabla.h"

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
void insertInSymbolTable(char* lex, TipoSimbolo tipo);
void eliminar_caracter(char *s, char c);

extern lista tabla_simbolos;

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
CTE_REAL            ({DIGITO}*{PUNTO}{DIGITO}*)|(\(-{DIGITO}*{PUNTO}{DIGITO}*\))
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

{ID}                { insertInSymbolTable(yytext, SIMBOLO_ID); return ID; }
{CTE_INT}           { validateIntRange(yytext); insertInSymbolTable(yytext, SIMBOLO_INT); return CTE_INT; }
{CTE_REAL}          { validateFloatRange(yytext); insertInSymbolTable(yytext, SIMBOLO_REAL); return CTE_REAL; }
{CTE_STRING}        { validateStringLength(yytext); insertInSymbolTable(yytext, SIMBOLO_STRING); return CTE_STRING; }

{PAR_A}             { return PAR_A; }
{PAR_C}             { return PAR_C; }
{COR_A}             { return COR_A; }
{COR_C}             { return COR_C; }
{LLA_A}             { return LLA_A; }
{LLA_C}             { return LLA_C; }
{PUNTO}             { return PUNTO; }
{COMA}              { return COMA; }
{PyC}               { return PyC; }
{DOS_PUNTOS}        { return DOS_PUNTOS; }
{OP_SUM}            { return OP_SUM; }
{OP_AS}             { return OP_AS; }
{OP_MUL}            { return OP_MUL; }
{OP_RES}            { return OP_RES; }
{OP_DIV}            { return OP_DIV; }
{OP_AND}            { return OP_AND; }
{OP_OR}             { return OP_OR; }
{OP_NOT}            { return OP_NOT; }
{CMP_EQ}            { return CMP_EQ; }
{CMP_NE}            { return CMP_NE; }
{CMP_LT}            { return CMP_LT; }
{CMP_LE}            { return CMP_LE; }
{CMP_GT}            { return CMP_GT; }
{CMP_GE}            { return CMP_GE; }
{IF}                { return IF; }
{ELSE}              { return ELSE; }
{WHILE}             { return WHILE; }
{FOR}               { return FOR; }
{T_INT}             { return T_INT; }
{T_FLOAT}           { return T_FLOAT; }
{T_STRING}          { return T_STRING; }
{READ}              { return READ; }
{WRITE}             { return WRITE; }
{TRI_AR_MAX}        { return TRI_AR_MAX; }
{CONV_D}            { return CONV_D; }
{INIT}              { return INIT; }

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

void validateIntRange(char* str)
{
    int val = atoi(str);
    if(val < INT_MIN_VALUE || val > INT_MAX_VALUE)
    {
        printf("\nERROR: Constante entera %s fuera de rango\n", yytext);
        exit(1);
    }
}

void validateFloatRange(char* str)
{
    float val = atof(str);
    if(val < FLOAT_MIN_VALUE || val > FLOAT_MAX_VALUE)
    {
        printf("\nERROR: Constante flotante %s fuera de rango\n", yytext);
        exit(1);
    }
}

void validateStringLength(char* str)
{
    if(strlen(str) - 2 > MAX_STR_LEN)
    {
        printf("\nERROR: String %s tiene longitud mayor a la permitida de %d caracteres\n", yytext, MAX_STR_LEN);
        exit(1);
    }
}

void insertInSymbolTable(char* lex, TipoSimbolo tipo)
{
    char lexValue[TAM_MAX];
    t_lexema newLexema;

    strcpy(lexValue, lex);

    switch (tipo)
    {
        case SIMBOLO_ID:
            strcpy(newLexema.tipo, "");
            strcpy(newLexema.valor, "");

            break;
        case SIMBOLO_INT:
            strcpy(newLexema.tipo, "CONST_INT");
            strcpy(newLexema.valor, lexValue);

            break;
        case SIMBOLO_REAL:
        
            if (lex[0] == '.') 
            {
                strcpy(lexValue, "0");
                strcat(lexValue, lex);
            } 
            else if (lex[strlen(lex) - 1] == '.') 
            {
                strcpy(lexValue, lex);
                strcat(lexValue, "0");
            }
            strcpy(newLexema.tipo, "CONST_REAL");
            strcpy(newLexema.valor, lexValue);

            break;
        case SIMBOLO_STRING:
            strcpy(newLexema.tipo, "CONST_STR");
            eliminar_caracter(lexValue, '"');
            strcpy(newLexema.valor,  lexValue);

            break;
        default:
            break;
    }

    strcpy(newLexema.nombre, "_");
    strcat(newLexema.nombre, lexValue);
    strcpy(newLexema.longitud, "");

    insertarSimboloSinDuplicados(&tabla_simbolos, newLexema);
}

void eliminar_caracter(char *s, char c)
{
    int i = 0, j = 0;

    while (s[j])
    {
        if (s[j]!=c) 
        {   
            s[i++] = s[j];
        }

        j++;       
    }

    s[i]=0;
}