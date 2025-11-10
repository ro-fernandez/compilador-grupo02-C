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
__p1 db MAXTEXTSIZE dup (?),'$'
__p2 db MAXTEXTSIZE dup (?),'$'
__p3 db MAXTEXTSIZE dup (?),'$'
__d2 db MAXTEXTSIZE dup (?),'$'
__g3 db MAXTEXTSIZE dup (?),'$'
__prueba db MAXTEXTSIZE dup (?),'$'
__f1 db "",'$', 10 dup (?)
__f2 db "",'$', 10 dup (?)
__fecha db "",'$', 10 dup (?)
_12345 dd 12345
_3_1415 dd 3.1415
_cte_str1 db "Hola mundo",'$', 10 dup (?)
_1 dd 1
_30_0 dd 30.0
_cte_str2 db "Ingrese el valor de A",'$', 21 dup (?)
_cte_str3 db "Ingrese el valor de B",'$', 21 dup (?)
_cte_str4 db "Ingrese el valor de C",'$', 21 dup (?)
_cte_str5 db "A es mayor a B o C es mayor a B",'$', 31 dup (?)
_cte_str6 db "B es mayor o igual que A y C",'$', 28 dup (?)
_15_2 dd 15.2
_20_0 dd 20.0
_3_2 dd 3.2
_cte_str7 db "Los tres valores A B y C son iguales",'$', 36 dup (?)
_cte_str8 db "Los valores A B y C son distintos",'$', 33 dup (?)
_cte_str9 db "Este mensaje se muestra si NO A igual B",'$', 39 dup (?)
_cte_str10 db "Ingrese el valor para saludarlo N veces ",'$', 40 dup (?)
_0_0 dd 0.0
_cte_str11 db "HOLA!!!",'$', 7 dup (?)
_1_0 dd 1.0
_cte_str12 db "Aritmetica combinada",'$', 20 dup (?)
_1_2 dd 1.2
_10_10 dd 10.10
_0 dd 0
_4_0 dd 4.0
_12 dd 12
_2_5 dd 2.5
_3 dd 3
__y3 dd ?
__y2 dd ?
__y1 dd ?
__x3 dd ?
__x2 dd ?
__x1 dd ?
_6 dd 6
_2 dd 2
__y6 dd ?
__y5 dd ?
__y4 dd ?
__x6 dd ?
__x5 dd ?
__x4 dd ?
_0_5 dd 0.5
__mayor dd ?
_10_09_2025 db "10.09.2025",'$', 10 dup (?)
_2025 dd 2025
_9 dd 9
_10 dd 10
_10000 dd 10000
_100 dd 100
@auxASM25 dd ?
@auxASM24 dd ?
@auxASM23 dd ?
@auxASM22 dd ?
@auxASM21 dd ?
@auxASM20 dd ?
@auxASM19 dd ?
@auxASM18 dd ?
@auxASM17 dd ?
@auxASM16 dd ?
@auxASM15 dd ?
@auxASM14 dd ?
@auxASM13 dd ?
@auxASM12 dd ?
@auxASM11 dd ?
@auxASM10 dd ?
@auxASM9 dd ?
@auxASM8 dd ?
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

	FLD _12345
	FSTP __a2
	FLD _3_1415
	FSTP __d1
	MOV SI, OFFSET _cte_str1
	MOV DI, OFFSET __g3
	CALL COPIAR
	FLD _1
	FSTP __var1
	FLD _30_0
	FSTP __e1
	DisplayString _cte_str2
	newLine
	GetFloat __a1
	newLine
	DisplayString _cte_str3
	newLine
	GetFloat __b1
	newLine
	DisplayString _cte_str4
	newLine
	GetFloat __c1
	newLine
	FLD __a1
	FCOMP __b1
	FSTSW ax
	SAHF
	JBE ET_35
	JMP ET_40
ET_35:
	FLD __c1
	FCOMP __b1
	FSTSW ax
	SAHF
	JBE ET_44
ET_40:
	DisplayString _cte_str5
	newLine
	JMP ET_46
ET_44:
	DisplayString _cte_str6
	newLine
ET_46:
	FLD __a1
	FCOMP __b1
	FSTSW ax
	SAHF
	JBE ET_67
	FLD __c1
	FCOMP __b1
	FSTSW ax
	SAHF
	JAE ET_67
	FLD __b1
	FCOMP _15_2
	FSTSW ax
	SAHF
	JA ET_64
	FLD _20_0
	FSTP __a1
ET_64:
	FLD _3_2
	FSTP __a1
