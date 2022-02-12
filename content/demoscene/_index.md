+++
title = "Demoscene"
+++

This is a placeholder page for my demoscene prods. I've submitted some for [LoveByte 2022](https://lovebyte.party/) and I'll include download links and perhaps some content here later.

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

