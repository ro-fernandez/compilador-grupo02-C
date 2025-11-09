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
char* operadorLogicoActual;
booleano negadorCondicion = FALSO;

Pila pila_operadores_logicos;

char* negarCondicion();
booleano insertarOperadorPolaca();
booleano insertarEnPilaCeldaActual();
booleano resolverOperadorOR();
booleano insertarCeldaEnValorDePila();
booleano completarBranchOR();
booleano completarBranchWhile();
booleano completarBranchElse();

booleano insertarTriangulo1EnPolaca();
booleano insertarTriangulo2EnPolaca();
booleano triangleAreaMaximum();
booleano insertarCalculoArea1();
booleano insertarCalculoArea2();

booleano convertDate(char* dia, char* mes, char* anio);

Pila pila_IDs;
char tipoDatoVariables[10];
booleano actualizarTipoDatoVariables();

Pila pila_tipos_dato_expresion;

void validarTipoDatoAsignacion(const char* id_asignado, TipoAsignacion tipo_asignacion);
void validarTiposDatoExpresion();
void validarTiposDatoComparacion();
void validarTipoDatoCoordenada(char* id);

char* generarNombreIDTS(const char* id);
char* obtenerTipoDatoIDExistente(char* lex);

/* FUNCIONES DE ASSEMBLER */
void generarAssembler();
void preprocesarPolaca(t_polaca* polaca, lista* listaTS);
int esCTEnumerica(char* celda);
int esCTEString(char* celda);
int esID( char* celda);
void eliminarCaracteres(char* str, char c);
int esSalto(char* celda);
void generarCodeAssembler(FILE* archASM);
void procesarCeldaPolaca(FILE* fAssembler, char* celda) ;
char* ObtenerOperador(char* celda);
int esOperando(char* celda);
void ResOperacionMatAsm(FILE* fAssembler, char* operador);
char* crearAuxiliar();
void RescCmpASM(FILE* fAssembler);
void ResAsignacionAsm(FILE* fAssembler);
char* ProcesarSalto(char* celda);
void ResBIAsm(FILE* fAssembler);
void ResEscrituraAsm(FILE* fAssembler);
void ResLecturaAsm(FILE* fAssembler);
void generarDataAssembler(FILE* fAssembler, lista* listaTS);
void mergeArchivos(FILE* fAssembler, FILE* fCodeAsm);

/* ESTRUCTURAS DE ASSEMBLER */
Pila pilaAuxAsm;
Pila pilaOperandos;
int auxActual = 0;

lista tablaSimbolosDup;
t_polaca polacaDup;

%}

%union
{
	struct
    {
        char d[3];
        char m[3];
        char a[5];
    } fecha;
    
    char str_val[400];
}

/* Tokens */
%token <str_val> ID
%token <str_val> CTE_INT 
%token <str_val> CTE_REAL
%token <str_val> CTE_STRING
%token <fecha> CTE_FECHA
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
    programa {printf("    Programa es Inicio_Programa\n");  generarAssembler();}
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
    WRITE PAR_A CTE_STRING PAR_C        {printf("    WRITE PAR_OP CTE_STRING PAR_CL es Escribir\n"); insertarPolaca(&polaca, $3); insertarPolaca(&polaca,"ESCRIBIR");}
    | WRITE PAR_A expresion PAR_C       {printf("    WRITE PAR_OP Expresion PAR_CL es Escribir\n"); insertarPolaca(&polaca,"ESCRIBIR");}
    ;

sentencia:  	   
	asignacion {printf("    Asignacion es Sentencia\n");}
    | while {printf("    While es Sentencia\n");}
    | triangleAreaMax {printf("     TriangleAreaMax es Sentencia\n");}
    | convDate  {printf("    ConvDate es Sentencia\n");}
    | leer  {printf("    Leer es Sentencia\n");}
    | escribir  {printf("    Escribir es Sentencia\n");}
    | sentencia_if {insertarCeldaEnValorDePila(); printf("    If es Sentencia\n"); eliminarDePila(&pila_operadores_logicos);}
    | sentencia_else {printf("    Else es Sentencia\n"); eliminarDePila(&pila_operadores_logicos);}
    ;

