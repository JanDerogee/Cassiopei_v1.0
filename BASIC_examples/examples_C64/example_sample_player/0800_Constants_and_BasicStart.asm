; 10 SYS2080

*=$801

        BYTE        $0B, $08, $0A, $00, $9E, $32, $30, $38, $30, $00, $00, $00


;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;                           BUILD RELATED SETTINGS
;-------------------------------------------------------------------------------

FALSE = 0
TRUE  = 1

WEDGEAVAILABLE = FALSE

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

;-------------------------------------------------------------------------------
;                            zeropage RAM regsiters
;-------------------------------------------------------------------------------
;we use only the 0-page locations that are marked as "unused" or "free 0-page space for user programs"


;common variables
;----------------

CPIO_DATA       = $02           ;this zeropage memory location is used to parse the CPIO data
RASTER_CNT      = $97


;variables used by menu program only
;-----------------------------------

MODE            = $F7   ;the speed and source of the data over the cassette port (classic(SLOW) or CPIO(fast), flash or USB)
INDEX           = $F8   ;this reg holds the index of the selected file
INDEX_MAX       = $F9

CURSOR_X        = $FA   ;buffer used for text printing routine
CURSOR_Y        = $FB   ;buffer used for text printing routine
CHAR_ADDR       = $FC
;CHAR_ADDR+1    = $FD

;CHRCNT          = $61
ENTRY           = $62
LINE            = $63
LINE_CNT        = $64

COL_PRINT       = $6B  ;holds the color of the charaters printed with the PRINT_CHAR routine
COLOR_ADDR      = $6C  ;pointer to color memory
;COLOR_ADDR+1   = $6D
STR_ADDR        = $6E  ;pointer to string
;STR_ADDR+1     = $6F  ;           



;we use only the 0-page locations that are marked as "unused" or "free 0-page space for user programs"
;variables used by wedge only
;----------------------------
POINTER_BUF     = $FB   ;and $FC
TABLE_ADR       = $FD   ;and $FE


;...............................................................................
;                         KERNAL ROUTINES AND ADDRESSES
;...............................................................................

BORDER          = $D020         ;bordercolour
BACKGROUND      = $D021         ;background-0
CHARSCREEN      = $0400         ;location of the character screen memory
COLORSCREEN     = $D800         ;location of the color screen memory (this value cannot change)

TXTPTR          = $7A   ;this value is noted as 2 digits (no zeros are noted here, to use it as a zero-page address)
CHRGET          = $0073 ;this value is noted as 4 digits, because we want to jump to it and therefore it needs to be a 4 digit address ;get character from basic line (value corresponds to table in Appendix C of prog ref guid (page 379))
CHRGOT          = $0079 ;this value is noted as 4 digits, because we want to jump to it and therefore it needs to be a 4 digit address ;get the last character again
IGONE           = $0308         ;non function BASIC commands 
IEVAL           = $030A         ;functions in BASIC commands
NEWBASIC_DONE   = $A7E4         ;fetch new character from basic line and interpret (jump to this vector after !HELP which is a command that has no prarameters to be processed)
STNDRDBASICCMD  = $A7E7         ;interpret just fetched character from basic line as a command
STNDRDBASICFUNC = $AE8D         ;interpret just fetched character from basic line as a function
SYNTAXERROR     = $AF08         ;syntax error

CHROUT          = $FFD2         ;

CHKCOMANDGETVAL = $E200         ;check if last fetched char was a comma, if so get value (stores 8-bit value in X), if not syntax error
CHKCOM          = $AEFD         ;If it is not, a SYNTAX ERROR results.  If it is, the character is skipped and the next character is read.
FRMNUM          = $AD8A         ;
GETADR          = $B7F7         ;

DATA_DIR_6510   = $00           ;the MOS6510 data direction register of the peripheral IO pins (P7-0)
DATA_BIT_6510   = $01           ;the MOS6510 value f the bits of the peripheral IO pins (P7-0)

;-------------------------------------------------------------------------------
;                                   constants
;-------------------------------------------------------------------------------

DIRWINDOWSIZE   = 13            ;the max. number of lines that we can display in our directory window
MODE_ADR        = $00           ;the register address of the location where the CPIO's can sotre settings
INDEX_ADR       = $01           ;the register address of the location where the CPIO's can sotre settings

; CPIO related constants
;------------------------

CPIO_LOAD_SPEC_FILE     = #%00000000    ;read fast from the cassiopei's filesystem
;CPIO_SAVEFAST           = #%00000000    ;save fast from the cassiopei's filesystem

CPIO_R_DIRECTORY_FLASH  = #%00000100    ;read diretory info from flash        
CPIO_SIMULATE_BUTTON    = #%00000111    ;simulate press on play
CPIO_R_EEPROM           = #%00001111    ;read from slave, EEPROM
CPIO_W_EEPROM           = #%10001111    ;write to slave, EEPROM

CPIO_ADC                = #%00001001    ;get ADC value
CPIO_EEPROM_RD          = #%00001111    ;read from slave, EEPROM
CPIO_PARAMETER          = #%00001101    ;used to prepare transfer of AUDIO sample(s)
CPIO_PLAYSAMPLE         = #%00001110    ;transfer 4 bit AUDIO sample(s)

CPIO_EEPROM_WR          = #%10001111    ;write to slave, EEPROM
CPIO_SINEWAVE           = #%10001000    ;write to slave, audio: type pure sine
CPIO_DTMF               = #%10001001    ;write to slave, audio: type DTMF
CPIO_SPEECH             = #%10001010    ;write to slave, audio: type speech
CPIO_KAKU13             = #%10001011    ;write to slave, klik aan klik uit code 13 bits
CPIO_KAKU32             = #%10001100    ;write to slave, klik aan klik uit code 32 bits

CPIO_SERVOINIT          = #%10010001    ;init PCA9685 PWEM controller for servo mode
CPIO_SERVOPOS           = #%10010010    ;send servo postioning command

CPIO_I2C                = #%10010000    ;I2C data
CPIO_I2C_STOP           = #$00          ;write I2C data to slave
CPIO_I2C_ADR_W          = #$01          ;write I2C address to slave and indicate that we are sending data TO the I2C slave
CPIO_I2C_ADR_R          = #$02          ;write I2C address to slave and indicate that we are going to read data FROM the I2C slave
CPIO_I2C_PUT            = #$10          ;write I2C data to slave
CPIO_I2C_GET            = #$20          ;read I2C data from slave and acknowledge
CPIO_I2C_GETLAST        = #$21          ;read I2C data from slave, but do not acknowledge to indicate this is the last byte we want to read

;-------------------------------------------------------------------------------


