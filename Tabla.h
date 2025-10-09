#ifndef TABLA_H
#define TABLA_H

#include "Utilitarios.h"

#define TAM_MAX 200

typedef enum
{
    SIMBOLO_ID,
    SIMBOLO_INT,
    SIMBOLO_REAL,
    SIMBOLO_STRING,
    SIMBOLO_FECHA
} TipoSimbolo;

typedef struct
{
    char nombre[TAM_MAX];
    char tipo[TAM_MAX];
    char valor[TAM_MAX];
    char longitud [TAM_MAX];

} t_lexema;

typedef struct Nodo
{
    t_lexema lex;
    struct Nodo* siguiente;
} t_nodo;

typedef t_nodo* lista;

void crearLista(lista* lista);

t_nodo* crearNodo();

/* Se inserta al final */

booleano insertarSimbolo(lista* lista, t_lexema lex);

booleano insertarSimboloSinDuplicados(lista* lista, t_lexema lex);    

booleano buscarSimbolo(lista* lista, char* lexBuscado); 

t_nodo* obtenerSimbolo(lista* lista, char* lexBuscado); 

void mostrarTabla(lista* lista);

void vaciarLista(lista* lista);

void guardarYVaciarLista(lista* lista, char* nombre_archivo);

void copiarLexema(t_lexema* destino, t_lexema origen);

#endif /* TABLA_H */