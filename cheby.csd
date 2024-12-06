<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-Ma -odac -m128 -+rtaudio=jack -i adc -o dac
--env:SSDIR+=./samples
; For Non-realtime ouput leave only the line below:
; -o chebyshevpoly.wav -W ;;; for file output any platform
; https://csound.com/docs/manual/chebyshevpoly.html
</CsOptions>
<CsInstruments>

sr = 88200
ksmps = 32
nchnls = 2
0dbfs  = 1

gS_tasty1 = "Tasty_Ice_Crunch-1.wav"        ; dur: 19.953
gS_boogaloo4 = "Boogaloo-4.wav"             ; dur: 42.956

; time-varying mixture of first six harmonics
instr 1
	; According to the GEN13 manual entry,
	; the pattern + - - + + - - for the signs of 
	; the chebyshev coefficients has nice properties.
	
	; these six lines control the relative powers of the harmonics
	k1         line           1.0, p3, 0.0
	k2         line           -0.5, p3, 0.0
	k3         line           -0.333, p3, -1.0
	k4         line           0.0, p3, 0.5
	k5         line           0.0, p3, 0.7
	k6         line           0.0, p3, -1.0
	
	; play the sine wave at a frequency of 256 Hz with amplitude = 1.0
	;ax         oscili         1, 256, 1
	aSampTasty[]   diskin  gS_tasty1, 1, 0, 1
    aSamp[] diskin  gS_boogaloo4, 1, 0, 1
	
    aMod = aSampTasty[0] * aSamp[0]
    ; waveshape it
	ay         chebyshevpoly  aMod, 0, k1, k2, k3, k4, k5, k6
	
    iAmps = 0.25

	; avoid clicks, scale final amplitude, and output
	adeclick   linseg         0.0, 0.05, 1.0, p3 - 0.1, 1.0, 0.05, 0.0
	           outs           ay * adeclick * iAmps, ay * adeclick * iAmps
endin

</CsInstruments>
<CsScore>
f1 0 32768 10 1	; a sine wave

i1 0 5
e

</CsScore>
</CsoundSynthesizer>