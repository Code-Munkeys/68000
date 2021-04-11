; ***************************************
; * Written by Franz Ayestaran 14/11/90 *

; A 68000 assembly routine that scrolls up and down a set of Red / Green / Blue / Grey
; gradient colour bars using the background colour register vertical beam position.

          ;*****************
          ;* SuperScroller *
          ;*****************

Cols:   ;  --- Red ---
        dc.w $0000,$0000        ; or no lower than 2b
        dc.w $0000,$0f00
        dc.w $0000,$0e00
        dc.w $0000,$0d00
        dc.w $0000,$0c00
        dc.w $0000,$0b00
        dc.w $0000,$0a00
        dc.w $0000,$0900
        dc.w $0000,$0800
        dc.w $0000,$0700
        dc.w $0000,$0600
        dc.w $0000,$0500
        dc.w $0000,$0400
        dc.w $0000,$0300
        dc.w $0000,$0200
        dc.w $0000,$0100
        dc.w $0000,$0100

       
        ; --- Green ---
        dc.w $0000,$00f0
        dc.w $0000,$00e0
        dc.w $0000,$00d0
        dc.w $0000,$00c0
        dc.w $0000,$00b0
        dc.w $0000,$00a0
        dc.w $0000,$0090
        dc.w $0000,$0080
        dc.w $0000,$0070
        dc.w $0000,$0060
        dc.w $0000,$0050
        dc.w $0000,$0040
        dc.w $0000,$0030
        dc.w $0000,$0020
        dc.w $0000,$0010
        dc.w $0000,$0010
        

        ; --- Blue ---
        dc.w $0000,$000f
        dc.w $0000,$000e
        dc.w $0000,$000d
        dc.w $0000,$000c
        dc.w $0000,$000b
        dc.w $0000,$000a
        dc.w $0000,$0009
        dc.w $0000,$0008
        dc.w $0000,$0007
        dc.w $0000,$0006
        dc.w $0000,$0005
        dc.w $0000,$0004
        dc.w $0000,$0003
        dc.w $0000,$0002
        dc.w $0000,$0001
        dc.w $0000,$0000
  

        ; --- Grey ---
        dc.w $0000,$0fff
        dc.w $0000,$0eee
        dc.w $0000,$0ddd
        dc.w $0000,$0ccc
        dc.w $0000,$0bbb
        dc.w $0000,$0aaa
        dc.w $0000,$0999
        dc.w $0000,$0888
        dc.w $0000,$0777
        dc.w $0000,$0666
        dc.w $0000,$0555
        dc.w $0000,$0444
        dc.w $0000,$0333
        dc.w $0000,$0222
        dc.w $0000,$0111
        dc.w $0000,$0000

Program:
        lea     $def006,a0      ; beam position.w (8 vbits)
        lea     $def004,a1      ; beam position.l (9 vbits)
        lea     $def180,a2      ; background color register
        lea     $def182,a4
        clr.l d4

AnimateDown:
        add.w #$03,d4   ; Speed
        cmp.w #$90,d4
        beq AnimateUp
        bsr DrawStripes
        cmp.b #$37,$bfec01
        beq Done
        jmp AnimateDown


AnimateUp:
        sub.w #$03,d4   ; Speed 
        cmp.w #$00,d4
        beq Program
        bsr DrawStripes
        cmp.b #$37,$bfec01
        beq Done
        jmp AnimateUp 
        
DrawStripes:
        clr.w   d0              ; reset stripes-counter
        lea     Cols,a3         ; reser color table
        clr.l d3
Loop2:  clr.l d1                ; all zeros
        add.w  (a3)+,d1         ; vpos for next color
        clr.l d1
        add.w  #$2b,d1          ; start of lines
        add.w  d3,d1            ; next line
        add.w  d4,d1            ; next line for animation
        asl.l  #8,d1            ; shift left 8 bits
Wait:   move.l  (a1),d2         ; beam position
        and.l   #$0001ff00,d2   ; only vertival position is needed
        cmp.l   d1,d2           ; desired line ?
        bne     Wait            ; not yet

        move.w  (a3)+,(a2)      ; set background color
       ;move.w  #00,(a4)        ; set foreground color
        addq    #1,d0           ; inc counter
        add.w   #$01,d3         ; line width
        cmp.w   #65,d0          ; stripes ?
        bne     Loop2           ; next stripe
Done:   rts                     ; exit this program

