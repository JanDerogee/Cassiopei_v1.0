*=$0830 ;start address      ;by keeping the start adress close to the basic line, we keep the compiled program small. This because the "gap" between the basic line and the assembly code is filled with padding bytes.


;this example plays 4-bit samples at a rate of 10500Hz
;the samples are actually 8 bits of which only 4 bits can be used by the SID (which has 16 analog levels $D418)

;===============================================================================
;                              MAIN PROGRAM
;===============================================================================

INIT            JSR CPIO_INIT           ;initialize IO for use of CPIO protocol on the C64's cassetteport

;===============================================================================
;  !SPLAY       Sample play routine
;===============================================================================

CMD_SPLAY       JSR KOALA_START         ;start showing the koala picture
                
                LDA CPIO_PARAMETER      ;the mode we want to operate in   
                JSR CPIO_START          ;send this command so the connected device knows we now start working in this mode

                                        ;offset to start of sample (000000=play sample form the start)
                LDA #$00                ;position offset of the sample in bytes (MSB)
                JSR CPIO_SEND           ;
                LDA #$00                ;position offset of the sample in bytes (LSB)
                JSR CPIO_SEND           ;
                                
                                        ;sample duration in bytes (000000=play the sample to the end)
                LDA #$00                ;limit of the sample in bytes (MSB)
                JSR CPIO_SEND           ;
                LDA #$00                ;limit of the sample in bytes (LSB)
                JSR CPIO_SEND           ;

                LDA #$00                ;destination (0=CBM, 1=PWM, 2=CBM and PWM)
                JSR CPIO_SEND           ;

                LDA #"J"                ;first char of filename  "JAMES BROWN - I FEEL GOOD"
                JSR CPIO_SEND           ;
                LDA #"A"                ;second char of filename
                JSR CPIO_SEND           ;
                LDA #"M"                ;third char of filename
                JSR CPIO_SEND_LAST      ;(we don't care about the remaining part of the filename as there aren't any other files of this type and that start with these 3 characters)

                ;JSR CPIO_REC_LAST       ;when destination is 1 (PWM), the CBM does not have to do anything any more, just load the response byte and it's done
                ;JSR KOALA_STOP          ;stop showing the koala picture
                ;RTS                     ;

                LDA CPIO_PLAYSAMPLE     ;the mode we want to operate in   
                JSR CPIO_START          ;send this command so the connected device knows we now start working in this mode
                JSR CPIO_RECIEVE        ;the cassiopei responds with a 0=file-not-found, 1=file-found-starting-playback (although this is the last byte, we do not drop the ATTENTION line as we want to continue with the async protocol, which also uses the attention line)
                BEQ CMD_SPLAY_EXIT      ;0=file-not-found, so we exit!
        
                JSR PREPARE_SIDDAC      ;prepare sid for playing back digital sounds
                SEI                     ;disable interrupts
                JSR PLAYSAMPLE          ;playback the sample
                CLI                     ;enable interrupts

CMD_SPLAY_EXIT  JSR CPIO_INIT           ;by raising the attention signal we indicate that we no longer require data from the cassiopei
                JSR KOALA_STOP          ;stop showing the koala picture
                RTS


;-------------------------------------------------------------------------------

;===============================================================================
;this small routine will retrieve 4 bit sample from the Casiopei and converts them into audible sound
;using the SID's volume register. Which effectively is the easiest way to produce sound.
;===============================================================================
PREPARE_SIDDAC  LDA #$FF                ;we must boost the digi...
                STA $D406               ;
                LDA #$49                ;
                STA $D404               ;
                LDA #$FF                ;Setting more voices gives the digi a substantial extra boost:
                STA $D406               ;
                STA $D40D               ;
                STA $D414               ;
                LDA #$49                ;
                STA $D404               ;
                STA $D40B               ;
                STA $D412               ;
                RTS

;...............................................................................
;this routine will produce sound without disabling the screen
;by avoiding a the "bad lines" the samplerate cannot be affected

PLAYSAMPLE      LDA #%00000001          ;the bit pattern we are interested in
PLAY_LP0        BIT $D012               ;we wait for a line (that could be a bad line)
                BEQ PLAY_LP0            ;        

                LDA CPIO_DATA           ;
                STA BORDER              ;change color (very usefull for debugging)

                ;check the CPIO "READY" signal which indicates the end of sample
                LDA $DC0D               ;read CIA connected to the cassetteport (reading clears the state of the bits)
                AND #%00010000          ;mask out bit 4
                BEQ PLAY_LP1            ;loop until the slave lowers the read signal              
                RTS                     ;the ready signal has been activated by the cassiopei, this means that the sample has ended!!! Exit playing routine!!!

                ;check for user pressing space
PLAY_LP1        LDA $DC01               ;check keyboard inputs
                CMP #$EF                ;SPACE ?
                BNE PLAY_LP2            ;if not, keep polling
                RTS                     ;space pressed, Exit playing routine!!!


PLAY_LP2        LDA #%00000111          ;lower clock change state of write line to '0'
                STA DATA_BIT_6510       ;the cassiopei triggers on the falling edge before it starts to send the data of the sample, so making this signal is not time critical

                LDA #%00000001          ;the bit pattern we are interested in
