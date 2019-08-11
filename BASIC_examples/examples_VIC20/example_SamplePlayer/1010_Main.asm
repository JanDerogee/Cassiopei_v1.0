
*=$1010 ;start address      ;by keeping the start adress close to the basic line, we keep the compiled program small. This because the "gap" between the basic line and the assembly code is filled with padding bytes.

;this example plays 4-bit samples at a rate of 10500Hz
;the samples are actually 8 bits of which only 4 bits can be used by the VIC20's audio chip (which has 16 analog levels at $900E)

;===============================================================================
;                              MAIN PROGRAM
;===============================================================================

INIT            JSR CPIO_INIT           ;initialize IO for use of CPIO protocol on the C64's cassetteport

                LDA #$01                ;1=white
                STA COL_PRINT           ;set printing color
                LDX #0                  ;build the screen
                LDY #0                  ;
                JSR SET_CURSOR          ;
                LDA #<SCREEN_MENU       ;set pointer to the text that defines the main-screen
                LDY #>SCREEN_MENU       ;
                JSR PRINT_STRING        ;the print routine is called, so the pointed text is now printed to screen   

MAIN            LDA #$08                ;define background and border color
                STA $900F               ;
               

                ;beware: keyboard matrix of the VIC20 is not the same as on the C64!!
SCAN_KEYPRESS   LDA $C5                 ;matrix value of last Key pressed; No Key = $40.
                CMP #$00                ;$00 = 1
                BEQ KEY_1               ;
                CMP #$38                ;$38 = 2
                BEQ KEY_2               ;
                CMP #$01                ;$01 = 3
                BEQ KEY_3               ;
                CMP #$39                ;$39= 4
                BEQ KEY_4              ;
                CMP #$02                ;$02= 5
                BEQ KEY_5              ;


;                JSR PRINT_HEX           ;the print routine is called
;                LDX #0                  ;
;                LDY #0                  ;
;                JSR SET_CURSOR          ;
                JMP SCAN_KEYPRESS       ;when the pressed key has no function then continue the key scanning

                ;JMP DAC_TEST   ;generates 1.064KHz triangle, a very usefull test waveform

KEY_1           LDA CPIO_PARAMETER      ;the mode we want to operate in   
                JSR CPIO_START          ;send this command so the connected device knows we now start working in this mode
                LDA #<FILENAME_1        ;set pointer to the text that defines the main-screen
                LDY #>FILENAME_1        ;
                JSR SEND_COMMAND        ;send the command string as defined in the table pointed to in Accu and Y-register
                JSR CMD_SPLAY           ;
                JMP MAIN                ;return to main loop

KEY_2           LDA CPIO_PARAMETER      ;the mode we want to operate in   
                JSR CPIO_START          ;send this command so the connected device knows we now start working in this mode
                LDA #<FILENAME_2        ;set pointer to the text that defines the main-screen
                LDY #>FILENAME_2        ;
                JSR SEND_COMMAND        ;send the command string as defined in the table pointed to in Accu and Y-register
                JSR CMD_SPLAY           ;
                JMP MAIN                ;return to main loop

KEY_3           LDA CPIO_PARAMETER      ;the mode we want to operate in   
                JSR CPIO_START          ;send this command so the connected device knows we now start working in this mode
                LDA #<FILENAME_3        ;set pointer to the text that defines the main-screen
                LDY #>FILENAME_3        ;
                JSR SEND_COMMAND        ;send the command string as defined in the table pointed to in Accu and Y-register
                JSR CMD_SPLAY           ;
                JMP MAIN                ;return to main loop
 
KEY_4           LDA CPIO_PARAMETER      ;the mode we want to operate in   
                JSR CPIO_START          ;send this command so the connected device knows we now start working in this mode
                LDA #<FILENAME_4        ;set pointer to the text that defines the main-screen
                LDY #>FILENAME_4        ;
                JSR SEND_COMMAND        ;send the command string as defined in the table pointed to in Accu and Y-register
                JSR CMD_SPLAY           ;
                JMP MAIN                ;return to main loop

