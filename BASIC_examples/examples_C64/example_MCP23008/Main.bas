5 SYS 49500:REM ACTIVATE WEDGE (C64)
10 !I2CAW,66  :REM ADDRESS DEVICE
20 !I2CPU,0   :REM ADDRESS IODIR REGISTER INSIDE DEVICE
30 !I2CPU,0   :REM ADDRESS ALL IOPINS ARE OUTPUT
40 !I2CST     :REM STOP I2C
100 PRINT "{clear}all high"
110 !I2CAW,66 :REM ADDRESS DEVICE
120 !I2CPU,9  :REM ADDRESS GPIO REGISTER INSIDE DEVICE
130 !I2CPU,255:REM ADDRESS ALL HIGH
140 !I2CST    :REM STOP I2C
150 FOR L=0TO1000:NEXT L
200 PRINT "{clear}all low"
210 !I2CAW,66 :REM ADDRESS DEVICE
220 !I2CPU,9  :REM ADDRESS GPIO REGISTER INSIDE DEVICE
230 !I2CPU,0  :REM ADDRESS ALL HIGH
240 !I2CST    :REM STOP I2C
250 FOR L=0TO1000:NEXT L
300 GOTO 100