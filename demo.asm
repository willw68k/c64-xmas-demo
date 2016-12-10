:BasicUpstart2(2500)

.const BORDER = $d020
.const BACKGROUND = $d021
.const SCREEN = $0400 + 173 // Mask the screen starting position where the text should start
.const COLORPOSITON = $d800 + 173 // Do the same for the relative color positions

.pc = 2500

// Color the canvas
lda #$00
sta BORDER 
lda #$00
sta BACKGROUND

sei

// jump to the screen clear
jsr clear

// ******* THIS ISR WAS RIPED FROM "SOMEWHERE", SORRY CAN'T REMEMBER WHERE ******

ldy #$7f    // $7f = %01111111
sty $dc0d   // Turn off CIAs Timer interrupts ($7f = %01111111)
sty $dd0d   // Turn off CIAs Timer interrupts ($7f = %01111111)
lda $dc0d   // by reading $dc0d and $dd0d we cancel all CIA-IRQs in queue/unprocessed
lda $dd0d   // by reading $dc0d and $dd0d we cancel all CIA-IRQs in queue/unprocessed

lda #$01    // Set Interrupt Request Mask...
sta $d01a   // ...we want IRQ by Rasterbeam (%00000001)

lda $d011   // Bit#0 of $d011 indicates if we have passed line 255 on the screen
and #$7f    // it is basically the 9th Bit for $d012
sta $d011   // we need to make sure it is set to zero for our intro.

lda #<irq   // point IRQ Vector to our custom irq routine
ldx #>irq 
sta $314    // store in $314/$315
stx $315   


lda #$01    // trigger first interrupt at row zero
sta $d01a

cli 
rts                 // clear interrupt disable flag

irq:        
	dec $d019        // acknowledge IRQ / clear register for next interrupt
	jsr loopH
	jmp $ea81        // return to kernel interrupt routine

clear:    
	lda #$20    // load emtpy space and copy it to screen locations below
	sta $0400,x  
	sta $0500,x 
	sta $0600,x 
	sta $06e8,x 
	sta $286 // Clear the cursor
	inx           
	bne clear     
	       
	rts

// **** Here we start the overly cumbersome animated letter writing, I'm sure I could have done a nested routine 
// and iterated the loops, but for the purpose of this demo, this works.

loopH:
	ldx delay // This count down adds a little speed throttle
	dex 
	stx delay
	bne H

	H:
		clc
		ldx counter // load the position we want to count from to the letters position
		cpx #$07 // Off set letter required by 1
		bne innerLoopH // Move into the letter animation rountine

		beq loopA // If we hit the letter, move onto the next letter in the message

		innerLoopH:
			dex
			lda #$ff // Start way out at the end of the CHAR range 
			adc counter
			sta SCREEN // And print the letter
			lda #$02 // Here is where we add the seasonly colors to these characters
			sta COLORPOSITON
			
			stx counter // Store the count down value, ready for next pass in the loop
		rts
	rts
rts

loopA:
	ldx delay
	dex 
	stx delay
	bne A

	A:
		clc
		ldx counter2
		cpx #$00 // Off set letter required by 1
		bne innerLoopA
		beq loopP1

		innerLoopA:
			dex
			lda #$ff
			adc counter2
			sta SCREEN + 1
			lda #$01
			sta COLORPOSITON + 1
			
			stx counter2
		rts
	rts
rts

loopP1:
	ldx delay
	dex 
	stx delay
	bne P1
	
	P1:
		clc
		ldx counter3
		cpx #$0f // Off set letter required by 1
		bne innerLoopP1

		beq loopP2

		innerLoopP1:
			dex
			lda #$ff
			adc counter3
			sta SCREEN + 2
			lda #$05
			sta COLORPOSITON + 2
			
			stx counter3
		rts
	rts
rts

loopP2:
	ldx delay
	dex 
	stx delay
	bne P2
	
	P2:
		clc
		ldx counter4
		cpx #$0f // Off set letter required by 1
		bne innerLoopP2

		beq loopY

		innerLoopP2:
			dex
			lda #$ff
			adc counter4
			sta SCREEN + 3
			lda #$02
			sta COLORPOSITON + 3
			
			stx counter4
		rts
	rts
rts

loopY:
	ldx delay
	dex 
	stx delay
	bne Y
	
	Y:
		clc
		ldx counter5
		cpx #$18 // Off set letter required by 1
		bne innerLoopY

		beq loopH2

		innerLoopY:
			dex
			lda #$ff
			adc counter5
			sta SCREEN + 4
			lda #$01
			sta COLORPOSITON + 4
			
			stx counter5
		rts
	rts
rts

loopH2:
	ldx delay
	dex 
	stx delay
	bne H2
	
	H2:
		clc
		ldx counter6
		cpx #$07 // Off set letter required by 1
		bne innerLoopH2

		beq loopO

		innerLoopH2:
			dex
			lda #$ff
			adc counter6
			sta SCREEN + 6
			lda #$05
			sta COLORPOSITON + 6
			
			stx counter6
		rts
	rts
rts

loopO:
ldx delay
	dex 
	stx delay
	bne O
	
	O:
		clc
		ldx counter7
		cpx #$0e // Off set letter required by 1
		bne innerLoopO

		beq loopL

		innerLoopO:
			dex
			lda #$ff
			adc counter7
			sta SCREEN + 7
			lda #$02
			sta COLORPOSITON + 7
			
			stx counter7
		rts
	rts
