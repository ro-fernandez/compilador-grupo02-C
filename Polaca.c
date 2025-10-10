#include "Polaca.h"

void crearListaPolaca(listaPolaca* lista)
{
    *lista = NULL;
}

t_nodoPolaca* crearNodoPolaca()
{
    t_nodoPolaca* nodo;

    nodo = (t_nodoPolaca*) malloc(sizeof(t_nodoPolaca));

    if(!nodo)
    {
        return NULL;
    }

    return nodo;
}

booleano insertarPolaca(listaPolaca* lista,char* valor)
{
    t_nodoPolaca* nuevo = crearNodoPolaca();

    if(!nuevo)
    {
        return FALSO;
    }

    while(*lista)
    {
        lista = &(*lista)->siguiente;
    }

    strcpy(nuevo->valor,valor);
    
    nuevo->siguiente = NULL;
    *lista = nuevo;

    return VERDADERO;
}


void avanzar(listaPolaca* lista)
{
    insertarPolaca(lista,"");
}

booleano insertarEnPosicion(listaPolaca* lista,int posicion,char* valor)
{
    int i;

    for(i = 0; i < posicion; i++){
        lista = &(*lista)->siguiente;
    }

    strcpy((*lista)->valor,valor);
    

    return VERDADERO;

}

void vaciarListaPolaca(listaPolaca* lista)
{
    t_nodoPolaca* eliminado;
    while(*lista)
    {
        eliminado = *lista;
        *lista = eliminado->siguiente;
        free(eliminado);
    }
}

void guardarYVaciarListaPolaca(listaPolaca* lista, char* nombre_archivo)
{
    t_nodoPolaca* actual = *lista;
    t_nodoPolaca* eliminado;

    FILE* archivo = fopen(nombre_archivo, "wt");

    if(!archivo || !actual)
    {
        printf("\nError al intentar guardar en la tabla de simbolos");
        return;
    }

    while(actual)
    {
        fprintf(archivo,"%s|",actual->valor);
        eliminado = actual;
        actual = actual->siguiente;
        free(eliminado);
    }

    *lista = NULL;
    fclose(archivo);

}