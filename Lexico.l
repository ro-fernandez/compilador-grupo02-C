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
#define MIN_YEAR 1900
#define MAX_YEAR 2100

FILE *yyin;
int yyerror(void);

void validateStringLength(char* str);
void validateFloatRange(char* str);
void validateIntRange(char* str);
void validateDate(char* str);

void insertInSymbolTable(char* lex, TipoSimbolo tipo);
void removeChar(char *s, char c);

void handleError(char* str);
void getLexema(char* str);

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
CTE_FECHA           {DIGITO}{DIGITO}\.{DIGITO}{DIGITO}\.{DIGITO}{DIGITO}{DIGITO}{DIGITO}
ID                  {GUION_BAJO}({LETRA}({LETRA}|{DIGITO})*)

/* Palabras Reservadas */
IF                  "if"
ELSE                "else"
WHILE               "while"
FOR                 "for"
T_INT               "Int"
T_FLOAT             "Float"
T_STRING            "String"
T_DATE_CONV         "DateConverted"
READ                "read"
WRITE               "write"
TRI_AR_MAX          "triangleAreaMaximum"
CONV_D              "convDate"
INIT                "init"

%%

{ID}                { getLexema(yytext); insertInSymbolTable(yytext, SIMBOLO_ID); return ID; }
{CTE_INT}           { validateIntRange(yytext); getLexema(yytext); insertInSymbolTable(yytext, SIMBOLO_INT); return CTE_INT; }
{CTE_REAL}          { validateFloatRange(yytext); getLexema(yytext); insertInSymbolTable(yytext, SIMBOLO_REAL); return CTE_REAL; }
{CTE_STRING}        { validateStringLength(yytext); getLexema(yytext); insertInSymbolTable(yytext, SIMBOLO_STRING); return CTE_STRING; }
{CTE_FECHA}         { validateDate(yytext); getLexema(yytext); insertInSymbolTable(yytext,SIMBOLO_FECHA); return CTE_FECHA; }


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
{T_DATE_CONV}       { return T_DATE_CONV; }
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

.                   { handleError(yytext); }

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

void validateDate(char* str)
{
    int day, month, year;

    if(sscanf(str, "%2d.%2d.%4d", &day, &month, &year) != 3)
    {
        printf("\nERROR: Fecha %s no es divisible por el formato DD.MM.YYYY\n", yytext);
        exit(1);
    }

    if(year < MIN_YEAR || year > MAX_YEAR)
    {
        printf("\nERROR: Fecha %s no tiene un año valido\n", yytext);
        exit(1);
    }

    if(month < 1 || month > 12)
    {
        printf("\nERROR: Fecha %s no tiene un mes valido\n", yytext);
        exit(1);
    }

    int daysPerMonth[] = {0,31,28,31,30,31,30,31,31,30,31,30,31};

    if((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0))
        daysPerMonth[2] = 29;

    if(day < 1 || day > daysPerMonth[month])
    {
        printf("\nERROR: Fecha %s no tiene un dia valido\n", yytext);
        exit(1);
    }
}

void handleError(char* str)
{
    printf("ERROR LEXICO : Caracter no reconocido: %s\n", str);
    exit(1);
}

void getLexema(char* str)
{
    strcpy(yylval.str_val, str);
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
            strcpy(newLexema.longitud, "");
            break;
        case SIMBOLO_INT:
            strcpy(newLexema.tipo, "CONST_INT");
            strcpy(newLexema.valor, lexValue);
            strcpy(newLexema.longitud, "");
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
            strcpy(newLexema.longitud, "");
            strcpy(yylval.str_val, newLexema.valor);
            break;
        case SIMBOLO_STRING:
            strcpy(newLexema.tipo, "CONST_STR");
            removeChar(lexValue, '"');
            strcpy(newLexema.valor,  lexValue);
            itoa(strlen(newLexema.valor), newLexema.longitud, 10);
            break;
        case SIMBOLO_FECHA:
            strcpy(newLexema.tipo, "CONST_FECHA");
            strcpy(newLexema.valor, lexValue);
            strcpy(newLexema.longitud, "");
        default:
            break;
    }

    strcpy(newLexema.nombre, "_");
    strcat(newLexema.nombre, lexValue);

    insertarSimboloSinDuplicados(&tabla_simbolos, newLexema);
}

void removeChar(char *s, char c)
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