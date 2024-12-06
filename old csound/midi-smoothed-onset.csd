<CsoundSynthesizer>
<CsOptions>
-Ma -odac -m128 -+rtaudio=jack -i adc -o dac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

giSine   ftgen    0,0,2^12,10,1
         initc7   1,1,1          ;initialize CC 1 to its max. level

instr 1
; portk is a filter to interpolate 2^7 values of volume from MIDI in
; smooths zipper noise from quantized volume
; portk must remain rather fast to avoid 'sluggish response'
    iCps      cpsmidi                ;read in midi pitch in cycles-per-second
    iAmp      ampmidi 1              ;read in note velocity - re-range 0 to 1
    kVol      ctrl7   1,1,0,1        ;read in CC 1, chan. 1. Re-range from 0 to 1
    kPortTime linseg 0,0.005,0.01    ;create a value that quickly ramps up to .01
    kVol      portk   kVol,kPortTime ;create a filtered version of kVol
    ;kVol       portk   kVol        ;demonstrate issues of volume interp w/out very fast line @kPortTime
    aVol      interp  kVol           ;create an a-rate version of kVol
    aSig      poscil  iAmp*aVol,iCps,giSine
    ;aSig        poscil  iAmp*kVol, iCps, giSine
            out     aSig
endin

</CsInstruments>
<CsScore>
f 0 300 ;f loads new values into a function table --- how does this let midi through?
</CsScore>
<CsoundSynthesizer>