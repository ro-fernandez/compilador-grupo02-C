%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
#include "Tabla.h"
#include "Pila.h"

int yystopparser=0;
FILE  *yyin;

int yyerror();
int yylex();

lista tabla_simbolos;
char* archivo_tabla_simbolos = "symbol-table.txt";
%}

%union
{
	char str_val[400];
}

/* Tokens */
%token ID
%token CTE_INT
%token CTE_REAL
%token CTE_STRING
%token CTE_FECHA
%token PAR_A
%token PAR_C
%token COR_A
%token COR_C
%token LLA_A
%token LLA_C
%token PUNTO
%token COMA
%token PyC
%token DOS_PUNTOS
%token OP_AS
%token OP_SUM
%token OP_MUL
%token OP_RES
%token OP_DIV
%token OP_AND
%token OP_OR
%token OP_NOT
%token CMP_EQ
%token CMP_NE
%token CMP_LT
%token CMP_LE
%token CMP_GT
%token CMP_GE
%token IF
%token ELSE
%token WHILE
%token FOR
%token T_INT
%token T_FLOAT
%token T_STRING
%token T_DATE_CONV
%token READ
%token WRITE
%token TRI_AR_MAX
%token CONV_D
%token INIT

/* Start Symbol */
%start programa

%%

programa:
    init {printf("    Init es Programa\n");}
    | bloque {printf("    Bloque es Programa\n");}
    | init bloque {printf("    Init Bloque es Programa\n");}
    ;

bloque:
    sentencia {printf("    Sentencia es Bloque\n");}
    | bloque sentencia {printf("    Bloque Sentencia es Bloque\n");}
    ;

init:
    INIT LLA_A declaraciones LLA_C {printf("    INIT LLA_A Declaraciones LLA_C es Init\n");}
    ;

declaraciones:
    declaracion                 {printf("    Declaracion es Declaraciones\n");}
    | declaraciones declaracion    {printf("    Declaraciones Declaracion es Declaraciones\n");}
    ;

declaracion:
    lista_ids DOS_PUNTOS tipo_dato {printf("    Lista_Ids DOS_PUNTOS Tipo_dato es Declaracion\n");}
    ;

lista_ids:
    ID              {printf("    ID es Lista_Ids\n");}
    | lista_ids COMA ID {printf("    Lista_Ids COMA ID es Lista_Ids\n");}
    ;

tipo_dato:
    T_STRING {printf("    T_STRING es Tipo_dato\n");}
    | T_FLOAT {printf("    T_FLOAT es Tipo_dato\n");}
    | T_INT   {printf("    T_INT es Tipo_dato\n"); }
    | T_DATE_CONV {printf("    T_DATE_CONV es Tipo_dato\n"); }
    ;

leer:
    READ PAR_A ID PAR_C     {printf("    READ PAR_A ID PAR_C es Leer\n");}
    ;

escribir:
    WRITE PAR_A CTE_STRING PAR_C        {printf("    WRITE PAR_OP CTE_STRING PAR_CL es Escribir\n");}
    | WRITE PAR_A expresion PAR_C       {printf("    WRITE PAR_OP Expresion PAR_CL es Escribir\n");}
    ;

sentencia:  	   
	asignacion {printf("    Asignacion es Sentencia\n");}
    | while {printf("    While es Sentencia\n");}
    | triangleAreaMax {printf("     TriangleAreaMax es Sentencia\n");}
    | convDate  {printf("    ConvDate es Sentencia\n");}
    | leer  {printf("    Leer es Sentencia\n");}
    | escribir  {printf("    Escribir es Sentencia\n");}
    | if {printf("    If es Sentencia\n");}
    | else {printf("    Else es Sentencia\n");}
    ;


asignacion: 
    ID OP_AS expresion {printf("    ID -> Expresion es Asignacion\n");}
    | ID OP_AS triangleAreaMax {printf("    ID -> TriangleAreaMax es Asignacion\n");}
    | ID OP_AS convDate {printf("    ID -> ConvDate es Asignacion\n");}
    | ID OP_AS CTE_STRING {printf("    ID -> CTE_STRING es Asignacion\n");}
	;