asignacion: 
    ID OP_AS expresion {printf("    ID -> Expresion es Asignacion\n"); validarTipoDatoAsignacion($1, ASIG_EXPRESION); insertarPolaca(&polaca,$1); insertarPolaca(&polaca,"->");}
    | ID OP_AS triangleAreaMax {printf("    ID -> TriangleAreaMax es Asignacion\n"); validarTipoDatoAsignacion($1, ASIG_TRIANGLE); insertarPolaca(&polaca,$1); insertarPolaca(&polaca,"->");}
    | ID OP_AS convDate {printf("    ID -> ConvDate es Asignacion\n"); validarTipoDatoAsignacion($1, ASIG_CONVDATE); insertarPolaca(&polaca,$1); insertarPolaca(&polaca,"->");}
    | ID OP_AS CTE_STRING {printf("    ID -> CTE_STRING es Asignacion\n"); validarTipoDatoAsignacion($1, ASIG_STRING); insertarPolaca(&polaca,$3); insertarPolaca(&polaca,$1); insertarPolaca(&polaca,"->");}
	;

while:
    WHILE { insertarEnPilaCeldaActual();/*insertarPolaca(&polaca,"ET");*/} PAR_A condicion PAR_C {completarBranchOR();} LLA_A bloque {completarBranchWhile();} LLA_C {printf("    WHILE PAR_A Condicion PAR_C LLA_A Bloque LLA_C es While\n");}
    ;

sentencia_if:
    IF PAR_A condicion PAR_C LLA_A {completarBranchOR();} bloque LLA_C {printf("    IF PAR_A Condicion PAR_C LLA_A Bloque LLA_C es If\n");}
    ;

sentencia_else:
    sentencia_if ELSE LLA_A {insertarPolaca(&polaca,"BI"); insertarEnPilaCeldaActual(); avanzar(&polaca); char* aux = sacarDePila(&pila_celdas); insertarCeldaEnValorDePila(); insertarEnPila(&pila_celdas,aux);} bloque LLA_C {completarBranchElse();}
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
    comparacion {printf("    Comparacion es Condicion\n"); insertarEnPila(&pila_operadores_logicos, "");}
    | comparacion operador_logico {resolverOperadorOR();} comparacion {printf("    Comparacion Operador_Logico Comparacion es Condicion\n");}
    | OP_NOT {negadorCondicion = VERDADERO;} comparacion {printf("    OP_NOT Comparacion es Condicion\n"); negadorCondicion = FALSO; insertarEnPila(&pila_operadores_logicos, "");}
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
    OP_AND {printf("    OP_AND es Operador Logico\n"); insertarEnPila(&pila_operadores_logicos, "AND");}
    | OP_OR {printf("    OP_OR es Operador Logico\n"); insertarEnPila(&pila_operadores_logicos, "OR");}
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
    | ID        {validarTipoDatoCoordenada($1); insertarEnPila(&pilaTriangulo,$1); printf("    ID es Valor\n");}
    ;

convDate:
    CONV_D PAR_A CTE_FECHA PAR_C {printf("    CONV_D PAR_A CTE_FECHA PAR_C es ConvDate\n"); convertDate($3.d, $3.m, $3.a);}
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
    crearPila(&pila_operadores_logicos);

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
    itoa(polaca.celdaActual+1,celdaActualStr,10);
    posicion = atoi(sacarDePila(&pila_celdas));
    insertarEnPosicion(&polaca,posicion,celdaActualStr);
    operadorLogicoActual = verTopeDePila(&pila_operadores_logicos);
    if(operadorLogicoActual && strcmp(operadorLogicoActual, "AND") == 0)
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
    operadorLogicoActual = verTopeDePila(&pila_operadores_logicos);
    if(operadorLogicoActual && strcmp(operadorLogicoActual, "OR") == 0)
    {
        char celdaAInsertar[7];
        char* celdaStr = sacarDePila(&pila_celdas);
        int celda = atoi(celdaStr);
        insertarPolaca(&polaca, "BI");
        itoa(polaca.celdaActual + 2, celdaAInsertar, 10);
        insertarEnPosicion(&polaca, celda, celdaAInsertar);
        insertarEnPilaCeldaActual();
        avanzar(&polaca);
    }

    return VERDADERO;
}


//NUEVO
booleano completarBranchElse()
{
    char* celdaStr = sacarDePila(&pila_celdas);
    int celda = atoi(celdaStr);
    char celdaActualStr[TAM_MAX];
    itoa(polaca.celdaActual + 1,celdaActualStr,10);
    insertarEnPosicion(&polaca,celda,celdaActualStr);
}

