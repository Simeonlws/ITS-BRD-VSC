;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : mains.s
;* Author             : Simeon Lawson  
;* Version            : V1.0
;* Date               : 30.04.26
;* Description        : This is a simple main to demonstrate data transfer
;                     : and manipulation.
;                     : 
;
;*******************************************************************************
    EXTERN initITSboard ; Helper to organize the setup of the board

    EXPORT main         ; we need this for the linker - In this context it set the entry point,too

ConstByteA  EQU 0xaffe
    
;* We need some data to work on
    AREA DATA, DATA, align=2    
VariableA   DCW 0xbeef
VariableB   DCW 0x1234
VariableC   DCW 0xaffe    

;* We need minimal memory setup of InRootSection placed in Code Section 
    AREA  |.text|, CODE, READONLY, ALIGN = 3    
    ALIGN   
main
    BL initITSboard             ; needed by the board to setup
;* swap memory - Is there another, at least optimized approach?
    ldr     R0,=VariableA   ; Anw01 In das Register R0 wird die Adresse VariableA  geladen
    ldrb    R2,[R0]         ; Anw02 In das Register R2 wird wird das erste Byte aus der Adresse R0 geladen
    ldrb    R3,[R0,#1]      ; Anw03 In das Register R2 wird das Byte an zweiter stelle aus der Adresse R0 geladen
    lsl     R2, #8          ; Anw04 R2 Wird um 8 Bits nach links verschoben
    orr     R2, R3          ; Anw05 R2 und R3 werden zusammenngefügt
    strh    R2,[R0]         ; Anw06 R2 wird auf 16 bits gekürzt wieder zurück in die Adresse R0 gespeichert 
    
;* const in var
    ldr     R0,=VariableC
    mov     R5,#ConstByteA  ;Anw07
    lsl     R4, R5, #8.     ;Anw08
    lsr     R5, R5, #8.     ;Anw09
    orr     R5, R4, R5      ;Anw0A
    strh    R5,[R0]         ;Anw0B
    
;* Change value from x1234 to x4321
    ldr     R1,=VariableB   ;Anw0C
    mov     R6, #0x3412     ;Anw0D
    strh    R6, [R1]        ;Anw0E
    b .                     ;Anw0F
    
    ALIGN
    END