<CsoundSynthesizer>
<CsOptions>
    -Ma -odac -m128 -+rtaudio=jack -i adc -o dac
    --env:SSDIR+=./samples
    ; Select audio/midi flags here according to platform
    ; -odac     ;;;realtime audio out
    ;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
    ; For Non-realtime ouput leave only the line below:
    ;-o ice_cleat-test-10.wav -W ;;; for file output any platform
    ;-o dac
    ; https://csound.com/docs/manual/loscil3.html
</CsOptions>

; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

<CsInstruments>

    ; bifurcated from code by Menno Knevel 2022
    sr = 88200
    ksmps = 32
    nchnls = 2
    0dbfs  = 1

instr 1
    knh linseg  12, p3, 1
    gares buzz 1, 500, knh, 1
endin

instr 3
    ;gaSamp[] diskin "YEAH.wav", 1, 0, 1
    gaSamp[] diskin "Tasty_Ice_Crunch-1.wav", 1, 0, 1
endin

instr 2
    kHz linseg p4, p3, p4+(p4*.5)
    iHz = p4

    kBand linseg p5, p3, p6
    ;afilt butbp gares, kHz, kBand
    afilt[] init 2
    afilt[0] butbp gaSamp[0], kHz, kBand
    afilt[1] butbp gaSamp[1], kHz*1.5, kBand
    aL = afilt[0]*p7
    aR = afilt[1]*p7
    outs aL, aR
endin

</CsInstruments>
<CsScore>
f 1 0 16384 10 1

i 3 0 22
/* i 2 0 5 \
    1000 50 25 0.5
i 2 0 5 \
    500 50 125 0.5
    /*
        Instr 2 calls the global a value of 1
        while 1 is playing, 2 produces sound.
    */
i 2 3 5 \
    2000 500 400 0.4 */

i 2 0 3 150	50	50 0.125
i 2 1 3 250	50	49 0.125
i 2 2 3 350	50	48 0.125
i 2 3 3 450	50	47 0.125
i 2 4 3 550	50	46 0.125
i 2 5 3 650	50	45 0.125
i 2 6 3 750	50	44 0.125
i 2 7 3 850	50	43 0.125
i 2 8 3 950	50	42 0.125
i 2 9 3 1050	50	41 0.125
i 2 10 3 1150	50	40 0.125
i 2 11 3 1250	50	39 0.125
i 2 12 3 1350	50	38 0.125
i 2 13 3 1450	50	37 0.125
i 2 14 3 1550	50	36 0.125
i 2 15 3 1650	50	35 0.125
i 2 16 3 1750	50	34 0.125
i 2 17 3 1850	50	33 0.125
i 2 18 3 1950	50	32 0.125
i 2 19 3 2050	50	31 0.125

</CsScore>

</CsoundSynthesizer>