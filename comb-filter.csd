<CsoundSynthesizer>
<CsOptions>
    -Ma -odac -m128 -+rtaudio=jack -i adc -o dac
    --env:SSDIR+=./samples
</CsOptions>
<CsInstruments>

sr = 88200
ksmps = 32
nchnls = 2
0dbfs = 1

gS_tasty1 = "Tasty_Ice_Crunch-1.wav"        ; dur: 19.953
gS_boogaloo4 = "Boogaloo-4.wav"             ; dur: 42.956

  instr 1
; -- generate an input audio signal (noise impulses) --
; repeating amplitude envelope:
kEnv         loopseg   1,0, 0,1,0.005,1,0.0001,0,0.9949,0
aSig         pinkish   kEnv*0.6                     ; pink noise pulses

; apply comb filter to input signal
krvt    linseg  0.1, 5, 2                           ; reverb time
alpt    expseg  0.005,5,0.005,6,0.0005,10,0.1,1,0.1 ; loop time
aRes    vcomb   aSig, krvt, alpt, 0.1               ; comb filter
        outs     aRes, aRes                               ; audio to output
  endin

    instr 2

aSamp[] diskin gS_boogaloo4, 1, 0, 1

krvt    linseg  0.1, 5, 2                         ; reverb time
;alpt    expseg  0.005,  .25*p3,  0.5, 0.75*p3, 0.005 ; loop time
alpt    poscil 1, 1
alpt = (alpt + 1) * 0.5 ; produces really nasty clips as the oscillator changes
aRes    vcomb   aSamp[0], 0.25, alpt*0.005, 0.5              ; comb filter
        outs     aRes, aRes                               ; audio to output
    endin

</CsInstruments>
<CsScore>
;i 1 0 25
i 2 0 10
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy