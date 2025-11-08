#ifndef GENERACIONASM_H
#define GENERACIONASM_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Tabla.h"
#include "Pila.h"
#include "Polaca.h"

void preprocesarPolaca(t_polaca* polaca, lista* listaTS);
int esCTEnumerica(char* celda);
int esCTEString(char* celda);
int esID( char* celda);
void eliminarCaracteres(char* str, char c);
int esSalto(char* celda);
void generarCuerpoAssembler(FILE* archASM);
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

#endif /* GENERACIONASM_H */