#include "Tabla.h"

void crearLista(lista* lista)
{
    *lista = NULL;
}

t_nodo* crearNodo()
{
    t_nodo* nodo;

    nodo = (t_nodo*) malloc(sizeof(t_nodo));

    if(!nodo)
    {
        return NULL;
    }

    return nodo;
}

void copiarLexema(t_lexema* destino, t_lexema origen)
{
    strcpy(destino->nombre, origen.nombre);
    strcpy(destino->tipo, origen.tipo);
    strcpy(destino->valor, origen.valor);
    strcpy(destino->longitud, origen.longitud);
}

int insertarSimbolo(lista* lista, t_lexema lex)
{
    t_nodo* nuevo = crearNodo();

    if(!nuevo)
    {
        return 0;
    }

    while(*lista)
    {
        lista = &(*lista)->siguiente;
    }

    copiarLexema(&(nuevo->lex), lex);

    nuevo->siguiente = NULL;
    *lista = nuevo;

    return 1;
}

int insertarSimboloSinDuplicados(lista* lista, t_lexema lex)
{
    t_nodo* nuevo = crearNodo();

    if(!nuevo)
    {
        return 0;
    }

    while(*lista && strcmp((*lista)->lex.nombre, lex.nombre) != 0)
    {
        lista = &(*lista)->siguiente;
    }

    copiarLexema(&(nuevo->lex), lex);

    nuevo->siguiente = NULL;
    *lista = nuevo;

    return 1;
}

int buscarSimbolo(lista* lista, char* lexBuscado)
{
    while(*lista && strcmp((*lista)->lex.nombre, lexBuscado) != 0)
    {
        lista = &(*lista)->siguiente;
    }

    if(!lista)
    {
        return 0;
    }

    return 1;
}

t_nodo* obtenerSimbolo(lista* lista, char* lexBuscado)
{
    while(*lista && strcmp((*lista)->lex.nombre, lexBuscado) != 0)
    {
        lista = &(*lista)->siguiente;
    }

    if(!lista)
    {
        return NULL;
    }

    return lista;
}

void mostrarTabla(lista* lista)
{
    t_nodo* actual = *lista;

    if (!actual)
    {
        printf("La tabla está vacía.\n");
        return;
    }

    printf("\n%-20s %-20s %-20s %-20s\n", "NOMBRE", "TIPO", "VALOR", "LONGITUD");
    printf("--------------------------------------------------------------------------------\n");

    while (actual)
    {
        printf("%-20s %-20s %-20s %-20s\n",
               actual->lex.nombre,
               actual->lex.tipo,
               actual->lex.valor,
               actual->lex.longitud);

        actual = actual->siguiente;
    }
}

void vaciarLista(lista* lista)
{
    t_nodo* eliminado;
    while(*lista)
    {
        eliminado = *lista;
        *lista = eliminado->siguiente;
        free(eliminado);
    }
}