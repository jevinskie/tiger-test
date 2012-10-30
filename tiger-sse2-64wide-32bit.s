.text

.globl _tiger_round_sse2
# tiger_round( u64 *ra, u64 *rb, u64 *rc, u64 x, int mul )
#    u64 a = *ra;
#    u64 b = *rb;
#    u64 c = *rc;
_tiger_round_sse2:
  pushl %ebx
  movl 16(%esp), %ecx             # %ecx = *rc
  movq (%ecx), %mm0               # %mm0 = c
  movq 20(%esp), %mm1             # %mm1 = x
  pxor %mm1, %mm0                 # c ^= x
  movq %mm0, (%ecx)               # return c to memory
  
  
  pxor %mm4, %mm4                 # zero the temp xor
  movl 8(%esp), %ecx              # %ecx = *ra
  movq (%ecx), %mm2               # %mm2 = a
  
  pextrw $0, %mm0, %eax           # %eax = c & 0xFFFF
  andl $0xFF, %eax                # %eax = c & 0xFF
  pextrw $1, %mm0, %ebx           # %ebx = (c >> 16) & 0xFFFF
  and $0xFF, %ebx                 # %ebx = (c >> 16) & 0xFF
  pextrw $2, %mm0, %ecx           # %ecx = (c >> 32) & 0xFFFF
  andl $0xFF, %ecx                # %ecx = (c >> 32) & 0xFF
  pextrw $3, %mm0, %edx           # %edx = (c >> 48) & 0xFFFF
  andl $0xFF, %edx                # %edx = (c >> 48) & 0xFF
  
  movq _sbox1(,%eax,8), %mm3      # %eax = sbox1[c & 0xFF]
  pxor %mm3, %mm4
  movq _sbox2(,%ebx,8), %mm3      # %ecx = sbox1[c & 0xFF]
  pxor %mm3, %mm4
  movq _sbox3(,%ecx,8), %mm3      # %eax = sbox1[c & 0xFF]
  pxor %mm3, %mm4
  movq _sbox4(,%edx,8), %mm3      # %eax = sbox1[c & 0xFF]
  pxor %mm3, %mm4
  
  psubq %mm4, %mm2                # a = a - xor
  movl 8(%esp), %ecx              # %ecx = *ra
  movq %mm2, (%ecx)               # a = %mm2
  
  
  pxor %mm4, %mm4                 # zero the temp xor
  movl 12(%esp), %ecx             # %ecx = *rb
  movq (%ecx), %mm2               # %mm2 = b
  
  psrlq $8, %mm0                  # shift c right one byte
  pextrw $0, %mm0, %eax           # %eax = c & 0xFFFF
  andl $0xFF, %eax                # %eax = c & 0xFF
  pextrw $1, %mm0, %ebx           # %ebx = (c >> 16) & 0xFFFF
  andl $0xFF, %ebx                # %ebx = (c >> 16) & 0xFF
  pextrw $2, %mm0, %ecx           # %ecx = (c >> 32) & 0xFFFF
  andl $0xFF, %ecx                # %ecx = (c >> 32) & 0xFF
  pextrw $3, %mm0, %edx           # %edx = (c >> 48) & 0xFFFF
  andl $0xFF, %edx                # %edx = (c >> 48) & 0xFF
  
  movq _sbox4(,%eax,8), %mm3      # %eax = sbox1[c & 0xFF]
  pxor %mm3, %mm4
  movq _sbox3(,%ebx,8), %mm3      # %ecx = sbox1[c & 0xFF]
  pxor %mm3, %mm4
  movq _sbox2(,%ecx,8), %mm3      # %eax = sbox1[c & 0xFF]
  pxor %mm3, %mm4
  movq _sbox1(,%edx,8), %mm3      # %eax = sbox1[c & 0xFF]
  pxor %mm3, %mm4
  
  paddq %mm4, %mm2                # b = b + xor
  
  movq %mm2, %mm5
  movl 28(%esp), %ecx
  cmpl $5, %ecx
  je mult5
  cmpl $7, %ecx
  je mult7
  psllq $3, %mm5
  paddq %mm2, %mm5

end:
  movl 12(%esp), %ecx             # %ecx = *rb
  movq %mm5, (%ecx)               # b = %mm5
  popl %ebx
  ret


mult5:
  psllq $2, %mm5
  paddq %mm2, %mm5
  jmp end
  
mult7:
  psllq $3, %mm5
  psubq %mm2, %mm5
  jmp end



.globl _has_sse2
#   int has_sse2(void)
_has_sse2:
  pushl %ebx
  
  pushfl
  popl %eax
  movl %eax, %ecx
  xorl $0x200000, %eax
  pushl %eax
  popfl
  pushfl
  popl %eax
  cmpl %eax, %ecx
  jnz cpuid
  movl $0, %eax
  jmp exit
  
  cpuid:
  movl $1, %eax
  cpuid
  andl $0x4000000, %edx
  movl %edx, %eax
  
  exit:
  popl %ebx
  ret


