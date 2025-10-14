%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
#include "Tabla.h"
#include "Pila.h"
#include "Polaca.h"

int yystopparser=0;
FILE  *yyin;

int yyerror();
int yylex();

lista tabla_simbolos;
char* archivo_tabla_simbolos = "symbol-table.txt";

t_polaca polaca;
char* archivo_polaca = "intermediate-code.txt";

Pila pilaCeldas;

Pila pilaTriangulo;

char branchComparadorActual[4];
char operadorLogicoActual[4];
booleano negadorCondicion = FALSO;

char* negarCondicion();
booleano insertarOperadorPolaca();
booleano insertarEnPilaCeldaActual();
booleano resolverOperadorOR();
booleano insertarCeldaEnValorDePila();
booleano completarBranchOR();
booleano insertarTriangulo1EnPolaca();
booleano insertarTriangulo2EnPolaca();
booleano triangleAreaMaximum();
booleano insertarCalculoArea1();
booleano insertarCalculoArea2();

%}

%union
{
	char str_val[400];
}

/* Tokens */
%token <str_val> ID
%token <str_val> CTE_INT 
%token <str_val> CTE_REAL
%token <str_val> CTE_STRING
%token <str_val> CTE_FECHA
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
    ID              {printf("    ID es Lista_Ids\n"); insertarPolaca(&polaca, $1);}
    | lista_ids COMA ID {printf("    Lista_Ids COMA ID es Lista_Ids\n"); insertarPolaca(&polaca, $3);}
    ;

tipo_dato:
    T_STRING {printf("    T_STRING es Tipo_dato\n");}
    | T_FLOAT {printf("    T_FLOAT es Tipo_dato\n");}
    | T_INT   {printf("    T_INT es Tipo_dato\n"); }
    | T_DATE_CONV {printf("    T_DATE_CONV es Tipo_dato\n"); }
    ;

leer:
    READ PAR_A ID PAR_C     {printf("    READ PAR_A ID PAR_C es Leer\n"); insertarPolaca(&polaca, $3); ; insertarPolaca(&polaca,"LEER");}
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
    | sentencia_if {printf("    If es Sentencia\n");}
    | sentencia_else {printf("    Else es Sentencia\n");}
    ;


asignacion: 
    ID OP_AS expresion {printf("    ID -> Expresion es Asignacion\n"); insertarPolaca(&polaca,$1); insertarPolaca(&polaca,"->");}
    | ID OP_AS triangleAreaMax {printf("    ID -> TriangleAreaMax es Asignacion\n"); insertarPolaca(&polaca,$1); insertarPolaca(&polaca,"->");}
    | ID OP_AS convDate {printf("    ID -> ConvDate es Asignacion\n"); insertarPolaca(&polaca,$1); insertarPolaca(&polaca,"->");}
    | ID OP_AS CTE_STRING {printf("    ID -> CTE_STRING es Asignacion\n"); insertarPolaca(&polaca,$3); insertarPolaca(&polaca,$1); insertarPolaca(&polaca,"->");}
	;

while:
    WHILE PAR_A condicion PAR_C LLA_A bloque LLA_C {printf("    WHILE PAR_A Condicion PAR_C LLA_A Bloque LLA_C es While\n");}
    ;

sentencia_if:
    IF PAR_A condicion PAR_C LLA_A {completarBranchOR();} bloque LLA_C {insertarCeldaEnValorDePila(); printf("    IF PAR_A Condicion PAR_C LLA_A Bloque LLA_C es If\n");}
    ;

sentencia_else:
    sentencia_if ELSE LLA_A {insertarCeldaEnValorDePila();} bloque LLA_C {printf("    IF PAR_A Condicion PAR_C LLA_A Bloque LLA_C ELSE LLA_A Bloque LLA_C es If\n");}
    ;

expresion:
    termino {printf("    Termino es Expresion\n");}
    |expresion OP_SUM termino {printf("    Expresion+Termino es Expresion\n"); insertarPolaca(&polaca,"+");}
    |expresion OP_RES termino {printf("    Expresion-Termino es Expresion\n"); insertarPolaca(&polaca,"-");}
    ;

