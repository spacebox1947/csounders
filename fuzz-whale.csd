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
    ; wave shaping
    /* 
        The cheb partials are mediocre, 
            - cheb2 seems broken in some way? entire clip becomes static value
            - cheb1, 4, 5 have minimal effect
        the sample as table has potential, but needs the right sample

    */
    giNat   ftgen 1, 0, 2049, -7, -1, 2048, 1   ; normal
    giDist  ftgen 2, 0, 2049, -7, -1, 1024, -.1, 0, .1, 1024, 1 ;extreme distortion, -.1 -> .1 can be decreased
    giCheb1 ftgen 3, 0, 513, 3, -1, 1, 0, 1 
    giCheb2 ftgen 4, 0, 513, 3, -1, 1, -1, 0, 2 ; weidly full clips at 1 for boogaloos? no sound on
    giCheb3 ftgen 5, 0, 513, 3, -1, 1, 0, 3, 0, 4
    giCheb4 ftgen 6, 0, 513, 3, -1, 1, 1, 0, 8, 0, 4
    giCheb5 ftgen 7, 0, 513, 3, -1, 1, 3, 20, -30, -60, 32, 48
    giYeah ftgen 8, 0, -79730, 1, "YEAH.wav", 0, 0, 1
    giLastWhale ftgen   9, 0, -97792, 1, "Not the Last Whale-Mono.wav", 0, 0, 1

    ; distortion tables
    ; ftgen: fn, p3 relative, size, GEN routine, n1 ... na args
    gi1 ftgen 10,   0,  257,    9,  \   ;sinoid (also the next)
        0.5,    1,  270 
    gi2 ftgen 11,   0,  257,    9,  \   ;sinoid, more partials
        0.5,    1,  270,    1.5,    0.33,   90, 2.5,    0.2,    270,    3.5,    0.143,  90
    gi3 ftgen 12,   0,  129,    7,  \   ; natural shaping -- how would it sound with 2x points in table?
        -1, 128,    1 
    gi4 ftgen 13,   0,  129,    10, \   ;sine with 1 partial
        1 
    /*
        Odd and even partials are very similar, but could highlight slight differences
        Half sine and complex sinoid does a very nice job with boomy fuzzstortion
        white noise takes a lot of amplitude, but produces a cool 'windy' effect
    */
    gi5 ftgen 14,   0,  129,    10, \   ;odd partials -- sounds nice so far
        1,  0,  1,  0,  1,  0,  1,  0,  1 
    gi6 ftgen 15,   0,  129,    10, \   ; even partials
        0,  1,  0,  1,  0,  1,  0,  1,  0
    gi7 ftgen 16,   0,  129,    21, \   ;white noise
        1 
    gi8 ftgen 17,   0,  129,    9,  \   ;half sine
        0.5,    1,  0
    gi9 ftgen 18,   0,  129,    7,  \   ;square wave
        1,  64, 1,  0,  -1, 64, -1 
    

    instr FuzzWhale
        iSampleArray = p4
        iSampleIndex = p5
        kSampSpeed = p6 ;Sample Pitch
        iAtkGain = p7   ;AS Atk Gain
        iAtkDur = p8    ;AS Atk Dur
        iSusGain = p9   ;AS Sus Gain
        iStart = p10    ; spat start
        iEnd = p11      ; spat end
        iDur = p12      ; % p3 dur
        iTable = p13    ; 1 = use limit glitchiness
        iMasterdB = p14  ;Master Gain Correction
        iStortStart = p15
        iStortEnd = p16

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
        printks "Intsr: SimpleDiskin Samp :> %s%n%tDur %d%tPitch %.2f%tMaster Amps:%.2f%n", p3, gSamp[iSampleIndex], p3, kSampSpeed, iMasterdB
        printks "%tAmps Envelope:%t%.2f :> %.2f @ %.2f%n", p3, iAtkGain, iSusGain, iAtkDur
        printks "%tSpatialize:%t%.2f :> %.2f @ %.2f%n%n", p3, iStart, iEnd, iDur

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

        ; distort
        /*
        I really enjoy the warm fuzziness of this. The parials (odd, even) and white noise seem to provide
        the best results for boogaloo and tasty ice. 
        Need to be rediculously careful of setting distortion % below .25, as amplitude spikes.
        It appears at 0 distortion, the source sound file plays louder than mastered. Not sure why.
        */
        kStort line iStortStart, p3, iStortEnd
        aDistL  distort aL, kStort, iTable
        aDistR  distort aR, kStort, iTable

        outs aDistL*aFade*iMasterdB, aDistR*aFade*iMasterdB
    endin

    instr RingWhale
        iSampleArray = p4
        iSampleIndex = p5
        kSampSpeed = p6 ;Sample Pitch
        iAtkGain = p7   ;AS Atk Gain
        iAtkDur = p8    ;AS Atk Dur
        iSusGain = p9   ;AS Sus Gain
        iStart = p10    ; spat start
        iEnd = p11      ; spat end
        iDur = p12      ; % p3 dur
        iRingHz = p13
        iRingEnd = p14
        iModeIndex = p15
        iPWM = p16
        iWetDry = p17
        iMasterdB = p18  ;Master Gain Correction


        iModes[] init 7
        iModes = fillarray(12, 10, 8, 6, 4, 2, 0)
        SModes[] init 7
        SModes = fillarray("Triangle", "Square Wave", "Integrated Sawtooth", "Pulse", "Saw Ramp", "PWM", "Sawtooth")

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
        printks "Intsr: SimpleDiskin Samp :> %s%n%tDur %d%tPitch %.2f%tMaster Amps:%.2f%n", p3, gSamp[iSampleIndex], p3, kSampSpeed, iMasterdB
        printks "%tAmps Envelope:%t%.2f :> %.2f @ %.2f%n", p3, iAtkGain, iSusGain, iAtkDur
        printks "%tSpatialize:%t%.2f :> %.2f @ %.2f%n", p3, iStart, iEnd, iDur
        printks "%tRing Mod: %s%t%.2f Hz :> %.2f Hz%t%.2f WetDry%t%.2f PWM%n", p3, SModes[iModeIndex], iRingHz, iRingEnd, iWetDry, iPWM
        printks "%n", p3

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

        ; ring mod simple
        /*
            Ring mod has lots of potential, but you would need to curate the
            significant signal loss of amplitude carefully

            low frequencies on an oscillator are smoothly chopped up (when using Poscil3)
            
            saw or PWm are probably best to replicate bad limiter opcode
            pulse will require LOTS of amp control
        */
        kHz     linseg  iRingHz, p3, iRingEnd
        if iPWM <= 0 then
            iPWM = 0.01
        elseif iPWM >= 1 then
            iPWM = 0.99
        endif 
        aMod    vco2    1, kHz, iModes[iModeIndex], iPWM
        aRML = aMod * aL 
        aRMR = aMod * aR

        ; > iWetDry = more processed signal
        iWet = iWetDry
        iDry = 1 - iWetDry
        aSigL = ((aRML*iWet) + (aL*iDry)) * iMasterdB * aFade
        aSigR = ((aRMR*iWet) + (aR*iDry)) * iMasterdB * aFade

        outs aSigL, aSigR
    endin


