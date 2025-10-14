%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
#include "Tabla.h"
#include "Pila.h"
#include "Polaca.h"

#define TIPO_INT "INT"
#define TIPO_FLOAT "FLOAT"
#define TIPO_STRING "STRING"
#define TIPO_DATE_CONV "DATE_CONV"

int yystopparser=0;
FILE  *yyin;

int yyerror();
int yylex();

lista tabla_simbolos;
char* archivo_tabla_simbolos = "symbol-table.txt";

t_polaca polaca;
char* archivo_polaca = "intermediate-code.txt";

Pila pila_celdas;

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

Pila pila_IDs;
char tipoDatoVariables[10];
booleano actualizarTipoDatoVariables();

Pila pila_tipos_dato_expresion;

void validarTipoDatoAsignacion(const char* id_asignado, TipoAsignacion tipo_asignacion);
void validarTiposDatoExpresion();
void validarTiposDatoComparacion();

char* generarNombreIDTS(const char* id);
char* obtenerTipoDatoIDExistente(char* lex);

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
%start inicio_programa

%%

inicio_programa:
    programa {printf("    Programa es Inicio_Programa\n");}
    ;

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
    lista_ids DOS_PUNTOS tipo_dato {printf("    Lista_Ids DOS_PUNTOS Tipo_dato es Declaracion\n"); actualizarTipoDatoVariables();}
    ;

lista_ids:
    ID              {printf("    ID es Lista_Ids\n"); insertarEnPila(&pila_IDs, $1);}
    | lista_ids COMA ID {printf("    Lista_Ids COMA ID es Lista_Ids\n"); insertarEnPila(&pila_IDs, $3);}
    ;

tipo_dato:
    T_STRING {printf("    T_STRING es Tipo_dato\n"); strcpy(tipoDatoVariables, TIPO_STRING);}
    | T_FLOAT {printf("    T_FLOAT es Tipo_dato\n"); strcpy(tipoDatoVariables, TIPO_FLOAT);}
    | T_INT   {printf("    T_INT es Tipo_dato\n"); strcpy(tipoDatoVariables, TIPO_INT);}
    | T_DATE_CONV {printf("    T_DATE_CONV es Tipo_dato\n"); strcpy(tipoDatoVariables, TIPO_DATE_CONV);}
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
    ID OP_AS expresion {printf("    ID -> Expresion es Asignacion\n"); validarTipoDatoAsignacion($1, ASIG_EXPRESION); insertarPolaca(&polaca,$1); insertarPolaca(&polaca,"->");}
    | ID OP_AS triangleAreaMax {printf("    ID -> TriangleAreaMax es Asignacion\n"); validarTipoDatoAsignacion($1, ASIG_TRIANGLE); insertarPolaca(&polaca,$1); insertarPolaca(&polaca,"->");}
    | ID OP_AS convDate {printf("    ID -> ConvDate es Asignacion\n"); validarTipoDatoAsignacion($1, ASIG_CONVDATE); insertarPolaca(&polaca,$1); insertarPolaca(&polaca,"->");}
    | ID OP_AS CTE_STRING {printf("    ID -> CTE_STRING es Asignacion\n"); validarTipoDatoAsignacion($1, ASIG_STRING); insertarPolaca(&polaca,$3); insertarPolaca(&polaca,$1); insertarPolaca(&polaca,"->");}
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
    |expresion OP_SUM termino {printf("    Expresion+Termino es Expresion\n"); validarTiposDatoExpresion(); insertarPolaca(&polaca,"+");}
    |expresion OP_RES termino {printf("    Expresion-Termino es Expresion\n"); validarTiposDatoExpresion(); insertarPolaca(&polaca,"-");}
    ;

termino: 
    factor {printf("    Factor es Termino\n");}
    |termino OP_MUL factor {printf("     Termino*Factor es Termino\n"); validarTiposDatoExpresion(); insertarPolaca(&polaca,"*");}
    |termino OP_DIV factor {printf("     Termino/Factor es Termino\n"); validarTiposDatoExpresion(); insertarPolaca(&polaca,"/");}
    ;

factor: 
    ID {printf("    ID es Factor \n"); insertarEnPila(&pila_tipos_dato_expresion, obtenerTipoDatoIDExistente(generarNombreIDTS($1))); insertarPolaca(&polaca,$1);}
    | CTE_INT {printf("    CTE_INT es Factor\n"); insertarEnPila(&pila_tipos_dato_expresion, TIPO_INT); insertarPolaca(&polaca,$1);}
    | CTE_REAL {printf("    CTE_REAL es Factor\n"); insertarEnPila(&pila_tipos_dato_expresion, TIPO_FLOAT); insertarPolaca(&polaca,$1);}
	| PAR_A expresion PAR_C {printf("    PAR_A Expresion PAR_C es Factor\n");}
    ;

condicion:
    comparacion {printf("    Comparacion es Condicion\n");}
    | comparacion operador_logico {resolverOperadorOR();} comparacion {printf("    Comparacion Operador_Logico Comparacion es Condicion\n");}
    | OP_NOT {negadorCondicion = VERDADERO;} comparacion {printf("    OP_NOT Comparacion es Condicion\n"); negadorCondicion = FALSO;}
    ;

comparacion:
    expresion comparador expresion {printf("    Expresion Comparador Expresion es Comparacion\n"); validarTiposDatoComparacion(); insertarPolaca(&polaca,"CMP"); insertarOperadorPolaca(); insertarEnPilaCeldaActual(); avanzar(&polaca);}
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
    crearPila(&pila_celdas);
    crearPila(&pilaTriangulo);
    crearPila(&pila_IDs);
    crearPila(&pila_tipos_dato_expresion);

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
    insertarEnPila(&pila_celdas, celdaActualStr);
    return VERDADERO;
}