termino: 
    factor {printf("    Factor es Termino\n");}
    |termino OP_MUL factor {printf("     Termino*Factor es Termino\n"); insertarPolaca(&polaca,"*");}
    |termino OP_DIV factor {printf("     Termino/Factor es Termino\n"); insertarPolaca(&polaca,"/");}
    ;

factor: 
    ID {printf("    ID es Factor \n"); insertarPolaca(&polaca,$1); }
    | CTE_INT {printf("    CTE_INT es Factor\n"); insertarPolaca(&polaca,$1);}
    | CTE_REAL {printf("    CTE_REAL es Factor\n"); insertarPolaca(&polaca,$1);}
	| PAR_A expresion PAR_C {printf("    PAR_A Expresion PAR_C es Factor\n");}
    ;

condicion:
    comparacion {printf("    Comparacion es Condicion\n");}
    | comparacion operador_logico {resolverOperadorOR();} comparacion {printf("    Comparacion Operador_Logico Comparacion es Condicion\n");}
    | OP_NOT {negadorCondicion = VERDADERO;} comparacion {printf("    OP_NOT Comparacion es Condicion\n"); negadorCondicion = FALSO;}
    ;

comparacion:
    expresion comparador expresion {printf("    Expresion Comparador Expresion es Comparacion\n"); insertarPolaca(&polaca,"CMP"); insertarOperadorPolaca(); insertarEnPilaCeldaActual(); avanzar(&polaca);}
    ;

comparador:
    CMP_EQ {printf("    CMP_EQ es Comparador\n"); strcpy(branchComparadorActual, "BNE");}
    | CMP_NE {printf("    CMP_NE es Comparador\n"); strcpy(branchComparadorActual, "BEQ");}
    | CMP_LT {printf("    CMP_LT es Comparador\n"); strcpy(branchComparadorActual, "BGE");}
    | CMP_LE {printf("    CMP_LE es Comparador\n"); strcpy(branchComparadorActual, "BGT");}
    | CMP_GT {printf("    CMP_GT es Comparador\n"); strcpy(branchComparadorActual, "BLE");}
    | CMP_GE {printf("    CMP_GE es Comparador\n"); strcpy(branchComparadorActual, "BLT");}
    ;
    
operador_logico:
    OP_AND {printf("    OP_AND es Operador Logico\n"); strcpy(operadorLogicoActual, "AND");}
    | OP_OR {printf("    OP_OR es Operador Logico\n"); strcpy(operadorLogicoActual, "OR");}
    ;

triangleAreaMax:
    TRI_AR_MAX PAR_A triangulo {insertarTriangulo1EnPolaca();} PyC triangulo {insertarTriangulo2EnPolaca();} PAR_C {triangleAreaMaximum(); printf("    TRI_AR_MAX es TriangleAreaMax\n");}
    ;

triangulo:
    COR_A coordenada PyC coordenada PyC coordenada COR_C {printf("    COR_A Coordenada COMA Coordenada COMA Coordenada COR_C es Triangulo\n");}
    ;


coordenada:
    valor COMA valor {printf("    valor PyC valor es Coordenada\n");}
    ;


valor:
    CTE_INT     {insertarEnPila(&pilaTriangulo,$1); printf("    CTE_INT es Valor\n");}
    | CTE_REAL  {insertarEnPila(&pilaTriangulo,$1); printf("    CTE_REAL es Valor\n");}
    | ID        {insertarEnPila(&pilaTriangulo,$1); printf("    ID es Valor\n");}
    ;


convDate:
    CONV_D PAR_A CTE_FECHA PAR_C {printf("    CONV_D PAR_A CTE_FECHA PAR_C es ConvDate\n");}
    ;

%%


int main(int argc, char *argv[])
{
    crearLista(&tabla_simbolos);
    crearListaPolaca(&polaca);
    crearPila(&pilaCeldas);
    crearPila(&pilaTriangulo);

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
    guardarYVaciarListaPolaca(&polaca,archivo_polaca);

    return 0;
}

