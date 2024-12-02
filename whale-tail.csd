<CsoundSynthesizer>
<CsOptions>
    ;-Ma -odac -m128 -+rtaudio=jack -i adc -o dac
    --env:SSDIR+=./samples
    ; Select audio/midi flags here according to platform
    ; -odac     ;;;realtime audio out
    ;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
    ; For Non-realtime ouput leave only the line below:
    -o ice_cleat-test-10.wav -W ;;; for file output any platform
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

    ; longer organizing clips
        gS_file1 = "Bring-Cleats-FullClip.wav"          ; BringCleats       dur: 1m58.808
        gS_file2 = "2024-11-28--Nearby.wav"             ; Nearby            dur: 3m57.511
        gS_file3 = "To Creekside Longer Crunch.wav"     ; to creekside      dur: 3m10.423
        gS_file4 = "To Creekside.wav"                   ; to creekside      dur: 2m13.977
        gS_file5 = "Creekside.wav"                      ; creekside         dur: 1m06.340
        gS_file6 = "Ready_To_See_The_Whale_YEAH.wav"    ; You ready? full   dur: 14.656s
        gS_file7 = "2024-11-28--Nearby-2.wav"           ; dur: 2m35.223
    
    ; four to five boogaloos
    gS_boogaloo1 = "Boogaloo-1.wav"             ; dur 1m08.542
    gS_boogaloo2 = "Boogaloo-2.wav"             ; dur 1m37.767
    gS_boogaloo3 = "Boogaloo-3-Mouth.wav"       ; dur: 27.581
    gS_boogaloo4 = "Boogaloo-4.wav"             ; dur: 42.956
    gS_boogaloo5 = "Boogaloo-5.wav"             ; dur 56.806
    gS_boogaloo6 = ""

    ; four or five tasty crunches
    gS_tasty1 = "Tasty_Ice_Crunch-1.wav"        ; dur: 19.953
    gS_tasty2 = "Tasty_Ice_Crunch-2.wav"        ; dur: 11.680
    gS_tasty3 = "Tasty_Ice_Crunch-3.wav"        ; dur: 1m03.751
    gS_tasty4 = "Tasty_Ice_Crunch-4.wav"        ; dur: 1m13.152
    gS_tasty5 = ""
    gS_tasty6 = ""

    ; voice samples == 1
        gS_voice1 = "IceCleats.wav"
        gS_voice2 = "InWinter.wav"
        gS_voice3 = "Planes and Cough Full Clip.wav"    ; done      dur: 10.600
        gS_voice4 = "Planes Full.wav"                   ; done      dur: 6.653
        gS_voice5 = "Not the last Whale.wav"            ; done      dur: 2.218
        gS_voice6 = "Falling Outta the Sky.wav"          ; done      dur: 4.400
        gS_voice7 = "Ready.wav"                         ; done      dur: 2.084
        gS_voice8 = "YEAH.wav"                          ; done      dur: 1.808
        gS_voice9 = "Dead Right.wav"                    ; done      dur: 1.616
    
    ; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

    instr SimpleDiskin
        /* Plays a stereo sample with a relative envelope */
        iSampleArray = p4
        iSampleIndex = p5
        kSampSpeed = p6 ;Sample Pitch
        iAtkGain = p7   ;AS Atk Gain
        iAtkDur = p8    ;AS Atk Dur
        iSusGain = p9   ;AS Sus Gain
        iMasterdB = p10  ;Master Gain Correction

        gSamp[] init 8      ; longest group of files - 1
        if iSampleArray == 1 then   ; voice clips
            gSamp fillarray gS_voice1, gS_voice2, gS_voice3, gS_voice4, gS_voice5, gS_voice6, gS_voice7, gS_voice8, gS_voice9
        elseif iSampleArray == 2 then
            gSamp fillarray gS_boogaloo1, gS_boogaloo2, gS_boogaloo3, gS_boogaloo4, gS_boogaloo5, gS_boogaloo6
        elseif iSampleArray == 3 then
            gSamp fillarray gS_tasty1, gS_tasty2, gS_tasty3, gS_tasty4, gS_tasty5, gS_tasty6
        else
            gSamp fillarray gS_file1, gS_file2, gS_file3, gS_file4, gS_file5, gS_file6, gS_file7
        endif
        
        ; cli print stuff
        printks "Intsr: SimpleDiskin Samp :> %s%n%tDur %d%tPitch %f%tMaster Amps:%f%n", p3, gSamp[iSampleIndex], p3, kSampSpeed, iMasterdB
        printks "%tAmps Envelope:%t%f :> %f @ %f%n", p3, iAtkGain, iSusGain, iAtkDur

        aEnvL linseg 0, \
            p3*iAtkDur, iAtkGain, \
            p3-(p3*iAtkDur), iSusGain

        aEnvR linseg 0, \
            p3*iAtkDur, iAtkGain, \
            p3-(p3*iAtkDur), iSusGain

        aFade linseg 1, p3*0.99, 1, p3*0.01, 0

        aL, aR diskin \
            gSamp[iSampleIndex], kSampSpeed, 0, 1

        outs aL*aEnvL*iMasterdB*aFade, aR*aEnvR*iMasterdB*aFade
    endin

    instr SpatLimit
        iSampleArray = p4
        iSampleIndex = p5
        kSampSpeed = p6 ;Sample Pitch
        iAtkGain = p7   ;AS Atk Gain
        iAtkDur = p8    ;AS Atk Dur
        iSusGain = p9   ;AS Sus Gain
        iStart = p10    ; spat start
        iEnd = p11      ; spat end
        iDur = p12      ; % p3 dur
        iLimit = p13    ; 1 = use limit glitchiness
        iMasterdB = p14  ;Master Gain Correction

        gSamp[] init 8      ; longest group of files - 1
            if iSampleArray == 1 then   ; voice clips
                gSamp fillarray gS_voice1, gS_voice2, gS_voice3, gS_voice4, gS_voice5, gS_voice6, gS_voice7, gS_voice8, gS_voice9
            elseif iSampleArray == 2 then
                gSamp fillarray gS_boogaloo1, gS_boogaloo2, gS_boogaloo3, gS_boogaloo4, gS_boogaloo5, gS_boogaloo6
            elseif iSampleArray == 3 then
                gSamp fillarray gS_tasty1, gS_tasty2, gS_tasty3, gS_tasty4, gS_tasty5, gS_tasty6
            else
                gSamp fillarray gS_file1, gS_file2, gS_file3, gS_file4, gS_file5, gS_file6, gS_file7
            endif
        
        ; cli print stuff
        printks "Intsr: SimpleDiskin Samp :> %s%n%tDur %d%tPitch %f%tMaster Amps:%f%n", p3, gSamp[iSampleIndex], p3, kSampSpeed, iMasterdB
        printks "%tAmps Envelope:%t%f :> %f @ %f%n", p3, iAtkGain, iSusGain, iAtkDur
        printks "%tSpatialize:%t%f :> %f @ %f%n%n", p3, iStart, iEnd, iDur

        aEnv linseg 0, \
            p3*iAtkDur, iAtkGain, \
            p3-(p3*iAtkDur), iSusGain

        aPan linseg 0, \
            p3*iDur, iStart, \
            p3-(p3*iDur), iEnd

        aFade linseg 1, p3*0.99, 1, p3*0.01, 0

        aSamp[] diskin \
            gSamp[iSampleIndex], kSampSpeed, 0, 1

        ; stero -> mono
        aS = (aSamp[0]+aSamp[1])*0.5

        aL, aR pan2 aS, aPan

        if (iLimit > 0) then
            aSigL limit aL, 0, 1
            aSigR limit aR, 0, 1
            outs aSigL*iMasterdB*aFade, aSigR*iMasterdB*aFade
        else
            outs aL*iMasterdB*aFade, aR*iMasterdB*aFade
        endif
    endin

    instr SpatButter
        iSampleArray = p4
        iSampleIndex = p5
        kSampSpeed = p6 ;Sample Pitch
        iAtkGain = p7   ;AS Atk Gain
        iAtkDur = p8    ;AS Atk Dur
        iSusGain = p9   ;AS Sus Gain
        iStart = p10    ; spat start
        iEnd = p11      ; spat end
        iDur = p12      ; % p3 dur
        iBpHz = p13  ; butbp Hz
        iBandStart = p14    ;butbp start bandwidth
        iBandEnd = p15      ; but bp end bandwidth
        iBandDur =  p16     ; % p3 dur
        iMasterdB = p17  ;Master Gain Correction

        gSamp[] init 8      ; longest group of files - 1
            if iSampleArray == 1 then   ; voice clips
                gSamp fillarray gS_voice1, gS_voice2, gS_voice3, gS_voice4, gS_voice5, gS_voice6, gS_voice7, gS_voice8, gS_voice9
            elseif iSampleArray == 2 then
                gSamp fillarray gS_boogaloo1, gS_boogaloo2, gS_boogaloo3, gS_boogaloo4, gS_boogaloo5, gS_boogaloo6
            elseif iSampleArray == 3 then
                gSamp fillarray gS_tasty1, gS_tasty2, gS_tasty3, gS_tasty4, gS_tasty5, gS_tasty6
            else
                gSamp fillarray gS_file1, gS_file2, gS_file3, gS_file4, gS_file5, gS_file6, gS_file7
            endif
        
        ; cli print stuff
        printks "Intsr: SimpleDiskin Samp :> %s%n%tDur %d%tPitch %f%tMaster Amps:%f%n", p3, gSamp[iSampleIndex], p3, kSampSpeed, iMasterdB
        printks "%tAmps Envelope:%t%f :> %f @ %f%n", p3, iAtkGain, iSusGain, iAtkDur
        printks "%tSpatialize:%t%f :> %f @ %f%n", p3, iStart, iEnd, iDur
        printks "%tButter BP Filter: %t%fHz%t%f :> %f @ %f%n%n", p3, iBpHz, iBandStart, iBandEnd, iBandDur

        aEnv linseg 0, \
            p3*iAtkDur, iAtkGain, \
            p3-(p3*iAtkDur), iSusGain

        aPan linseg 0, \
            p3*iDur, iStart, \
            p3-(p3*iDur), iEnd

        

        aFade linseg 1, p3*0.99, 1, p3*0.01, 0

        aSamp[] diskin \
            gSamp[iSampleIndex], kSampSpeed, 0, 1

        ; stero -> mono
        aS = (aSamp[0]+aSamp[1])*0.5

        kBand linseg iBandStart, p3*iBandDur, iBandEnd

        aFiltered butbp aS, iBpHz, kBand
        aFiltered2 butbp aS, iBpHz*2, kBand*0.5
        aFiltered3 butbp aS, iBpHz*2.5, kBand*0.25
        aFiltered4 butbp aS, iBpHz*5.0*0.25, kBand*0.125 ; 5/4 ratio
        aFiltered5 butbp aS, iBpHz*6.0*0.2, kBand*0.075 ; 6 / 5 ratio

        aL, aR pan2 aFiltered+(aFiltered2*0.5)+(aFiltered3*0.25)+(aFiltered4*0.125)+(aFiltered5*0.075), aPan

            outs aL*iMasterdB*aFade, aR*iMasterdB*aFade
    endin
