<CsScore>
[ Fuzzy Crowd Boogaloo ]
    ; busy-fuzz-1.wav // left side fuzz
        ; boogaloo 1 fuzz
        i   115 0 68.4          \ ; boogaloo sampler
            0   1   0           \ ; index, speed, offset
            1   0.25 0.08      \ ; gain, ramp, fade
            700 0                 ; bus out, channel#
        i   700 0 68.4          \ ; fuzz
            0.0 0.125 0.25   1   \ ; wet dry s->e, gain corr, type
            115 900 0             ; in, out, channel

        i   115 68.51 51.5       \ ; boogaloo sampler
            0   0.75   2           \ ; index, speed, offset
            1   0.05 0.25       \ ; gain, ramp, fade
            700 0                 ; bus out, channel#
        i   700 68.51 51.5       \ ; fuzz
            0.135 0.5 1   4     \ ; wet dry s->e, gain corr, type
            115 900 0             ; in, out, channel
        ; l channel-ish fuzz
        i   900 0 120.01          \
            0.4 0.05 0.6      \ ; spat s->e, %p3
            700 0              \ ; in, channel
            1                  \ ; masterdb
    ; busy-fuzz-2.wav // right side fuzz
        ; boogaloo 5 fuzz
        i   115 0 56.508          \ ; boogaloo sampler
            4   1   0           \ ; index, speed, offset
            1   0.25 0.08      \ ; gain, ramp, fade
            700 0                 ; bus out, channel#
        i   700 0 56.508          \ ; fuzz
            0.0 0.125 0.25   2   \ ; wet dry s->e, gain corr, type
            115 900 0             ; in, out, channel

        i   115 73 47      \ ; boogaloo sampler
            4   0.65   2           \ ; index, speed, offset
            1   0.05 0.25       \ ; gain, ramp, fade
            700 0                 ; bus out, channel#
        i   700 73 47       \ ; fuzz
            0.135 0.5 1   4     \ ; wet dry s->e, gain corr, type
            115 900 0             ; in, out, channel
        ; l channel-ish fuzz
        i   900 0 120.01          \
            0.6 0.95 0.6      \ ; spat s->e, %p3
            700 0              \ ; in, channel
            1                  \ ; masterdb
[ RESONANT CREEK SIDE EMERGES]
    ; Resonant Creekside // First 30 seconds
        ; this chunk overlaps, which causes some probs ... but could work if 'skating' over a long form out
        ; --- initial HP chain // ends @ 15 // channel 0
        i   110 0   17          \   ;diskin2 110
            4   1.1 0             \   ;index, speed, offset
            0.75 0.125 0.125    \   ; atk, adur, fdur
            250 0                  ;out, channel
        i   250 0   17          \   ; var filter
            2000    0.35    1   \   ; hz, q, type
            110 901 0               ; in, out, channel
        i   901 0   17          \
            0.5 0.75 0.6        \   ; pan start, end, dur
            250 0               \
            1                       ; masterdB

        ; bpUp emerges from hp chain // ends @ 27s // channel 2
        i   111 10   17          \   ;diskin2 111
            0   1.1 15             \   ;index, speed, offset
            0.7 0.125 0.125    \   ; atk, adur, fdur
            200 2                  ;out, channel
        i   200 10  17          \
            2000 750 500 0.75   \   ; hz, band s->e, dur
            111 251 2
        i   251 10   17          \   ; var filter
            2000    0.45    1   \   ; hz, q, type
            200 900 2               ; in, out, channel
        i   900 10   17          \
            0.75 1 0.6        \   ; pan start, end, dur
            251 2               \
            0.8                       ; masterdB */

        ; bpUp on left side // ends @ 37s // channel 0
        i   110 20   17          \   ;diskin2 110
            4   .98  25           \   ;index, speed
            0.7 0.25 0.125    \   ; atk, adur, fdur
            200 0                  ;out, channel
        i   200 20  17          \
            1800 500 300 0.75   \   ; hz, band s->e, dur
            110 250 0
        i   250 20   17          \   ; var filter
            1800    0.55    1   \   ; hz, q, type
            200 901 0               ; in, out, channel
        i   901 20   17          \
            0 0.125 0.6        \   ; pan start, end, dur
            250 0               \
            0.7                       ; masterdB