booleano completarBranchOR()
{
    operadorLogicoActual = verTopeDePila(&pila_operadores_logicos);
    if(operadorLogicoActual && strcmp(operadorLogicoActual, "OR") == 0)
    {
        char* tope = sacarDePila(&pila_celdas);
        char* celdaStr = sacarDePila(&pila_celdas);
        int celda = atoi(celdaStr);
        char celdaActualStr[TAM_MAX];
        itoa(polaca.celdaActual+1,celdaActualStr,10);
        insertarEnPosicion(&polaca,celda,celdaActualStr);
        insertarEnPila(&pila_celdas,tope);
    }

    return VERDADERO;
}

booleano completarBranchWhile()
{
    
    char* tope = sacarDePila(&pila_celdas);//desapilar Z (tope de pila)
    int celda = atoi(tope);
    char celdaSig[TAM_MAX];

    insertarPolaca(&polaca,"BI"); // Escribir BI
    itoa(polaca.celdaActual + 1,celdaSig,10);
    insertarEnPosicion(&polaca,celda,celdaSig); // escribir en Z  el nº celda actual + 1
    
    tope = sacarDePila(&pila_celdas); //desapilar Z (tope de pila)
    celda = atoi(tope);

    insertarPolaca(&polaca, tope); // escribir Z en la celda actual 

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

    insertarValorEnTS(&tabla_simbolos, "y3", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "y2", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "y1", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "x3", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "x2", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "x1", SIMBOLO_ID);

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

    insertarValorEnTS(&tabla_simbolos, "y6", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "y5", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "y4", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "x6", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "x5", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "x4", SIMBOLO_ID);

    return VERDADERO;
}

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
    
    insertarValorEnTS(&tabla_simbolos, "a1", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "a2", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "mayor", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "0.0", SIMBOLO_REAL);

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

    insertarValorEnTS(&tabla_simbolos, "y3", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "y2", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "y1", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "x3", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "x2", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "x1", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "a1", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "0.5", SIMBOLO_REAL);

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

    insertarValorEnTS(&tabla_simbolos, "y6", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "y5", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "y4", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "x6", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "x5", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "x4", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "a2", SIMBOLO_ID);
    insertarValorEnTS(&tabla_simbolos, "0.5", SIMBOLO_REAL);

    return VERDADERO;
}