PLAY_LP3        BIT $D012               ;we wait for a line that isn't for sure a bad line (and it stays an OK line as long as we don't touch the scroll-Y register)
                BNE PLAY_LP3            ;        

                LDA #%00001111          ;raise clock by changing state of write line to '1'
                STA DATA_BIT_6510       ;

                LDA #$00                ;clear the data register (the upper nibble MUST be all 0, because these are shifted into the Carry with every ROL instruction) 
                STA CPIO_DATA           ;

                CLC                     ;the Carry must be set to 0 because the ADC relies on the carry to be 0    
                LDA DATA_BIT_6510       ;the data is on the sense line of the cassette port we know the state of the other IO-lines (as we also control these during the clock/startdata pulse) 
                ADC #%11110000          ;when our input is a '1' it will cause the carry bit to be set
                ROL CPIO_DATA           ;shift all the bits one position to the right and add the LSB which is located in the carry

                                        ;CLC instruction is not needed here as we know that the carry is zero, due to the ROL instruction which shifted the MSB of CPIO_DATA into the carry
                LDA DATA_BIT_6510       ;
                ADC #%11110000          ;when our input is a '1' it will cause the carry bit to be set
                ROL CPIO_DATA           ;shift all the bits one position to the right and add the LSB which is located in the carry

                                        ;CLC instruction is not needed here as we know that the carry is zero, due to the ROL instruction which shifted the MSB of CPIO_DATA into the carry
                LDA DATA_BIT_6510       ;
                ADC #%11110000          ;when our input is a '1' it will cause the carry bit to be set
                ROL CPIO_DATA           ;shift all the bits one position to the right and add the LSB which is located in the carry

                                        ;CLC instruction is not needed here as we know that the carry is zero, due to the ROL instruction which shifted the MSB of CPIO_DATA into the carry
                LDA DATA_BIT_6510       ;
                ADC #%11110000          ;when our input is a '1' it will cause the carry bit to be set
                ROL CPIO_DATA           ;shift all the bits one position to the right and add the LSB which is located in the carry

                LDA CPIO_DATA           ;the sample we've just read from the Cassiopei, will now be send to the DAC (volume register of the SID)
                STA $D418               ;change volume of the SID to create the analog voltage level

                JMP PLAYSAMPLE          ;keep looping...


;------------------------------------------------------------------------------------

;The Commodore 64 version of Koala Painter used a fairly simple file format corresponding directly to the way bitmapped graphics are handled on the computer:
;   2 bytes load address                (this is the original memory address of the koala picture, it is irrelevant is most cases and may be discarded)
;8000 bytes of raw bitmap data
;1000 bytes of raw "Video Matrix" data
;1000 bytes of raw "Color RAM" data
;   1 byte Background Color field

PICTURE = $2000         ;we load our koala picture at address $.... the first two bytes of the koala file have to be discarded so we start directly with the bitmap data)
BITMAP  = PICTURE       ;bitmap starts without offset
VIDEO   = PICTURE+8000  ;video data is stored at an offset of $1F40 (8000 bytes)
COLOR   = PICTURE+9000  ;color data is stored at an offset of $2328 (8000 bytes + 1000 bytes)
BACKGND = PICTURE+10000 ;background color data is stored at an offset of $2710 (8000 bytes + 1000 bytes + 1000 bytes)


KOALAVIEWER
KOALA_START     lda #$00                ;
                sta $d020               ;Border Color
                lda BACKGND             ;get background color from picture data
                sta $d021               ;Screen Color

                ldx #$00                ;
TRANSFERDATA    lda VIDEO,x             ;Transfers video data
                sta $0400,x             ;
                lda VIDEO+$100,x        ;
                sta $0500,x             ;
                lda VIDEO+$200,x        ;
                sta $0600,x             ;
                lda VIDEO+$2e8,x        ;
                sta $06e8,x             ;
                lda COLOR,x             ;Transfers color data
                sta $d800,x             ;
                lda COLOR+$100,x        ;
                sta $d900,x             ;
                lda COLOR+$200,x        ;
                sta $da00,x             ;
                lda COLOR+$2e8,x        ;
                sta $dae8,x             ;
                inx                     ;
                bne TRANSFERDATA        ;

                lda #$3b                ;Bitmap Mode On
                sta $d011               ;
                lda #$d8                ;MultiColor On
                sta $d016               ;
                lda #$18                ;When bitmap adress is $2000, Screen at $0400 then the value of $d018 is $18
                sta $d018               ;

                RTS                     ;

;---------------------------------------

KOALA_STOP      lda #14                  ;
                sta $d020               ;Border Color
                lda #6                  ;
                sta $d021               ;Screen Color

                ldx #$00                ;
RESTORE_SCREEN  lda #14                 ;Transfer color data (the color of the characters that are typed or printed)
                sta $d800,x             ;
                sta $d900,x             ;
                sta $da00,x             ;
                sta $dae8,x             ;
                lda #$20                ;Transfer character (space)
                sta $0400,x             ;
                sta $0500,x             ;
                sta $0600,x             ;
                sta $06e8,x             ;
                inx                     ;
                bne RESTORE_SCREEN      ;

                ;set bitmap related registers back to default
                lda #$1B                ;Bitmap Mode Off, 25 rows, scroll pos to 011
                sta $d011               ;
                lda #$C8                ;MultiColor Off, 40 columns, scroll pos to 000
                sta $d016               ;
                lda #$15                ;When bitmap adresses ... bladiebla
                sta $d018

                RTS                     ;


;---------------------------------------


*=$2000
incbin "Cassiopei_sample.kla",2      ;skip the first 2 bytes of the koala file (this is the original load address, we can ignore this) the included file must be in the same dir as this assembly file
;incbin "DEFENDER.KOA",2         ;skip the first 2 bytes of the koala file (this is the original load address, we can ignore this) the included file must be in the same dir as this assembly file
;incbin  "CASSIOPE_LOGO.KLA",2


