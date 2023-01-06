<CsoundSynthesizer>
<CsOptions>
-o dac ; output to DAC
</CsOptions>
<CsInstruments>
sr = 44100 ; sample rate
ksmps = 32 ; data rate or control rate -- non-audio function sample window
nchnls = 2 ; 2 = stereo, 1 = mono
0dbfs = 1 ; gain range 0 - 1

; define opcodes ; gen opcode

; build instruments


</CsInstruments>
; assign instruments in the score
<CsScore>
i 1 0 8 ;3 9
i 2 8 8 9 3
e
</CsScore>
</CsoundSynthesizer>