;************************************************
;* Beginn der globalen Daten *
;************************************************
                   AREA MyData, DATA, align = 2
Base
VariableA          DCW 0x1234
VariableB          DCW 0x4711

VariableC          DCD  0

MeinHalbwortFeld   DCW 0x22 , 0x3e , -52, 78 , 0x27 , 0x45

MeinWortFeld       DCD 0x12345678 , 0x9dca5986
                   DCD -872415232 , 1308622848
                   DCD 0x27000000
                   DCD 0x45000000

MeinTextFeld       DCB "ABab0123",0

                   EXPORT VariableA
                   EXPORT VariableB
                   EXPORT VariableC
                   EXPORT MeinHalbwortFeld
                   EXPORT MeinWortFeld
                   EXPORT MeinTextFeld

;***********************************************
;* Beginn des Programms *
;************************************************
    AREA |.text|, CODE, READONLY, ALIGN = 3
; ----- S t a r t des Hauptprogramms -----
                EXPORT main
                EXTERN initITSboard
main            PROC
                bl    initITSboard                 ; HW Initialisieren

; Laden von Konstanten in Register
                mov   r0,#0x12                      ; Anw-01 Kopiert #0x12 ins Register r0
                mov   r1,#-128                      ; Anw-02 Kopiert #-128 als Zweierkomplement in r1
                ldr   r2,=0x12345678                ; Anw-03 Kopiert den Wert aus dem Speicher in das Register r2

; Zugriff auf Variable
                ldr   r0,=VariableA                 ; Anw-04 Lädt die Adresse von VariableA in das r0
                ldrh  r1,[r0]                       ; Anw-05 Geht zur Adresse, die in r0 steht und holt das 16 Bit Halfword
                ldr   r2,[r0]                       ; Anw-06 Kopiert die Adresse die in r0 steht in r2
                str   r2,[r0,#VariableC-VariableA]  ; Anw-07 Speichert den Inhalt aus r2 zurück in den Speicher

; Zugriff auf Felder (Speicherzellen)
                ldr   r0,=MeinHalbwortFeld          ; Anw-08 Lädt die Adresse von MeinHalbwortFeld in das r0
                ldrh  r1,[r0]                       ; Anw-09 Lädt die Adresse die in r0 steht in r1 als Halfword
                ldrh  r2,[r0,#2]                    ; Anw-10 Geht zur Adresse in r0, springt zwei Bytes weiter und lädt das Halbwort
                mov   r3,#10                        ; Anw-11 Kopiert die Dezimazahl #10 in das Register r3
                ldrh  r4,[r0,r3]                    ; Anw-12 Geht zur Adresse die in r0 steht, springt 10 bytes 

                ldrh  r5,[r0,#2]!                   ; Anw-13 Lädt die Adresse aus r0 springt 2 Bytes weiter. speichert diesen Wert neu und in r5 ABab0123
                ldrh  r6,[r0,#2]!                   ; Anw-14 Springt zwei weiter in der Adresse die in r0 steht und speichert sie in r6
                strh  r6,[r0,#2]!                   ; Anw-15 Speichert den Wert der in r6 steht auf den Platz von 78

; Addition und Subtraktion von unsigned / signed Integer-Werten
                ldr  r0,=MeinWortFeld               ; Anw-16 Lädt die Adresse aus MeinWortFeld in das Register r0
                ldr  r1,[r0]                        ; Anw-17 Lädt die Adresse aus r0 in das Register r1
                ldr  r2,[r0,#4]                     ; Anw-18 Lädt die Adresse aus r0 mit einem Offset von 4 in das r2
                adds r3,r1,r2                       ; Anw-19 Nimmt den Wert aus r1 und r2 und Addiert ihn zusammen

                ldr  r4,[r0,#8]                     ; Anw-20 Lädt die Adresse aus r0 mit 8 Offset in das r4
                ldr  r5,[r0,#12]                    ; Anw-21 Lädt die Adresse aus r0 mit 12 Offset in das r5

                ldr  r7,[r0,#16]                    ; Anw-23 Lädt die Adresse aus r0 mit 16 Offset in das r7
                ldr  r8,[r0,#20]                    ; Anw-24 Lädt die Adresse aus r0 mit 20 Offset in das r8
                subs r9,r7,r8                       ; Anw-25 Subtrahiert r7 mit r8 und trägt den Wert in r9 ein

forever         b   forever                         ; Anw-26
                ENDP
                END