#ifndef POLACA_H
#define POLACA_H

#include "Utilitarios.h"

typedef struct NodoPolaca
{
    char valor[TAM_MAX];
    struct NodoPolaca* siguiente;
} t_nodoPolaca;

typedef t_nodoPolaca* listaPolaca;

typedef struct {
    listaPolaca lista;
    int celdaActual;
} t_polaca;

void crearListaPolaca(t_polaca* polaca);

t_nodoPolaca* crearNodoPolaca();

booleano insertarPolaca(t_polaca* polaca,char* valor); 

booleano insertarEnPosicion(t_polaca* polaca,int posicion,char* valor);

void avanzar(t_polaca* polaca);

void vaciarListaPolaca(t_polaca* polaca);

void guardarYVaciarListaPolaca(t_polaca* polaca, char* nombre_archivo);

#endif /* POLACA_H */