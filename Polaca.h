#ifndef POLACA_H
#define POLACA_H

#include "Utilitarios.h"

#define TAM_MAX 200

typedef struct NodoPolaca
{
    char valor[TAM_MAX];
    struct NodoPolaca* siguiente;
} t_nodoPolaca;

typedef t_nodoPolaca* listaPolaca;

void crearListaPolaca(listaPolaca* lista);

t_nodoPolaca* crearNodoPolaca();

/* Se inserta al final */

booleano insertarPolaca(listaPolaca* lista,char* valor); 

booleano insertarEnPosicion(listaPolaca* lista,int posicion,char* valor);

void avanzar(listaPolaca* lista);

void vaciarListaPolaca(listaPolaca* lista);

void guardarYVaciarListaPolaca(listaPolaca* lista, char* nombre_archivo);

#endif /* POLACA_H */