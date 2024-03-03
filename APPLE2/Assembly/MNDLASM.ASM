ly = $0000
lx = $0001
cx = $0002
cy = $0003
zx = $0004
zy = $0005
tmp= $0006
i  = $0007
t  = $0008

sa1= $0009
b0 = $000A
a0 = $000B
sa = $000C
REM= $000D

yLoop:
	xLoop: 
		; calculation of cx
		lda lx
        sbc 0
        sta sa1
		CLC
		
		lda 0  ; 127
        sbc 255 ; -128
        sta b0
		CLC
		
		lda 255 ; screen width
        sbc 0  ; 0
        sta a0
		CLC
		
		; multiply
		LDA #0       ;Initialize RESULT to 0
        LDX #8       ;There are 8 bits in NUM2
L1:     LSR b0     ;Get low bit of NUM2
        BCC L2       ;0 or 1?
        CLC          ;If 1, add NUM1
        ADC sa1
L2:     ROR A        ;"Stairstep" shift (catching carry from add)
        ROR sa
        DEX
        BNE L1
        STA sa+1
		
		; division
		LDA #0      ;Initialize REM to 0
        STA REM
        STA REM+1
        LDX #16     ;There are 16 bits in NUM1
L3:     ASL sa    ;Shift hi bit of NUM1 into REM
        ROL sa+1  ;(vacating the lo bit, which will be used for the quotient)
        ROL REM
        ROL REM+1
        LDA REM
        SEC         ;Trial subtraction
        SBC a0
        TAY
        LDA REM+1
        SBC a0+1
        BCC L4      ;Did subtraction succeed?
        STA REM+1   ;If yes, save it
        STY REM
        INC sa    ;and record a 1 in the quotient
L4:     DEX
        BNE L3
		
		clc
		lda 0
		adc REM
		sta cx
		
		; calculation of cy
		lda ly
        sbc 0
        sta sa1
		CLC
		
		lda 255  ; 127
        sbc 0 ; -128
        sta b0
		CLC
		
		lda 255 ; screen width
        sbc 0  ; 0
        sta a0
		CLC
		
		; multiply
		LDA #0       ;Initialize RESULT to 0
        LDX #8       ;There are 8 bits in NUM2
L5:     LSR b0     ;Get low bit of NUM2
        BCC L6       ;0 or 1?
        CLC          ;If 1, add NUM1
        ADC sa1
L6:     ROR A        ;"Stairstep" shift (catching carry from add)
        ROR sa
        DEX
        BNE L5
        STA sa+1
		
		; division
		LDA #0      ;Initialize REM to 0
        STA REM
        STA REM+1
        LDX #16     ;There are 16 bits in NUM1
L7:     ASL sa    ;Shift hi bit of NUM1 into REM
        ROL sa+1  ;(vacating the lo bit, which will be used for the quotient)
        ROL REM
        ROL REM+1
        LDA REM
        SEC         ;Trial subtraction
        SBC a0
        TAY
        LDA REM+1
        SBC a0+1
        BCC L8      ;Did subtraction succeed?
        STA REM+1   ;If yes, save it
        STY REM
        INC sa    ;and record a 1 in the quotient
L8:     DEX
        BNE L7
		
		clc
		lda 0
		adc REM
		sta cy
		
		; zx = cx
		lda cx
		sta zx
		lda cy
		sta zy
		
		iter:
			lda zx
			sta tmp
		
		
		