KEY_5           LDA CPIO_PARAMETER      ;the mode we want to operate in   
                JSR CPIO_START          ;send this command so the connected device knows we now start working in this mode
                LDA #<FILENAME_5        ;set pointer to the text that defines the main-screen
                LDY #>FILENAME_5        ;
                JSR SEND_COMMAND        ;send the command string as defined in the table pointed to in Accu and Y-register
                JSR CMD_SPLAY           ;
                JMP MAIN                ;return to main loop

FILENAME_1      BYTE $00,$00            ;high byte, low byte of position offset*256 of the sample in bytes (MSB)
                BYTE $00,$00            ;high byte, low byte of limit*256 of the sample in bytes
                BYTE $02                ;destination (0=CBM (requires ample playing routines), 1=PWM (CBM may continue with other tasks), 2=CBM and PWM (requires sample playing routines)
                BYTE "01"               ;the filename must be in upper case
                BYTE 0                  ;end of table marker

FILENAME_2      BYTE $00,$00            ;high byte, low byte of position offset*256 of the sample in bytes (MSB)
                BYTE $00,$00            ;high byte, low byte of limit*256 of the sample in bytes
                BYTE $02                ;destination (0=CBM (requires ample playing routines), 1=PWM (CBM may continue with other tasks), 2=CBM and PWM (requires sample playing routines)
                BYTE "02"               ;the filename must be in upper case
                BYTE 0                  ;end of table marker

FILENAME_3      BYTE $00,$00            ;high byte, low byte of position offset*256 of the sample in bytes (MSB)
                BYTE $00,$00            ;high byte, low byte of limit*256 of the sample in bytes
                BYTE $02                ;destination (0=CBM (requires ample playing routines), 1=PWM (CBM may continue with other tasks), 2=CBM and PWM (requires sample playing routines)
                BYTE "03"               ;the filename must be in upper case
                BYTE 0                  ;end of table marker

FILENAME_4      BYTE $00,$00            ;high byte, low byte of position offset*256 of the sample in bytes (MSB)
                BYTE $00,$00            ;high byte, low byte of limit*256 of the sample in bytes
                BYTE $02                ;destination (0=CBM (requires ample playing routines), 1=PWM (CBM may continue with other tasks), 2=CBM and PWM (requires sample playing routines)
                BYTE "04"               ;the filename must be in upper case
                BYTE 0                  ;end of table marker

FILENAME_5      BYTE $00,$00            ;high byte, low byte of position offset*256 of the sample in bytes (MSB)
                BYTE $00,$00            ;high byte, low byte of limit*256 of the sample in bytes
                BYTE $02                ;destination (0=CBM (requires ample playing routines), 1=PWM (CBM may continue with other tasks), 2=CBM and PWM (requires sample playing routines)
                BYTE "05"               ;the filename must be in upper case
                BYTE 0                  ;end of table marker

;===============================================================================
;       Sample play routine
;===============================================================================

CMD_SPLAY       ;the actual playback of the sample, let the sound begin
                LDA CPIO_PLAYSAMPLE     ;the mode we want to operate in   
                JSR CPIO_START          ;send this command so the connected device knows we now start working in this mode
                JSR CPIO_RECIEVE        ;the cassiopei responds with a 0=file-not-found, 1=file-found-starting-playback (although this is the last byte, we do not drop the ATTENTION line as we want to continue with the async protocol, which also uses the attention line)
                BEQ CMD_SPLAY_EXIT      ;0=file-not-found, so we exit!
        
                SEI                     ;disable interrupts
                JSR PLAYSAMPLE          ;playback the sample
                CLI                     ;enable interrupts

CMD_SPLAY_EXIT  JSR CPIO_INIT           ;by raising the attention signal we indicate that we no longer require data from the cassiopei
                RTS


;-------------------------------------------------------------------------------

;...............................................................................
;this routine will produce sound without disabling the screen
;it's code originates from a C64, where there were bad lines. A vic20 doe snot has that problem
;but to keep the timing similar, we just play a sample on every even line (resulting in approx 8KHz sample rate)

PLAYSAMPLE      LDA #%10000000          ;the bit pattern we are interested in
PLAY_LP0        BIT $9003               ;we wait for a line
                BEQ PLAY_LP0            ;        

                LDA CPIO_DATA           ;
                AND #$07                ;use only the 3 lowest bits, if we use the 4th bit, then the screen itself would have bars which would be very disturbing to watch        
                STA $900F               ;define background and border color

                ;check the CPIO "READY" signal which indicates the end of sample
                LDA $912D               ;get the interrupt flags of 6522(B1)
                AND #%00000010          ;mask out bit CA1
                BEQ PLAY_LP1            ;loop until the slave lowers the read signal              
                LDA $9121               ;reading port A of the 6522 clears the int flags
                RTS                     ;the ready signal has been activated by the cassiopei, this means that the sample has ended!!! Exit playing routine!!!

                ;check for user pressing space
PLAY_LP1        LDA #$EF
                STA $9120
                LDA $9121
                CMP #$FE                ;SPACE ?
                BNE PLAY_LP2            ;if not, keep polling
                RTS                     ;space pressed, Exit playing routine!!!


PLAY_LP2              ;lower clock change state of write line to '0'
                      ;the cassiopei triggers on the falling edge before it starts to send the data of the sample, so making this signal is not time critical

                LDA $9120           ;data register of 6522(B1)
                AND #%11110111      ;make clock line low              
                STA $9120           ;


                LDA #%10000000          ;the bit pattern we are interested in
PLAY_LP3        BIT $9003               ;we wait for a line
                BNE PLAY_LP3            ;        

                LDA $9120           ;
                ORA #%00001000      ;make clock line high
                STA $9120           ;

                LDA #$00            ;clear the data register (the upper nibble MUST be all 0, because these are shifted into the Carry with every ROL instruction) 
                STA CPIO_DATA       ;

                CLC                     ;the Carry must be set to 0 because the ADC relies on the carry to be 0    
                LDA $911F           ;read data line
                ADC #%11000001      ;when our input is a '1' it will cause the carry bit to be set
                ROL CPIO_DATA       ;shift all the bits one position to the right and add the LSB which is located in the carry

                LDA $911F           ;read data line
                ADC #%11000001      ;when our input is a '1' it will cause the carry bit to be set
                ROL CPIO_DATA       ;shift all the bits one position to the right and add the LSB which is located in the carry

                LDA $911F           ;read data line
                ADC #%11000001      ;when our input is a '1' it will cause the carry bit to be set
                ROL CPIO_DATA       ;shift all the bits one position to the right and add the LSB which is located in the carry

                LDA $911F           ;read data line
                ADC #%11000001      ;when our input is a '1' it will cause the carry bit to be set
                ROL CPIO_DATA       ;shift all the bits one position to the right and add the LSB which is located in the carry

                LDA CPIO_DATA           ;the sample we've just read from the Cassiopei, will now be send to the DAC (volume register of the SID)
                STA $900E               ;Volume of VIC-20's sound chip(bit 0-3 vol)
        
                JMP PLAYSAMPLE          ;keep looping...


;=================================================================================
; This routine will send a string to the Cassiopei
; call example:
; -------------
;
;   LDA #<FILENAME_1        ;set pointer to the text that defines the main-screen
;   LDY #>FILENAME_1        ;
;   JSR SEND_STRING         ;sends a string to the cassiopei
;
; Table example:
; --------------
;
;   BYTE $00,$00            ;high byte, low byte of position offset*256 of the sample in bytes (MSB)
;   BYTE $00,$00            ;high byte, low byte of limit*256 of the sample in bytes
;   BYTE $00                ;destination (0=CBM (requires ample playing routines), 1=PWM (CBM may continue with other tasks), 2=CBM and PWM (requires sample playing routines)
;   BYTE "THE"              ;the filename must be in upper case
;   BYTE 0                  ;end of table marker
;
;---------------------------------------------------------------------------------
                
SEND_COMMAND    STA STR_ADDR            ;
                STY STR_ADDR+1          ;
                LDA #$05                ;a counter which we use to keep track of the first 5 bytes, those could be 0 and are not an end-of-table marker
                STA CNTR                ;

SEND_STR_01     LDY #$00                ;
                LDA CNTR                ;when the counter isn't zero we send the data directly to the Cassiopei
                BEQ SEND_STR_03         ;but if the counter is zero then we must look for the value 0, because this is the end-of-table marker
                DEC CNTR                ;
                LDA (STR_ADDR),Y        ;read character from string
                JMP SEND_STR_04         ;

SEND_STR_03     LDA (STR_ADDR),Y        ;read character from string
                BEQ SEND_STR_END        ;when the character was 0, then the end of string marker was detected and we must exit

SEND_STR_04     JSR CPIO_SEND           ;send char to Cassiopei
                                     
                CLC                     ;
                LDA #$01                ;add 1
                ADC STR_ADDR            ;
                STA STR_ADDR            ;string address pointer
                LDA #$00                ;
                ADC STR_ADDR+1          ;add carry...
                STA STR_ADDR+1          ;                            

                JMP SEND_STR_01         ;repeat...

SEND_STR_END    JSR CPIO_SEND_LAST      ;send last (end-of_string) char to Cassiopei
                RTS                     ;


;===============================================================================
;       DACtest generates a triangle waveform of 1.064KHz
;       This routine is usefull to verify the functionality of the volume
;       register. The AV-connector on the back of the VIC20 should output a
;       triangle of approximatly 100mv top-top.
;       This signal is also available (unfiltered and much smaller) on pin 19
;       of the audio-video chip.
;       This routine learned me that one of my VIC20's had a bad AV-chip <damn>
;===============================================================================

DAC_TEST        SEI             ;disable interrupts        
DAC_TEST_00     LDX #$00        ;
DAC_TEST_01     STX $900E       ;Volume of VIC-20's sound chip(bit 0-3 vol)                        
                PHA             ;waste cycles, to get the frequency of the generated signal
                PLA             ;to the required frequency of 1.064KHz
                PHA             ;
                PLA             ;
                PHA             ;
                PLA             ;
                INX             ;
                CPX #$10        ;
                BNE DAC_TEST_01 ;

                DEX             ;
DAC_TEST_02     STX $900E       ;Volume of VIC-20's sound chip(bit 0-3 vol)        
                PHA             ;
                PLA             ;
                PHA             ;
                PLA             ;
                PHA             ;
                PLA             ;
                DEX             ;
                CPX #$FF        ;
                BNE DAC_TEST_02 ;

                JMP DAC_TEST_00 ;        


;///////////////////////////////////////////////////////////////////////////////
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;
;            C P I O   r o u t i n  e s   ( f o r   t h e   V I C - 2 0 )
;
;///////////////////////////////////////////////////////////////////////////////
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

;let op: omdat de write lijn van de cassettepoort aan de keyboard matrix vastzit
;moeten we er rekening mee houden dat CPIO en keyboard niet samen gaan
;dus interrupts uit ofzo

;               ;lower ATTENTION-line (this signal is inverted therefore we need to write a '1' into the reg.)
;               LDA $911C               ;Attention signal = NO ATTENTION
;               ORA #%00001110          ;CA2 high (motor=OFF)
;               STA $911C               ;

;               ;raise ATTENTION-line (this signal is inverted therefore we need to write a '0' into the reg.)
;               LDA $911C               ;Attention signal = ATTENTION
;               ORA #%00001100          ;define IO CA to proper mode
;               AND #%11111101          ;CA2 low (motor=ON)
;               STA $911C               ;


;*******************************************************************************
; Cassette Port Input Output protocol initialisation
;******************************************************************************* 
CPIO_INIT       ;lower ATTENTION-line (cassette motor line)
                LDA $911C               ;peripheral control register of 6522(B3)
                ORA #%00001110          ;CA2 high (motor=OFF) Attention signal = NO ATTENTION
                STA $911C               ;

                ;raise CLOCK-line (cassette write-line)
                LDA $9122               ;data direction register of 6522(B1)
                ORA #%00001000          ;define PB3 as an output (make the DDR bit high)
                STA $9122               ;

                LDA $9120               ;data register of 6522(B1)
                ORA #%00001000          ;make PB3 high
                STA $9120               ;

                ;raise DATA-line (cassette button sense-line)
                LDA $911B               ;Auxilary control register of 6522(B3)
                AND #%11111110          ;clear bit 0 to disable latch on port A
                STA $911B               ;this setting is required further on in the code when we will use this pin as an INPUT

                LDA $9113               ;data direction register of 6522(B3)
                ORA #%01000000          ;define PA6 as an output
                STA $9113               ;

                LDA $911F               ;data register of 6522(B3)
                ORA #%01000000          ;make PA6 high
                STA $911F               ;


                ;set the READ-line properties (CA1 interrupt settings to falling edge)
                                        ;Peripheral control register of 6522(B1), we need to trigger on falling edges
                LDA        #$DE         ;CB2 low, serial data out high, CB1 +ve edge, CA2 high, serial clock out low, CA1 -ve edge
                STA        $912C        ;set VIA 2 PCR

                LDA        #$82         ;enable CA1 interrupt
                STA        $912E        ;set VIA 2 IER, enable interrupts

                RTS                     ;return to caller

;*******************************************************************************
; JSR CPIO_WAIT4RDY     ;wait untill the slave signals that it is ready
;
        ;this routine just keeps polling the 6522(B1)

CPIO_WAIT4RDY   LDA $912D               ;get the interrupt flags of 6522(B1)
                AND #%00000010          ;mask out bit CA1
                BEQ CPIO_WAIT4RDY       ;keep looping until the flag is set
                
                LDA $9121               ;reading port A of the 6522 clears the int flags
                RTS                     ;return to caller


;*******************************************************************************
;LDA <data>     ;data is the requested operating mode of the slave
;JSR CPIO_START  ;raise attention signal, now communication is set up, we can read or write data from this point
CPIO_START      STA CPIO_DATA       ;store value in A (which holds the mode-byte) to working register

                SEI                 ;disable interrupts
  ;--this is a C64 line--;   LDA $DC0D           ;reading clears all flags, so when we do a Read here we clear the old interrupts so that our routines will trigger on the correct event (instead of an old unhandled event)
               
                LDA $911C           ;Attention signal = ATTENTION
                ORA #%00001100      ;define IO CA to proper mode
                AND #%11111101      ;CA2 low (motor=ON)
                STA $911C           ;

                JMP SEND_DATA       ;send the mode byte to the slave


;*******************************************************************************
;this routine will lower the attention to indicate that the current is the last byte
CPIO_SEND_LAST  STA CPIO_DATA       ;safe the data (stored in the accu) to a working register
                LDA $911C           ;Attention signal = NO ATTENTION
                ORA #%00001110      ;CA2 high (motor=OFF)
                STA $911C           ;with the attention signal being low (motor-off) the slave has been notified that communication has come to an end and that the current byte is the last byte within this session
                JMP SEND_DATA       ;transmit the byte
;...............................................................................
;this routine will send a byte to the slave
;LDA <data>
;JSR CPIO_SEND

CPIO_SEND       STA CPIO_DATA       ;safe the data (stored in the accu) to a working register
SEND_DATA       LDY #$08            ;every byte consists of 8 bits, this will be use in the CPIO_send and CPIO_recieve routine which are calling this routine

                LDA $9113           ;data direction register of 6522(B3)
                ORA #%01000000      ;define PA6 (data line) as an output
                STA $9113           ;

                JSR CPIO_WAIT4RDY   ;wait untill the slave signals that it is ready
                
SEND_DATA_LP
SEND_CLOCK_0    LDA $9120           ;data register of 6522(B1)
                AND #%11110111      ;make clock line low              
                STA $9120           ;

                BIT CPIO_DATA       ;bit moves bit-7 of CPIO_DATA into the N-flag of the status register
                BPL SEND_ZERO       ;BPL tests the N-flag, when it is 0 the branch to SEND_ZERO is executed (using the BIT instruction instead of conventional masking, we save 2 cycles, and 2 bytes)
SEND_ONE        LDA $911F           ;data register of 6522(B3)
                ORA #%01000000      ;make PA6 high
                JMP SEND_BIT        ;
SEND_ZERO       LDA $911F           ;data register of 6522(B3)
                AND #%10111111      ;make PA6 low

SEND_BIT        STA $911F           ;
SEND_CLOCK_1    LDA $9120           ;data register of 6522(B1)
                ORA #%00001000      ;make clock line high
                STA $9120           ;

                ASL CPIO_DATA       ;rotate data in order to send each individual bit, we do it here so that we save time, we have to wait for the clock pulse high-time anyway

                DEY                 ;decrement the Y value
                BNE SEND_DATA_LP    ;exit loop after the eight bit

                LDA $9120           ;data register of 6522(B1)
                AND #%11110111      ;make clock line low, the slave now reads the last bit of the data
                STA $9120           ;
                ORA #%00001000      ;make clock line high, to indicate that the byte has come to an end
                STA $9120           ;

                LDA $9113           ;data direction register of 6522(B3)
                AND #%10111111      ;define PA6 (data line) as an input
                STA $9113           ;

                RTS                 ;end of subroutine

;*******************************************************************************
;this routine will lower the attention to indicate that the current is the last byte
CPIO_REC_LAST   LDA $911C           ;Attention signal = NO ATTENTION
                ORA #%00001110      ;CA2 high (motor=OFF)
                STA $911C           ;with the attention signal being low (motor-off) the slave has been notified that communication has come to an end and that the current byte is the last byte within this session
;...............................................................................

;this routine will recieve a byte to the slave
;JSR CPIO_RECIEVE
;data is in Accu

CPIO_RECIEVE    LDY #$08            ;every byte consists of 8 bits, this will be use in the CPIO_send and CPIO_recieve routine which are calling this routine

                JSR CPIO_WAIT4RDY   ;wait untill the slave signals that it is ready

REC_DATA_LP
REC_CLOCK_0     LDA $9120           ;data register of 6522(B1)
                AND #%11110111      ;make clock line low, the slave now prepares the data to be send
                STA $9120           ;

                CLC                 ;clear the carry, which is usefull for the ADC later, we clear it here in order to make the clock=0 time 2 cycles longer (keeps our clock duty cycle closer to 50% (which is allways nice))
REC_CLOCK_1     LDA $9120           ;
                ORA #%00001000      ;make clock line high
                STA $9120           ;

                LDA $911F           ;read data line
                AND #%01000000      ;test input signal for '0' or '1'
                ADC #%11111111      ;when our input is a '1' it will cause the carry bit to be set
                ROL CPIO_DATA       ;shift all the bits one position to the right and add the LSB which is located in the carry

                DEY                 ;decrement the Y value
                BNE REC_DATA_LP     ;exit loop after the eight bit

                LDA $9120           ;data register of 6522(B1)
                AND #%11110111      ;make clock line low, the slave now prepares the data to be send
                STA $9120           ;(this indicates to the slave that the master has read the data)
                ORA #%00001000      ;make clock line high to return to the default state
                STA $9120           ;
                
                LDA CPIO_DATA       ;move data to accu
                RTS                 ;end of subroutine
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

;-------------------------------------------------------------------------------
; use this routine before calling a PRINT related routine
;                        LDX CURSOR_Y;.. chars from the top of the defined screen area
;                        LDY CURSOR_X;.. chars from the left of the defined screen area
;   JSR SET_CURSOR
;-------------------------------------------------------------------------------
;CHARSCREEN = $0400 (default char screen loc.) is the first visible char location within this program 
;the first location is defined as coordinate 0,0 (which makes life so much easier)

SET_CURSOR      LDA #<CHARSCREEN        ;
                STA CHAR_ADDR           ;store base address (low byte)
                LDA #>CHARSCREEN        ;
                STA CHAR_ADDR+1         ;store base address (high byte)

                LDA #<COLORSCREEN       ;
                STA COLOR_ADDR          ;store base address (low byte)
                LDA #>COLORSCREEN       ;
                STA COLOR_ADDR+1        ;store base address (high byte)

                ;calculate exact value based on the requested X and Y coordinate
                CLC                     ;
                TXA                     ;add  value in X register (to calculate the new X position of cursor)
                ADC CHAR_ADDR           ;                        
                STA CHAR_ADDR           ;
                LDA #$00                ;
                ADC CHAR_ADDR+1         ;add carry
                STA CHAR_ADDR+1         ;

                CLC                     ;
                TXA                     ;add  value in X register (to calculate the new X position of cursorcolor)
                ADC COLOR_ADDR          ;                        
                STA COLOR_ADDR          ;
                LDA #$00                ;
                ADC COLOR_ADDR+1        ;add carry
                STA COLOR_ADDR+1        ;

                TYA                     ;save Y for next calc
                PHA                     ;
SET_CURS_CHR_LP CPY #00                 ;
                BEQ SET_CURS_COL        ;when Y is zero, calculation is done

                CLC                     ;
                LDA #CHARSPERLINE       ;add  ... (which is the number of characters per line) to calculate the new Y position of cursor
                ADC CHAR_ADDR           ;                        
                STA CHAR_ADDR           ;
                LDA #$00                ;
                ADC CHAR_ADDR+1         ;add carry... and viola, we have a new cursor position (memory location where next character will be printed)
                STA CHAR_ADDR+1         ;
                DEY                     ;
                JMP SET_CURS_CHR_LP     ;


SET_CURS_COL    PLA                     ;
                TAY                     ;restore Y for calc
SET_CURS_COL_LP CPY #00                 ;
                BEQ SET_CURS_END        ;when Y is zero calculation is done

                CLC                     ;
                LDA #CHARSPERLINE       ;add  ... (which is the number of characters per line) to calculate the new Y position of cursor
                ADC COLOR_ADDR          ;                        
                STA COLOR_ADDR          ;
                LDA #$00                ;
                ADC COLOR_ADDR+1        ;add carry... and viola, we have a new cursor position (memory location where next character will be printed)
                STA COLOR_ADDR+1        ;
                DEY                     ;
                JMP SET_CURS_COL_LP     ;
SET_CURS_END    RTS                     ;
  

;-------------------------------------------------------------------------------
;call this routine as described below:
;
;               LDA #character          ;character is stored in Accumulator
;               JSR PRINT_CHAR          ;character is printed to screen, cursor is incremented by one
; also affects Y
; note: when the character value is 0 there is nothing printed but we do increment the cursor by one
;-------------------------------------------------------------------------------
PRINT_CHAR      BEQ PRINT_NOTHING       ;when the value = 0, we print nothing but we do increment the cursor by one
                LDY #00                 ;
                STA (CHAR_ADDR),Y       ;character read from string (stored in A) is now written to screen memory (see C64 manual appendix E for screen display codes)
                LDA COL_PRINT           ;
                STA (COLOR_ADDR),Y      ;write colorvalue to the corresponding color memory location

                ;increment character pointer
PRINT_NOTHING   CLC                     ;
                LDA #$01                ;add 1
                ADC CHAR_ADDR           ;                        
                STA CHAR_ADDR           ;
                LDA #$00                ;
                ADC CHAR_ADDR+1         ;add carry... and viola, we have a new cursor position (memory location where next character will be printed)
                STA CHAR_ADDR+1         ;

                ;also increment color memory pointer
                CLC                     ;
                LDA #$01                ;add 1
                ADC COLOR_ADDR          ;                        
                STA COLOR_ADDR          ;
                LDA #$00                ;
                ADC COLOR_ADDR+1        ;add carry... and viola, we have a new cursor position (memory location where next character will be printed)
                STA COLOR_ADDR+1        ;

                RTS                     ;      
              
;-------------------------------------------------------------------------------
;call this routine as described below:
;
;        LDA #<label                ;set pointer to the text that defines the main-screen
;        LDY #>label                ;
;        JSR PRINT_STRING        ;the print routine is called, so the pointed text is now printed to screen
;
; JSR PRINT_CUR_STR ;print the string as indicated by the current string pointer
;-------------------------------------------------------------------------------
PRINT_STRING    STA STR_ADDR            ;
                STY STR_ADDR+1          ;
PRINT_CUR_STR   LDY #$00                ;
                LDA (STR_ADDR),Y        ;read character from string
                BEQ PR_STR_END          ;when the character was 0, then the end of string marker was detected and we must exit
                JSR PRINT_CHAR          ;print char to screen
                                     
                CLC                     ;
                LDA #$01                ;add 1
                ADC STR_ADDR            ;
                STA STR_ADDR            ;string address pointer
                LDA #$00                ;
                ADC STR_ADDR+1          ;add carry...
                STA STR_ADDR+1          ;                            

                JMP PRINT_CUR_STR       ;repeat...

PR_STR_END      RTS                     ;


;-------------------------------------------------------------------------------
; this routine will print the value in A as a 2 digit hexadecimal value
;        LDA #value                      ;A-register must contain value to be printed
;        JSR PRINT_HEX     ;the print routine is called
;-------------------------------------------------------------------------------
PRINT_HEX       PHA                     ;save A to stack
                AND #$F0                ;mask out low nibble
                LSR A                   ;shift to the right
                LSR A                   ;
                LSR A                   ;
                LSR A                   ;
                TAX                     ;
                LDA HEXTABLE,X          ;convert using table                                 
                JSR PRINT_CHAR          ;print character to screen

                PLA                     ;retrieve A from stack
                AND #$0F                ;mask out high nibble
                TAX                     ;
                LDA HEXTABLE,X          ;convert using table                                 
                JSR PRINT_CHAR          ;print character to screen
 
                RTS                     ;

HEXTABLE        TEXT '0123456789abcdef'     

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

SCREEN_MENU
; Screen 1 - 
        BYTE    $20,$20,$20,$20,$20,$20,$03,$01,$13,$13,$09,$0F,$10,$05,$09,$20,$20,$20,$20,$20,$20,$20
        BYTE    $20,$20,$20,$20,$20,$20,$45,$45,$45,$45,$45,$45,$45,$45,$45,$20,$20,$20,$20,$20,$20,$20
        BYTE    $20,$0D,$0F,$0E,$09,$14,$0F,$12,$3A,$20,$34,$02,$09,$14,$2C,$20,$38,$0B,$08,$1A,$20,$20
        BYTE    $20,$13,$10,$05,$01,$0B,$05,$12,$3A,$20,$38,$02,$09,$14,$2C,$20,$38,$0B,$08,$1A,$20,$20
        BYTE    $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
        BYTE    $20,$55,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$43,$49,$20
        BYTE    $20,$42,$20,$31,$3A,$0D,$09,$0E,$0E,$09,$05,$20,$14,$08,$05,$20,$0D,$2E,$20,$20,$48,$20
        BYTE    $20,$42,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$48,$20
        BYTE    $20,$42,$20,$32,$3A,$06,$09,$0E,$01,$0C,$20,$03,$0F,$15,$0E,$14,$04,$0F,$17,$0E,$48,$20
        BYTE    $20,$42,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$48,$20
        BYTE    $20,$42,$20,$33,$3A,$13,$15,$0D,$0D,$05,$12,$20,$0F,$06,$20,$36,$39,$20,$20,$20,$48,$20
        BYTE    $20,$42,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$48,$20
        BYTE    $20,$42,$20,$34,$3A,$09,$20,$17,$01,$0E,$14,$20,$09,$14,$20,$01,$0C,$0C,$20,$20,$48,$20
        BYTE    $20,$42,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$48,$20
        BYTE    $20,$42,$20,$35,$3A,$0A,$0F,$08,$0E,$0E,$19,$20,$02,$2E,$20,$07,$0F,$0F,$04,$20,$48,$20
        BYTE    $20,$4A,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$4B,$20
        BYTE    $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
        BYTE    $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
        BYTE    $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
        BYTE    $20,$20,$20,$04,$15,$12,$09,$0E,$07,$20,$10,$0C,$01,$19,$02,$01,$03,$0B,$20,$20,$20,$20
        BYTE    $20,$20,$10,$12,$05,$13,$13,$20,$0B,$05,$19,$20,$14,$0F,$20,$13,$14,$0F,$10,$20,$20,$20
        BYTE    $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
        BYTE    $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20

        BYTE    0