<CsoundSynthesizer>
<CsOptions>
-Ma -odac -m128 -+rtaudio=jack -i adc -o dac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

/*
    instr 1:
        - there is a drone at a specific pitch ALWAYS playing when instrument is active
        - there is a subtle 'plunk' sound of the digital bow
        - it is somewhat inconsistant if a note will ACTUALLLY play
        - need to press keys VERY hard to get things to work consistantly
        - sounds really cool, but difficult to play.
        - had an issue during one improv where a bunch of notes got stuck on
        - amplitude or pressure seems to get out of control over time ... the longer a note plays the more likely it is to distort
*/

gisine   ftgen  0, 0, 4096, 10, 1
initc7   1,1,1        ; initialize controller to its maximum level

instr 1
    iNum    notnum              ;get midi note number
    iAmp    ampmidi     .5     ; get note velocity; ranging of 0 - 0.2
    kVol    ctrl7       1, 1, 0, 1      ; read controller chan 1; range 0 - 1
    kPortTime   linseg  0, 0.005, 0.01  ;quick ramp for volume interp
    kVol        portk   kVol, kPortTime ; filtered output of kVol
    //aVol        interp  kVol            ; kVol => aVol

    icps    cpsmidi
    kcps    line        icps*.98, 2, icps

    ;random spline interp   minVal    maxVal    minCps, maxCps
    kpres       rspline     .01, .1, 0.5, 2
    krat = 0.127236
    kvibf = 4.5
    kvibamp = 0
    iminfreq = 20

    kEnv    linsegr     0, 0.0005, 1, 2, 0     ;envelope with release
    

    aBow    wgbow    iAmp*kVol*kEnv, kcps, kpres, krat, kvibf, kvibamp, gisine, iminfreq

    outs aBow, aBow
endin


</CsInstruments>
<CsScore>
;i 1 0 600
;f 0 300
</CsScore>
</CsoundSynthesizer>