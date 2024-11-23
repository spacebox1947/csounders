<CsoundSynthesizer>

<CsOptions>
   -Ma -odac -m128 -+rtaudio=jack -i adc -o dac
   --env:SSDIR+=./samples
   ; Select audio/midi flags here according to platform
   ; -odac     ;;;realtime audio out
   ;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
</CsOptions>

; ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

<CsInstruments>

sr = 88200
ksmps = 32
nchnls = 2
0dbfs  = 1

giFt1   ftgen   1, 0, 0, 1, "2023_07_24_22_04_54 Indiana Storms.wav", 0, 0, 0
giFt2   ftgen   2, 0, 0, 1, "2023_07_24_22_04_54 Indiana Storms_bugs1.wav", 0, 0, 0
giFt3   ftgen   3, 0, 0, 1, "2024-11-20-Whale-Adventure--Bring-Cleats-Clip.wav", 0, 0, 0

instr Grains
    iOlaps = 4
    kGrSize = 0.07
    
    kAmps = 0.4
    kFreq = iOlaps/kGrSize
    iPs = 1/iOlaps 
    kStretch = p4
    kPitch = p5

    kPitch linseg p5, p3*.5, p6, p3*.5, p5

    aL, aR diskgrain "2024-11-20-Whale-Adventure--Bring-Cleats-Clip.wav", \
        kAmps, kFreq, kPitch, \
        kGrSize, iPs*kStretch, \
        1, iOlaps

    outs aL, aR
endin


</CsInstruments>

<CsScore>
f 1 0 8192 20 2 1       ; Hanning Function

i "Grains"  0   8   1   1   0.99      
i "Grains"   +   6     2           1    0.75
i "Grains"   +   6     1          0.75  0.67
i "Grains"   +   6     1.5        1.5   1.3
i "Grains"   +   6.25  0.5        1.5   1.3
i "Grains"   +   6.25   0.25        1.5 1.9
i "Grains"  +   6.25    0.5         2   3.5

</CsScore>

</CsoundSynthesizer>