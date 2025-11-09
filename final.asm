include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h

MAXTEXTSIZE equ 40

.DATA
__a1 dd ?
__b1 dd ?
__c1 dd ?
__d1 dd ?
__e1 dd ?
__a dd ?
__var1 dd ?
__var2 dd ?
__x dd ?
__z dd ?
__a2 dd ?
__p1 dd ?
__p2 dd ?
__p3 dd ?
__d2 dd ?
__g3 dd ?
__f1 dd ?
__f2 dd ?
__fecha dd ?
_prueba \string\ en variable dd prueba \string\ en variable
_12345 dd 12345
_3.1415 dd 3.1415
_Hola mundo dd Hola mundo
_1 dd 1
_a dd a
_15.2 dd 15.2
_20.0 dd 20.0
_3.2 dd 3.2
_test dd test
_03.07.2025 dd 03.07.2025
_2025 dd 2025
_7 dd 7
_3 dd 3
_10000 dd 10000
_100 dd 100
_10.09.2025 dd 10.09.2025
_9 dd 9
_10 dd 10
@auxASM7 dd ?
@auxASM6 dd ?
@auxASM5 dd ?
@auxASM4 dd ?
@auxASM3 dd ?
@auxASM2 dd ?
@auxASM1 dd ?
@auxASM0 dd ?

.CODE
.startup

START:
	MOV AX, @DATA
	MOV DS, AX
	MOV es,ax

	MOV SI, OFFSET _prueba \string\ en variable
	MOV DI, OFFSET __d2
	CALL COPIAR
	FLD _12345
	FSTP __a2
	FLD _3.1415
	FSTP __d1
	MOV SI, OFFSET _Hola mundo
	MOV DI, OFFSET __g3
	CALL COPIAR
	FLD __a1
	FCOMP __b1
	FSTSW ax
	SAHF
	JBE ET_20
	JMP ET_25
ET_20:
	FLD __c1
	FCOMP __b1
	FSTSW ax
	SAHF
	JBE ET_30
ET_25:
	FLD _1
	FSTP __a2
	JMP ET_33
ET_30:
	MOV SI, OFFSET _a
	MOV DI, OFFSET __d2
	CALL COPIAR
ET_33:
	FLD __a1
	FCOMP __b1
	FSTSW ax
	SAHF
	JBE ET_54
	FLD __c1
	FCOMP __b1
	FSTSW ax
	SAHF
	JAE ET_54
	FLD __b1
	FCOMP _15.2
	FSTSW ax
	SAHF
	JA ET_51
	FLD _20.0
	FSTP __a1
ET_51:
	FLD _3.2
	FSTP __a1
ET_53:
ET_54:
	FLD __a1
	FCOMP __b1
	FSTSW ax
	SAHF
	JBE ET_61
	JMP ET_66
ET_61:
	FLD __c1
	FCOMP __b1
	FSTSW ax
	SAHF
	JBE ET_70
ET_66:
	FLD __d1
	FSTP __c1
	JMP ET_53
ET_70:
	GetFloat __a
	newLine
	DisplayString _test
	newLine
	FLD _2025
	FLD _10000
	FMUL
	FSTP @auxASM0
	FLD _7
	FLD _100
	FMUL
	FSTP @auxASM1
	FLD @auxASM0
	FLD @auxASM1
	FADD
	FSTP @auxASM2
	FLD @auxASM2
	FLD _3
	FADD
	FSTP @auxASM3
	FLD _2025
	FLD _10000
	FMUL
	FSTP @auxASM4
	FLD _9
	FLD _100
	FMUL
	FSTP @auxASM5
	FLD @auxASM4
	FLD @auxASM5
	FADD
	FSTP @auxASM6
	FLD @auxASM6
	FLD _10
	FADD
	FSTP @auxASM7
	FLD @auxASM7
	FSTP __fecha
	MOV AX, 4C00h
	INT 21h


STRLEN PROC NEAR
	mov bx, 0
STRL01:
	cmp BYTE PTR [SI+BX],'$'
	je STREND
	inc BX
	jmp STRL01
STREND:
	ret
STRLEN ENDP

COPIAR PROC NEAR
	call STRLEN
	cmp bx,MAXTEXTSIZE
	jle COPIARSIZEOK
	mov bx,MAXTEXTSIZE
COPIARSIZEOK:
	mov cx,bx
	cld
	rep movsb
	mov al,'$'
	mov BYTE PTR [DI],al
	ret
COPIAR ENDP

END START