int yyerror(void)
{
    printf("Error Sintactico\n");
    exit (1);
}

booleano insertarEnPilaCeldaActual()
{
    char celdaActualStr[TAM_MAX];
    itoa(polaca.celdaActual, celdaActualStr, 10);
    insertarEnPila(&pilaCeldas, celdaActualStr);
    return VERDADERO;
}

booleano insertarCeldaEnValorDePila()
{
    int posicion;
    char celdaActualStr[TAM_MAX];
    itoa(polaca.celdaActual,celdaActualStr,10);
    posicion = atoi(sacarDePila(&pilaCeldas));
    insertarEnPosicion(&polaca,posicion,celdaActualStr);
    if(strcmp(operadorLogicoActual, "AND") == 0)
    {
        posicion = atoi(sacarDePila(&pilaCeldas));
        insertarEnPosicion(&polaca,posicion,celdaActualStr);
    }
    return VERDADERO;
}


booleano insertarOperadorPolaca()
{
    if(negadorCondicion)
        strcpy(branchComparadorActual, negarCondicion());
    
    insertarPolaca(&polaca,branchComparadorActual);

    return VERDADERO;
}

char* negarCondicion()
{
    if(strcmp(branchComparadorActual, "BNE") == 0)
        return "BEQ";

    if(strcmp(branchComparadorActual, "BEQ") == 0)
        return "BNE";
    
    if(strcmp(branchComparadorActual, "BGE") == 0)
        return "BLT";

    if(strcmp(branchComparadorActual, "BGT") == 0)
        return "BLE";

    if(strcmp(branchComparadorActual, "BLE") == 0)
        return "BGT";
    
    if(strcmp(branchComparadorActual, "BLT") == 0)
        return "BGE";

    return NULL;
}


//FRAN: acá entiendo que lo que hacés es,
//si el operador es OR, entonces insertas en polaca el BI y te guardas en pila el valor de la celda que sigue, para poner el inicio del IF/WHILE
booleano resolverOperadorOR()
{
    if(strcmp(operadorLogicoActual, "OR") == 0)
    {
        char celdaAInsertar[7];
        char* celdaStr = sacarDePila(&pilaCeldas);
        int celda = atoi(celdaStr);
        insertarPolaca(&polaca, "BI");
        itoa(polaca.celdaActual + 1, celdaAInsertar, 10);
        insertarEnPosicion(&polaca, celda, celdaAInsertar);
        insertarEnPilaCeldaActual();
        avanzar(&polaca);
    }

    return VERDADERO;
}

booleano completarBranchOR()
{
    if(strcmp(operadorLogicoActual, "OR") == 0)
    {
        char* tope = sacarDePila(&pilaCeldas);
        char* celdaStr = sacarDePila(&pilaCeldas);
        int celda = atoi(celdaStr);
        char celdaActualStr[TAM_MAX];
        itoa(polaca.celdaActual,celdaActualStr,10);
        insertarEnPosicion(&polaca,celda,celdaActualStr);
        insertarEnPila(&pilaCeldas,tope);
    }

    return VERDADERO;
}

