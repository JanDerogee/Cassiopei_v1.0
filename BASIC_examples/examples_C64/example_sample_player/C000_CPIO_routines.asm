 
ifdef WEDGEAVAILABLE

*=$C000        ; START ADDRESS 49152

else

*=$0A00        ; START ADDRESS 7936

endif

;///////////////////////////////////////////////////////////////////////////////
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;
;                          C P I O   r o u t i n e s
;
;///////////////////////////////////////////////////////////////////////////////
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


;*******************************************************************************
; Cassette Port Input Output protocol initialisation
;******************************************************************************* 
CPIO_INIT       LDA DATA_BIT_6510   ;
                ORA #%00101000      ;P5: lower ATTENTION-line (this signal is inverted therefore we need to write a '1' into the reg.) by the power stage that drives the motor-line
                STA DATA_BIT_6510   ;P3: raise CLOCK-line (cassette write-line)               

                LDA DATA_DIR_6510   ;data direction register of the MOS6510
                AND #%11101111      ;set the direction of the DATA-line (cassette button sense-line) to input
                STA DATA_DIR_6510   ;data direction register of the MOS6510

                RTS

;*******************************************************************************
;JSR CPIO_WAIT4RDY   ;wait until the CPIO device (slave) is ready

                
CPIO_WAIT4RDY   LDA $DC0D           ;read CIA connected to the cassetteport (reading clears the state of the bits)
                AND #%00010000      ;mask out bit 4
                BEQ CPIO_WAIT4RDY   ;loop until the slave lowers the read signal              
                RTS

;*******************************************************************************
;LDA <data>     ;data is the requested operating mode of the slave
;JSR CPIO_START  ;raise attention signal, now communication is set up, we can read or write data from this point
CPIO_START      STA CPIO_DATA       ;store value in A (which holds the mode-byte) to working register

                SEI                 ;disable interrupts
                LDA $DC0D           ;reading clears all flags, so when we do a Read here we clear the old interrupts so that our routines will trigger on the correct event (instead of an old unhandled event)
               
                LDA DATA_BIT_6510   ;set ATTENTION signal to make slave prepare for communication
                AND #%11011111      ;motor control line is set to 0 (MOTOR is now ON (6 volt))
                STA DATA_BIT_6510   ;

                JMP SEND_DATA       ;send the mode byte to the slave


;*******************************************************************************
;this routine will lower the attention to indicate that the current is the last byte
CPIO_SEND_LAST  STA CPIO_DATA       ;safe the data (stored in the accu) to a working register
                LDA DATA_BIT_6510   ;send a '0'
                ORA #%00100000      ;motor control line is set to 1 (MOTOR is now OFF (0 Volt))
                STA DATA_BIT_6510   ;with the attention signal being low (motor-off) the slave has been notified that communication has come to an end and that the current byte is the last byte within this session
                JMP SEND_DATA       ;transmit the byte
;...............................................................................
;this routine will send a byte to the slave
;LDA <data>
;JSR CPIO_SEND

CPIO_SEND       STA CPIO_DATA       ;safe the data (stored in the accu) to a working register
SEND_DATA       LDY #$08            ;every byte consists of 8 bits, this will be use in the CPIO_send and CPIO_recieve routine which are calling this routine

                LDA DATA_DIR_6510   ;data direction register of the MOS6510
                ORA #%00010000      ;set the direction of the sense line to output
                STA DATA_DIR_6510   ;data direction register of the MOS6510

                JSR CPIO_WAIT4RDY   ;wait until the CPIO device (slave) is ready                
SEND_DATA_LP
SEND_CLOCK_0    LDA DATA_BIT_6510   ;lower clock
                AND #%11110111      ;change state of write line to '0'
                STA DATA_BIT_6510   ;    

                BIT CPIO_DATA       ;bit moves bit-7 of CPIO_DATA into the N-flag of the status register
                BPL SEND_ZERO       ;BPL tests the N-flag, when it is 0 the branch to SEND_ZERO is executed (using the BIT instruction instead of conventional masking, we save 2 cycles, and 2 bytes)
SEND_ONE        LDA DATA_BIT_6510   ;
                ORA #%00010000      ;change state of sense line to '1'
                JMP SEND_BIT        ;
SEND_ZERO       LDA DATA_BIT_6510   ;
                AND #%11101111      ;change state of sense line to '0'

SEND_BIT        STA DATA_BIT_6510   ;
SEND_CLOCK_1   ; LDA DATA_BIT_6510  ;raise clock to indicate data is ready for the slave to be read
                ORA #%00001000      ;change state of write line to '1'
                STA DATA_BIT_6510   ;
                ASL CPIO_DATA       ;rotate data in order to send each individual bit, we do it here so that we save time, we have to wait for the clock pulse high-time anyway

                DEY                 ;decrement the Y value
                BNE SEND_DATA_LP    ;exit loop after the eight bit

                LDA DATA_BIT_6510   ;
                AND #%11110111      ;lower the clock line so that the slave has the opportunity to read the data
                STA DATA_BIT_6510   ;
                ORA #%00001000      ;raise clock by changing state of write line to '1' to indicate that the byte has come to an end
                STA DATA_BIT_6510   ;

                LDA DATA_DIR_6510   ;data direction register of the MOS6510
                AND #%11101111      ;set the direction of the sense line to input
                STA DATA_DIR_6510   ;data direction register of the MOS6510
                RTS                 ;end of subroutine

;*******************************************************************************
;this routine will lower the attention to indicate that the current is the last byte
CPIO_REC_LAST   LDA DATA_BIT_6510   ;send a '0'
                ORA #%00100000      ;motor control line is set to 1 (MOTOR is now OFF (0 Volt))
                STA DATA_BIT_6510   ;with the attention signal being low (motor-off) the slave has been notified that communication has come to an end and that the current byte is the last byte within this session
;...............................................................................

;this routine will recieve a byte to the slave
;JSR CPIO_RECIEVE
;data is in Accu

CPIO_RECIEVE    LDY #$08            ;every byte consists of 8 bits, this will be use in the CPIO_send and CPIO_recieve routine which are calling this routine

CPIO_REC_01     JSR CPIO_WAIT4RDY   ;wait until the CPIO device (slave) is ready

REC_DATA_LP
REC_CLOCK_0     LDA DATA_BIT_6510   ;lower clock
                AND #%11110111      ;change state of write line to '0'
                STA DATA_BIT_6510   ;               

                CLC                 ;clear the carry, which is usefull for the ADC later, we clear it here in order to make the clock=0 time 2 cycles longer (keeps our clock duty cycle closer to 50% (which is allways nice))
REC_CLOCK_1     LDA DATA_BIT_6510   ;raise clock by
                ORA #%00001000      ;changing state of write line to '1'
                STA DATA_BIT_6510   ;

                LDA DATA_BIT_6510   ;
                AND #%00010000      ;test input signal for '0' or '1'
                ADC #%11111111      ;when our input is a '1' it will cause the carry bit to be set
                ROL CPIO_DATA       ;shift all the bits one position to the right and add the LSB which is located in the carry

                DEY                 ;decrement the Y value
                BNE REC_DATA_LP     ;exit loop after the eight bit

                LDA DATA_BIT_6510   ;to indicate to the slave that the master has read the data we must
                AND #%11110111      ;lower clock change state of write line to '0'
                STA DATA_BIT_6510   ;to return to the default state of the CLOCK line we must  
                ORA #%00001000      ;raise clock by changing state of write line to '1'
                STA DATA_BIT_6510   ;

                LDA CPIO_DATA       ;move data to accu
                RTS                 ;end of subroutine

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<