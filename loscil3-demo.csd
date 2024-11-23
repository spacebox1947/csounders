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

;initc7   1, 1, 1
massign 1,4
; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

instr 1     ; loscil makes use of embedded loop points in wav
   ichnls = ftchnls(p4)
   prints  "\nnumber of channels = %d\n\n", ichnls

   if (ichnls == 1) then
      asigL loscil3 .8, 1, p4, 1           ; sample loops between 1 and end loop point at 2 secs.
      asigR = 	asigL
   elseif (ichnls == 2) then
      asigL, asigR loscil3 .8, 1, p4, 1    ; sample loops between 2 and end loop point at 3 secs.
   else                                    ; safety precaution if not mono or stereo
      asigL = 0
      asigR = 0
   endif
         outs asigL, asigR
endin

; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

instr 2     ; butterbp resonant bandpass

   ; LOCSIL3 SAMPLE TABLE
   ; sig sig    opcode  amps  cps   f#    baseHz,  looping
   asigL, asigR loscil3 .8,   1,    p4,   1,       1


   ; BUTTERBP XBAND WIDTH ENVELOPE
   ; asig linseg                    : ksig
   ;  ia    :  starting val         : kres
   ;  ia, idur1, ib                 : starting val, change over seconds, ending val, etc.
   kfilt linseg p5, 10, p5*0.9, 25, p5*0.25, 25, p5*0.1
   kfilt2 linseg p6, 10, p6*0.9, 25, p6*0.4, 25, p6*0.25


   ; BUTTERBP REALLY BUTTERY
   ; sig butterbp asig xfreq xband [, iskip]
   abp butterbp asigL, p7, kfilt
   abp2 butterbp asigR, p8, kfilt2


   ; LINSEG FOR PANTS
   aspat linseg p9, p3*0.5, p10, p3*0.5, p9
   aspat2 linseg p11, p3*0.5, p12, p3*0.5, p11


   ; PAN2 PANTS FOR YOU
   ; a1, a2 pan2
   ;  asig     : sig to pan
   ;  xp       : a or k rate 0,1 is L,R
   ;  imode    : position algo: 0 = harmonic panning [default], 1 = square root, 2 = simple linear, 3 = alt equal pan (UDO)
   aL, aR pan2 abp, aspat
   aL2, aR2 pan2 abp2, aspat2
      outs (aL+aL2)*0.25, (aR+aR2)*0.25

endin

; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

instr 3 ; Basic Bitch Changing Sample
   asigL, asigR loscil3 .8, 1, p4, 1

   kfilt linseg 480, p3*0.5, 640, p5*0.5, 596
   kfilt2 linseg 800, p5*0.5, 640, p5*0.5, 596

   abp butterbp asigL, 1250, kfilt
   abp2 butterbp asigR, 1250, kfilt2
      outs abp*0.7, abp2*0.7

endin

; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