//decidi dejar las variables de las coordenadas sin "_" para que se diferencien de las del usuario
booleano insertarTriangulo1EnPolaca()
{
    int i;
    char* valor;
    char* coordenada;
    
    //formato: x1,y1,x2,y2,x3,y3
    //en polaca: val|y3|->|val|x3|->|val|y2|->|val|x2|->|val|y1|->|val|x1|->|
    coordenada = sacarDePila(&pilaTriangulo);
    insertarPolaca(&polaca,coordenada);
    insertarPolaca(&polaca,"y3");
    insertarPolaca(&polaca,"->");

    coordenada = sacarDePila(&pilaTriangulo);
    insertarPolaca(&polaca,coordenada);
    insertarPolaca(&polaca,"x3");
    insertarPolaca(&polaca,"->");

    coordenada = sacarDePila(&pilaTriangulo);
    insertarPolaca(&polaca,coordenada);
    insertarPolaca(&polaca,"y2");
    insertarPolaca(&polaca,"->");

    coordenada = sacarDePila(&pilaTriangulo);
    insertarPolaca(&polaca,coordenada);
    insertarPolaca(&polaca,"x2");
    insertarPolaca(&polaca,"->");

    coordenada = sacarDePila(&pilaTriangulo);
    insertarPolaca(&polaca,coordenada);
    insertarPolaca(&polaca,"y1");
    insertarPolaca(&polaca,"->");

    coordenada = sacarDePila(&pilaTriangulo);
    insertarPolaca(&polaca,coordenada);
    insertarPolaca(&polaca,"x1");
    insertarPolaca(&polaca,"->");

    return VERDADERO;
}

booleano insertarTriangulo2EnPolaca()
{
    int i;
    char* valor;
    char* coordenada;

    //formato: x4,y4,x5,y5,x6,y6
    //en polaca: val|y6|->|val|x6|->|val|y5|->|val|x5|->|val|y4|->|val|x4|->|
    coordenada = sacarDePila(&pilaTriangulo);
    insertarPolaca(&polaca,coordenada);
    insertarPolaca(&polaca,"y6");
    insertarPolaca(&polaca,"->");

    coordenada = sacarDePila(&pilaTriangulo);
    insertarPolaca(&polaca,coordenada);
    insertarPolaca(&polaca,"x6");
    insertarPolaca(&polaca,"->");

    coordenada = sacarDePila(&pilaTriangulo);
    insertarPolaca(&polaca,coordenada);
    insertarPolaca(&polaca,"y5");
    insertarPolaca(&polaca,"->");

    coordenada = sacarDePila(&pilaTriangulo);
    insertarPolaca(&polaca,coordenada);
    insertarPolaca(&polaca,"x5");
    insertarPolaca(&polaca,"->");

    coordenada = sacarDePila(&pilaTriangulo);
    insertarPolaca(&polaca,coordenada);
    insertarPolaca(&polaca,"y4");
    insertarPolaca(&polaca,"->");

    coordenada = sacarDePila(&pilaTriangulo);
    insertarPolaca(&polaca,coordenada);
    insertarPolaca(&polaca,"x4");
    insertarPolaca(&polaca,"->");

    return VERDADERO;
}




//TRIANGLE AREA MAXIMUM: BASADO EN ESTE CODIGO
/*
float triangleAreaMaximum(float x1,float y1,float x2,float y2,float x3,float y3,float x4,float y4,float x5,float y5,float x6,float y6) 
{
    float mayor;
    
    float areaTri1 = 1/2 * (x1*(y2-y3) + x2*(y3-y1) + x3*(y1-y2));
    if(areaTri1 == 0)
    {
        printf("Error, las coordenadas correspondientes al primer triángulo no cumplen la condición de triangularidad");
        return -1;
    }
    float areaTri2 = 1/2 * (x4*(y5-y6) + x5*(y6-y4) + x6*(y4-y5));
    if(areaTri2 == 0)
    {
        printf("Error, las coordenadas correspondientes al segundo triángulo no cumplen la condición de triangularidad");
        return -1;
    }
    
    if(areaTri1 > areaTri2)
    {
        mayor = areaTri1;    
    }    
    else
    {
        mayor = areaTri2;
    }
    
    return mayor;
}
*/



