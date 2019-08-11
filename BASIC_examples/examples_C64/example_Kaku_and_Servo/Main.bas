1 rem pca9685 drives 16 servos
2 rem klikaanklikuit controls lights
3 a=128      :rem address servo controller
4 o=128      :rem no offset, servo centered
7 poke 53281,0:poke 53280,0
8 sys 49500  :rem activate wedge (c64)
9 !serin,a:rem init controller
10 print"{white}{clear}{home}     home automation & servo control"
13 print"              basic commands:{down}"
20 rem ---------------
21 print"!kli13,0,0,3,1   :rem lamp #3 on"
22 !kli13,0,0,3,1:gosub 1000
23 print"!kli13,0,0,3,0   :rem lamp #3 off{down}"
24 !kli13,0,0,3,0:gosub 1000
30 rem ---------------
31 print"!kli32,187,0,128 :rem dimmer 40%"
32 !kli32,187,0,128:gosub 1000
33 print"!kli32,187,0,133 :rem dimmer 75%"
34 !kli32,187,0,133:gosub 1000
35 print"!kli32,187,0,143 :rem dimmer 100%"
36 !kli32,187,0,143:gosub 1000
37 print"!kli32,187,0,0   :rem dimmer off{down}"
38 !kli32,187,0,0:gosub 1000
40 rem ---------------
41 print"!servo,a,0,o,0   :rem servo #1 left"
42 !servo,a,0,o,0:gosub 1000
43 print"!servo,a,0,o,255 :rem servo #1 right"
44 !servo,a,0,o,255:gosub 1000
45 print"!servo,a,0,o,128 :rem servo #1 center{down}"
46 !servo,a,0,o,128:gosub 1000
50 rem ---------------
51 print"!servo,a,1,o,0   :rem servo #2 left"
52 !servo,a,1,o,0:gosub 1000
53 print"!servo,a,1,o,255 :rem servo #2 right"
54 !servo,a,1,o,255:gosub 1000
55 print"!servo,a,1,o,128 :rem servo #2 center"
56 !servo,a,1,o,128:gosub 1000
999 gosub 1000:goto 10
1000 for l=0 to 2500:next l
1010 return