.globl _key_schedule_sse2
#   void key_schedule( u64 *x )
_key_schedule_sse2:
  movl 4(%esp), %eax
  
  movq (%eax), %mm0               # x[0] -= x[7] ^ 0xa5a5a5a5a5a5a5a5LL;
  movq 56(%eax), %mm1             # x[7] = %mm1, x[0] = %mm0
  movl $0xA5A5A5A5, %ecx
  movd %ecx, %mm2
  psllq $32, %mm2
  movd %ecx, %mm3
  por %mm3, %mm2
  pxor %mm1, %mm2
  psubq %mm2, %mm0
  movq %mm0, (%eax)
  
  movq 8(%eax), %mm2              # x[1] ^= x[0];
  pxor %mm0, %mm2                 # x[1] = %mm2, x[0] = %mm0
  movq %mm2, 8(%eax)
  
  movq 16(%eax), %mm3             # x[2] += x[1];
  paddq %mm2, %mm3                # x[2] = %mm3, x[1] = %mm2
  movq %mm3, 16(%eax)
  
  movq 24(%eax), %mm4             # x[3] -= x[2] ^ ((~x[1]) << 19 );
  movl $0xFFFFFFFF, %ecx
  movd %ecx, %mm5
  psllq $32, %mm5
  movd %ecx, %mm6
  por %mm6, %mm5
  pxor %mm5, %mm2
  psllq $19, %mm2
  pxor %mm3, %mm2
  psubq %mm2, %mm4
  movq %mm4, 24(%eax)             # x[3] = %mm4, x[1] is no more, x[2] = %mm3
  
  movq 32(%eax), %mm6             # x[4] ^= x[3];
  pxor %mm4, %mm6                 # x[4] = %mm6, x[3] = %mm4, ~0 = %mm5
  movq %mm6, 32(%eax)
  
  movq 40(%eax), %mm7             # x[5] += x[4];
  paddq %mm6, %mm7                # x[5] = %mm7, x[4] = %mm6
  movq %mm7, 40(%eax)
  
  movq 48(%eax), %mm0             # x[6] -= x[5] ^ ((~x[4]) >> 23 );
  pxor %mm5, %mm6
  psrlq $23, %mm6
  pxor %mm7, %mm6
  psubq %mm6, %mm0
  movq %mm0, 48(%eax)             # x[6] = %mm0, x[4] is no more, x[0] is no more, x[4] = %mm3, x[5] = %mm6
  
  pxor %mm0, %mm1                 # x[7] ^= x[6];
  movq %mm1, 56(%eax)             # x[7] = %mm1, x[6] = %mm0
  
  movq (%eax), %mm2               # x[0] += x[7];
  paddq %mm1, %mm2
  movq %mm2, (%eax)               # x[0] = %mm2, x[7] = %mm1
  
  movq 8(%eax), %mm3              # x[1] -= x[0] ^ ((~x[7]) << 19 );
  pxor %mm5, %mm1
  psllq $19, %mm1
  pxor %mm2, %mm1
  psubq %mm1, %mm3
  movq %mm3, 8(%eax)              # x[1] = %mm3, x[7] is no more, x[0] = %mm2

  movq 16(%eax), %mm4             # x[2] ^= x[1];
  pxor %mm3, %mm4
  movq %mm4, 16(%eax)             # x[2] = %mm4, x[1] = %mm3
  
  movq 24(%eax), %mm6             # x[3] += x[2];
  paddq %mm4, %mm6
  movq %mm6, 24(%eax)             # x[3] = %mm6, x[2] = %mm4
  
  movq 32(%eax), %mm7             # x[4] -= x[3] ^ ((~x[2]) >> 23 );
  pxor %mm5, %mm4
  psrlq $23, %mm4
  pxor %mm6, %mm4
  psubq %mm4, %mm7
  movq %mm7, 32(%eax)             # x[4] = %mm7, x[2] is no more, x[3] = %mm6
  
  movq 40(%eax), %mm0             # x[5] ^= x[4];
  pxor %mm7, %mm0
  movq %mm0, 40(%eax)             # x[5] = %mm0, x[4] = %mm7
  
  movq 48(%eax), %mm1             # x[6] += x[5];
  paddq %mm0, %mm1
  movq %mm1, 48(%eax)             # x[6] = %mm1, x[5] = %mm0
  
  movq 56(%eax), %mm2             # x[7] -= x[6] ^ 0x0123456789abcdefLL;
  movl $0x01234567, %ecx
  movl $0x89ABCDEF, %edx
  movd %ecx, %mm3
  movd %edx, %mm4
  psllq $32, %mm3
  por %mm3, %mm4
  pxor %mm1, %mm4
  psubq %mm4, %mm2
  movq %mm2, 56(%eax)             # x[7] = %mm2, x[6] = %mm1
  
  ret



.globl _memcpy_sse2
_memcpy_sse2:
  mov 4(%esp), %edx
  mov 8(%esp), %eax
  prefetchnta (%eax)
  prefetchnta 16(%eax)
  movdqu (%eax), %xmm0
  movdqu 16(%eax), %xmm1
  movdqu 32(%eax), %xmm2
  movdqu 48(%eax), %xmm3
  movdqu %xmm3, 48(%edx)
  movdqu %xmm2, 32(%edx)
  movdqu %xmm1, 16(%edx)
  movdqu %xmm0, (%edx)
  ret

