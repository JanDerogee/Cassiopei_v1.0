!- --------------------------------------------------------------------------
!- THIS PROGRAM WAS MADE USING "CBM PROGRAM STUDIO" BY ARTHUR JORDISON
!- This program requires a Cassiopei, C64 and modified klik-aan-klik-uit
!- remote control modify the event list at the bottom of this program
!- to suit your own requirements.
!-
!- This example requires the following files to be installed onto the cassiopei:
!-  - a system file containing all sound samples as required for speech synthesis
!-  - a vocabulary file containing the words that are spoken by this program
!-  - this program in .PRG format
!-  - a sound sample called "dean martin"
!- --------------------------------------------------------------------------
1 REM JAN DEROGEE  (2013)
2 SYS 49500:REM activate wedge
3 POKE 53281,0:POKE 53280,0:POKE 54296,15:PRINT"{CLEAR}{HOME}{WHITE}"
4 INPUT"enter current time [hhmmss]";TI$
5 rem TI$="064650"
6 GOSUB 1000
7 FORL=55936 TO 55975:POKEL,15:NEXT
8 FORL=55976 TO 56015:POKEL,12:NEXT
9 FORL=56016 TO 56256:POKEL,11:NEXT:GOTO14
10 PRINT"{HOME}{DOWN*3}{RED}{LEFT*5}";MID$(TI$,5,2)
11 IF ALARM = 1 THEN GOSUB 65
12 GET A$:IF A$=" " THEN ALARM=0
13 IF NOT MID$(TI$,5,2)="00" THEN GOTO 10
14 X=5 :Y=VAL(MID$(TI$,1,1)):GOSUB 70
15 X=12:Y=VAL(MID$(TI$,2,1)):GOSUB 70
16 X=21:Y=VAL(MID$(TI$,3,1)):GOSUB 70
17 X=28:Y=VAL(MID$(TI$,4,1)):GOSUB 70
!- --------------------------------------------------
!- check for and handle events
!- --------------------------------------------------
18 RESTORE:FOR B=1TO70:READ A$:NEXT B:REM set pointer to events
19 READ AL$:IF AL$ = "end" GOTO 10:REM end of table?
20 READ M:ON M GOTO 21,22,23,24,25
21 GOTO 30
22 READ O:READ E:READ D:GOTO 30
23 GOTO 30
24 READ H:READ G:READ B:READ S:GOTO 30
25 READ H:READ B:READ S:GOTO 30
30 READ C$:IF NOT AL$=MID$(TI$,1,4) THEN GOTO 19
31 REM scroll screen
32 FORL=1984TO1624STEP-1:POKEL+40,PEEK(L):NEXT
33 PRINT"{HOME}{DOWN*15}{WHITE}                                       "
34 GOSUB 60:REM beep on event
35 PRINT"{HOME}{DOWN*15}  ";MID$(TI$,1,2);":";MID$(TI$,3,2);" - ";C$
!- --------------------------------------------------
!- execute event
!- --------------------------------------------------
40 ON M GOTO 41,42,43,44,45
41 !SAY,0,C$:GOTO19:REM SPEAK TEXT
42 !SAMPL,O,E,D,C$
43 ALARM=1:GOTO 19:REM SOUND ALARM  
44 !kli13,H,G,B,S:GOTO 19:REM execute 13bit kaku command
45 !kli32,H,B,S  :GOTO 19:REM execute 32bit kaku command
49 GOTO 19
!- --------------------------------------------------
60 rem simple beep
61 POKE 54276,16:POKE 54273,56: POKE 54272,250
62 POKE 54277,7: POKE 54278,15:POKE 54276,17
63 RETURN
65 REM alarm beep
66 POKE 54276,16:POKE 54273,100: POKE 54272,250
67 POKE 54277,7: POKE 54278,15:POKE 54276,17
68 RETURN
!- --------------------------------------------------
70 REM --------------------------------
71 RESTORE:PRINT"{HOME}{RED}{DOWN*2}";
72 IF Y=0 THEN 75
73 FOR B=1TO7*Y:READ A$:NEXT B:REM SKIP UNWANTED
75 FOR B=0TO6:READ A$:PRINT TAB(X);A$:NEXT B
78 RETURN:REM ---------------------------------------
97 REM -------------------------
98 REM TABLE OF 7 SEGMENT VALUES
99 REM -------------------------
100 DATA " CCCC "
101 DATA "B    B"
102 DATA "B    B"
103 DATA "B    B"
104 DATA "B    B"
105 DATA "B    B"
106 DATA " CCCC "
107 REM -----------
110 DATA "      "
111 DATA "     B"
112 DATA "     B"
113 DATA "     B"
114 DATA "     B"
115 DATA "     B"
116 DATA "      "
117 REM -----------
120 DATA " CCCC "
121 DATA "     B"
122 DATA "     B"
123 DATA " CCCC "
124 DATA "B     "
125 DATA "B     "
126 DATA " CCCC "
127 REM ----------
130 DATA " CCCC "
131 DATA "     B"
132 DATA "     B"
133 DATA " CCCC "
134 DATA "     B"
135 DATA "     B"
136 DATA " CCCC "
137 REM -----------
140 DATA "      "
141 DATA "B    B"
142 DATA "B    B"
143 DATA " CCCC "
144 DATA "     B"
145 DATA "     B"
146 DATA "      "
147 REM -----------
150 DATA " CCCC "
151 DATA "B     "
152 DATA "B     "
153 DATA " CCCC "
154 DATA "     B"
155 DATA "     B"
156 DATA " CCCC "
157 REM ----------
160 DATA " CCCC "
161 DATA "B     "
162 DATA "B     "
163 DATA " CCCC "
164 DATA "B    B"
165 DATA "B    B"
166 DATA " CCCC "
167 REM -----------
170 DATA " CCCC "
171 DATA "     B"
172 DATA "     B"
173 DATA "     B"
174 DATA "     B"
175 DATA "     B"
176 DATA "      "
177 REM -----------
180 DATA " CCCC "
181 DATA "B    B"
182 DATA "B    B"
183 DATA " CCCC "
184 DATA "B    B"
185 DATA "B    B"
186 DATA " CCCC "
187 REM -----------
190 DATA " CCCC "
191 DATA "B    B"
192 DATA "B    B"
193 DATA " CCCC "
194 DATA "     B"
195 DATA "     B"
196 DATA " CCCC "
200 REM -------------------------
201 REM          EVENT LIST
202 REM -------------------------
203 rem 1 = say text (4-bit digi)
204 rem 2 = play audio sample (4bit digi)
205 rem 3 = alarm sound (stop by pressing space)
206 rem 4 = klikaanklikuit 13bit
207 rem 5 = klikaanklikuit 32bit 
209 data "0647",2 ,0,0,0,"dean martin":rem play music sample
210 data "0648",5 ,187,0,135,   "bedroom-1  :light 50%":rem dimmer min
211 data "0648",1 ,"it is time to wake up"
212 data "0654",4 ,0,0,3,1,     "kitchen    :toaster  ":rem A,I,3,ON
213 data "0655",4 ,0,0,1,1,     "kitchen    :coffee   ":rem A,I,1,ON
215 data "0659",1 ,"get out of bed, breakfast is ready" 
216 data "0659",3 ,"<press space to stop alarm>" 
217 data "0715",5 ,187,0,0,     "bedroom-1  :light off":rem dimmer off
218 data "2030",4 ,0,0,2,1,     "living room:light on" :rem A,I,2,ON
317 data "2230",4 ,0,0,2,0,     "living room:light off":rem A,I,2,ON
999 data "end"
1000 PRINT "{HOME} {gray}{117}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{105}"
1010 PRINT " {098}{117}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{105}{098}"
1020 PRINT " {098}{103}                                  {104}{098}"
1030 PRINT " {098}{103}                {red}{113}                 {gray}{104}{098}"
1040 PRINT " {098}{103}                                  {104}{098}"
1050 PRINT " {098}{103}                                  {104}{098}"
1060 PRINT " {098}{103}                                  {104}{098}"
1070 PRINT " {098}{103}                {red}{113}                 {gray}{104}{098}"
1080 PRINT " {098}{103}                                  {104}{098}"
1090 PRINT " {098}{103}                                  {104}{098}"
1100 PRINT " {098}{106}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{102}{107}{098}"
1110 PRINT " {106}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{099}{107}"
1250 return