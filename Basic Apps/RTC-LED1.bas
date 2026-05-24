10 C=0       : REM Start with LEDs OFF
20 GOSUB 400 : REM Get initial time
30 T=S       : REM Save starting second
40 OUT 255,C : REM Output C to the LEDs
50 GOSUB 400 : REM Get current time again (inside loop now!)
60 IF S=T THEN 50 : REM If second didn't change, keep checking
70 T=S       : REM Update T to new second
80 C=C+1     : REM Increment C
90 IF C>255 THEN C=0 : REM Wrap C to 0 after 255
100 GOTO 40  : REM Repeat forever
400 REM -------- get current time in H:M:S
410 R=0:GOSUB 500:S=D:REM read seconds
420 R=1:GOSUB 500:M=D:REM read minutes
430 R=2:GOSUB 500:H=D:REM read hours
440 R=0:GOSUB 500:IF D<S THEN 410
450 RETURN
500 REM -------- read clock register R, return in D
510 OUT 96,129+(R AND 31)*2
520 D=INP(97)
530 D=INT(D/16)*10+(D AND 15)
540 RETURN