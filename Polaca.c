#include "Polaca.h"

void crearListaPolaca(t_polaca* polaca)
{
    polaca->lista = NULL;
    polaca->celdaActual = 0;
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

booleano insertarPolaca(t_polaca* polaca,char* valor)
{
    t_nodoPolaca* nuevo = crearNodoPolaca();

    if(!nuevo)
    {
        return FALSO;
    }

    t_nodoPolaca** pp = &polaca->lista;

    while(*pp)
    {
        pp = &(*pp)->siguiente;
    }

    strcpy(nuevo->valor,valor);
    
    nuevo->siguiente = NULL;
    *pp = nuevo;
    polaca->celdaActual++;

    return VERDADERO;
}


void avanzar(t_polaca* polaca)
{
    insertarPolaca(polaca,"");
}

booleano insertarEnPosicion(t_polaca* polaca,int posicion,char* valor)
{
    int i;

    t_nodoPolaca** pp = &polaca->lista;

    for(i = 0; i < posicion; i++)
    {
        pp = &(*pp)->siguiente;
    }

    strcpy((*pp)->valor,valor);
  

    return VERDADERO;

}

void vaciarListaPolaca(t_polaca* polaca)
{
    t_nodoPolaca* eliminado;
    while(polaca->lista)
    {
        eliminado = polaca->lista;
        polaca->lista = eliminado->siguiente;
        polaca->celdaActual--;
        free(eliminado);
    }
}

void guardarYVaciarListaPolaca(t_polaca* polaca, char* nombre_archivo)
{
    t_nodoPolaca* actual = polaca->lista;
    t_nodoPolaca* eliminado;

    FILE* archivo = fopen(nombre_archivo, "wt");

    if(!archivo || !actual)
    {
        printf("\nError al intentar guardar en la tabla de simbolos");
        return;
    }

    fprintf(archivo,"%s\n",actual->valor);
    eliminado = actual;
    actual = actual->siguiente;
    free(eliminado);
    polaca->celdaActual--;

    while(actual)
    {
        fprintf(archivo,"%s\n",actual->valor);
        eliminado = actual;
        actual = actual->siguiente;
        free(eliminado);
        polaca->celdaActual--;
    }

    polaca->lista = NULL;
    fclose(archivo);

}

void copiarPolaca(t_polaca *polacaOriginal, t_polaca *polacaDuplicada) {

    t_nodoPolaca *actualOriginal = polacaOriginal->lista;
    t_nodoPolaca *nuevoNodo, *ultimoNodoDuplicado = NULL;

    while (actualOriginal) {
        // Crear un nuevo nodo
        nuevoNodo = (t_nodoPolaca*)malloc(sizeof(t_nodoPolaca));
        if (!nuevoNodo) return; // Error de memoria

        strcpy(nuevoNodo->valor, actualOriginal->valor);
        nuevoNodo->siguiente = NULL;

        // Enlazar el nuevo nodo a la lista duplicada
        if (!polacaDuplicada->lista) {
            polacaDuplicada->lista = nuevoNodo;
        } else {
            ultimoNodoDuplicado->siguiente = nuevoNodo;
        }
        
        // Actualizar el último nodo en la lista duplicada
        ultimoNodoDuplicado = nuevoNodo;

        // Pasar al siguiente nodo en la lista original
        actualOriginal = actualOriginal->siguiente;
        polacaDuplicada->celdaActual++;
    }
    
    return;
}

char* obtenerValorEnPolaca(t_polaca *polaca, int numCelda) {
    if (numCelda < 0 || numCelda >= polaca->celdaActual) {
        return NULL; 
    }

    t_nodoPolaca *actual = polaca->lista;
    int i;

    
    for (i = 0; actual && i < numCelda; i++) 
    {
        actual = actual->siguiente;
    }

    if(actual)
    {
        return actual->valor;
    }
    
    return NULL; 
}