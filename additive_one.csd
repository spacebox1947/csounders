<CsoundSynthesizer>
<CsOptions>
-o dac ; output to DAC
</CsOptions>
<CsInstruments>
sr = 44100 ; sample rate
ksmps = 32 ; data rate or control rate -- non-audio function sample window
nchnls = 2 ; 2 = stereo, 1 = mono
0dbfs = 1 ; gain range 0 - 1

; gen opcode
; a cosine wave
gicos ftgen 0, 0, 2^10, 11, 1
gicos ftgen 0, 0, 2^8, 11, 1


instr 1
    knh line 1, p3, 20 ; number of harmonics
    klh = 1 ; lowest harmonic
    kmul = 1 ; amplitude coefficient multiplier
    asig gbuzz 1, 100, knh, klh, kmul, gicos
    outs asig, asig
endin

instr 2
    knh line p4, p3, p5
    klh = 1
    kmul = .8
    asig gbuzz 1, 240, knh, klh, kmul, gicos
    outs asig, asig
endin
</CsInstruments>
<CsScore>
i 1 0 8 ;3 9
i 2 8 8 9 3
e
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy