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
_Hola_mundo db "Hola mundo",'$', 10 dup (?)
_1 dd 1
_a db "a",'$', 1 dup (?)
_15_2 dd 15.2
_20_0 dd 20.0
_3_2 dd 3.2
_21_1 dd 21.1
_1000_10 dd 1000.10
_test db "test",'$', 4 dup (?)
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
_0_0 dd 0.0
_10_09_2025 db "10.09.2025",'$', 10 dup (?)
_2025 dd 2025
_9 dd 9
_10 dd 10
_10000 dd 10000
_100 dd 100
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
	MOV SI, OFFSET _Hola_mundo
	MOV DI, OFFSET __g3
	CALL COPIAR
	FLD _1
	FSTP __var1
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
	FCOMP _15_2
	FSTSW ax
	SAHF
	JA ET_51
	FLD _20_0
	FSTP __a1
ET_51:
	FLD _3_2
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
	JBE ET_76
ET_66:
	FLD __e1
	FLD _21_1
	FSUB
	FSTP @auxASM0
	FLD __d1
	FLD @auxASM0
	FMUL
	FSTP @auxASM1
	FLD @auxASM1
	FLD _1000_10
	FDIV
	FSTP @auxASM2
	FLD @auxASM2
	FSTP __c1
	JMP ET_53
ET_76:
	getString __prueba
	newLine
	DisplayString _test
	newLine
	DisplayFloat __d1, 2
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
	FSTP @auxASM3
	FLD @auxASM3
	FLD __x1
	FMUL
	FSTP @auxASM4
	FLD __y3
	FLD __y1
	FSUB
	FSTP @auxASM5
	FLD @auxASM5
	FLD __x2
	FMUL
	FSTP @auxASM6
	FLD @auxASM4
	FLD @auxASM6
	FADD
	FSTP @auxASM7
	FLD __y1
	FLD __y2
	FSUB
	FSTP @auxASM8
	FLD @auxASM8
	FLD __x3
	FMUL
	FSTP @auxASM9
	FLD @auxASM7
	FLD @auxASM9
	FADD
	FSTP @auxASM10
	FLD @auxASM10
	FLD _0_5
	FMUL
	FSTP @auxASM11
	FLD @auxASM11
	FSTP __a1
	FLD __y5
	FLD __y6
	FSUB
	FSTP @auxASM12
	FLD @auxASM12
	FLD __x4
	FMUL
	FSTP @auxASM13
	FLD __y6
	FLD __y4
	FSUB
	FSTP @auxASM14
	FLD @auxASM14
	FLD __x5
	FMUL
	FSTP @auxASM15
	FLD @auxASM13
	FLD @auxASM15
	FADD
	FSTP @auxASM16
	FLD __y4
	FLD __y5
	FSUB
	FSTP @auxASM17
	FLD @auxASM17
	FLD __x6
	FMUL
	FSTP @auxASM18
	FLD @auxASM16
	FLD @auxASM18
	FADD
	FSTP @auxASM19
	FLD @auxASM19
	FLD _0_5
	FMUL
	FSTP @auxASM20
	FLD @auxASM20
	FSTP __a2
	FLD __a1
	FCOMP _0
	FSTSW ax
	SAHF
	JNE ET_168
	JMP ET_190
ET_168:
	FLD __a2
	FCOMP _0
	FSTSW ax
	SAHF
	JNE ET_175
	JMP ET_190
ET_175:
	FLD __a1
	FCOMP __a2
	FSTSW ax
	SAHF
	JBE ET_185
	FLD __a1
	FSTP __mayor
	JMP ET_188
ET_185:
	FLD __a2
	FSTP __mayor
ET_188:
	FLD __mayor
	FSTP __a
ET_190:
	FLD _2025
	FLD _10000
	FMUL
	FSTP @auxASM21
	FLD _9
	FLD _100
	FMUL
	FSTP @auxASM22
	FLD @auxASM21
	FLD @auxASM22
	FADD
	FSTP @auxASM23
	FLD @auxASM23
	FLD _10
	FADD
	FSTP @auxASM24
	MOV SI, OFFSET @auxASM24
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
