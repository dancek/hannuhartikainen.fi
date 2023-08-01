+++
title = "Demoscene"
+++

This is a placeholder page for my demoscene prods. There may be more content later.

My prods elsewhere on the web:
- [Demozoo](https://demozoo.org/sceners/130104/)
- [Pouet](https://www.pouet.net/user.php?who=105070)
- [Nano Gems](https://nanogems.demozoo.org/)

## LoveByte 2023

### Synthwave Camouflage (8 bytes, 8088 / PC-DOS)

[synthwave-camouflage.zip](synthwave-camouflage.zip)

Featured in [Nano Gems](https://nanogems.demozoo.org/) <3

### col0fall (16 bytes, C64)

[col0fall.zip](col0fall.zip)

### Transition effects (16 bytes, MS-DOS)

[transition-effects.zip](transition-effects.zip)

### lustrous (64 bytes, MS-DOS)

[lustrous.zip](lustrous.zip)

## LoveByte Turbo (in Evoke 2022)

### net growth (16 bytes, MS-DOS)
[net-growth.zip](net-growth.zip)

## LoveByte 2022

### RAINBOW DASH 8B

[rbd-8b.zip](rbd-8b.zip)

### OLUMPIC SWIM 16B

[olumpi16.zip](olumpi16.zip)

### HITHAEGLIR 32B

I was hoping to enter all the compos/showcases in Lovebyte 2022 from 8 to 256
bytes, but I had a really hard time coming up with anything reasonable in 32
bytes. Then I looked at some existing 32 byte intros and dissected some that I
liked.

This intro was strongly inspired and basically based on `matisse` by
orbitaldecay, published in 2010. Kudos for the technique! I just found another
way to use it and get different visuals. So huge thanks to orbitaldecay!

[hithaeglir.zip](hithaeglir.zip)

### HYPERBOLAE 64B

```asm
;; HYPERBOLAE 64B / hannu
;
; This is a difficult size category. I tried to find something interesting
; with the FPU that fits, and this was the best I could do. It was really
; difficult to get working on hardware because I had no idea what I was doing.
; But after a lot of FPU register debugging it finally does work. Everywhere
; I tested. It may not be the coolest demo, its graphical ideas might be few,
; but oh boy did I put in a lot of work to get it done.
;
; Greets to all sizecoders!
```

[hyperbolae.zip](hyperbolae.zip)

### ALMONDS IN A SNOWSTORM 128B

A 128 byte fractal intro inspired by the snowy weather we have in Finland
this time of the year.

Glad I could fit both Mandelbrot and Julia with animation and reasonably
nice colors. I learned a lot along the way, and this feels like my best
sizecoding effort of the bunch I'm submitting for Lovebyte 2022.

Thanks to everyone who contributed to the Sizecoding wiki! It's really easy
to learn these days with information freely available. I'm standing on the
shoulders of giants.

Greets to all sizecoders!

[almonds.zip](almonds.zip)

### RIGID ROENTGEN 256B

[rigidroentgen.zip](rigidroentgen.zip)

### QUINE

A 256 byte demo that prints its own source code.

Eg. after `QUINE.COM > OUT.ASM` the contents of `QUINE.ASM` and `OUT.ASM` are exactly the same.

[quine.zip](quine.zip)

```asm
;; QUINE / hannu
; Greets to all sizecoders!
; prints its source:
org 256
mov ah,6
s:mov si,t
l:lodsb
mov dl,al
and dl,127
cmp al,160
int 33
jne l
mov dl,39
int 33
r:dec byte[l+4]
mov byte[r],195
jmp s
t:db ';; QUINE / hannuìè; Greets to all sizecoders!ìè; prints its source:ìèorg 256ìèmov ah,6ìès:mov si,tìèl:lodsbìèmov dl,alìèand dl,127ìècmp al,160ìèint 33ìèjne lìèmov dl,39ìèint 33ìèr:dec byte[l+4]ìèmov byte[r],195ìèjmp sìèt:dbá'
```

