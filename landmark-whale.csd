<CsoundSynthesizer>
<CsOptions>
    ;-Ma -odac -m128 -+rtaudio=jack -i adc -o dac
    --env:SSDIR+=./samples
    -o ice_cleat-landmark-testBEtA.wav -W ;;; for file output any platform
    ;-o dac
</CsOptions>
; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
<CsInstruments>

    sr = 88200
    ksmps = 32
    nchnls = 2
    0dbfs  = 1

    gSlandmark[] = fillarray(                 \
        "Bring-Cleats-FullClip.wav",        \   ; dur: 1m58.808
        "2024-11-28--Nearby-2.wav",         \   ; dur: 2m35.223
        "To Creekside Longer Crunch.wav",   \   ; dur: 3m10.423
        "To Creekside.wav",                 \   ; dur: 2m13.977
        "Creekside.wav",                    \   ; dur: 1m06.340
        "Ready_To_See_The_Whale_YEAH.wav",  \   ; dur: 14.656s
        "2024-11-28--Nearby.wav",           \   ; dur: 3m57.511
        "Creekside-2.wav")                      ; dur 1m02.709

    gaLandmark[] init 4

    instr Landmark
        /* Plays a SF as is */
        iSampleIndex = p4   ; only looks @ gSlandmark
        iAtkGain = p5       ; max Amps
        iAtkDur = p6        ; %p3 Dur
        iFadeDur = p7       ; %p3 Dur
        iPair = p8

        printks "Landmark Playing: %s :> %.2f s%n", p3, gSlandmark[iSampleIndex], p3
        printks "%tEnvelope: Atk %.2f @ %.2fs%tFade Dur.: %.2fs", p3, iAtkGain, iAtkDur*p3, iFadeDur*p3
        printks "%n", p3

        ;gaLandmark[] init 4
        ; ---- !! ---- everytime landmark is called, gaLandmark is replaced 
        ; ---- need to have a pair switching plan?
        ; ---- pair 0 puls [0, 1] and pair 1 pulls[2, 3]
        aLandmark[] diskin2 \
            gSlandmark[iSampleIndex], 1, 0, 1

        aEnv expseg 0.01, p3*iAtkDur, iAtkGain, p3-(p3*iAtkDur), iAtkGain
        aFade expseg 1, p3-(p3*iFadeDur), 1, p3*iFadeDur, 0.001

        ;gaLandmark[0] = aLandmark[0] * aEnv * aFade
        ;gaLandmark[1] = aLandmark[1] * aEnv * aFade
        gaLandmark[0+iPair] = aLandmark[0] * aEnv * aFade
        gaLandmark[1+iPair] = aLandmark[0] * aEnv * aFade
        ;outs gaLandmark[0]*aFade*aEnv, gaLandmark[1]*aFade*aEnv
    endin

    instr Spat2
        iOutputList = p4 ; which list does the sample come from?
        iOutputIndex = p5   ; which index in that list?-- does spat2 need this detail?
        iSpatStart = p6
        iSpatEnd = p7
        iSpatDur = p8
        iMasterdB = p10
        iPair = p9

        SoutputType[] = fillarray("Landmark", "Tasty", "Boogaloo", "Voice")
        SsampleName = gSlandmark[iOutputIndex]

        if iOutputList > 0 then
            printks "%tSpat2 >> Type: %s Samp: %s @ %.2fdB", p3, SoutputType[iOutputList], SsampleName, iMasterdB
            printks "%t%.2f :> %.2f @ %.2fs", p3, iSpatStart, iSpatEnd, p3*iSpatDur
            printks "%n%n", p3
        else
            printks "%tSpat2 >> Type: %s Samp: %s @ %.2fdB%t%.2f :> %.2f @ %.2fs", p3, SoutputType[iOutputList], SsampleName, iMasterdB
            printks "%n%n", p3
        endif

        if iOutputList == 1 then
            aInL = gaLandmark[0+iPair]
            aInR = gaLandmark[1+iPair]
        else    ; gaLandmark case
            aInL = gaLandmark[0+iPair]
            aInR = gaLandmark[1+iPair]

            aL = aInL
            aR = aInR
        endif
        outs aL*iMasterdB, aR*iMasterdB
    endin
</CsInstruments>

<CsScore>
/**/
    ; ---- LANDMARKS
        ; ---- Ice Cleats // Section A 118.808s
            i "Landmark"            \
                0   118.808         \   ; start, dur
                0                   \   ; sample # IceCleat Full clip
                1   0.01   0.03    \   ; atkAmps, atkDur, fadeDur
                0                       ; pair offet (0, or 2)
            i "Spat2"               \
                0   118.808         \   ; match landmark
                0   1   1           \   ; meainingless for landmark
                0   0   0   0.85        ; outList, outIdx, pair masterdB
        ; ---- Nearby // Section B 155.223s // Total 268.223
            i "Landmark"            \
                113     155.223     \   ; start, dur
                1                   \   ; sample # Nearby 2
                1   0.1   0.025     \   ; atkAmps, atkDur, fadeDur
                2                       ; pair offet (0, or 2)
            i "Spat2"               \
                113     155.223     \   ; start, dur
                0   1   1           \   ; spat meainingless for landmark
                0   1   2   0.8             ; outList, outIdx, masterdB
        ; ---- Crunching to creekside // Section C 190.423s // Total 454.423s
            i "Landmark"            \
                264     72          \   ; start, dur
                3                   \   ; sample # To Creekside
                1   0.015   0.01   \   ; atkAmps, atkDur, fadeDur
                0                       ; pair offet (0, or 2)
            i "Spat2"               \
                264     72          \   ; start, dur
                0   1   1           \   ; spat meainingless for landmark
                0   3   0   0.85            ; outList, outIdx, masterdB
        ; ---- @ Creekside // Section D 145s // total 468s 
        ; ---- !!-- This landmark ends before the section --!!
            i "Landmark"            \
                323     66.340      \   ; start, dur 
                7                   \   ; sample # @ Creekside
                0.9   0.09   0.019  \   ; atkAmps, atkDur, fadeDur
                2                       ; pair offet (0, or 2)
            i "Spat2"               \
                323     66.340      \   ; start, dur
                0   1   1           \   ; spat meainingless for landmark
                0   7   2   0.55            ; outList, outIdx, masterdB
        ; ---- YEAH!! // Coda 19.565s // total 485.565s
        ; ---- !!-- Pause between end of D and start of Coda --!!
            i "Landmark"            \
                471     14.565      \   ; start, dur 
                5                   \   ; sample # YEAH
                1   0.005   0.01    \   ; atkAmps, atkDur, fadeDur
                0                       ; pair offet (0, or 2)
            i "Spat2"               \
                471     14.565      \   ; start, dur
                0   1   1           \   ; spat meainingless for landmark
                0   5   0   0.9             ; outList, outIdx, masterdB
</CsScore>
</CsoundSynthesizer>