The speech synthesizer is an English speech synthesizer using a vocabulary to pronounce the words.
This means that the synthesizer is limitted in it's speech... well you have to know the words to be spoken and you can add the more words to the vocabulary.
The tools to create the vocubulary and the systemfile are not yet released, however the files it generates are.
These files are the:
- .sys file (this file holds the sound samples (phonemes) required for speech.
- .voc file (this file holds the vocabulary)

The idea behind a separate .sys and .voc file is that the .sys file must be located at the beginning of the flash memory,
this makes it difficult to update when there are more files installed on the flash memory of the Cassiopei, so the .voc file
which may be stored anywhere on the flash, may be update as many times as required, it may be as large as you want.
However, a larger vocabulary will result in longer searching times

The .sys file holds the samples of the english language, it could be changed to a different language easily, if someone could provide the samples for that language
and a set of words for it's vocabulary. This however is something I cannot do myself, as I was unable to locate useable files on the internet.

The supported words in the vocabulary are:   
------------------------------------------

word or sign <space> set of phonemes

%  P ER N S EH1 N T
&  AE1 M P ER N S AE2 N D
#  SH AA1 R P S AY1 N
   K AA1 M AH
.  P OY1 N T
/  S L AE1 SH
:  K OW1 L AH N
;  S EH1 M IYK OW1 L AH N
?  K W EH1 S CH AH N M AA1 R K
!  EH2 K S K L AH M EY1 SH AH N P OY2 N T
0  Z IH1 R OW  
1  W AH1 N   
2  T UW1   
3  TH R IY1   
4  F AO1 R   
5  F AY1 V   
6  S IH1 K S   
7  S EH1 V AH N   
8  EY1 T   
9  N AY1 N   
10  T EH1 N   
11  IH L EH1 V AH N   
12  T W EH1 L V   
13  TH ER N1 T IY1 N   
14  F AO1 R T IY1 N   
15  F IH F T IY1 N   
16  S IH K S T IY1 N   
17  S EH1 V AH N T IY1 N   
18  EY T IY1 N   
19  N AY1 N T IY1 N   
20  T W EH1 N T IY  
30  TH ER N1 D IY  
ZERO  Z IH1 R OW  
ONE  W AH1 N   
TWO  T UW2   
THREE  TH R IY1   
FOUR  F AO R   
FIVE  F AY1 V   
SIX  S IH1 K S   
SEVEN  S EH1 V AH N   
EIGHT  EY1 T   
NINE  N AY1 N   
TEN  T EH1 N   
ELEVEN  IH L EH1 V AH N   
TWELVE  T W EH1 L V   
THIRTEEN  TH ER N1 T IY1 N   
FOURTEEN  F AO1 R T IY1 N   
FIFTEEN  F IH F T IY1 N   
SIXTEEN  S IH K S T IY1 N   
SEVENTEEN  S EH1 V AH N T IY1 N   
EIGHTEEN  EY T IY1 N   
NINETEEN  N AY1 N T IY1 N   
TWENTY  T W EH1 N T IY  
THIRTY  TH ER N1 D IY  
A  EY   
B  B IY1   
C  S IY1   
D  D IY1   
E  IY1   
F  EH1 F   
G  JH IY1   
H  EY1 CH   
I  AY1   
J  JH EY1   
K  K EY1   
L  EH1 L   
M  EH1 M   
N  EH1 N   
O  OW1   
P  P IY1   
Q  K Y UW1   
R  AA1 R   
S  EH1 S   
T  T IY1   
U  Y UW1   
V  V IY1   
W  D AH1 B AH L Y UW  
X  EH1 K S   
Y  W AY1   
Z  Z IY1   
ALPHA  AE1 L F AH  
BRAVO  B R AA1 V OW  
CHARLIE  CH AA1 R L IY  
DELTA  D EH1 L T AH  
ECHO  EH1 K OW  
FOXTROT  F AA1 K S T R AAT   
GOLF  G AA1 L F   
HOTEL  HH OWT EH1 L   
INDIA  IH1 N D IYAH  
JULIET  JH UW1 L IYEH2 T   
KILO  K IH1 L OW2   
LIMA  L AY1 M AH  
MIKE  M AY1 K   
NOVEMBER  N OW V EH1 M B ER
OSCAR  AO1 S K ER
PAPA  P AA1 P AH  
QUEBEC  K W AHB EH1 K   
ROMEO  R OW1 M IYOW2   
SIERRA  S IY EH1 R AH  
TANGO  T AE1 NG G OW  
UNIFORM  Y UW1 N AHF AO2 R M   
VICTOR  V IH1 K T ER
WHISKEY  W IH1 S K IY  
X-RAY  EH1 K S R EY2   
YANKEE  Y AE1 NG K IY  
ZULU  Z UW1 L UW2   
ACCESS  AE1 K S EH2 S   
DENIED  D IH N AY1 D   
GRANTED  G R AE1 N T AH D   
ALARM  AH L AA1 R M   
SECURITY  S IH K Y UH1 R AH T IY  
BREACH  B R IY1 CH   
BREACHED  B R IY1 CH T   
SHUTDOWN  SH AH1 T D AW2 N   
COUNTDOWN  K AW1 N T D AW2 N   
SEQUENCE  S IY1 K W AH N S   
OK  OW1 K EY1   
ERROR  EH1 R ER  
PASS  P AE1 S   
FAIL  F EY1 L   
ATTENTION  AH T EH1 N SH AH N   
WARNING  W AO1 R N IH NG   
REACHED  R IY1 CH T   
CRITICAL  K R IH1 T IH K AH L   
LEVEL  L EH1 V AH L   
HIGH  HH AY1   
LOW  L OW1   
OIL  OY1 L   
BATTERIES  B AE1 T ER IY Z   
FUEL  F Y UW1 AH L   
TEMPERATURE  T EH1 M P R AH CH ER
PRESSURE  P R EH1 SH ER
AIRFLOW  EH1 R F L OW  
GIGA  G IH1 G AH  
MEGA  M EH1 G AH  
KILO  K IH1 L OW2   
MILLI  M IH1 L IY  
MICRO  M AY1 K R OW2   
NANO  N AA1 N OW  
PICO  P IY1 K OW  
VOLT  V OW1 L T   
AMPERE  AH N HH AE1 M P ER
OHM  OW1 M   
TURN  T ER N1 N   
RETURN  R IH T ER N1 N   
BASE  B EY1 S   
HEADQUARTER  HH EH1 D K W AO2 R T ER
HOME  HH OW1 M   
FORWARD  F AO1 R W ER ND   
REVERSE  R IHV ER N1 S   
NEXT  N EH1 K S T   
PREVIOUS  P R IY1 V IY AH S   
UP  AH1 P   
DOWN  D AW1 N   
LEFT  L EH1 F T   
RIGHT  R AY1 T   
FRONT  F R AH1 N T   
REAR  R IH1 R   
BACK  B AE1 K   
SIDE  S AY2 D   
CENTER  S EH1 N T ER
POSITION  P AH Z IH1 SH AH N   
HEADING  HH EH1 D IH NG   
NORTH  N AO1 R TH   
SOUTH  S AW1 TH   
EAST  IY1 S T   
WEST  W EH1 S T   
HELLO  HH AH L OW1   
BYE  B AY1   
GREETINGS  G R IY T IH NG Z   
GOOD  G UH2 D   
MORNING  M AO1 R N IH NG   
EVENING  IY1 V N IH NG   
AFTERNOON  AE2 F T ER NN UW1 N   
NIGHT  N AY1 T   
CLOCK  K L AA1 K   
QUARTER  K W AO1 R T ER
HALF  HH AE1 F   
PAST  P AE1 S T   
TO  T UW1   
AM  AE1 M   
PM  P IY1 EH1 M   
SECOND  S EH1 K AH N D   
SECONDS  S EH1 K AH N D Z   
MINUTES  M IH1 N AH T   
MINUTES  M IH1 N AH T S   
HOUR  AW1 ER
HOURS  AW1 ER NZ   
DAY  D EY1   
DAYS  D EY1 Z   
WEEK  W IY1 K   
WEEKS  W IY1 K S   
MONTH  M AH1 N TH   
MONTHS  M AH1 N TH S   
YEAR  Y IH1 R   
YEARS  Y IH1 R Z   
JANUARY  JH AE1 N Y UW EH2 R IY  
FEBRUARY  F EH1 B Y AH W EH2 R IY  
MARCH  M AA1 R CH   
APRIL  EY1 P R AH L   
MAY  M EY1   
JUNE  JH UW1 N   
JULI  JH UW1 L IY  
AUGUST  AA1 G AH S T   
SEPTEMBER  S EH P T EH1 M B ER
OCTOBER  AA K T OW1 B ER
NOVEMBER  N OW V EH1 M B ER
DECEMBER  D IH S EH1 M B ER
THE  DH AH  
TIME  T AY1 M   
IS  IHZ   
ARE  AA1 R   
HAS  HH AE1 Z   
FALKEN  F AO K AH N   
PROFESSOR  P R AH F EH S ER
SHALL  SH AE L   
WE  W IY   
PLAY  P L EY   
COMMODORE  K AA M AH D AO R   
GAME  G EY M   
PRESS  P R EH1 S   
SHIFT  SH IH1 F T   
RUN  R AH1 N   
STOP  S T AA1 P   
LOAD  L OW1 D   
PROGRAM  P R OW1 G R AE2 M   
START  S T AA1 R T   
STARTUP  S T AA1 R T AH2 P   
START-UPS  S T AA1 R T AH1 P S   
STARTED  S T AA1 R T AH D   
WEDGE  W EH1 JH   
WHAT  W AH1 T
IS  IH1 Z
YOUR  Y AO1 R
NAME  N EY1 M
WORLD  W ER1 L D

