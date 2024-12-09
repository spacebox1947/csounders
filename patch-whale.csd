<CsoundSynthesizer>
<CsOptions>
    ;-Ma -odac -m128 -+rtaudio=jack -i adc -o dac
    ;-+rtaudio=jack -i adc -o dac
    --env:SSDIR+=./samples
    -o busy-fuzz-3.wav -W ;;; for file output any platform
    ;-o dac
</CsOptions>
; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
/*
    Discovered several issues in the file.
    It appears that using Mixer and vbap or pan (4) does not work.
    outch also fails. 
*/
; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
<CsInstruments>

    sr = 88200
    ksmps = 32
    nchnls = 4
    0dbfs  = 1

    vbaplsinit 2, 4, 0, 90, 180, -90

    ; Bpass arrays
        giBpUpAmps[] = fillarray(1, 0.5, 0.25, 0.125, 0.09, 0.06, 0.03)
        giBpUpPartial[] = fillarray(1, 2, 1.5, 3, 3.125, 3.25, 4.08)
        giBpDownAmps[] = fillarray(0.03, 0.06, 0.09, 0.125, 0.25, 0.5, 1)
        giBpClusterAmps[] = fillarray(.5, 0.25, 0.25, 0.125, 0.125, 0.09, 0.09)
        giBpClusterPartial[] = fillarray(1, 2.083, 0.917, 1.375, 1.1875, 1.44, 0.72)

    ; Fuzz ftables
        gi5 ftgen 1,   0,  129,    10, \   ;odd partials -- sounds nice so far
            1,  0,  1,  0,  1,  0,  1,  0,  1 
        gi6 ftgen 2,   0,  129,    10, \   ; even partials
            0,  1,  0,  1,  0,  1,  0,  1,  0
        gi7 ftgen 3,   0,  129,    21, \   ;white noise
            1 
        gi8 ftgen 4,   0,  129,    9,  \   ;half sine
            0.5,    1,  0
        gi9 ftgen 5,   0,  129,    7,  \   ;square wave
            1,  64, 1,  0,  -1, 64, -1 
        gSFuzzNames[] = fillarray("Odd Partials", "Even Partials", "White Noize", "Half Sine", "Square Wave")

    gSlandmark[] = fillarray(                 \
        "Bring-Cleats-FullClip.wav",        \   ; dur: 1m58.808
        "2024-11-28--Nearby-2.wav",         \   ; dur: 2m35.223
        "To Creekside Longer Crunch.wav",   \   ; dur: 3m10.423
        "To Creekside.wav",                 \   ; dur: 2m13.977
        "Creekside.wav",                    \   ; dur: 1m06.340
        "Ready_To_See_The_Whale_YEAH.wav",  \   ; dur: 14.656s
        "2024-11-28--Nearby.wav",           \   ; dur: 3m57.511
        "Creekside-2.wav")                      ; dur 1m02.709
    
    gSboogaloo[] = fillarray(               \   ; dur 1m08.542
        "Boogaloo-1.wav",                   \   ; dur 1m37.767
        "Boogaloo-2.wav",                   \   ; dur: 27.581
        "Boogaloo-3-Mouth.wav",             \   ; dur: 42.956
        "Boogaloo-4.wav",                   \   ; dur 56.806
        "Boogaloo-5.wav")

    ; ---- Sample Readers ----
        instr 100 ;Landmark 100
            /* Plays a SF as is */
            iSelf = 100
            iSampleIndex = p4   ; only looks @ gSlandmark
            iAtkGain = p5       ; max Amps
            iAtkDur = p6        ; %p3 Dur
            iFadeDur = p7       ; %p3 Dur
            iBus = p8           ; instrument receiving this instrument
            iChannel = p9   ; channel on iBus receiving this instrument

            printks "Landmark Playing: %s :> %.2f s%n", p3, gSlandmark[iSampleIndex], p3
            printks "%tEnvelope: Atk %.2f @ %.2fs%tFade Dur.: %.2fs%n", p3, iAtkGain, iAtkDur*p3, iFadeDur*p3
            printks "%t%t!! Sending Self to %d::%d,%d%n", p3, iBus, iChannel, iChannel+1
            printks "%n", p3

            aLandmark[] diskin2 \
                gSlandmark[iSampleIndex], 1, 0, 1

            aEnv expseg 0.01, p3*iAtkDur, iAtkGain, p3-(p3*iAtkDur), iAtkGain
            aFade expseg 1, p3-(p3*iFadeDur), 1, p3*iFadeDur, 0.001

            ; each effect needs it own mapping ... :/
            ; single mapped signal
            MixerSetLevel iSelf, iBus, 1
            MixerSend aLandmark[0], iSelf, iBus, iChannel
            MixerSend aLandmark[1], iSelf, iBus, iChannel+1
        endin

        instr 110 ;Sampler 110
            /* Plays a SF as is */
            iSelf = 110
            iSampleIndex = p4   ; only looks @ gSlandmark
            iSampleSpeed = p5
            iSampleOffset = p6
            iAtkGain = p7       ; max Amps
            iAtkDur = p8        ; %p3 Dur
            iFadeDur = p9       ; %p3 Dur
            iBus = p10           ; instrument receiving this instrument
            iChannel = p11   ; channel on iBus receiving this instrument

            printks "Sampler Playing: %s @ %.2f rate @ %.2fs Offset :> %.2f s%n", p3, gSlandmark[iSampleIndex], iSampleSpeed, iSampleOffset, p3
            printks "%tEnvelope: Atk %.2f @ %.2fs%tFade Dur.: %.2fs%n", p3, iAtkGain, iAtkDur*p3, iFadeDur*p3
            printks "%t%t!! Sending Self to %d::%d,%d%n", p3, iBus, iChannel, iChannel+1
            printks "%n", p3

            aLandmark[] diskin2 \
                gSlandmark[iSampleIndex], iSampleSpeed, iSampleOffset, 1

            kEnv expseg 0.01, p3*iAtkDur, iAtkGain, p3-(p3*iAtkDur), iAtkGain
            kFade linseg 1, p3-(p3*iFadeDur), 1, p3*iFadeDur, 0

            ; each effect needs it own mapping ... :/
            ; single mapped signal
            MixerSetLevel iSelf, iBus, kFade*kEnv
            MixerSend aLandmark[0], iSelf, iBus, iChannel
            MixerSend aLandmark[1], iSelf, iBus, iChannel+1
        endin

        instr 111 ;Sampler 111
            /* Plays a SF as is */
            iSelf = 111
            iSampleIndex = p4   ; only looks @ gSlandmark
            iSampleSpeed = p5
            iSampleOffset = p6
            iAtkGain = p7       ; max Amps
            iAtkDur = p8        ; %p3 Dur
            iFadeDur = p9       ; %p3 Dur
            iBus = p10           ; instrument receiving this instrument
            iChannel = p11   ; channel on iBus receiving this instrument

            printks "Sampler Playing: %s @ %.2f rate @ %.2fs Offset :> %.2f s%n", p3, gSlandmark[iSampleIndex], iSampleSpeed, iSampleOffset, p3
            printks "%tEnvelope: Atk %.2f @ %.2fs%tFade Dur.: %.2fs%n", p3, iAtkGain, iAtkDur*p3, iFadeDur*p3
            printks "%t%t!! Sending Self to %d::%d,%d%n", p3, iBus, iChannel, iChannel+1
            printks "%n", p3

            aLandmark[] diskin2 \
                gSlandmark[iSampleIndex], iSampleSpeed, iSampleOffset, 1

            kEnv expseg 0.01, p3*iAtkDur, iAtkGain, p3-(p3*iAtkDur), iAtkGain
            kFade linseg 1, p3-(p3*iFadeDur), 1, p3*iFadeDur, 0

            ; each effect needs it own mapping ... :/
            ; single mapped signal
            MixerSetLevel iSelf, iBus, kFade*kEnv
            MixerSend aLandmark[0], iSelf, iBus, iChannel
            MixerSend aLandmark[1], iSelf, iBus, iChannel+1
        endin

        instr 115 ;Sampler 115 Boogaloo
            /* Plays a SF as is */
            iSelf = 115
            iSampleIndex = p4   ; only looks @ gSboogaloo
            iSampleSpeed = p5
            iSampleOffset = p6
            iAtkGain = p7       ; max Amps
            iAtkDur = p8        ; %p3 Dur
            iFadeDur = p9       ; %p3 Dur
            iBus = p10           ; instrument receiving this instrument
            iChannel = p11   ; channel on iBus receiving this instrument

            if iSampleIndex > 4 then
                iSampleIndex = 4
            endif

            printks "Sampler Playing: %s @ %.2f rate @ %.2fs Offset :> %.2f s%n", p3, gSboogaloo[iSampleIndex], iSampleSpeed, iSampleOffset, p3
            printks "%tEnvelope: Atk %.2f @ %.2fs%tFade Dur.: %.2fs%n", p3, iAtkGain, iAtkDur*p3, iFadeDur*p3
            printks "%t%t!! Sending Self to %d::%d,%d%n", p3, iBus, iChannel, iChannel+1
            printks "%n", p3

            aLandmark[] diskin2 \
                gSboogaloo[iSampleIndex], iSampleSpeed, iSampleOffset, 1

            kEnv expseg 0.01, p3*iAtkDur, iAtkGain, p3-(p3*iAtkDur), iAtkGain
            kFade linseg 1, p3-(p3*iFadeDur), 1, p3*iFadeDur, 0

            ; each effect needs it own mapping ... :/
            ; single mapped signal
            MixerSetLevel iSelf, iBus, kFade*kEnv
            MixerSend aLandmark[0], iSelf, iBus, iChannel
            MixerSend aLandmark[1], iSelf, iBus, iChannel+1
        endin

    ; ---- Filters ----
        instr 200 ; butbp up [2FILT]
            ; 7 partials, decreasing amps, increasing hz
            iSelf = 200
            iHz = p4
            iBandStart = p5
            iBandEnd = p6
            iBandDur = p7
            iBusIn = p8
            iBusOut = p9
            iChannel = p10

            printks "%tbutbp UpHz DownAmps: %.2fHz%t%.2f :> %.2f Bands @ %.2fs%n", p3, iHz, iBandStart, iBandEnd, iBandDur*.3
            printks "%t%t!! Sending Self from %d to %d::%d,%d%n", p3, iBusIn, iBusOut, iChannel, iChannel+1
            printks "%n", p3

            kGainIn MixerGetLevel iBusIn, iSelf
            aInA MixerReceive iSelf, iChannel
            aInB MixerReceive iSelf, iChannel+1

            aPartsL[] init 7
            aPartsR[] init 7

            kBands linseg iBandStart, p3*iBandDur, iBandEnd

            kRamp line 0, p3*.01, 0.25
            kRamp2 linseg 0, p3*0.05, 0, p3*0.05, 0.25
            kRamp3 linseg 0, p3*0.1, 0, p3*0.05, 0.25

            aPartsL[0] butbp aInA*giBpUpAmps[0], iHz*giBpUpPartial[0], kBands
            aPartsL[1] butbp aInA*giBpUpAmps[1], iHz*giBpUpPartial[1], kBands*0.9
            aPartsL[2] butbp aInA*giBpUpAmps[2], iHz*giBpUpPartial[2], kBands*0.8
            aPartsL[3] butbp aInA*giBpUpAmps[3], iHz*giBpUpPartial[3], kBands*0.7
            aPartsL[4] butbp aInA*giBpUpAmps[4], iHz*giBpUpPartial[4], kBands*0.6
            aPartsL[5] butbp aInA*giBpUpAmps[5], iHz*giBpUpPartial[5], kBands*0.5
            aPartsL[6] butbp aInA*giBpUpAmps[6], iHz*giBpUpPartial[6], kBands*0.4
            ;aFiltL = aPartsL[0] + aPartsL[1] + aPartsL[2] + aPartsL[3] + aPartsL[4] + aPartsL[5] + aPartsL[6]
            aFiltL = (aPartsL[0]*kRamp + aPartsL[1]*kRamp + aPartsL[2]*kRamp + aPartsL[3]*kRamp2 + aPartsL[4]*kRamp2 + aPartsL[5]*kRamp3 + aPartsL[6]*kRamp3) * .3

            aPartsR[0] butbp aInB*giBpUpAmps[0], iHz*giBpUpPartial[0], kBands
            aPartsR[1] butbp aInB*giBpUpAmps[1], iHz*giBpUpPartial[1], kBands*0.9
            aPartsR[2] butbp aInB*giBpUpAmps[2], iHz*giBpUpPartial[2], kBands*0.8
            aPartsR[3] butbp aInB*giBpUpAmps[3], iHz*giBpUpPartial[3], kBands*0.7
            aPartsR[4] butbp aInB*giBpUpAmps[4], iHz*giBpUpPartial[4], kBands*0.6
            aPartsR[5] butbp aInB*giBpUpAmps[5], iHz*giBpUpPartial[5], kBands*0.5
            aPartsR[6] butbp aInB*giBpUpAmps[6], iHz*giBpUpPartial[6], kBands*0.4
            ;aFiltR = aPartsR[0] + aPartsR[1] + aPartsR[2] + aPartsR[3] + aPartsR[4] + aPartsR[5] + aPartsR[6]
            aFiltR = (aPartsR[0]*kRamp + aPartsR[1]*kRamp + aPartsR[2]*kRamp + aPartsR[3]*kRamp2 + aPartsR[4]*kRamp2 + aPartsR[5]*kRamp3 + aPartsR[6]*kRamp3) * .3

            aOutA = aFiltL * kGainIn
            aOutB = aFiltR * kGainIn

            MixerSetLevel iSelf, iBusOut, 1
            MixerSend aOutA, iSelf, iBusOut, iChannel
            MixerSend aOutB, iSelf, iBusOut, iChannel+1
        endin

        instr 201 ; butbp down [2FILT]
            ; 7 partials, decreasing amps, increasing hz
            iSelf = 201
            iHz = p4
            iBandStart = p5
            iBandEnd = p6
            iBandDur = p7
            iBusIn = p8
            iBusOut = p9
            iChannel = p10

            printks "%tbutbp UpHz UpAmps: %.2fHz%t%.2f :> %.2f Bands @ %.2fs%n", p3, iHz, iBandStart, iBandEnd, iBandDur*.3
            printks "%t%t!! Sending Self from %d to %d::%d,%d%n", p3, iBusIn, iBusOut, iChannel, iChannel+1
            printks "%n", p3

            kGainIn MixerGetLevel iBusIn, iSelf
            aInA MixerReceive iSelf, iChannel
            aInB MixerReceive iSelf, iChannel+1

            aPartsL[] init 7
            aPartsR[] init 7

            kBands linseg iBandStart, p3*iBandDur, iBandEnd

            kRamp3 line 0, p3*.01, 0.25
            kRamp2 linseg 0, p3*0.05, 0, p3*0.05, 0.25
            kRamp linseg 0, p3*0.1, 0, p3*0.05, 0.25

            aPartsL[0] butbp aInA*giBpDownAmps[0], iHz*giBpUpPartial[0], kBands
            aPartsL[1] butbp aInA*giBpDownAmps[1], iHz*giBpUpPartial[1], kBands*0.9
            aPartsL[2] butbp aInA*giBpDownAmps[2], iHz*giBpUpPartial[2], kBands*0.8
            aPartsL[3] butbp aInA*giBpDownAmps[3], iHz*giBpUpPartial[3], kBands*0.7
            aPartsL[4] butbp aInA*giBpDownAmps[4], iHz*giBpUpPartial[4], kBands*0.6
            aPartsL[5] butbp aInA*giBpDownAmps[5], iHz*giBpUpPartial[5], kBands*0.5
            aPartsL[6] butbp aInA*giBpDownAmps[6], iHz*giBpUpPartial[6], kBands*0.4
            ;aFiltL = aPartsL[0] + aPartsL[1] + aPartsL[2] + aPartsL[3] + aPartsL[4] + aPartsL[5] + aPartsL[6]
            aFiltL = (aPartsL[0]*kRamp + aPartsL[1]*kRamp + aPartsL[2]*kRamp2 + aPartsL[3]*kRamp2 + aPartsL[4]*kRamp3 + aPartsL[5]*kRamp3 + aPartsL[6]*kRamp3) * .3

            aPartsR[0] butbp aInB*giBpDownAmps[0], iHz*giBpUpPartial[0], kBands
            aPartsR[1] butbp aInB*giBpDownAmps[1], iHz*giBpUpPartial[1], kBands*0.9
            aPartsR[2] butbp aInB*giBpDownAmps[2], iHz*giBpUpPartial[2], kBands*0.8
            aPartsR[3] butbp aInB*giBpDownAmps[3], iHz*giBpUpPartial[3], kBands*0.7
            aPartsR[4] butbp aInB*giBpDownAmps[4], iHz*giBpUpPartial[4], kBands*0.6
            aPartsR[5] butbp aInB*giBpDownAmps[5], iHz*giBpUpPartial[5], kBands*0.5
            aPartsR[6] butbp aInB*giBpDownAmps[6], iHz*giBpUpPartial[6], kBands*0.4
            ;aFiltR = aPartsR[0] + aPartsR[1] + aPartsR[2] + aPartsR[3] + aPartsR[4] + aPartsR[5] + aPartsR[6]
            aFiltR = (aPartsR[0]*kRamp + aPartsR[1]*kRamp + aPartsR[2]*kRamp2 + aPartsR[3]*kRamp2 + aPartsR[4]*kRamp3 + aPartsR[5]*kRamp3 + aPartsR[6]*kRamp3) * .3

            aOutA = aFiltL * kGainIn
            aOutB = aFiltR * kGainIn

            MixerSetLevel iSelf, iBusOut, 1
            MixerSend aOutA, iSelf, iBusOut, iChannel
            MixerSend aOutB, iSelf, iBusOut, iChannel+1
        endin

        instr 225 ; butbp cluster [2FILT]
            ; 7 partials, cluster of partials
            iSelf = 225
            iHz = p4
            iBandStart = p5
            iBandEnd = p6
            iBandDur = p7
            iBusIn = p8
            iBusOut = p9
            iChannel = p10

            printks "%tbutbp cluster: %.2fHz%t%.2f :> %.2f Bands @ %.2fs%n", p3, iHz, iBandStart, iBandEnd, iBandDur*.3
            printks "%t%t!! Sending Self from %d to %d::%d,%d%n", p3, iBusIn, iBusOut, iChannel, iChannel+1
            printks "%n", p3

            kGainIn MixerGetLevel iBusIn, iSelf
            aInA MixerReceive iSelf, iChannel
            aInB MixerReceive iSelf, iChannel+1

            aPartsL[] init 7
            aPartsR[] init 7

            kBands linseg iBandStart, p3*iBandDur, iBandEnd

            kRamp line 0, p3*.01, 0.25
            kRamp2 linseg 0, p3*0.05, 0, p3*0.05, 0.25
            kRamp3 linseg 0, p3*0.1, 0, p3*0.05, 0.25

            aPartsL[0] butbp aInA*giBpClusterAmps[0], iHz*giBpClusterPartial[0], kBands
            aPartsL[1] butbp aInA*giBpClusterAmps[1], iHz*giBpClusterPartial[1], kBands*0.9
            aPartsL[2] butbp aInA*giBpClusterAmps[2], iHz*giBpClusterPartial[2], kBands*0.8
            aPartsL[3] butbp aInA*giBpClusterAmps[3], iHz*giBpClusterPartial[3], kBands*0.7
            aPartsL[4] butbp aInA*giBpClusterAmps[4], iHz*giBpClusterPartial[4], kBands*0.6
            aPartsL[5] butbp aInA*giBpClusterAmps[5], iHz*giBpClusterPartial[5], kBands*0.5
            aPartsL[6] butbp aInA*giBpClusterAmps[6], iHz*giBpClusterPartial[6], kBands*0.4
            ;aFiltL = aPartsL[0] + aPartsL[1] + aPartsL[2] + aPartsL[3] + aPartsL[4] + aPartsL[5] + aPartsL[6]
            aFiltL = (aPartsL[0]*kRamp + aPartsL[1]*kRamp + aPartsL[2]*kRamp + aPartsL[3]*kRamp2 + aPartsL[4]*kRamp2 + aPartsL[5]*kRamp3 + aPartsL[6]*kRamp3) * .3

            aPartsR[0] butbp aInB*giBpClusterAmps[0], iHz*giBpClusterPartial[0], kBands
            aPartsR[1] butbp aInB*giBpClusterAmps[1], iHz*giBpClusterPartial[1], kBands*0.9
            aPartsR[2] butbp aInB*giBpClusterAmps[2], iHz*giBpClusterPartial[2], kBands*0.8
            aPartsR[3] butbp aInB*giBpClusterAmps[3], iHz*giBpClusterPartial[3], kBands*0.7
            aPartsR[4] butbp aInB*giBpClusterAmps[4], iHz*giBpClusterPartial[4], kBands*0.6
            aPartsR[5] butbp aInB*giBpClusterAmps[5], iHz*giBpClusterPartial[5], kBands*0.5
            aPartsR[6] butbp aInB*giBpClusterAmps[6], iHz*giBpClusterPartial[6], kBands*0.4
            ;aFiltR = aPartsR[0] + aPartsR[1] + aPartsR[2] + aPartsR[3] + aPartsR[4] + aPartsR[5] + aPartsR[6]
            aFiltR = (aPartsR[0]*kRamp + aPartsR[1]*kRamp + aPartsR[2]*kRamp + aPartsR[3]*kRamp2 + aPartsR[4]*kRamp2 + aPartsR[5]*kRamp3 + aPartsR[6]*kRamp3) * .3

            aOutA = aFiltL * kGainIn
            aOutB = aFiltR * kGainIn

            MixerSetLevel iSelf, iBusOut, 1
            MixerSend aOutA, iSelf, iBusOut, iChannel
            MixerSend aOutB, iSelf, iBusOut, iChannel+1
        endin

        instr 250 ; svfilter static [SVFILT]
            iSelf = 250
            iHz = p4
            iQ = p5
            iType = p6      ; 0 = lp 1 = hp # = bp
            iBusIn = p7
            iBusOut = p8
            iChannel = p9
            iScl = 0        ; normalize the svfilters?

            Stype = ""
            if iType == 0 then
                Stype = "lowpass"
            elseif iType == 1 then
                Stype = "highpass"
            else
                Stype = "bandpass"
            endif

            printks "%tStatic svfilter %s Filter: %.2fHz @ %.2fQ%n", p3, Stype, iHz, iQ
            printks "%t%t!! Sending Self from %d to %d::%d,%d%n", p3, iBusIn, iBusOut, iChannel, iChannel+1
            printks "%n", p3

            kGainIn MixerGetLevel iBusIn, iSelf
            aInA MixerReceive iSelf, iChannel
            aInB MixerReceive iSelf, iChannel+1

            if iQ >= 0.5 then
                iScl = 1
            endif

            alowA, ahighA, abandA svfilter aInA, iHz, iQ, iScl
            alowB, ahighB, abandB svfilter aInA, iHz, iQ, iScl

            if iType == 0 then
                aOutA = alowA * kGainIn
                aOutB = alowB * kGainIn
            elseif iType == 1 then
                aOutA = ahighA * kGainIn
                aOutB = ahighB * kGainIn
            else
                aOutA = abandA * kGainIn
                aOutB = abandB * kGainIn
            endif

            MixerSetLevel iSelf, iBusOut, 1
            MixerSend aOutA, iSelf, iBusOut, iChannel
            MixerSend aOutB, iSelf, iBusOut, iChannel+1
        endin

        instr 251 ; svfilter static #2 [SVFILT]
            iSelf = 251
            iHz = p4
            iQ = p5
            iType = p6      ; 0 = lp 1 = hp # = bp
            iBusIn = p7
            iBusOut = p8
            iChannel = p9
            iScl = 0        ; normalize the svfilters?

            Stype = ""
            if iType == 0 then
                Stype = "lowpass"
            elseif iType == 1 then
                Stype = "highpass"
            else
                Stype = "bandpass"
            endif

            printks "%tStatic svfilter %s Filter: %.2fHz @ %.2fQ%n", p3, Stype, iHz, iQ
            printks "%t%t!! Sending Self from %d to %d::%d,%d%n", p3, iBusIn, iBusOut, iChannel, iChannel+1
            printks "%n", p3

            kGainIn MixerGetLevel iBusIn, iSelf
            aInA MixerReceive iSelf, iChannel
            aInB MixerReceive iSelf, iChannel+1

            if iQ >= 0.5 then
                iScl = 1
            endif

            alowA, ahighA, abandA svfilter aInA, iHz, iQ, iScl
            alowB, ahighB, abandB svfilter aInA, iHz, iQ, iScl

            if iType == 0 then
                aOutA = alowA * kGainIn
                aOutB = alowB * kGainIn
            elseif iType == 1 then
                aOutA = ahighA * kGainIn
                aOutB = ahighB * kGainIn
            else
                aOutA = abandA * kGainIn
                aOutB = abandB * kGainIn
            endif

            MixerSetLevel iSelf, iBusOut, 1
            MixerSend aOutA, iSelf, iBusOut, iChannel
            MixerSend aOutB, iSelf, iBusOut, iChannel+1
        endin
    
    ; ---- FUzzifiers ---- [7FUZZ] 
    instr 700 ; standard fuzz with w/d mix
            iSelf = 700
            iWetDryStart = p4
            iWetDryEnd = p5
            iGain = p6
            iType = p7  ; !! 1 indexed for fn tables
            iBusIn = p8
            iBusOut = p9
            iChannel = p10
            
            if iType > 4 then
                iType = 0
            endif
            Stype = gSFuzzNames[iType-1]
            
            printks "%tFuzzy Buddy %s W/D: %.2f% :> %.2f @ %.2famps%n", p3, Stype, iWetDryStart, iWetDryEnd, iGain
            printks "%t%t!! Sending Self from %d to %d::%d,%d%n", p3, iBusIn, iBusOut, iChannel, iChannel+1
            printks "%n", p3

            kGainIn MixerGetLevel iBusIn, iSelf
            aInA MixerReceive iSelf, iChannel
            aInB MixerReceive iSelf, iChannel+1

            kStort line iWetDryStart, p3, iWetDryEnd
            kGain linseg 0, 0.025, 0, 0.025, iGain, p3-0.05, iGain ; correct for issues @ beginning with square distort

            aOutA distort aInA*kGainIn*kGain, kStort, iType
            aOutB distort aInA*kGainIn*kGain, kStort, iType

            MixerSetLevel iSelf, iBusOut, 1
            MixerSend aOutA, iSelf, iBusOut, iChannel
            MixerSend aOutB, iSelf, iBusOut, iChannel+1
    endin

    ; ---- Compressors ---- [8COMP]
        instr 800 ;dam 800 minimal impact
            iSelf = 800
            iBusIn = p4
            iBusOut = p5
            iChannel = p6

            kGainIn MixerGetLevel iBusIn, iSelf
            aInA MixerReceive iSelf, iChannel
            aInB MixerReceive iSelf, iChannel+1

            kthresh = 0.5
            icomp1 = 0.98
            icomp2 = 0.98
            irtime = 0.01
            iftime = 0.05

            printks "%tCompressor Minimal:%t%.2f Thresh %.2f Upper %.2f Lower %.2f Rise %.2f Fall%n", \
                p3, kthresh, icomp1, icomp2, irtime, iftime
            printks "%t%t!! Sending Self from %d to %d::%d,%d%n", p3, iBusIn, iBusOut, iChannel, iChannel+1
            printks "%n", p3

            aOutA dam aInA*kGainIn, kthresh, icomp1, icomp2, irtime, iftime
            aOutB dam aInB*kGainIn, kthresh, icomp1, icomp2, irtime, iftime

            MixerSetLevel iSelf, iBusOut, 1
            MixerSend aOutA, iSelf, iBusOut, iChannel
            MixerSend aOutB, iSelf, iBusOut, iChannel+1
        endin

        instr 801 ;dam 801 slow rise / fast release harmonic
            iSelf = 801
            iBusIn = p4
            iBusOut = p5
            iChannel = p6

            kGainIn MixerGetLevel iBusIn, iSelf
            aInA MixerReceive iSelf, iChannel
            aInB MixerReceive iSelf, iChannel+1

            kthresh = 0.3
            icomp1 = 0.5
            icomp2 = 0.763
            irtime = 0.1
            iftime = 0.01

            printks "%tCompressor Slower Rise:%t%.2f Thresh %.2f Upper %.2f Lower %.2f Rise %.2f Fall%n", \
                p3, kthresh, icomp1, icomp2, irtime, iftime
            printks "%t%t!! Sending Self from %d to %d::%d,%d%n", p3, iBusIn, iBusOut, iChannel, iChannel+1
            printks "%n", p3

            aOutA dam aInA*kGainIn, kthresh, icomp1, icomp2, irtime, iftime
            aOutB dam aInB*kGainIn, kthresh, icomp1, icomp2, irtime, iftime

            MixerSetLevel iSelf, iBusOut, 1
            MixerSend aOutA, iSelf, iBusOut, iChannel
            MixerSend aOutB, iSelf, iBusOut, iChannel+1
        endin


    ; ---- Spatializers     !! ---- > End of Mixer must contain MixerClear < ---- !! [9SPAT]
        instr 900 ;pan2 900 // Simple Stereo Mixer
            iSelf = 900
            iPanStart = p4
            iPanEnd = p5
            iPanDur = p6
            iBus = p7
            iChannel = p8
            iMasterdB = p9

            kGainIn MixerGetLevel iBus, iSelf
            aInA MixerReceive iSelf, iChannel
            aInB MixerReceive iSelf, iChannel+1

            if iPanStart >= 0 then
                aSpat line iPanStart, p3*iPanDur, iPanEnd
                aOutL, aOutR pan2 (aInA+aInB)*0.5*kGainIn, aSpat
                printks "%tpan2:%t%.2f :> %.2f @ %.2fs%n", p3, iPanStart, iPanEnd, iPanDur*p3
            else 
                aOutL = aInA*kGainIn
                aOutR = aInB*kGainIn
                printks "%tpan2: Bypass!%n", p3
            endif

            printks "%n%n", p3
            outs aOutL*iMasterdB, aOutR*iMasterdB
            MixerClear
        endin

        instr 901 ;pan2 #2 901 // Simple Stereo Mixer
            iSelf = 901
            iPanStart = p4
            iPanEnd = p5
            iPanDur = p6
            iBus = p7
            iChannel = p8
            iMasterdB = p9

            kGainIn MixerGetLevel iBus, iSelf
            aInA MixerReceive iSelf, iChannel
            aInB MixerReceive iSelf, iChannel+1

            if iPanStart >= 0 then
                aSpat line iPanStart, p3*iPanDur, iPanEnd
                aOutL, aOutR pan2 (aInA+aInB)*0.5*kGainIn, aSpat
                printks "%tpan2:%t%.2f :> %.2f @ %.2fs%n", p3, iPanStart, iPanEnd, iPanDur*p3
            else 
                aOutL = aInA*kGainIn
                aOutR = aInB*kGainIn
                printks "%tpan2: Bypass!%n", p3
            endif

            printks "%n%n", p3
            outs aOutL*iMasterdB, aOutR*iMasterdB
            MixerClear
        endin

        instr 925 ;vbap 925 // for Landmarks or StereoIn > Mono > vbap
            /* mixes stereo in -> mono */
            iSelf = 925
            iPanStart = p4
            iPanEnd = p5
            iBus = p6
            iChannel = p7
            iMasterdB = p8

            kGainIn MixerGetLevel iBus, iSelf
            aInA MixerReceive iSelf, iChannel
            aInB MixerReceive iSelf, iChannel+1

            kPan line iPanStart, p3, iPanEnd
            ; mix stereo in to mono (assuming Landmark)
            aOutA = (aInA+aInB)*kGainIn*0.5

            printks "%tMulti Channel vbap (stero>mono<<multi):%t%.2f :> %.2f%n", p3, iPanStart, iPanEnd
            printks "%n%n", p3

            aVbap[] vbap aOutA*iMasterdB, kPan
            out aVbap
            MixerClear
        endin

        instr 926 ;vbap 926 #2 // for Landmarks or StereoIn > Mono > vbap
            /* mixes stereo in -> mono */
            iSelf = 926
            iPanStart = p4
            iPanEnd = p5
            iBus = p6
            iChannel = p7
            iMasterdB = p8

            kGainIn MixerGetLevel iBus, iSelf
            aInA MixerReceive iSelf, iChannel
            aInB MixerReceive iSelf, iChannel+1

            kPan line iPanStart, p3, iPanEnd
            ; mix stereo in to mono (assuming Landmark)
            aOutA = (aInA+aInB)*kGainIn*0.5

            printks "%tMulti Channel vbap (stero>mono<<multi):%t%.2f :> %.2f%n", p3, iPanStart, iPanEnd
            printks "%n%n", p3

            aVbap[] vbap aOutA*iMasterdB, kPan
            out aVbap
            MixerClear
        endin

        instr 928 ;vbap 928 // for Mono << vbap
            iSelf = 928
            iPanStart = p4
            iPanEnd = p5
            iBus = p6
            iChannel = p7
            iMasterdB = p8

            kGainIn MixerGetLevel iBus, iSelf
            aIn MixerReceive iSelf, iChannel

            kPan line iPanStart, p3, iPanEnd
            aOutA = aIn*kGainIn*0.5

            printks "%tMulti Channel vbap (mono<<multi):%t%.2f :> %.2f%n", p3, iPanStart, iPanEnd
            printks "%n%n", p3

            aVbap[] vbap aOutA*iMasterdB, kPan
            out aVbap
            MixerClear
        endin

        instr 1000
            MixerClear
        endin
</CsInstruments>

<CsScore>
; busy-fuzz-3.wav
    ; boogaloo 4 fuzz
    i   115 0 42.9          \ ; boogaloo sampler
        3   .8   0           \ ; index, speed, offset
        1   0.25 0.08      \ ; gain, ramp, fade
        250 0                 ; bus out, channel#
    i   250 0 42.9             \
        1500 0.65 0              \
        115 700 0               
    i   700 0 42.9          \ ; fuzz
        0.05 0.15 1   3   \ ; wet dry s->e, gain corr, type
        250 900 0             ; in, out, channel

    ; l channel-ish fuzz
    i   900 0 43          \
        .5 .5 1      \ ; spat s->e, %p3
        700 0              \ ; in, channel
        .75                  \ ; masterdb

</CsScore>
</CsoundSynthesizer>