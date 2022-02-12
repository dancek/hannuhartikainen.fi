+++
title = "Demoscene"
+++

This is a placeholder page for my demoscene prods. I've submitted some for [LoveByte 2022](https://lovebyte.party/) and I'll include download links and perhaps some content here later.

## HYPERBOLAE 64B

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

## QUINE

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

