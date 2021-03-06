; The MIT License (MIT)
;
; Copyright (c) 2014 Microsoft
; 
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
;
; Author: Mark Gottscho <mgottscho@ucla.edu>

.code
win_x86_64_asm_forwStride16Read_Word128 proc

; Arguments:
; rcx is address of the first 128-bit word in the array
; rdx is address of the last 128-bit word in the array

; rax holds number of words accessed
; rcx holds the first 128-bit word address
; rdx holds the target total number of words to access
; xmm0 holds result from reading the memory 128-bit wide

    xor rax,rax     ; initialize number of words accessed to 0
    sub rdx,rcx     ; Get total number of 128-bit words between starting and ending addresses
    shr rdx,4       
    cmp rax,rdx     ; have we completed the target total number of words to access?
    jae done        ; if the number of words accessed >= the target number, then we are done

myloop:
    ; Unroll 16 loads of 128-bit words (16 bytes is 10h) in strides of 16 words before checking loop condition.
    vmovdqa xmm0, xmmword ptr [rcx+0000h]               
    vmovdqa xmm0, xmmword ptr [rcx+0100h]               
    vmovdqa xmm0, xmmword ptr [rcx+0200h]               
    vmovdqa xmm0, xmmword ptr [rcx+0300h]               
    vmovdqa xmm0, xmmword ptr [rcx+0400h]               
    vmovdqa xmm0, xmmword ptr [rcx+0500h]               
    vmovdqa xmm0, xmmword ptr [rcx+0600h]               
    vmovdqa xmm0, xmmword ptr [rcx+0700h]               
    vmovdqa xmm0, xmmword ptr [rcx+0800h]               
    vmovdqa xmm0, xmmword ptr [rcx+0900h]               
    vmovdqa xmm0, xmmword ptr [rcx+0A00h]               
    vmovdqa xmm0, xmmword ptr [rcx+0B00h]               
    vmovdqa xmm0, xmmword ptr [rcx+0C00h]               
    vmovdqa xmm0, xmmword ptr [rcx+0D00h]               
    vmovdqa xmm0, xmmword ptr [rcx+0E00h]               
    vmovdqa xmm0, xmmword ptr [rcx+0F00h]               

    add rax,16     ; Just did 16 accesses

    cmp rax,rdx     ; have we completed the target number of accesses in total yet?
    jb myloop       ; make another unrolled pass on the memory
    
done:
    xor eax,eax     ; return 0
    ret

win_x86_64_asm_forwStride16Read_Word128 endp
end