[ SHRILL CRINKLES ]
    ; high-creek-1.wav 90s
            ; first bloop
            i   110 0   9          \   ;diskin2 110
                4   1.5 0             \   ;index, speed, offset
                1 0.09 0.09    \   ; atk, adur, fdur
                225 0                  ;out, channel
            i   225 0   9          \   ;bp cluster
                3000 100 35 .4        \ 
                110 250 0 
            i   250 0   9          \   ; var filter
                1000    0.45    1   \   ; hz, q, type
                225 251 0               ; in, out, channel
            i   251 0   9          \   ; var filter
                2000    0.65    1   \   ; hz, q, type
                250 901 0               ; in, out, channel

            i   110 12   9          \   ;diskin2 110
                4   1.5 0             \   ;index, speed, offset
                1 0.09 0.09    \   ; atk, adur, fdur
                201 0                  ;out, channel
            i   201 12   9          \   ;bp down
                1500 25 35 .4        \ 
                110 250 0 
            i   250 12   9          \   ; var filter
                1500    0.45    1   \   ; hz, q, type
                201 251 0               ; in, out, channel
            i   251 12   9          \   ; var filter
                2500    0.65    1   \   ; hz, q, type
                250 901 0               ; in, out, channel

                ; third bloop
            i   110 25   13          \   ;diskin2 110
                4   1.5 0             \   ;index, speed, offset
                1 0.09 0.09    \   ; atk, adur, fdur
                225 0                  ;out, channel
            i   225 25   13          \   ;bp cluster
                2750 35 65 .7        \ 
                110 250 0 
            i   250 25   13          \   ; var filter
                1500    0.45    1   \   ; hz, q, type
                225 251 0               ; in, out, channel
            i   251 25   13          \   ; var filter
                2000    0.65    1   \   ; hz, q, type
                250 901 0               ; in, out, channel

            i   110 65   20          \   ;diskin2 110
                4   1.5 0             \   ;index, speed, offset
                1 0.25 0.12    \   ; atk, adur, fdur
                201 0                  ;out, channel
            i   201 65   20          \   ;bp down
                2326.9 85 28 .6        \ 
                110 250 0 
            i   250 65   20          \   ; var filter
                1500    0.45    1   \   ; hz, q, type
                201 251 0               ; in, out, channel
            i   251 65   20         \   ; var filter
                3500    0.65    1   \   ; hz, q, type
                250 901 0               ; in, out, channel

            ; spat is avail all 90
            i   901 0   90          \
                1 0  1        \   ; pan start, end, dur
                251 0               \
                4                       ; masterdB

    ; high-creek-1a.wav
            i   110 55   35          \   ;diskin2 110
                4   1.5 0             \   ;index, speed, offset
                0.8 0.125 0.15    \   ; atk, adur, fdur
                201 0                  ;out, channel
            i   201 55   35          \   ;bp down
                1162.45 18 70 .4        \ 
                110 250 0 
            i   250 55   35          \   ; var filter
                900    0.45    1   \   ; hz, q, type
                201 251 0               ; in, out, channel
            i   251 55   35         \   ; var filter
                1800    0.35    1   \   ; hz, q, type
                250 901 0               ; in, out, channel

        ; spat is avail all 90
        i   901 0   90          \
            0 1  1        \   ; pan start, end, dur
            251 0               \
            4                       ; masterdB

    ; high-creek-2.wav 90s
            ; first bloop
            i   110 2   11          \   ;diskin2 110
                4   1.5 0             \   ;index, speed, offset
                1 0.09 0.09    \   ; atk, adur, fdur
                200 0                  ;out, channel
            i   200 2   11          \   ;bp up
                1363 500 300 .4        \ 
                110 250 0 
            i   250 2   11          \   ; var filter
                900    0.45    1   \   ; hz, q, type
                200 251 0               ; in, out, channel
            i   251 2   11          \   ; var filter
                200    0.45    1   \   ; hz, q, type
                250 901 0               ; in, out, channel

            i   110 18.5 9          \   ;diskin2 110
                4   1.5 0             \   ;index, speed, offset
                1 0.09 0.09    \   ; atk, adur, fdur
                200 0                  ;out, channel
            i   200 18.5 9          \   ;bp up
                1500 45 60 .7        \ 
                110 250 0 
            i   250 18.5 9          \   ; var filter
                1000    0.45    1   \   ; hz, q, type
                200 251 0               ; in, out, channel
            i   251 18.5 9          \   ; var filter
                1200    0.65    1   \   ; hz, q, type
                250 901 0               ; in, out, channel

                ; third bloop
            i   110 30   30          \   ;diskin2 110
                4   1.5 0             \   ;index, speed, offset
                1 0.09 0.09    \   ; atk, adur, fdur
                225 0                  ;out, channel
            i   225 30   30          \   ;bp cluster
                1636.36 25 55 .7        \ 
                110 250 0 
            i   250 30   30          \   ; var filter
                1500    0.45    1   \   ; hz, q, type
                225 251 0               ; in, out, channel
            i   251 30   30          \   ; var filter
                2000    0.55    1   \   ; hz, q, type
                250 901 0               ; in, out, channel
        ; spat is avail all 90
        i   901 0   61          \
            0 1  1        \   ; pan start, end, dur
            251 0               \
            1                       ; masterdB 
    ; high-creek-1.wav 90s5 0             \   ;index, speed, offset
                1 0.25 0.12    \   ; atk, adur, fdur
                201 0                  ;out, channel
            i   201 61   24          \   ;bp down
                2326.9 85 28 .6        \ 
                110 250 0 
            i   250 61   24          \   ; var filter
                1500    0.45    1   \   ; hz, q, type
                201 251 0               ; in, out, channel
            i   251 61   24         \   ; var filter
                3500    0.65    1   \   ; hz, q, type
                250 901 0               ; in, out, channel

        ; spat is avail all 90
        i   901 0   90          \
            0 1  1        \   ; pan start, end, dur
            251 0               \
            2                       ; masterdB 

    ; high-creek-2a.wav 60s
        ; first bloop
        i   110 5   60          \   ;diskin2 110
            4   1.5 0             \   ;index, speed, offset
            1 0.09 0.09    \   ; atk, adur, fdur
            225 0                  ;out, channel
        i   225 5   60          \   ;bp cluster
            1500 500 275 .3        \ 
            110 250 0 
        i   250 5   60          \   ; var filter
            900    0.45    1   \   ; hz, q, type
            225 251 0               ; in, out, channel
        i   251 5   60          \   ; var filter
            200    0.45    1   \   ; hz, q, type
            250 901 0               ; in, out, channel

    ; spat is avail all 90
    i   901 0   68          \
        .25 .75  1        \   ; pan start, end, dur
        251 0               \
        1                       ; masterdB 