booleano convertDate(char* dia, char* mes, char* anio)
{
    insertarPolaca(&polaca, anio);
    insertarPolaca(&polaca, "10000");

    insertarPolaca(&polaca, "*");

    insertarPolaca(&polaca, mes);
    insertarPolaca(&polaca, "100");

    insertarPolaca(&polaca, "*");

    insertarPolaca(&polaca, "+");

    insertarPolaca(&polaca, dia);

    insertarPolaca(&polaca, "+");

    /*
    ESTO SE COMENTA PARA QUE ANDE
    insertarPolaca(&polaca, "fecha_conv");
    insertarPolaca(&polaca, "->");
    */
    
    insertarValorEnTS(&tabla_simbolos, anio, SIMBOLO_INT);
    insertarValorEnTS(&tabla_simbolos, mes, SIMBOLO_INT);
    insertarValorEnTS(&tabla_simbolos, dia, SIMBOLO_INT);
    //insertarValorEnTS(&tabla_simbolos, "10000.0", SIMBOLO_REAL);
    //insertarValorEnTS(&tabla_simbolos, "100.0", SIMBOLO_REAL);

    insertarValorEnTS(&tabla_simbolos, "10000", SIMBOLO_INT);
    insertarValorEnTS(&tabla_simbolos, "100", SIMBOLO_INT);
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

void validarTipoDatoCoordenada(char* id)
{
    char* tipoDatoID;

    tipoDatoID = obtenerTipoDatoIDExistente(generarNombreIDTS(id));

    if(strcmp(tipoDatoID, TIPO_FLOAT) != 0 && strcmp(tipoDatoID, TIPO_INT) != 0)
    {
        printf("\nERROR: Se intento utilizar una variable %s como valor de coordenada\n", tipoDatoID);
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


/* Funciones de Assembler */

void generarAssembler()
{

    FILE* fAssembler = fopen("final.asm", "wt+");
    if(!fAssembler)
    {
        printf("\nError al abrir el archivo final.asm\n");
        exit(1);
    }

    FILE* fBodyAsm = fopen("final.temp", "wt+");
    if(!fBodyAsm)
    {
        printf("\nError al abrir el archivo final.temp\n");
        exit(1);
    }

    /* Acá guardo los operandos */

    crearPila(&pilaOperandos);

    /* Acá guardo los resultados parciales de los operandos: 2 + 1 */

    crearPila(&pilaAuxAsm);

   /* Duplico la tabla de símbolos para no modificar la original */
    
    crearLista(&tablaSimbolosDup);

    copiarTabla(&tabla_simbolos, &tablaSimbolosDup);

    /* Duplico la polaca ya que debo iterar la misma y realizar un preprocesamiento para que
     tanto la Tabla de Simbolos como la polaca "hablen el mismo idioma" con los mismos nombres 
     de variables. Además de modificar los nombres de los saltos y hacia donde van */

    copiarPolaca(&polaca,&polacaDup);
   
    /* transforma la polaca intermedia del compilador en una versión limpia con etiquetas (ET_x) y 
    nombres de símbolos válidos para poder traducirla directamente a código assembler.  */

    preprocesarPolaca(&polacaDup, &tablaSimbolosDup);

    /* escribo el cuerpo del assembler, la parte CODE: */
    generarCodeAssembler(fBodyAsm);
    //guardarYVaciarListaPolaca(&polacaDup, "PolacaDup.txt");

    /* escribo la cabecera del assembler: la parte DATA: */
    generarDataAssembler(fAssembler, &tablaSimbolosDup);

    mergeArchivos(fAssembler, fBodyAsm);

    //escribo el fin del assembler:
    fprintf(fAssembler, "\tMOV AX, 4C00h\n\tINT 21h\n");
    fprintf(fAssembler, "\n\nSTRLEN PROC NEAR\n\tmov bx, 0\nSTRL01:\n\tcmp BYTE PTR [SI+BX],'$'\n\tje STREND\n\tinc BX\n\tjmp STRL01\nSTREND:\n\tret\nSTRLEN ENDP\n");
	fprintf(fAssembler, "\nCOPIAR PROC NEAR\n\tcall STRLEN\n\tcmp bx,MAXTEXTSIZE\n\tjle COPIARSIZEOK\n\tmov bx,MAXTEXTSIZE\nCOPIARSIZEOK:\n\tmov cx,bx\n\tcld\n\trep movsb\n\tmov al,'$'\n\tmov BYTE PTR [DI],al\n\tret\nCOPIAR ENDP\n");
	fprintf(fAssembler, "\nEND START\n");

    printf("\n\nAssembler generado exitosamente\n\n");
    fclose(fAssembler);
}

void preprocesarPolaca(t_polaca* polaca, lista* listaTS)
{
    int celdaActual = 0, celdaSaltoInt;
    char buffer[100], celda[100], celdaSalto[100], celdaAnt[100];

    t_lexema actual;
    while(celdaActual != polaca->celdaActual) //iteramos para cambiar las celdas con valores (que no sean saltos) a sus respectivos nombres de la tabla de símbolos
    {
        strcpy(celda, obtenerValorEnPolaca(polaca, celdaActual));

        if (esCTEnumerica(celda))
        {
            //printf("\nSimbolo en polaca: %s", celda);
            buscarSimboloPorValor(listaTS, celda, &actual);
            //printf("\nSimbolo en tabla: %s", actual.nombre);
            
            if(celdaActual == 0 || !esSalto(celdaAnt))
            {
                insertarEnPosicion(polaca, celdaActual, actual.nombre); //OJO ACÁ, NO VALIDAMOS LOS EXTREMOS, PUEDE FALLAR!! revisar en caso de error
            }
        }
        else if(esCTEString(celda))
        {
            strcpy(buffer, celda);
            eliminarCaracteres(buffer, '"');
            buscarSimboloPorValor(listaTS, buffer, &actual);
            insertarEnPosicion(polaca, celdaActual, actual.nombre);
        }
        else if(esID(celda))
        {
            insertarEnPosicion(polaca, celdaActual, generarNombreIDTS(celda));
        }

        strcpy(celdaAnt, celda);
        celdaActual++;
    }
    

    celdaActual = 0;

    while(celdaActual != polaca->celdaActual) 
    { //iteramos para modificar las celdas de saltos por sus respectivas etiquetas
        //si la celda actual de la polaca es un salto, actualiza la celda del salto con un @ET_numCelda
        strcpy(celda, obtenerValorEnPolaca(polaca, celdaActual));

        if(esSalto(celda))
        {
            //actualiza act+1 con ET_[contenidoActual]
            strcpy(celdaSalto, obtenerValorEnPolaca(polaca, celdaActual+1));
            celdaSaltoInt = atoi(celdaSalto);

            sprintf(buffer, "ET_%d", celdaSaltoInt);
            insertarEnPosicion(polaca, celdaActual+1, buffer);

            //actualiza celda del salto con @ET_[celdaActual]: [contenidoActual]
            if(celdaSaltoInt < polaca->celdaActual)
            {
                strcpy(celda, obtenerValorEnPolaca(polaca, celdaSaltoInt));

                if(strstr(celda, "@ET_") == NULL)
                {
                    sprintf(buffer, "@ET_%d:%s", celdaSaltoInt, celda);
                    insertarEnPosicion(polaca, celdaSaltoInt, buffer);
                }
            }
            else
            {
                strcpy(celda, obtenerValorEnPolaca(polaca, (polaca->celdaActual)-1));

                if(strstr(celda, "@ET_") == NULL)
                {
                    sprintf(buffer, "@ET_%d:_FINAL_TAG", celdaSaltoInt);
                    insertarPolaca(polaca, buffer);
                }
            }
        }
    
        celdaActual++;
    }
}

int esCTEnumerica(char* celda) 
{
    int tamCelda = strlen(celda);
    if((celda[0] >= '0' && celda[0] <= '9') || ((celda[0] == '-' && tamCelda > 1) && celda[1] != '>'))
    {
        return 1;
    }

    return 0;
}

int esCTEString( char* celda)
{
    int tam = strlen(celda);
    return celda[0] == '"' && celda[tam-1] == '"';
}

int esID( char* celda)
{
    return celda[0] == '_';
}

void eliminarCaracteres(char* str, char c) 
{
    int i, j = 0;
    int len = strlen(str);

    for (i = 0; i < len; i++)
    {
        if (str[i] != c)
        {
            str[j++] = str[i];
        }
    }
    str[j] = '\0';
}

int esSalto(char* celda) 
{

    if(celda[0] == '"') //evita que casos con constantes strings como "a:BI" sean consideradas saltos
        return 0;
    

    char* celdaAux = strstr(celda, ":"); //si le celda donde cae un salto tenga a su vez otro salto
    if(celdaAux)
    {
        celdaAux++;
    } else {
        celdaAux = (char*)celda;
    }

    if (!strcmp(celdaAux, "BLE") || !strcmp(celdaAux, "BEQ") || !strcmp(celdaAux, "BNE") || !strcmp(celdaAux, "BGT") || !strcmp(celdaAux, "BLT") || !strcmp(celdaAux, "BGE") || !strcmp(celdaAux, "BI"))
    {
        return 1;
    }

    return 0;
}

void generarCodeAssembler(FILE* archASM)
{
    char celdaPolaca[100];
    while(sacarDePolaca(&polacaDup, celdaPolaca)) 
    {
        procesarCeldaPolaca(archASM, celdaPolaca);
    }
}


void procesarCeldaPolaca(FILE* fAssembler, char* celda) 
{
    /* debo verificar si la celda actual corresponde a una etiqueta pendiente de resolución.
   por un lado, puede tratarse del punto de origen del salto (ET_num), que se obtiene al procesar un salto
   incondicional o condicional (BIAssembler o comparacionAssembler);
   y por otro, puede ser el destino del salto (@ET_num:), es decir, la posición donde continúa la ejecución. */

    t_lexema lexemaActual;

    if(strncmp(celda, "@ET_", 4) == 0)
    {
        char* posPunto = strstr(celda, ":");

        char nombreTag[36];

        int cantACopiar = posPunto - celda;
        strncpy(nombreTag, celda+1, cantACopiar); 
        nombreTag[cantACopiar] = '\0';

        celda = posPunto+1;

        fprintf(fAssembler, "%s\n", nombreTag);
    }

    if (esOperando(celda)) 
    { 
        insertarEnPila(&pilaOperandos, celda);
        return;
    }

    char* operador = ObtenerOperador(celda);
    if (strcmp(operador, "") != 0)
    {
        ResOperacionMatAsm(fAssembler, operador); 
        return;
    }

    if(strcmp(celda, "->") == 0)
    {
        ResAsignacionAsm(fAssembler); 
        return;
    }

    if(strcmp(celda, "CMP") == 0)
    {
        RescCmpASM(fAssembler); 
        return;
    }
    
    if(strncmp(celda, "ET_", 3) == 0)
    {
        return;
    }

    if(strcmp(celda, "BI") == 0)
    {
        ResBIAsm(fAssembler);
    }

    if(strcmp(celda, "ESCRIBIR") == 0)
    {
        ResEscrituraAsm(fAssembler);
        return;
    }

    if(strcmp(celda, "LEER") == 0)
    {
        ResLecturaAsm(fAssembler);
        return;
    }
}

int esOperando(char* celda)
{
    return buscarSimbolo(&tabla_simbolos, celda) != FALSO;
}

char* ObtenerOperador(char* celda)
{
    char operador[2];
    if ( strcmp(celda, "+")==0 )
    {
       return "FADD";
    }
    if ( strcmp(celda, "-")==0 )
    {
        return "FSUB";
    }
    if ( strcmp(celda, "*")==0 )
    {
        return "FMUL";
    }
    if ( strcmp(celda, "/")==0 )
    {
        return "FDIV";
    }

    return "";
}

void ResOperacionMatAsm(FILE* fAssembler, char* operador)
{
    char* op1 = sacarDePila(&pilaOperandos);
    char* op2 = sacarDePila(&pilaOperandos);
    
    char* result = crearAuxiliar();

    char buff[100];

    sprintf(buff, "FLD %s\n\tFLD %s", op2, op1);

    fprintf(fAssembler, "\t%s\n\t%s\n\tFSTP %s\n", buff, operador, result);
    insertarEnPila(&pilaOperandos, result);
}

char* crearAuxiliar()
{
    static char aux[15];
    sprintf(aux, "@auxASM%d", auxActual++);
    insertarEnPila(&pilaAuxAsm, aux);
    return aux;
}

void ResAsignacionAsm(FILE* fAssembler)
{
    char buffer[100];
    char* variable = sacarDePila(&pilaOperandos);
    char* valor = sacarDePila(&pilaOperandos);

    char* tipoDatoVar = obtenerTipoDatoID(&tabla_simbolos, variable);

    if( strcmp(tipoDatoVar, "CONST_STR")==0 || strcmp(tipoDatoVar, TIPO_STRING)==0 )
		sprintf(buffer, "\tMOV SI, OFFSET %s\n\tMOV DI, OFFSET %s\n\tCALL COPIAR\n", valor, variable);
    else
        sprintf(buffer, "\tFLD %s\n\tFSTP %s\n", valor, variable);
    
    fprintf(fAssembler, "%s", buffer);
}

void RescCmpASM(FILE* fAssembler)
{
    char celda[100];
    char et[100];
    char* operador2 = sacarDePila(&pilaOperandos);
    char* operador1 = sacarDePila(&pilaOperandos);

    sacarDePolaca(&polacaDup, celda); 

    char* salto = ProcesarSalto(celda);

    sacarDePolaca(&polacaDup, et); 

    fprintf(fAssembler, "\tFLD %s\n\tFCOMP %s\n\tFSTSW ax\n\tSAHF\n\t%s %s\n", operador1, operador2, salto, et);
}

char* ProcesarSalto(char* celda)
{
    switch (celda[0]) 
    {
        case 'B':
            switch (celda[1]) 
            {
                case 'N':
                    if (celda[2] == 'E' && celda[3] == '\0') return "JNE";
                    break;
                case 'E':
                    if (celda[2] == 'Q' && celda[3] == '\0') return "JE";
                    break;
                case 'L':
                    if (celda[2] == 'E' && celda[3] == '\0') return "JBE";
                    if (celda[2] == 'T' && celda[3] == '\0') return "JB";
                    break;
                case 'G':
                    if (celda[2] == 'T' && celda[3] == '\0') return "JA";
                    if (celda[2] == 'E' && celda[3] == '\0') return "JAE";
                    break;
            }
    }

    return NULL;  // Retorna NULL si no coincide con ningún caso
}

void ResBIAsm(FILE* fAssembler)
{
    char et[100];
    sacarDePolaca(&polacaDup, et);
    fprintf(fAssembler, "\tJMP %s\n", et);
}

void ResEscrituraAsm(FILE* fAssembler)
{
    char buffer[100];
    char* variable = sacarDePila(&pilaOperandos);

    char* tipoDatoVar = obtenerTipoDatoID(&tabla_simbolos, variable);

    if(!tipoDatoVar)
    {
        //este caso sería cuando lo que se va a escribir no está en la TS sino que es un resultado de una operación intermedia
        fprintf(fAssembler, "\tDisplayFloat %s, 2\n\tnewLine\n", variable);
        return;
    }

    if( strcmp(tipoDatoVar, "CONST_STR")==0 || strcmp(tipoDatoVar, TIPO_STRING)==0 )
    {
        fprintf(fAssembler, "\tDisplayString %s\n\tnewLine\n", variable);
        return;
    }


    if( strcmp(tipoDatoVar, TIPO_INT)==0 || strcmp(tipoDatoVar, "CONST_INT") == 0)
    {
        fprintf(fAssembler, "\tDisplayFloat %s, 0\n\tnewLine\n", variable);
        return;
    }

    if( strcmp(tipoDatoVar, TIPO_FLOAT)==0 || strcmp(tipoDatoVar, "CONST_REAL") == 0)
    {
        fprintf(fAssembler, "\tDisplayFloat %s, 2\n\tnewLine\n", variable);
        return;
    }
}

void ResLecturaAsm(FILE* fAssembler)
{
    char* variable = sacarDePila(&pilaOperandos);

    char* tipoDatoVar = obtenerTipoDatoID(&tabla_simbolos, variable);

    if( strcmp(tipoDatoVar, TIPO_STRING)==0 )
    {
        fprintf(fAssembler, "\tgetString %s\n\tnewLine\n", variable);
        return;
    }

    if( strcmp(tipoDatoVar, TIPO_INT)==0 || strcmp(tipoDatoVar, TIPO_FLOAT)==0 )
    {
        fprintf(fAssembler, "\tGetFloat %s\n\tnewLine\n", variable);
        return;
    }
}

void generarDataAssembler(FILE* fAssembler, lista* listaTS){
    fprintf(fAssembler, "include macros2.asm\ninclude number.asm\n.MODEL LARGE\n.386\n.STACK 200h\n\nMAXTEXTSIZE equ 40\n\n.DATA\n");

    t_lexema lexActual;
    char tipo[3];
    char valor[256];
    char aux[100];
    char* punto;
    int tieneValor, esString, tam;

    while(sacarDeLista(listaTS, &lexActual)) {
        esString = (strcmp(lexActual.tipo, "CTE_STRING") == 0 || strcmp(lexActual.tipo, "string") == 0);
        tieneValor = strlen(lexActual.valor);
        tam = atoi(lexActual.longitud);

        if(esString){
            if(!tam){ 
                sprintf(valor, "MAXTEXTSIZE dup (?),'$'");
            } else {
                sprintf(valor, "\"%s\",'$', %s dup (?)", lexActual.valor, lexActual.longitud);
            }

            fprintf(fAssembler, "%s db %s\n", lexActual.nombre, valor);

            continue; //ya completé este lexema, paso al siguiente
        }

        //si no es cte string ni variable string:
        fprintf(fAssembler, "%s dd %s\n", lexActual.nombre, tieneValor ? lexActual.valor : "?");
    }

    while(!pilaVacia(&pilaAuxAsm)){
        strcpy(aux, sacarDePila(&pilaAuxAsm));
        fprintf(fAssembler, "%s dd ?\n", aux);
    }

    fprintf(fAssembler, "\n.CODE\n.startup\n\nSTART:\n\tMOV AX, @DATA\n\tMOV DS, AX\n\tMOV es,ax\n\n");
}

void mergeArchivos(FILE* fAssembler, FILE* fCodeAsm){
    
    fseek(fCodeAsm, 0, SEEK_SET);
    char* buffer = NULL;
    size_t tam = 0;
    while(!feof(fCodeAsm)){
        getline(&buffer, &tam, fCodeAsm);
        fprintf(fAssembler, "%s", buffer);
    }

    fclose(fCodeAsm);
    remove("final.temp"); 
}
