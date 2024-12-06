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
;id  func #, time, size power of 2, gen#,  [partial #, strength, phase]
gi1 ftgen 1, 0, 2^10, 9, 1,3,0, 3,1,0, 9,0.333,180, 12,0.111,0

; build instruments
instr 1
    kamp = .6   ;amplitude NOTE: amplitude is cumulative for ALL sound generators
    kcps = p4   ;Hz OR cycles per second
    ifn = 1
    ; precision oscillator ; amps, cycles * instrument value, 
    asig poscil kamp, kcps*p5, ifn
    ; assign this instrument to the stereo out
    outs asig, asig
endin

; a more interesting instrument
instr 2
    kamp = .6
    ; audio rate line segments  [starting val, duration, ending val] .. [duration, val] ...
    acps linseg p4, p3*0.67, p5, p3*0.33, p6
    ifn = 1
    asig poscil kamp, acps, ifn
    outs asig, asig
endin

; an even more intersting instrument with an envelope
instr 3
    ; audio rate exponential envelope OOOOO
    kamp expseg .001, p3*0.05,  0.6, p3*0.9, 0.5, p3*.04, .001
    kcps linseg p4, p3*0.67, p5, p3*0.33, p6
    ifn = 1

    asig poscil kamp, kcps, ifn
    outs asig, asig
endin
</CsInstruments>

<CsScore>
; assign instruments in the score
; add new instrument with a line i
; i instr#, delay from start, duration, p4, p5, p6 ... pN
i 1 0 2 32 2
i 1 + 2 32 2.5 ; + in the delay from start paramter will init that instrument after previous statement ends

; + notation does not work on different instruments!
i 2 4 4 32 128 64
i 3 8 6 330 518.571 330
e
</CsScore>
</CsoundSynthesizer>