while:
    WHILE PAR_A condicion PAR_C LLA_A bloque LLA_C {printf("    WHILE PAR_A Condicion PAR_C LLA_A Bloque LLA_C es While\n");}
    ;

if:
    IF PAR_A condicion PAR_C LLA_A bloque LLA_C {printf("    IF PAR_A Condicion PAR_C LLA_A Bloque LLA_C es If\n");}
    ;
    
else:
    IF PAR_A condicion PAR_C LLA_A bloque LLA_C ELSE LLA_A bloque LLA_C {printf("    IF PAR_A Condicion PAR_C LLA_A Bloque LLA_C ELSE LLA_A Bloque LLA_C es Else\n");}
    ;

expresion:
    termino {printf("    Termino es Expresion\n");}
    |expresion OP_SUM termino {printf("    Expresion+Termino es Expresion\n");}
    |expresion OP_RES termino {printf("    Expresion-Termino es Expresion\n");}
    ;

termino: 
    factor {printf("    Factor es Termino\n");}
    |termino OP_MUL factor {printf("     Termino*Factor es Termino\n");}
    |termino OP_DIV factor {printf("     Termino/Factor es Termino\n");}
    ;

factor: 
    ID {printf("    ID es Factor \n");}
    | CTE_INT {printf("    CTE_INT es Factor\n");}
    | CTE_REAL {printf("    CTE_REAL es Factor\n");}
	| PAR_A expresion PAR_C {printf("    PAR_A Expresion PAR_C es Factor\n");}
    ;

condicion:
    comparacion {printf("    Comparacion es Condicion\n");}
    | comparacion operador_logico comparacion {printf("    Comparacion Operador_Logico Comparacion es Condicion\n");}
    | OP_NOT comparacion {printf("    OP_NOT Comparacion es Condicion\n");}
    ;

comparacion:
    expresion comparador expresion {printf("    Expresion Comparador Expresion es Comparacion\n");}
    ;

comparador:
    CMP_EQ {printf("    CMP_EQ es Comparador\n");}
    | CMP_NE {printf("    CMP_NE es Comparador\n");}
    | CMP_LT {printf("    CMP_LT es Comparador\n");}
    | CMP_LE {printf("    CMP_LE es Comparador\n");}
    | CMP_GT {printf("    CMP_GT es Comparador\n");}
    | CMP_GE {printf("    CMP_GE es Comparador\n");}

operador_logico:
    OP_AND {printf("    OP_AND es Operador Logico\n");}
    | OP_OR {printf("    OP_OR es Operador Logico\n");}
    ;

triangleAreaMax:
    TRI_AR_MAX PAR_A triangulo PyC triangulo PAR_C {printf("    TRI_AR_MAX es TriangleAreaMax\n");}
    ;

triangulo:
    COR_A coordenada COMA coordenada COMA coordenada COR_C {printf("    COR_A Coordenada COMA Coordenada COMA Coordenada COR_C es Triangulo\n");}
    ;

coordenada:
    CTE_INT     {printf("    CTE_INT es Coordenada\n");}
    | CTE_REAL  {printf("    CTE_REAL es Coordenada\n");}
    | ID        {printf("    ID es Coordenada\n");}
    ;

convDate:
    CONV_D PAR_A CTE_FECHA PAR_C {printf("    CONV_D PAR_A CTE_FECHA PAR_C es ConvDate\n");}
    ;

%%


int main(int argc, char *argv[])
{
    crearLista(&tabla_simbolos);

    if((yyin = fopen(argv[1], "rt"))==NULL)
    {
        printf("\nNo se puede abrir el archivo de prueba: %s\n", argv[1]);
       
    }
    else
    { 
        
        yyparse();
    }

	fclose(yyin);

    guardarYVaciarLista(&tabla_simbolos, archivo_tabla_simbolos);
    
    return 0;
}

int yyerror(void)
{
    printf("Error Sintactico\n");
    exit (1);
}