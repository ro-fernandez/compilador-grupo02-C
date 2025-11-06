#ifndef PILA_H
#define PILA_H

#include "Utilitarios.h"

typedef struct sNodo
{
    char* elem;
    struct sNodo* sig;
} Nodo;

typedef Nodo* Pila;

void crearPila(Pila* pp);
booleano insertarEnPila(Pila* pp, const char* elem);
char* sacarDePila(Pila* pp);
void eliminarDePila(Pila* pp);
char* verTopeDePila(const Pila* pp);
booleano pilaVacia(const Pila* pp);
void vaciarPila(Pila* pp);

#endif /* PILA_H */