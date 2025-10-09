#include "Pila.h"

void crearPila(Pila* pp)
{
    *pp = NULL;
}

booleano insertarEnPila(Pila* pp, const char* elem)
{
    Nodo* nue = (Nodo*)malloc(sizeof(Nodo));
    char* elemNodo = malloc(strlen(elem)+1);

    if(!nue || !elemNodo)
    {
        free(nue);
        free(elemNodo);
        return FALSO;
    }

    strcpy(elemNodo, elem);

    nue->elem = elemNodo;
    nue->sig = *pp;

    *pp = nue;

    return VERDADERO;
}

char* sacarDePila(Pila* pp)
{
    if(!*pp)
        return FALSO;

    Nodo* nae = *pp;

    char* elem = nae->elem;

    *pp = nae->sig;

    free(nae);

    return elem;
}

char* verTopeDePila(const Pila* pp)
{
    if(!*pp)
        return FALSO;

    Nodo* tope = *pp;

    char* elem = tope->elem;

    return elem;
}

booleano pilaVacia(const Pila* pp)
{
    return *pp == NULL;
}

void vaciarPila(Pila* pp)
{
    Nodo* nae = *pp;

    while(nae)
    {
        *pp = nae->sig;

        free(nae->elem);
        free(nae);

        nae = *pp;
    }
}
