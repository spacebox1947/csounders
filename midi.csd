<CsoundSynthesizer>
<CsOptions>
-Ma -m128 -+rtaudio=jack -i adc -o dac
; activates all midi devices, suppress note printings
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

; this one prints data

; using massign with these arguments disables default instrument triggering
massign 0,0

instr 1
    kstatus, kchan, kdata1, kdata2  midiin            ;read in midi
    ktrigger changed kstatus, kchan, kdata1, kdata2 ;trigger if midi data change
    if ktrigger=1 && kstatus!=0 then          ;if status byte is non-zero...
    ; -- print midi data to the terminal with formatting --
    printks "status:%d%tchannel:%d%tdata1:%d%tdata2:%d%n",
            0,kstatus,kchan,kdata1,kdata2
    endif
endin

</CsInstruments>
<CsScore>
i 1 0 3600 ; instr 1 plays for 1 hour
;i 2 0 3600
</CsScore>
</CsoundSynthesizer>
;example by Iain McCurdy