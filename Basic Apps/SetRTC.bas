10 INPUT "Current time (H,M,S)? ",H,M,S
20 GOSUB 600
30 END
600 REM -------- set current time to H:M:S
610 OUT 97,0:OUT 96,142:REM clear write-protect bit
620 OUT 97,128:OUT 96,128:REM stop clock
630 R=2:D=H:GOSUB 700:REM set hours
640 R=1:D=M:GOSUB 700:REM set minutes
650 R=0:D=S:GOSUB 700:REM set seconds and re-start clock
660 RETURN
700 REM -------- write D to clock register R
710 OUT 97,INT(D/10)*16+(D MOD 10)
720 OUT 96,128+(R AND 31)*2
730 RETURN