[ LOW CREEK BITS ]
    ; low-creek-1.wav
    i   110 0   60          \   ;diskin2 110
        4   0.5 0             \   ;index, speed, offset
        1 0.125 0.125    \   ; atk, adur, fdur
        250 0                  ;out, channel
    i   250 0   60          \   ; var filter
        500    0.45    0   \   ; hz, q, type
        110 251 0               ; in, out, channel
    i   251 0   60          \   ; var filter
        400    0.45    0   \   ; hz, q, type
        250 901 0               ; in, out, channel
    i   901 0   60          \
        1 0.5 1        \   ; pan start, end, dur
        251 0               \
        2                       ; masterdB

    ; low-creek-2.wav
    i   110 0   70          \   ;diskin2 110
        4   0.5 0             \   ;index, speed, offset
        1 0.09 0.09    \   ; atk, adur, fdur
        225 0                  ;out, channel
    i   225 0   70          \   ;bp cluster
        150 50 20 .6        \ 
        110 250 0 
    i   250 0   70          \   ; var filter
        650    0.45    0   \   ; hz, q, type
        225 251 0               ; in, out, channel
    i   251 0   70          \   ; var filter
        550    0.45    0   \   ; hz, q, type
        250 901 0               ; in, out, channel
    i   901 0   70          \
        0 0.5 1        \   ; pan start, end, dur
        251 0               \
        4                       ; masterdB

    ; low-creek-3.wav
    i   110 0   45          \   ;diskin2 110
        4   0.35 0             \   ;index, speed, offset
        1 0.09 0.09    \   ; atk, adur, fdur
        225 0                  ;out, channel
    i   225 0   45          \   ;bp cluster
        325 25 15 .8        \ 
        110 250 0 
    i   250 0   45          \   ; var filter
        725    0.35    0   \   ; hz, q, type
        225 251 0               ; in, out, channel
    i   251 0   45          \   ; var filter
        600    0.45    0   \   ; hz, q, type
        250 901 0               ; in, out, channel
    i   901 0   45          \
        0.25 0.5 1        \   ; pan start, end, dur
        251 0               \
        2                       ; masterdB

    ; low-creek-4.wav
    i   110 0   45          \   ;diskin2 110
        4   0.35 10             \   ;index, speed, offset
        1 0.09 0.09    \   ; atk, adur, fdur
        225 0                  ;out, channel
    i   225 0   45          \   ;bp cluster
        411 31 10 .8        \ 
        110 250 0 
    i   250 0   45          \   ; var filter
        725    0.35    0   \   ; hz, q, type
        225 251 0               ; in, out, channel
    i   251 0   45          \   ; var filter
        600    0.45    0   \   ; hz, q, type
        250 901 0               ; in, out, channel
    i   901 0   45          \
        0.75 0.5 1        \   ; pan start, end, dur
        251 0               \
        4                       ; masterdB
</CsScore>