</CsInstruments>

<CsScore>
            /* i "FuzzWhale" \
                0   5              \
                2   3   .98           \
                1   0.125    .75     \
                0.25    0.25      .35     \
                14   1  \
                .75 .5
            i "FuzzWhale" \
                +   5              \
                2   3   .75           \
                1   0.125    .75     \
                0.25    0.25      .35     \
                14   1  \
                .25 .5
            i "FuzzWhale" \
                +   5              \
                2   3   .5           \
                1   0.125    .75     \
                0.25    0.25      .35     \
                14   1  \
                .5  .5
            i "FuzzWhale" \
                +   5              \
                2   3   .98           \
                1   0.125    .75     \
                0.25    0.25      .35     \
                16   1  \
                .75 .33
            i "FuzzWhale" \
                +   5              \
                2   3   1.25           \
                1   0.125    .75     \
                0.25    0.25      .35     \
                16   1  \
                .33 .47
            i "FuzzWhale" \
                +   5              \
                2   3   1.5           \
                1   0.125    .75     \
                0.25    0.25      .35     \
                16   1  \
                1   0 */
            i "RingWhale" \
                0   5                   \
                2   3   1               \
                1   1   1               \
                .5  .5  .5              \ 
                50  20   0  0.5         \ ; hz start, end, wavmode, pwm
                .5  1                   ; wetdry, masterDb

            i "RingWhale" \
                +   5                   \
                2   3   1               \
                1   1   1               \
                .5  .5  .5              \ 
                50  20   1  0.5         \ ; hz start, end, wavmode, pwm
                .5  1                   ; wetdry, masterDb
            i "RingWhale" \
                +   5                   \
                2   3   1               \
                1   1   1               \
                .5  .5  .5              \ 
                50  20   2  0.5         \ ; hz start, end, wavmode, pwm
                .5  1                   ; wetdry, masterDb
            i "RingWhale" \
                +   5                   \
                2   3   1               \
                1   1   1               \
                .5  .5  .5              \ 
                50  20   4  0.5         \ ; hz start, end, wavmode, pwm
                .5  1                   ; wetdry, masterDb

            i "RingWhale" \
                +   5                   \
                2   3   1               \
                1   1   1               \
                .5  .5  .5              \ 
                50  10   5  0.5         \ ; hz start, end, wavmode, pwm
                .5  1                   ; wetdry, masterDb
            i "RingWhale" \
                +   5                   \
                2   3   1               \
                1   1   1               \
                .5  .5  .5              \ 
                50  5   6  0.5         \ ; hz start, end, wavmode, pwm
                .5  1                   ; wetdry, masterDb
            
            
</CsScore>
</CsoundSynthesizer>