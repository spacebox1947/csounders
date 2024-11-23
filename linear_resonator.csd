<CsoundSynthesizer>
<CsOptions>
-o dac ; output to DAC
</CsOptions>
<CsInstruments>
sr = 44100 ; sample rate
ksmps = 32 ; data rate or control rate -- non-audio function sample window
nchnls = 2 ; 2 = stereo, 1 = mono
0dbfs = 1 ; gain range 0 - 1

; custom linear opcode
opcode lin_reson, a, akk
    setksmps    1
    avel        init    0   ; velocity
    ax          init    0   ; deflection x
    ain, kf, kdamp      xin
    kc          =       2-sqrt(4 - kdamp^2) * cos(kf * 2 * $M_PI / sr)
    aacel       =       -kc * ax
    avel        =       avel + aacel + ain
    avel        =       avel * (1 - kdamp)
    ax          =       ax + avel

    xout ax
endop

; build instruments
instr 1
    aexc    rand    p4
    aout    lin_reson   aexc, p5, p6
    out aout, aout
endin

</CsInstruments>
; assign instruments in the score
<CsScore>
;       excite  freq    damp
i 1 0 5 .0003   440     .0001
e
</CsScore>
</CsoundSynthesizer>