instr 4 ; MIDI controlled xTET bandpass stacks

   iNum      notnum                   ; read in midi note number / 0 - 127
   iTemps = 9.0
   iA = 57
   iAHz = 440
   
   ;iNumMap = 440 * ( 2 ^ ( iTemps * log(2) * ( ((iNum % iTemps)+1) / iTemps  ) / iTemps ))
   iNumMap = iAHz * ( 2 ^ (1 / iTemps)) ^ (iNum - iA)

   kstatus, kchan, kdata1, kdata2  midiin            ;read in midi
   if kstatus!=0 then          ;if status byte is non-zero...
   ; -- print midi data to the terminal with formatting --
      printks "notein: %d HzOut: %f%n", 
         0, iNum, iNumMap
   endif
   

   iAmp     ampmidi  1
   aEnv     linsegr 0, 0.005, 1, 10, 0

   ;aSamp, aSamp2    loscil3 1, 2, 1
   aSamp[]  diskin      gS_file1, 1, 5, 1

   aButters[] init 5
   /* kCount = 0
   while kCount<lenarray(aButters) do
      kFilterHz = iNumMap*(kCount+2)/(kCount+1)
      printks "partial %d:%t%f%t note in:%t%d", 0, kCount, kFilterHz, iNum
      aButters[kCount]  butterbp aSamp[kCount%2], kFilterHz, 20-(2*kCount)
      kCount = kCount + 1
   od */
   iPartial1 = iNumMap*2
   iPartial2 = iNumMap*(3/2.0)
   iPartial3 = iNumMap*(4/3.0)
   iPartial4 = iNumMap*(5/4.0)

   ;printks "Partials %t%f %t%f %t%f %t%f %t%f %n", 0, iNumMap, iPartial1, iPartial2, iPartial3, iPartial4

   aButters[0] butterbp aSamp[0], iNumMap, iNumMap*0.125
   aButters[1] butterbp aSamp[1], iPartial1, iNumMap*0.0325
   aButters[2] butterbp aSamp[0], iPartial2, 8
   aButters[3] butterbp aSamp[1], iPartial3, 6
   aButters[4] butterbp aSamp[0], iPartial4, 4

   ;printks "%n%n", 0
   ;aSig     butterbp    aSamp[0], iNumMap, 20
   ;aSig2    butterbp    aSamp[1], iNumMap*2, 35

   aSig[] init lenarray(aButters)

   kCount = 0
   while kCount < lenarray(aButters) do
      aSig[kCount] limit aButters[kCount]*aEnv*iAmp, 0, 0.5
      kCount = kCount + 1
   od

            ;outs aSig*aEnv*iAmp, aSig2*aEnv*iAmp
            out aSig*3
            ; midi notes: 54, 55 and 70 (F#, G and Bb) are EXPLODING in pitch. Why?

endin

instr SwellStereo
   ;p1 = instrument
   ;p2 = time offset
   ;p3 = duration
   ; ---- sampler
   ;p4 = sampler pitch (standard: 1)
   ; ---- AD envelope
   ;p5 = envelope 1 peak
   ;p6 = envelope 2 peak
   ;p7 = envelope attack dur in %
   ; --- spatialize
   ;p8 = spat l start
   ;p9 = spat l end
   ;p10 = spat l 'rise' in %
   ;p11 r
   ;p12 r
   ;p13 r

   printks "Instr: SwellStereo%tStart %d%tDur %d%tPitch %f%n", p3, p2, p3, p4
   printks "%tSpatialize:%tL: %f :> %f%tR: %f :> %f%t%n", p3, p8, p9, p11, p12
   printks "%tAmps Envelope:%t %f :> %f @ %f%n%n", p3, p5, p6, p7

   ; Amplitude Envelope
   aEnvOne linseg 0, \
      p3*p7, p5, \
      p3*(1-p7), 0

   aEnvTwo linseg 0, \
      p3*p7, p6, \
      p3*(1-p7), 0
   
   ; Stereo Panning Lines
   aPanOne linseg 0, \
      p3*p10, p11, \
      p3*(1-p10), p12

   aPanTwo linseg 0, \
      p3*p13, p11, \
      p3*(1-p13), p12

   ; read sample
   aSamp[] diskin \
      gS_file3,   p4,       0,       1
      ;fn,        kPitch,  iSkip,   iWrap
      
   ; spatialize
   aL, aR pan2 aSamp[0]*aEnvOne, aPanOne
   aL2, aR2 pan2 aSamp[1]*aEnvTwo, aPanTwo

   ; limit ;TODO: Causing audio artifacts, replace with compressor/limitor such as dam, compress
   ;aSigL limit aR+aR2, 0, 1
   ;aSigR limit aL+aL2, 0, 1

   ; Final Stage
      ;outs aSigL, aSigR
      outs aL+aL2, aR+aR2
endin

instr DiskTest

   aL, aR diskin \
      gS_file3,   p4,       0,       1
      ;fn,        kPitch,  iSkip,   iWrap

   outs aL, aR

endin

</CsInstruments>

; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

<CsScore>
   ;i "DiskTest" 0 20 1

   i "SwellStereo" \
      0     80    1     \
      0.6   1     0.15  \
      0.5   0     0.75   \
      0.5   1     0.75

   i "SwellStereo" \
      40    50    0.5     \
      1     1     0.337 \
      0.65  .9    0.67  \
      0.45  0.1    0.67

   i "SwellStereo"   \
      60    35    .25    \
      1     1     0.125  \
      0.5   1     0.4   \
      0.5   0     0.4   \

   i  "SwellStereo"  \
      75    25    3  \
      1     .8    .6 \
      0.8   0.4   .3 \

   i  "SwellStereo"  \
      78    25    4.11  \
      .9    .7    .7    \
      0.8   0.5   0.5

   i  "SwellStereo"  \
      81    13    5.14  \
      1     0.9    .47    \
      0.9   0.8   0.35

   i  "SwellStereo"  \
      99    20    1.3   \
      0.6   0.4   0.45  \
      0.3   0     0.8   \
      0.4   0.1   0.7   

   i  "SwellStereo"  \
      101    20    1.45   \
      0.3   0.2   0.45  \
      0.5   0     0.8   \
      0.6   0.15   0.7   

   i  "SwellStereo"  \
      109    45    0.03   \
      0.5   0.25   0.75  \
      0.5   0.65   0.8   \
      0.5   0.45   0.7   

   i  "SwellStereo"  \
      130   25     8.1  \
      0.35  0.2   0.6   \
      .7     1    .47    \
      0.6   0.9   0.35

   i  "SwellStereo"  \
      130   25     8.15  \
      0.35  0.2   0.6   \
      .3    0    .47    \
      0.4   0.2   0.35

   i  "SwellStereo"  \
      140   25     9.1  \
      0.35  0.2   0.6   \
      .7     1    .47    \
      0.6   0.9   0.35

   i  "SwellStereo"  \
      140   25     9.15  \
      0.35  0.2   0.6   \
      .3    0    .47    \
      0.4   0.2   0.35

   i  "SwellStereo"  \
      140   18     10.1  \
      0.35  0.2   0.6   \
      .7     1    .47    \
      0.6   0.9   0.35

   i  "SwellStereo"  \
      140   18     10.15  \
      0.35  0.2   0.6   \
      .3    0    .47    \
      0.4   0.2   0.35

   i  "SwellStereo"  \
      145   18     9.667  \
      0.35  0.2   0.6   \
      .7     1    .47    \
      0.6   0.9   0.35

   i  "SwellStereo"  \
      145   18     9.75  \
      0.35  0.2   0.6   \
      .3    0    .47    \
      0.4   0.2   0.35

   ;i 1 0 600 1
   ;i 4 0 600 ; MIDI receiver!

   ; --- Right sign
   ;              filter width,  Hz          spatialize
   /* i 2 0 63 2     125  125       1000 1500   1 0.75      1 0.75
   i 2 0 .  .     <    <         >     >     1 0.75      1 0.75
   i 2 0 .  .     62.5 62.5      3000 4500   1 0.75      1 0.75
   
   i 2 0 63 .     62.5 62.5      3000 4500   1 0.75      1 0.75
   i 2 0 .  .     <    <         >     >     1 0.75      1 0.75
   i 2 0 .  .     31.25 31.25    9000 13500  1 0.75      1 0.75

   i 2 18 63 .    31.25 31.25    1222.2 1833.3     0.75 0.55   0.75 0.55   ; 11:9 integer ratio of LEFT CHANNEL
   i 2 0 .  .     <    <         >     >           0.75 0.55   0.75 0.55
   i 2 0 .  .     15   15        3666.6 2749.95    0.75 0.55   0.75 0.55 */
   

   ; --- Left Side
   /* i 2 3 63 2     125  125       1750 2625   0 0.75      0 0.75      ; 7:4 integer ratio of RIGHT channel
   i 2 . .  .     <    <         >     >     0 0.75      0 0.75
   i 2 . .  .     62.5 62.5      3500 7875   0 0.75      0 0.75
   
   i 2 . 63 .     62.5 62.5      3500 7875   0 0.75      0 0.75
   i 2 . .  .     <    <         >     >     0 0.75      0 0.75
   i 2 . .  .     31.25 31.25    10500 15750 0 0.75      0 0.75

   i 2 18 63 .    31.25 31.25    2068.19 3102.285     0.25 0.45   0.25 0.45   ; 13:11 integer ratio of THIS CHANNEL
   i 2 0 .  .     <    <         >     >              0.25 0.45   0.25 0.45
   i 2 0 .  .     15   15        8272.76 9306.855     0.25 0.45   0.25 0.45 */

   ; centered relatively under-filtered low tones
   ;i 3 0 63 1
</CsScore>

</CsoundSynthesizer>