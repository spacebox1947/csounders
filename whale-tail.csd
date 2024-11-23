<CsoundSynthesizer>
<CsOptions>
    -Ma -odac -m128 -+rtaudio=jack -i adc -o dac
    --env:SSDIR+=./samples
    ; Select audio/midi flags here according to platform
    ; -odac     ;;;realtime audio out
    ;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
    ; For Non-realtime ouput leave only the line below:
    ; -o loscil3.wav -W ;;; for file output any platform
    ; https://csound.com/docs/manual/loscil3.html
</CsOptions>

; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

<CsInstruments>

    ; bifurcated from code by Menno Knevel 2022
    sr = 88200
    ksmps = 32
    nchnls = 2
    0dbfs  = 1

    giFt1    ftgen    1, 0, 0, 1, "2023_07_24_22_04_54 Indiana Storms.wav", 0, 0, 0
    giFt2    ftgen    2, 0, 0, 1, "2023_07_24_22_04_54 Indiana Storms_bugs1.wav", 0, 0, 0
    giFt3   ftgen   3, 0, 0, 1, "2024-11-20-Whale-Adventure--Bring-Cleats-Clip.wav", 0, 0, 0

    gS_file1 = "2023_07_24_22_04_54 Indiana Storms.wav"
    gS_file2 = "2023_07_24_22_04_54 Indiana Storms_bugs1.wav"
    gS_file3 = "2024-11-20-Whale-Adventure--Bring-Cleats-Clip.wav"


    ;massign 1,4
    ; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

    instr SimpleDiskin
        ;p4 Sample Pitch
        ;p5 AS Atk Gain
        ;p6 AS Atk Dur
        ;p7 AS Sus Gain
        ;p8 Master Gain Correction

        printks "Intsr: SimpleDiskin%tDur %d%tPitch %f%tMaster Amps:%f%n", p3, p4, p8
        printks "%tAmps Envelope:%t%f :> %f @ %f%n%n", p3, p5, p6, p7

        aEnvL linseg 0, \
            p6, p5, \
            p3-p5, p7

        aEnvR linseg 0, \
            p6, p5, \
            p3-p5, p7

        aL, aR diskin \
            gS_file3,   p4,       0,       1
            ;fn,        kPitch,  iSkip,   iWrap

        outs aL*aEnvL*p8, aR*aEnvR*p8
    endin

    instr SwellStereo
        /* pDoc
            ;p1 = instrument
            ;p2 = time offset
            ;p3 = duration
            ; ---- sampler
            ;p4 = sampler pitch (standard: 1)
            ; ---- AD envelope
            ;p5 = envelope peak
            ;p6 = envelope sustain
            ;p7 = envelope attack dur in %
            ; --- spatialize
            ;p8 = spat start
            ;p9 = spat end
            ;p10 = spat 'rise' in %
            ; --- limit-glitch
            ;p11 1 on 0 off
            ; --- master
            ;p12 master amps
        */
        aEnv linseg 0, \
            p3*p7, p5, \
            p3-(p3*p7), p6

        aPan linseg 0, \
            p3*p10, p8, \
            p3-(p3*p10), p9

        aSamp[] diskin \
            gS_file3, p4, 0, 1

        ; stero -> mono
        aS = (aSamp[0]+aSamp[1])*0.5

        aL, aR pan2 aS, aPan

        if (p11 > 0) then
            aSigL limit aL, 0, 1
            aSigR limit aR, 0, 1
            outs aSigL*p12, aSigR*p12
        else
            outs aL*p12, aR*p12
        endif
    endin
</CsInstruments>
<CsScore>
    ; ice cleats quote @ 35ish seconds
    i "SimpleDiskin" \
        0   65  1    \
        0.98    0.05    0.85 \
        0.5

    i "SwellStereo" \
        35  45      2       \
        0.9 0.05    0.85    \ ; amp env
        1   0.9     0       \ ; spat line
        1   0.5             ; limiter on, master amps

</CsScore>
</CsoundSynthesizer>