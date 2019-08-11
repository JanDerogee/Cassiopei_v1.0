; 10 SYS (4112)

*=$1001

        BYTE        $0E, $10, $0A, $00, $9E, $20, $28,  $34, $31, $31, $32, $29, $00, $00, $00




;-------------------------------------------------------------------------------
;                            zeropage RAM regsiters
;-------------------------------------------------------------------------------
;we use only the 0-page locations that are marked as "unused" or "free 0-page space for user programs"

CPIO_DATA       = $02           ;this zeropage memory location is used to parse the CPIO data

CNTR            = $F7   ;counter
STR_ADDR        = $F8   ;used for parsing strings
;STR_ADDR+1     = $F9

CURSOR_X        = $FA   ;buffer used for text printing routine
CURSOR_Y        = $FB   ;buffer used for text printing routine
CHAR_ADDR       = $FC
;CHAR_ADDR+1    = $FD

CHRCNT          = $61
ENTRY           = $62
LINE            = $63
LINE_CNT        = $64

COL_PRINT       = $6B  ;holds the color of the charaters printed with the PRINT_CHAR routine
COLOR_ADDR      = $6C  ;pointer to color memory
;COLOR_ADDR+1   = $6D
STR_ADDR        = $6E  ;pointer to string
;STR_ADDR+1     = $6F  ;           


;...............................................................................
;                         KERNAL ROUTINES AND ADDRESSES
;...............................................................................

CHROUT          = $FFD2         ;

CHARSCREEN      = $1E00         ;location of the character screen memory
COLORSCREEN     = $9600         ;location of the color screen memory
CHARSPERLINE    = 22            ;the number of charaters per line (40 for a c64, 22 for a VIC20)
;-------------------------------------------------------------------------------
;                                   constants
;-------------------------------------------------------------------------------

DIRWINDOWSIZE      = 13      ;the number of lines that we can display in our directory window

; CPIO related constants
;------------------------

CPIO_PARAMETER          = #%00001101    ;parameter (used for prepare transfer 4 bit AUDIO sample(s))
CPIO_PLAYSAMPLE         = #%00001110    ;transfer 4 bit AUDIO sample(s)


MODE_ADR        = $00           ;the register address of the location where the CPIO's can sotre settings
INDEX_ADR       = $01           ;the register address of the location where the CPIO's can sotre settings

DATA_DIR_6510   = $00           ;the MOS6510 data direction register of the peripheral IO pins (P7-0)
DATA_BIT_6510   = $01           ;the MOS6510 value f the bits of the peripheral IO pins (P7-0)

;-------------------------------------------------------------------------------


