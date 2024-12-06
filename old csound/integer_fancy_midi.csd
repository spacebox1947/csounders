// 01-12-2023 used for coSYNE-23 [Jamuary]

<CsoundSynthesizer>
<CsOptions>
-Ma -odac -m128 -+rtaudio=jack -i adc -o dac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

giCos   ftgen    0, 0, 2^4, 11, 2 ; a cosine wave
         initc7   1,1,1        ; initialize controller to its maximum level

;kPartials[] init 7
;                   0, 81/80,   comma,  limma           81:64       792/512         16/9
;kPartials fillarray 1, 1.0125,  1.024,  1.053497942,    1.265625,   1.423828125,   1.77777778 


instr 1
    ; note partial data
    kPartialsNumerator[]      fillarray   1, 81, 128, 256, 81, 792, 16
    kPartialsDenomenator[]    fillarray   1, 80, 125, 243, 64, 512, 9
    iNum      notnum                   ; read in midi note number / 0 - 127
    iAHz = 220
    ;map to partials
    kNumMap = (kPartialsNumerator[iNum % 7] / kPartialsDenomenator[iNum % 7]) * ((iNum+1)/7) * iAHz

    ; input data
    kstatus, kchan, kdata1, kdata2  midiin            ;read in midi
    if kstatus!=0 then          ;if status byte is non-zero...
    ; -- print midi data to the terminal with formatting --
    printks "notein: %d HzOut: %f ratio: %d / %d%n", 
        0, iNum, kNumMap, kPartialsNumerator[iNum%7], kPartialsDenomenator[iNum%7]
    endif


    iAmp      ampmidi 0.1              ; read in note velocity - range 0 to 0.2
    kVol      ctrl7   1,1,0,1          ; read in CC 1, chn 1. Re-range from 0 to 1
    kPortTime linseg 0,0.001,0.01   ; create a value that quickly ramps up to 0.01
    kVol      portk   kVol, kPortTime  ; create filtered version of kVol
    aVol      interp  kVol             ; create an a-rate version of kVol.
    iRange    =       2                ; pitch bend range in semitones
    iMin      =       0                ; equilibrium position
    kPchBnd   pchbend iMin, 2*iRange   ; pitch bend in semitones (range -2 to 2)
    kPchBnd   portk   kPchBnd,kPortTime; create a filtered version of kPchBnd

    /* if iNum < 30 then
        iDur = (((((iNum * -1) + 30) + 1) / 30) * 4) + 4
    else
        iDur = (((((iNum * -1) + 120) + 1) / 120) * 8) + 8
    endif */

    iDur = birnd(.33) + 2.25

    aEnv      linsegr 0, 0.005, 1, iDur, 0  ; amplitude envelope with release stage
    ;aEnv      linsegr 0, 0.005, 1, 3, 0
    kMul      aftouch 0.4,0.85         ; read in aftertouch
    kMul      portk   kMul,kPortTime   ; create a filtered version of kMul
    ; create an audio signal using the 'gbuzz' additive synthesis opcode
    ;aSig      gbuzz   iAmp*aVol*aEnv, cpsmidinn(iNum+kPchBnd), 70, 0, kMul, giCos

    iDrift = rnd(1)

    aSigL      gbuzz   (1-iDrift)* iAmp*aVol*aEnv, kNumMap, 2, 0, kMul, giCos
    aSigR      gbuzz   (0+iDrift)* iAmp*aVol*aEnv, kNumMap, 2, 0, kMul, giCos

    
            outs     aSigL, aSigR           ; audio to output
            ;fout    "syne2.wav", 18, aSig, aSig ; write a soundfile
endin

</CsInstruments>

<CsScore>
</CsScore>
<CsoundSynthesizer>
;example by Iain McCurdy