rts

loopL:
	ldx delay
	dex 
	stx delay
	bne L
	
	L:
		clc
		ldx counter8
		cpx #$0b // Off set letter required by 1
		bne innerLoopL

		beq loopI

		innerLoopL:
			dex
			lda #$ff
			adc counter8
			sta SCREEN + 8
			lda #$01
			sta COLORPOSITON + 8
			
			stx counter8
		rts
	rts
rts

loopI:
	ldx delay
	dex 
	stx delay
	bne I
	
	I:
		clc
		ldx counter9
		cpx #$08 // Off set letter required by 1
		bne innerLoopI

		beq loopD

		innerLoopI:
			dex
			lda #$ff
			adc counter9
			sta SCREEN + 9
			lda #$05
			sta COLORPOSITON + 9
			
			stx counter9
		rts
	rts
rts

loopD:
	ldx delay
	dex 
	stx delay
	bne D
	
	D:
		clc
		ldx counter10
		cpx #$03 // Off set letter required by 1
		bne innerLoopD

		beq loopA2

		innerLoopD:
			dex
			lda #$ff
			adc counter10
			sta SCREEN + 10
			lda #$02
			sta COLORPOSITON + 10
			
			stx counter10
		rts
	rts
rts

loopA2:
	ldx delay
	dex 
	stx delay
	bne A2
	
	A2:
		clc
		ldx counter11
		cpx #$00 // Off set letter required by 1
		bne innerLoopA2

		beq loopY2

		innerLoopA2:
			dex
			lda #$ff
			adc counter11
			sta SCREEN + 11
			lda #$01
			sta COLORPOSITON + 11
			
			stx counter11
		rts
	rts
rts

loopY2:
	ldx delay
	dex 
	stx delay
	bne Y2
	
	Y2:
		clc
		ldx counter12
		cpx #$18 // Off set letter required by 1
		bne innerLoopY2

		beq loopS

		innerLoopY2:
			dex
			lda #$ff
			adc counter12
			sta SCREEN + 12
			lda #$05
			sta COLORPOSITON + 12
			
			stx counter12
		rts
	rts
rts

loopS:
	ldx delay
	dex 
	stx delay
	bne S
	
	S:
		clc
		ldx counter13
		cpx #$12 // Off set letter required by 1
		bne innerLoopS

		beq stringText

		innerLoopS:
			dex
			lda #$ff
			adc counter13
			sta SCREEN + 13
			lda #$02
			sta COLORPOSITON + 13
			
			stx counter13
		rts
	rts
rts

// Once the Happy Holidays has animated in, let's print the sub message
stringText:
	ldx delay 
	strLoop: // Here we are using a loop to print the stored strings
		lda string1,x // This will index each char in the string
		sta SCREEN + 198,x // Add that char to a masked screen position
		lda #$01
		sta COLORPOSITON + 198,x // Add a color to the same position
		inx 
		stx delay
		cpx #$12 // Check if we reach the end of the end of the string
		bne strLoop // If not, move onto the next char
		beq stringText2 // If so, move onto the next stored line of text
rts

stringText2:
	ldx delay2 
	strLoop2: 
		lda string2,x 
		sta SCREEN + 231,x
		lda #$01
		sta COLORPOSITON + 231,x
		inx 
		stx delay2
		cpx #$1e
		bne strLoop2
		beq clearBottom
rts

// I've got some weird chars printing at the bottom of the screen, so I'll be all hacky about it and erase them ;)
clearBottom: 
	ldx #$01
	clearLoop:
		lda #$20
		sta SCREEN + 300,x
		inx
		cpx #$c8
		bne clearLoop
		beq colorCycle
rts

colorCycle: // Simple color cycling of alternating chars
	ldx delay2
	bne colorProcess

	colorProcess:
	
		ldx #$02
		stx COLORPOSITON
		stx COLORPOSITON + 2
		stx COLORPOSITON + 4
		stx COLORPOSITON + 7
		stx COLORPOSITON + 9
		stx COLORPOSITON + 11
		stx COLORPOSITON + 13
		ldx #$01
		stx COLORPOSITON
		stx COLORPOSITON + 2
		stx COLORPOSITON + 4
		stx COLORPOSITON + 7
		stx COLORPOSITON + 9
		stx COLORPOSITON + 11
		stx COLORPOSITON + 13
		ldx #$05
		stx COLORPOSITON
		stx COLORPOSITON + 2
		stx COLORPOSITON + 4
		stx COLORPOSITON + 7
		stx COLORPOSITON + 9
		stx COLORPOSITON + 11
		stx COLORPOSITON + 13
		dex 
	stx delay2

		
		jmp colorCycle

//	Reusable exit point
exit:
	rts

cyclePosition:
	.byte 1

delay:
	.byte 1

delay2:
	.byte 1

// Define character count down starting points for each letter in demo, this allows for position offset
counter:
	.byte 80

counter2:
	.byte 80

counter3:
	.byte 80

counter4:
	.byte 80

counter5:
	.byte 80

counter6:
	.byte 80

counter7:
	.byte 80

counter8:
	.byte 80

counter9:
	.byte 80

counter10:
	.byte 80

counter11:
	.byte 80

counter12:
	.byte 80

counter13:
	.byte 80

letterStore:
	.byte 1

string1:
	.text "and happy new year"
string2:
	.text " from countingvirtualsheep.com"

endCounter:
	.byte 80