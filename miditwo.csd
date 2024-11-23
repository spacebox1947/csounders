<CsoundSynthesizer>
<CsOptions>
-Ma -odac -m128 -+rtaudio=jack -i adc -o dac
;activates all midi devices, real time sound output, suppress note printings
</CsOptions>
<CsInstruments>
sr = 88200
ksmps = 32
nchnls = 1
0dbfs = 1

gisine ftgen 0,0,2^12,10,1

;massign 1,1
;massign 1,2
;massign 1,3
;opcode MidiTrig, 0, io ;lets you trigger more than one instrument

instr 1 ; 1 impulse (midi channel 1)
    prints "instrument/midi channel: %d%n",p1 ;print instrument number to terminal

    inote       notnum    ;midi note #
    icps        cpsmidi     ;midi as Hz
    iampmidi    ampmidi 1

    reset:                                    ;label 'reset'
        timout 0, 1, impulse                 ;jump to 'impulse' for 1 second
        reinit reset                         ;reninitialise pass from 'reset'
    impulse:                                  ;label 'impulse'
    aenv expon     1, 0.3, 0.0001             ;a short percussive envelope
    aSig poscil    aenv*iampmidi, icps, gisine          ;audio oscillator
        out       aSig                       ;audio to output
endin

instr 2 ; 1 impulse (midi channel 1)
    prints "instrument/midi channel: %d%n",p1 ;print instrument number to terminal

    inote       notnum    ;midi note #
    icps        cpsmidi     ;midi as Hz
    iampmidi    ampmidi 1

    reset:                                    ;label 'reset'
        timout 0, 1, impulse                 ;jump to 'impulse' for 1 second
        reinit reset                         ;reninitialise pass from 'reset'
    impulse:                                  ;label 'impulse'
    aenv expon     1, 6, 0.0001             ;a short percussive envelope 
    alin  line  0, 1.5, 1
    aSig poscil    aenv*iampmidi*alin, icps, gisine          ;audio oscillator
        out       aSig                       ;audio to output
endin

  instr 3 ; 3 impulses (midi channel 3)
prints "instrument/midi channel: %d%n",p1
reset:
     timout 0, 1, impulse
     reinit reset
impulse:
aenv expon     1, 0.3, 0.0001
aSig poscil    aenv, 500, gisine
a2   delay     aSig, 0.15                 ; delay adds a 2nd impulse
a3   delay     a2, 0.15                   ; delay adds a 3rd impulse
     out       aSig+a2+a3                 ; mix the three impulses at output
  endin

</CsInstruments>
<CsScore>
f 0 300
</CsScore>
<CsoundSynthesizer>
;example by Iain McCurdy