booleano triangleAreaMaximum()
{
    char branchValue[TAM_MAX];
    insertarCalculoArea1();
    insertarCalculoArea2();
    //validacion triangularidad: por ahora, lo que hace si alguno de los dos parametros NO ES TRIANGULO, va al final del codigo y no hace nada.

    //if(a1 == 0 || a2 == 0) ---> ir al final del codigo
    insertarPolaca(&polaca,"a1");
    insertarPolaca(&polaca,"0");
    insertarPolaca(&polaca,"CMP");
    insertarPolaca(&polaca,"BNE");
    itoa(polaca.celdaActual+3,branchValue,10);
    insertarPolaca(&polaca,branchValue);

    insertarPolaca(&polaca,"BI");
    itoa(polaca.celdaActual+21,branchValue,10);
    insertarPolaca(&polaca,branchValue);

    insertarPolaca(&polaca,"a2");
    insertarPolaca(&polaca,"0");
    insertarPolaca(&polaca,"CMP");
    insertarPolaca(&polaca,"BNE");
    itoa(polaca.celdaActual+3,branchValue,10);
    insertarPolaca(&polaca,branchValue);

    insertarPolaca(&polaca,"BI");
    itoa(polaca.celdaActual+14,branchValue,10);
    insertarPolaca(&polaca,branchValue);
    //fin validacion triangularidad


    //if(a1 > a2)
    insertarPolaca(&polaca,"a1");
    insertarPolaca(&polaca,"a2");
    insertarPolaca(&polaca,"CMP");
    insertarPolaca(&polaca,"BLE");
    itoa(polaca.celdaActual+6,branchValue,10);
    insertarPolaca(&polaca,branchValue);

    //mayor = a1
    insertarPolaca(&polaca,"a1");
    insertarPolaca(&polaca,"mayor");
    insertarPolaca(&polaca,"->");
    insertarPolaca(&polaca,"BI");
    itoa(polaca.celdaActual+4,branchValue,10);
    insertarPolaca(&polaca,branchValue);

    //mayor = a2
    insertarPolaca(&polaca,"a2");
    insertarPolaca(&polaca,"mayor");
    insertarPolaca(&polaca,"->");
    

    return VERDADERO;
}

booleano insertarCalculoArea1()
{
    //areaTri1 = 0.5 * (x1*(y2-y3) + x2*(y3-y1) + x3*(y1-y2)) 

    insertarPolaca(&polaca,"y2");
    insertarPolaca(&polaca,"y3");
    insertarPolaca(&polaca,"-");

    insertarPolaca(&polaca,"x1");
    insertarPolaca(&polaca,"*");

    insertarPolaca(&polaca,"y3");
    insertarPolaca(&polaca,"y1");
    insertarPolaca(&polaca,"-");

    insertarPolaca(&polaca,"x2");
    insertarPolaca(&polaca,"*");

    insertarPolaca(&polaca,"+");

    insertarPolaca(&polaca,"y1");
    insertarPolaca(&polaca,"y2");
    insertarPolaca(&polaca,"-");

    insertarPolaca(&polaca,"x3");
    insertarPolaca(&polaca,"*");

    insertarPolaca(&polaca,"+");

    insertarPolaca(&polaca,"0.5");
    insertarPolaca(&polaca,"*");
    
    insertarPolaca(&polaca,"a1");
    insertarPolaca(&polaca,"->");

    return VERDADERO;
}

booleano insertarCalculoArea2()
{
    //areaTri2 = 0.5 * (x4*(y5-y6) + x5*(y6-y4) + x6*(y4-y5)) 

    insertarPolaca(&polaca,"y5");
    insertarPolaca(&polaca,"y6");
    insertarPolaca(&polaca,"-");

    insertarPolaca(&polaca,"x4");
    insertarPolaca(&polaca,"*");

    insertarPolaca(&polaca,"y6");
    insertarPolaca(&polaca,"y4");
    insertarPolaca(&polaca,"-");

    insertarPolaca(&polaca,"x5");
    insertarPolaca(&polaca,"*");

    insertarPolaca(&polaca,"+");

    insertarPolaca(&polaca,"y4");
    insertarPolaca(&polaca,"y5");
    insertarPolaca(&polaca,"-");

    insertarPolaca(&polaca,"x6");
    insertarPolaca(&polaca,"*");

    insertarPolaca(&polaca,"+");

    insertarPolaca(&polaca,"0.5");
    insertarPolaca(&polaca,"*");
    
    insertarPolaca(&polaca,"a2");
    insertarPolaca(&polaca,"->");

    return VERDADERO;
}