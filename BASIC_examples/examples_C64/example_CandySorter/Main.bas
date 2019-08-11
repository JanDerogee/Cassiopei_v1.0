4 DIM C%(7):REM counter for the 6 colors
5 GOSUB 700:REM INIT SCREEN
8 SYS 49500:REM ACTIVATE WEDGE (C64)
9 GOSUB 1000:REM initialize IO
10 REM ----------------------
11 REM main program loop
20 GOSUB 400:REM home carriage
30 GOSUB 100:REM scan colour
31 GOSUB 200:REM activate hopper
32 REM check if empty
33 IF CO%>0 THEN GOTO 50
34 GOSUB 900:POKE 53280,2:rem beep and flicker
35 FOR L=0 TO 250:NEXT L
36 GOSUB 900:POKE 53280,0
37 GOTO 30
50 GOSUB 300:REM move stepper to pos
60 GOSUB 500:REM release candy
62 GOSUB 740:REM update counters
65 GOSUB 350:REM return to base
99 GOTO 20  :REM keep looping
100 REM --------------------------------
101 REM wait for hopper & scan colour
102 A$="wait for hopper":GOSUB 800
103 !I2CAW,66:!I2CPU,9:!I2CST:rem prepare read
104 !I2CAR,66:DA=!I2CGL AND 2:REM HOPPER OK=B1
105 !I2CST:REM STOP I2C
107 IF DA=0 THEN 103
110 A$="scan red":GOSUB 800
111 !I2CAW,66:!I2CPU,9:!I2CPU,4:!I2CST
112 for L=0 to 100:NEXT L:REM DELAY
113 GOSUB 600:MR%=AD%:REM MEASURE RED
114 PRINT"{HOME}{DOWN*10}"
115 PRINT"{RIGHT*8}      {left*6}{red}";MR%;"{white}"
119 REM ................................
120 A$="scan green":GOSUB 800
121 !I2CAW,66:!I2CPU,9:!I2CPU,16:!I2CST
122 for L=0 to 100:NEXT L:REM DELAY
123 GOSUB 600:MG%=AD%:REM MEASURE GREEN
124 PRINT"{HOME}{DOWN*11}"
125 PRINT"{RIGHT*8}      {left*6}{green}";MG%;"{white}"
129 REM ................................
130 A$="scan blue":GOSUB 800
131 !I2CAW,66:!I2CPU,9:!I2CPU,64:!I2CST
132 for L=0 to 100:NEXT L:REM DELAY
133 GOSUB 600:MB%=AD%:REM MEASURE BLUE
134 PRINT"{HOME}{DOWN*12}"
135 PRINT"{RIGHT*8}      {left*6}{blue}";MB%;"{white}"
136 REM ................................
137 !I2CAW,66:!I2CPU,9:!I2CPU,0:!I2CST
141 A$="calculate colour":GOSUB 800
142 PRINT"{HOME}{DOWN*9}"
143 RESTORE:TMP%=1024:REM reset data table
144 FOR L = 0 TO 6:REM determine error from ref.
145 READ TR%,TG%,TB%:REM read table for colour
146 ER%=ABS(TR%-MR%)+ABS(TG%-MG%)+ABS(TB%-MB%)
147 PRINT"{RIGHT*24}";ER%;"{left}   "
148 IF ER%>TMP% THEN GOTO 150
149 TMP%=ER%:CO%=L:REM save lowest err value
150 NEXT L
160 FOR L = 0 TO 6:REM read table for pos and name
161 READ P%,A1%,A2%,CO$
162 IF L = CO% THEN 170
163 NEXT L
170 PRINT"{DOWN}{RIGHT*24}";CO$
171 C%(L) = C%(L) + 1:REM inc color counter
172 !SERVO,254,7,A1%,A2%:REM position indicator
173 RETURN
180 REM  RED,GRE,BLU
181 DATA 156,145,151 :rem empty
182 DATA 107,90,96   :rem brown
183 DATA 177,105,108 :rem red
184 DATA 185,104,104 :rem orange
185 DATA 205,161,119 :rem yellow
186 DATA 117,140,112 :rem green
187 DATA 110,120,160 :rem blue
190 REM  POS,ARROW  ,STRING
191 DATA 0  ,210,255,"empty "
192 DATA 0  ,130,255,"brown "
193 DATA 31 ,65 ,255,"red   "
194 DATA 62 ,0  ,240,"orange"
195 DATA 93 ,0  ,165,"yellow"
196 DATA 124,0  ,110,"green "
197 DATA 154,60 ,0  ,"blue  "
200 REM --------------------------------
201 REM activate hopper rotation
205 A$="rotate hopper":GOSUB 800:REM print
210 !I2CAW,64 :REM ADDRESS DEVICE
211 !I2CPU,9  :REM ADDRESS GPIO REG
212 !I2CPU,128:REM rotate hopper motor
213 !I2CST    :REM STOP I2C
214 FOR L=0 TO 750:NEXT L
216 !I2CAW,64 :REM ADDRESS DEVICE
217 !I2CPU,9  :REM ADDRESS GPIO REG
218 !I2CPU,0  :REM all off
219 !I2CST    :REM STOP I2C
230 RETURN
300 REM --------------------------------
301 REM move stepper .. pos to the right
302 IF P% = 0 THEN GOTO 320:REM EXIT WHEN 0
303 A$="move carriage right":GOSUB 800:REM print
310 FOR L=1 TO P%
311 !I2CAW,64:!I2CPU,9:!I2CPU,2:!I2CPU,6:!I2CPU,4
312 !I2CPU,5:!I2CPU,1:!I2CPU,9:!I2CPU,8:!I2CPU,10
314 !I2CST:NEXT L
320 RETURN
350 REM --------------------------------
351 REM move stepper .. pos to the left
352 IF P% = 0 THEN GOTO 370:REM EXIT WHEN 0
353 A$="move carriage left":GOSUB 800:REM print
360 FOR L=1 TO P%
361 !I2CAW,64:!I2CPU,9:!I2CPU,10:!I2CPU,8:!I2CPU,9
362 !I2CPU,1:!I2CPU,5:!I2CPU,4:!I2CPU,6:!I2CPU,2
364 !I2CST:NEXT L
370 RETURN
400 REM --------------------------------
401 REM home carriage
405 A$="homing carriage":GOSUB 800:REM print
410 !I2CAW,66:!I2CPU,9:!I2CST:rem prepare read
411 !I2CAR,66:DA=!I2CGL AND 128:REM LIMIT SWITCH=B7
412 !I2CST:REM STOP I2C
413 IF DA=128 THEN 440 
420 P%=5:GOSUB 300:REM 1 step right
430 REM
440 FOR L=0 to 300:REM home with timeout
450 P%=1:GOSUB 350:REM 1 step left
452 !I2CAW,66:!I2CPU,9:!I2CST:rem prepare read
453 !I2CAR,66:DA=!I2CGL AND 128:REM LIMIT SWITCH=B7
454 !I2CST:REM STOP I2C
455 IF DA=0 THEN 470:REM EXIT ON LIMIT
460 NEXT L
470 P%=2:GOSUB 300:REM step right
480 RETURN
500 REM --------------------------------
501 REM release candy
505 A$="release candy":GOSUB 800:REM print
510 !SERVO,254,0,128,50:REM release
515 FOR L=0 TO 250 : NEXT L
520 !SERVO,254,0,128,135:REM release
525 FOR L=0 TO 250 : NEXT L
535 RETURN
600 REM average ADC measurement
601 AD%=0
602 FOR L=1 TO 16
603 AD% = AD% + !ADC,0
604 NEXT L
605 AD%=AD% / 16:REM determine average
610 RETURN
700 REM --------------------------------
701 REM SHOW SCREEN
702 poke 53281,0:poke 53280,0
703 PRINT"{clear}{home}{gray}";
710 PRINT"UDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDI"
711 PRINT"Gcandy sorting machine       (jd 2013)H"
712 PRINT"JFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFK"
713 PRINT"{white}"
720 PRINT"UDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDI"
721 PRINT"Gstatus :                             H"
722 PRINT"JFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFK"
723 print""
724 PRINT"UDDDDDDDDDDDDDI UDDDDDDDDDDDDDDDDDDDDDI"
725 PRINT"G {gray}adc results{white} H G        {gray}error   total{white}H"
726 PRINT"G             H Gempty :       :      H"
727 PRINT"G {red}red  :{white}      H Gbrown :       :      H"
728 PRINT"G {green}green:{white}      H Gred   :       :      H"
729 PRINT"G {blue}blue :{white}      H Gorange:       :      H"
730 PRINT"G             H Gyellow:       :      H"
731 PRINT"G             H Ggreen :       :      H"
732 PRINT"G             H Gblue  :       :      H"
733 PRINT"G             H G---------------------H"
734 PRINT"G             H Gresult:       :      H"
735 PRINT"JFFFFFFFFFFFFFK JFFFFFFFFFFFFFFFFFFFFFK"
740 PRINT"{HOME}{DOWN*10}{RIGHT*32}";C%(0)
741 PRINT"{RIGHT*32}";C%(1)
742 PRINT"{RIGHT*32}";C%(2)
743 PRINT"{RIGHT*32}";C%(3)
744 PRINT"{RIGHT*32}";C%(4)
745 PRINT"{RIGHT*32}";C%(5)
746 PRINT"{RIGHT*32}";C%(6)
747 T%=0:REM calculate total
748 FOR B=1 TO 6:T%=T%+C%(B):NEXT
749 PRINT"{DOWN}{RIGHT*32}";T%
750 RETURN
800 REM --------------------------------
810 REM print status
820 PRINT "{home}{down*5}{right*9}";A$;
830 B%=LEN(A$):REM PAD LINE WITH SPACES
831 FOR L = B% TO 28
832 PRINT " ";
833 NEXT L
840 RETURN
900 REM --------------------------------
901 rem play sound
902 POKE 54296,15: POKE 54276,16
903 POKE 54273,56: POKE 54272,250
904 POKE 54277,7: POKE 54278,15
905 POKE 54276,17
906 RETURN
1000 REM -------------------------------
1001 REM INITIALIZE IO
1005 A$="initialize io":GOSUB 800:REM print
1010 rem io for stepper motor
1011 !I2CAW,64  :REM ADDRESS DEVICE
1012 !I2CPU,0   :REM ADDRESS IODIR REG
1013 !I2CPU,0   :REM ALL IO=OUTPUT
1014 !I2CST     :REM STOP I2C
1015 !I2CAW,64  :REM ADDRESS DEVICE
1016 !I2CPU,5   :REM ADDRESS IOCON REG
1017 !I2CPU,32  :REM disable auto increment of address pointer
1018 !I2CST     :REM STOP I2C
1020 rem init servo 
1021 !SERIN,254
1030 rem io for switch and LED
1031 !I2CAW,66  :REM ADDRESS DEVICE
1032 !I2CPU,0   :REM ADDRESS IODIR REG
1033 !I2CPU,130 :REM RB7,RB0=input
1034 !I2CST     :REM STOP I2C
1035 !I2CAW,66  :REM ADDRESS DEVICE
1036 !I2CPU,5   :REM ADDRESS IOCON REG
1037 !I2CPU,32  :REM disable auto increment of address pointer
1038 !I2CST     :REM STOP I2C
1050 RETURN