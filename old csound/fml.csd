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
instr 1

    kamp expseg .001, p3*0.05,  0.6, p3*0.9, 0.5, p3*.04, .001
    kcps line 330, p3, 350
    kcar = 1
    kmod = p4
    kndx line 0, p3, 20
    asig foscil kamp*0.6, kcps, kmod, kndx, 1
    outs asig, asig
endin

</CsInstruments>
; assign instruments in the score
<CsScore>
i 1 0 5 1
i 1 + . .144
i 1 + . 1.414
i 1 + . 2.05
e
</CsScore>
</CsoundSynthesizer>