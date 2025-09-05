%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;

  int yyerror();
  int yylex();


%}

/* Tokens */
%token ID
%token CTE_INT
%token CTE_REAL
%token CTE_STRING
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
%token READ
%token WRITE
%token TRI_AR_MAX
%token CONV_D
%token INIT

/* Start Symbol */
%start programa

%%

programa:
    bloque
    ;

bloque:
    sentencia {printf("    Sentencia es Bloque\n");}
    | bloque sentencia {printf("    Bloque Sentencia es Bloque\n");}
    ;

sentencia:  	   
	asignacion {printf(" Asignacion\n");}
    | while {printf(" While\n");}
    ;


asignacion: 
    ID OP_AS expresion {printf("    ID = Expresion es ASIGNACION\n");}
	;

while:
    WHILE PAR_A condicion PAR_C LLA_A bloque LLA_C
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
	| PAR_A expresion PAR_C {printf("    Expresion entre parentesis es Factor\n");}
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

%%


int main(int argc, char *argv[])
{
    if((yyin = fopen(argv[1], "rt"))==NULL)
    {
        printf("\nNo se puede abrir el archivo de prueba: %s\n", argv[1]);
       
    }
    else
    { 
        
        yyparse();
        
    }
	fclose(yyin);
        return 0;
}

int yyerror(void)
{
    printf("Error Sintactico\n");
    exit (1);
}