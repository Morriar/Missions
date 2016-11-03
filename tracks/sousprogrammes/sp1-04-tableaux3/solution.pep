; Simple Pep/8 program, prints the content of an array
main:    DECI    size,d
         STRO    inmsg1,d
         DECO   size, d
         STRO    inmsg2, d
         LDA     size, d
         LDX     arr,i
         CALL    fillarr
         STRO    outmsg,d
         CHARO   '\n',i
         LDA     size, d
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
fillarr: NOP0         ; 5 means 0 to 4
filllp:  DECI    0,x
         ADDX    2,i
         SUBA    1,i
         BRNE    filllp
fillout: RET0

; Prints an array given as parameter
; The array must contain integers only for the function to work
;
; Parameters:
;	Register X: Base address of the array
;
; Return:
;	void.
printarr:SUBA 1,i
         CPA 0, i
         BREQ parrout
printlp: DECO    0,x
         CHARO   ',',i
         CHARO   ' ',i
         ADDX    2,i
         SUBA    1,i
         BRNE    printlp
parrout: DECO    0,x
         RET0

; Message for the beginning of the program
inmsg1:   .ASCII  "Please enter \x00"
inmsg2:  .ASCII " numbers:\n\x00"
; Message for the end of the program
outmsg:  .ASCII  "Done.\x00"
; /dev/null
devnull: .WORD 0
; Array size
size:    .WORD 0
; Reserved memory space for a int[100] (max allowed)
arr:     .BLOCK  20
         .END
