   PCA9685 DRIVES 16 SERVOS E  KLIKAANKLIKUIT CONTROLS LIGHTS b  100 : CALCULATE TABLE 	  49500 : ACTIVATE WEDGE (C64)  A˛128    : ADDRESS ¸ O˛128    : NO OFFSET Ø !SERIN, A: INIT CONTROLLER ų  -------------------------- 	 !KLI13,0,0,3,0 	  L˛0 ¤ 200 )	   40: L <	! !KLI13,0,0,3,1 L	"  L˛0 ¤ 200 Y	#  40: L b	%  30 	(  -------------------------- 	4 !SERVO,A,0,O,R(L,0) ŗ	5 !SERVO,A,1,O,R(L,1) Ë	6 !KLI32,187,0,R(L,2) Ņ	;  ë	d  CALCULATE SINETABLE 
f  "CALCULATING SINE TABLE (TAKES 25S)" +
i  R(200,3):L˛0 I
n  S˛Ģ3.14 ¤ 3.14 Š 0.0314 b
o R(L,0)˛128Ē(ŋ(S)Ŧ63) {
p R(L,1)˛128Ē(ž(S)Ŧ63) 
q R(L,2)˛128Ē(ļ(ŋ(S)Ŧ15)) Ą
r L˛LĒ1 Š
s  S ¯
t    