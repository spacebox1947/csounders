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
instr MassSpringRandom
    ;set ksamps to 1 for this instrument
    setksmps 1

    ; init vals
    a0  init    0
    a1  init    0.05
    ;ic  =       0.01 
    kc  randomi .001, .05, 8, 3 ; 'force' spring pulls 'back'

    ; calculate the next value
    a2  =       a1 + (a1-a0) - kc*a1
    outs a0 * 0.5, a0 * 0.5

    ;actualize values for next step
    a0 = a1
    a1 = a2
endin

instr MassSpringLine
    ;set ksamps to 1 for this instrument
    setksmps 1

    ; init vals
    a0  init    0
    a1  init    0.05
    kc  line      .001, p3, .005 ; amplitude is relate to a and kc, so be careful!

    ; calculate the next value
    ; a2  =       a1 + (a1-a0) - ic*a1
    a2  =       a1 + (a1-a0) - kc*a1
    outs a0 * 0.33, a0 * 0.33

    ;actualize values for next step
    a0 = a1
    a1 = a2
endin

</CsInstruments>
; assign instruments in the score
<CsScore>
i "MassSpringLine" 0 5
e
</CsScore>
</CsoundSynthesizer>