ET_67:
	FLD __a1
	FCOMP __b1
	FSTSW ax
	SAHF
	JNE ET_81
	FLD __b1
	FCOMP __c1
	FSTSW ax
	SAHF
	JNE ET_81
	DisplayString _cte_str7
	newLine
	JMP ET_83
ET_81:
	DisplayString _cte_str8
	newLine
ET_83:
	FLD __a1
	FCOMP __b1
	FSTSW ax
	SAHF
	JE ET_90
	DisplayString _cte_str9
	newLine
ET_90:
	DisplayString _cte_str10
	newLine
	GetFloat __a1
	newLine
ET_93:
	FLD __a1
	FCOMP _0_0
	FSTSW ax
	SAHF
	JBE ET_107
	DisplayString _cte_str11
	newLine
	FLD __a1
	FLD _1_0
	FSUB
	FSTP @auxASM0
	FLD @auxASM0
	FSTP __a1
	JMP ET_93
ET_107:
	DisplayString _cte_str12
	newLine
	FLD __e1
	FLD _1_2
	FSUB
	FSTP @auxASM1
	FLD __d1
	FLD @auxASM1
	FMUL
	FSTP @auxASM2
	FLD @auxASM2
	FLD _10_10
	FDIV
	FSTP @auxASM3
	DisplayFloat @auxASM3, 2
	newLine
	FLD _3
	FSTP __y3
	FLD _2_5
	FSTP __x3
	FLD _12
	FSTP __y2
	FLD _4_0
	FSTP __x2
	FLD __x
	FSTP __y1
	FLD _0
	FSTP __x1
	FLD _2
	FSTP __y6
	FLD __z
	FSTP __x6
	FLD _0
	FSTP __y5
	FLD _6
	FSTP __x5
	FLD _0
	FSTP __y4
	FLD __x
	FSTP __x4
	FLD __y2
	FLD __y3
	FSUB
	FSTP @auxASM4
	FLD @auxASM4
	FLD __x1
	FMUL
	FSTP @auxASM5
	FLD __y3
	FLD __y1
	FSUB
	FSTP @auxASM6
	FLD @auxASM6
	FLD __x2
	FMUL
	FSTP @auxASM7
	FLD @auxASM5
	FLD @auxASM7
	FADD
	FSTP @auxASM8
	FLD __y1
	FLD __y2
	FSUB
	FSTP @auxASM9
	FLD @auxASM9
	FLD __x3
	FMUL
	FSTP @auxASM10
	FLD @auxASM8
	FLD @auxASM10
	FADD
	FSTP @auxASM11
	FLD @auxASM11
	FLD _0_5
	FMUL
	FSTP @auxASM12
	FLD @auxASM12
	FSTP __a1
	FLD __y5
	FLD __y6
	FSUB
	FSTP @auxASM13
	FLD @auxASM13
	FLD __x4
	FMUL
	FSTP @auxASM14
	FLD __y6
	FLD __y4
	FSUB
	FSTP @auxASM15
	FLD @auxASM15
	FLD __x5
	FMUL
	FSTP @auxASM16
	FLD @auxASM14
	FLD @auxASM16
	FADD
	FSTP @auxASM17
	FLD __y4
	FLD __y5
	FSUB
	FSTP @auxASM18
	FLD @auxASM18
	FLD __x6
	FMUL
	FSTP @auxASM19
	FLD @auxASM17
	FLD @auxASM19
	FADD
	FSTP @auxASM20
	FLD @auxASM20
	FLD _0_5
	FMUL
	FSTP @auxASM21
	FLD @auxASM21
	FSTP __a2
	FLD __a1
	FCOMP _0
	FSTSW ax
	SAHF
	JNE ET_203
	JMP ET_225
ET_203:
	FLD __a2
	FCOMP _0
	FSTSW ax
	SAHF
	JNE ET_210
	JMP ET_225
ET_210:
	FLD __a1
	FCOMP __a2
	FSTSW ax
	SAHF
	JBE ET_220
	FLD __a1
	FSTP __mayor
	JMP ET_223
ET_220:
	FLD __a2
	FSTP __mayor
ET_223:
	FLD __mayor
	FSTP __a
ET_225:
	FLD _2025
	FLD _10000
	FMUL
	FSTP @auxASM22
	FLD _9
	FLD _100
	FMUL
	FSTP @auxASM23
	FLD @auxASM22
	FLD @auxASM23
	FADD
	FSTP @auxASM24
	FLD @auxASM24
	FLD _10
	FADD
	FSTP @auxASM25
	MOV SI, OFFSET @auxASM25
	MOV DI, OFFSET __fecha
	CALL COPIAR
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
