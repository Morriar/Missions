        DECI    x,d
        DECI    y,d
        LDA     x,d
        LDX     y,d
        CALL    add
        STA     x,d
        DECO    x,d
        STOP

add: 	STX	tmp,d
        ADDA    tmp,d
        RET0

tmp:  	.WORD   0
x:      .WORD   0
y:      .WORD   0
        .END