booleano insertarCeldaEnValorDePila()
{
    int posicion;
    char celdaActualStr[TAM_MAX];
    itoa(polaca.celdaActual,celdaActualStr,10);
    posicion = atoi(sacarDePila(&pila_celdas));
    insertarEnPosicion(&polaca,posicion,celdaActualStr);
    if(strcmp(operadorLogicoActual, "AND") == 0)
    {
        posicion = atoi(sacarDePila(&pila_celdas));
        insertarEnPosicion(&polaca,posicion,celdaActualStr);
    }
    return VERDADERO;
}

/* CONDICIONALES */

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
        char* celdaStr = sacarDePila(&pila_celdas);
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
        char* tope = sacarDePila(&pila_celdas);
        char* celdaStr = sacarDePila(&pila_celdas);
        int celda = atoi(celdaStr);
        char celdaActualStr[TAM_MAX];
        itoa(polaca.celdaActual,celdaActualStr,10);
        insertarEnPosicion(&polaca,celda,celdaActualStr);
        insertarEnPila(&pila_celdas,tope);
    }

    return VERDADERO;
}

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

booleano triangleAreaMaximum()
{

    

    return VERDADERO;
}

/* VALIDACIONES */

booleano actualizarTipoDatoVariables()
{
    char* idActual;
    char* tipoDatoActual;
    char* nombreIdActual;

    while(!pilaVacia(&pila_IDs))
    {
        idActual = sacarDePila(&pila_IDs);

        nombreIdActual = generarNombreIDTS(idActual);

        tipoDatoActual = obtenerTipoDatoID(&tabla_simbolos, nombreIdActual);

        if(strcmp(tipoDatoActual,"") != 0)
        {
            printf("\nERROR: Variable %s ya declarada\n", idActual);
            exit(1);
        }
        
        actualizarTipoDatoID(&tabla_simbolos, nombreIdActual, tipoDatoVariables);
    }
}

void validarTipoDatoAsignacion(const char* id_asignado, TipoAsignacion tipo_asignacion)
{
    char* tipoDatoAsignado;
    char* tipoExpresion;

    tipoDatoAsignado = obtenerTipoDatoIDExistente(generarNombreIDTS(id_asignado));

    switch (tipo_asignacion)
    {
        case ASIG_EXPRESION:
            tipoExpresion = sacarDePila(&pila_tipos_dato_expresion);
            if(strcmp(tipoDatoAsignado,tipoExpresion) != 0)
            {
                printf("\nERROR: Se intento asignar un %s a una variable %s\n", tipoExpresion, tipoDatoAsignado);
                exit(1);
            }
            break;
        case ASIG_TRIANGLE:
            if(strcmp(tipoDatoAsignado, TIPO_FLOAT) != 0)
            {
                printf("\nERROR: Se intento asignar un número a una variable %s\n", tipoDatoAsignado);
                exit(1);
            }
            break;
        case ASIG_CONVDATE:
            if(strcmp(tipoDatoAsignado, TIPO_DATE_CONV) != 0)
            {
                printf("\nERROR: Se intento asignar un CONV_DATE a una variable %s\n", tipoDatoAsignado);
                exit(1);
            }
            break;
        case ASIG_STRING:
            if(strcmp(tipoDatoAsignado, TIPO_STRING) != 0)
            {
                printf("\nERROR: Se intento asignar un STRING a una variable %s\n", tipoDatoAsignado);
                exit(1);
            }
            break;
    }
}

void validarTiposDatoExpresion()
{
    char* tipo_1 = sacarDePila(&pila_tipos_dato_expresion);
    char* tipo_2 = sacarDePila(&pila_tipos_dato_expresion);

    if(strcmp(tipo_1, TIPO_STRING) == 0 || strcmp(tipo_2, TIPO_STRING) == 0)
    {
        printf("\nERROR: No se pueden realizar operaciones sobre tipos STRING\n");
        exit(1);
    }

    if(strcmp(tipo_1,tipo_2) != 0)
    {
        printf("\nERROR: No se pueden realizar operaciones sobre tipos distintos\n");
        exit(1);
    }

    insertarEnPila(&pila_tipos_dato_expresion, tipo_1);
}

void validarTiposDatoComparacion()
{
    char* tipo_1 = sacarDePila(&pila_tipos_dato_expresion);
    char* tipo_2 = sacarDePila(&pila_tipos_dato_expresion);

    if(strcmp(tipo_1, TIPO_STRING) == 0 || strcmp(tipo_2, TIPO_STRING) == 0)
    {
        printf("\nERROR: No se pueden realizar operaciones sobre tipos STRING\n");
        exit(1);
    }

    if(strcmp(tipo_1,tipo_2) != 0)
    {
        printf("\nERROR: No se pueden realizar operaciones sobre tipos distintos\n");
        exit(1);
    }
}

char* generarNombreIDTS(const char* id)
{
    size_t tam_nombre = strlen(id) + 2;

    char* nombre_id = malloc(tam_nombre);

    if(!nombre_id)
        return NULL;

    snprintf(nombre_id, tam_nombre, "_%s", id);

    return nombre_id;
}

char* obtenerTipoDatoIDExistente(char* lex)
{
    char* tipo_dato = obtenerTipoDatoID(&tabla_simbolos, lex);

    if(strcmp(tipo_dato,"") == 0)
    {
        printf("\nERROR: Variable %s no declarada\n", lex+1);
        exit(1);
    }

    return tipo_dato;
}