</CsInstruments>

<CsScore>
/**/
    ; ---- LANDMARK SOUNDWALK ----
        ; ---- Bring Cleats
        ; ice cleats quote @ 35ish seconds
        i "SimpleDiskin" \          ; section A, Ice Cleat BG
            0   118.808             \ ; start, dur
            0   0   1               \  ; array, index, sample speed
            0.98    0.007    0.85   \ ; atk, dur, sus
            1

        ; -- A = 119 s / 2 mins
        ; ---- Nearby
        i "SimpleDiskin" \          ; section B, nearby Quietude, starts -5 before A ends
            113 155.223             \ ; start, dur 2m35.223 155.223
            0   6   1               \ ; array, index, kSampSpeed
            0.98    0.0025  0.85    \ ; atk, dur, sus
            1                       ; is very quiet @ 1, maybe a 2?

        ; -- A+B = 351.319 s / 6 mins
        ; ---- Crunching to Creekside
        i "SimpleDiskin" \          ; section C, crunching to creekside, starts -10 before B ends
            264 190.423             \   ; creekside starts @ -60ish full dur 190.423
            0   2   1               \
            0.98    0.007   0.85    \
            1

        ; -- A+B+C
        ; ---- At Creekside
        i "SimpleDiskin" \          ; section D, at the creekside
            323 66.340              \ ; 66.340 is sample dur
            0   4   1               \
            1   0.25   0.9         \
            0.6
        ; -- A+B+C+D = 550ish s / 9 mins
        ; ---- Ready to see the whale??? YEAH
        i "SimpleDiskin" \          ; section E, Coda. YEAH. 4 seconds after d
            468 14.565              \
            0   5   1               \
            1   0.005   1           \
            0.9

    ; Nearby Additions B Section 113 - 351
    ; Dog Lick It + Baby Glitchy
        ; start at least 75 seconds into B
        ; 68.542
        i "SpatLimit" \
            180   68.542              \
            2   0   1           \
            1   .125    .75     \
            1   .75  .5           \
            0   .75   

        ; fuzz 1 right
            i "SpatLimit" \
                183   34              \
                2   1   .99           \
                1   .125    .65     \
                1   .6       .67     \
                1   .5   
            i "SpatLimit" \
                186   34              \
                2   1   1.01           \
                1   .125    .65     \
                .75   1       .67     \
                1   .5

    ; int its mouth
        ; 17+45 = 62
        ; start at least 75 seconds into B, after dog lick
        i "SpatLimit" \
            200   27.581              \ ;duration is 27.581
            2   2   1           \
            1   .125    .75     \
            0   .25  .5           \
            0   1
        i "SpatLimit" \
            218     70  \
            2   4   1   \
            1   .9  .9  \
            1   0.75    .5  \
            0   1

        ; fuzz limit 2
            i "SpatLimit" \
                206   45              \
                2   3   .99           \
                1   .125    .65     \
                .6  1       .67     \
                1   .75   
            i "SpatLimit" \
                209   45              \
                2   3   1.01           \
                1   .125    .65     \
                .25   0       .67     \
                1   .75

            ; fuzz limit 3
            i "SpatLimit" \
                220   45              \
                2   4   .98           \
                1   0.125    .75     \
                0.6    0.8      .35     \
                1   .75   
            i "SpatLimit" \
                220   45              \
                2   4   1.02           \
                1   0.125    .75     \
                0.8     0.6    .35     \
                1   .75

    ; ----> C Section Walking to Creekside
        ; Planes and SHit Quote
        i "SimpleDiskin" \
            265     10.6   \
            1   2   1       \
            .9   1  0.0325  \
            1   

        ; fuzz limit 4 tasty
            i "SpatLimit" \
                275   45              \
                3   2   .98           \
                1   0.125    .75     \
                0.25    0.25      .35     \
                1   .75   
            i "SpatLimit" \
                275   45              \
                3   3   1.02           \
                1   0.125    .75     \
                0.75    0.75    .35     \
                1   .75


    ; ----> D Side At Creek Side 425 - 545 DONE
        ; Pair Right
            i "SpatButter" \
                352 66.340      \
                0   4   1.25     \   ; array sample speed
                .75   .9    .65 \
                .75 1   0.5     \   ; spat
                2000    1000    500     0.5 \ ; hz sart end dur
                1

            i "SpatButter" \
                355 66.340      \
                0   4   2     \   ; array sample speed
                .75   .9    .95 \
                .5 1   0.5     \   ; spat
                2000    500    125     0.35 \ ; hz sart end dur
                1
        ; pair Left
            i "SpatButter" \
                360 70      \
                0   4   1.25     \   ; array sample speed
                .75   .9    .65 \
                0.25    0   0.5     \   ; spat
                2025    800    330     0.25 \ ; hz sart end dur
                1
            i "SpatButter" \
                370 70      \
                0   4   2     \   ; array sample speed
                .75   .9    .85 \
                0.5     0   0.5     \   ; spat
                2025    400    95     0.55 \ ; hz sart end dur
                1
        ; Pair Right 2
            i "SpatButter" \
                372 70      \
                0   4   1.25     \   ; array sample speed
                .75   .9    .65 \
                1   0.25   0.5     \   ; spat
                2000    750    250     0.5 \ ; hz sart end dur
                1
            i "SpatButter" \
                378 70      \
                0   4   2     \   ; array sample speed
                .75   .9    .95 \
                .9  0.4   0.75     \   ; spat
                2000    400    75     0.65 \ ; hz sart end dur
                1
        ; pitchy center
            i "SpatButter" \
                398 40      \
                0   4   1.75     \   ; array sample speed
                .75   .9    .65 \
                0.75    0.25   0.75     \   ; spat
                3073.2    200    35     0.45 \ ; hz sart end dur
                .75
            i "SpatButter" \
                413 40      \
                0   4   2     \   ; array sample speed
                .75   .9    .85 \
                0.5     0.75   0.55     \   ; spat
                3111.4    225    25     0.3 \ ; hz sart end dur
                .75
        ; pair Left 2
            i "SpatButter" \
                390 70      \
                0   4   1.25     \   ; array sample speed
                .75   .9    .65 \
                0.125    0.6   0.5     \   ; spat
                2025    450    175     0.25 \ ; hz sart end dur
                1
            i "SpatButter" \
                395 70      \
                0   4   2     \   ; array sample speed
                .75   .9    .85 \
                0     0.75   0.55     \   ; spat
                2025    250    45     0.75 \ ; hz sart end dur
                1
        ; low boy7
            i "SpatButter" \
                408 35      \
                0   4   0.125     \   ; array sample speed
                .125   .8    .65 \
                0.5     0.5   0.5     \   ; spat
                125    100    40     0.35 \ ; hz sart end dur
                0.25
</CsScore>
</CsoundSynthesizer>