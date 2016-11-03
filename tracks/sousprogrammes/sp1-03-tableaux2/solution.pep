; Simple Pep/8 program, prints the content of an array
main:    STRO    inmsg,d
         LDX     arr,i
         CALL    fillarr
         STRO    outmsg,d
         CHARO   '\n',i
         LDX     arr,i
         CALL    printarr
         STOP

; Fills an array with the input from stdin
; The array is supposed to be of length 5
;
; Parameters:
;	Register X: base address of the array
;
; Return:
;	void
fillarr: LDA     5,i
filllp:  DECI    0,x
         ADDX    2,i
         SUBA    1,i
         BRNE    filllp
fillout: RET0

; Prints an array given as parameter
; The array must contain integers only for the function to work
; The array is supposed to be of length 5
;
; Parameters:
;	Register X: Base address of the array
;
; Return:
;	void.
printarr:LDA     4,i
parrlp:  DECO    0,x
         CHARO   ',',i
         CHARO   ' ',i
         ADDX    2,i
         SUBA    1,i
         BRNE    parrlp
parrout: DECO    0,x
         RET0

; Message for the beginning of the program
inmsg:   .ASCII  "Please enter 5 numbers:\n\x00"
; Message for the end of the program
outmsg:  .ASCII  "Done.\x00"
; Reserved memory space for a int[5]
arr:     .BLOCK  10
         .END
