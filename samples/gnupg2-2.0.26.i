# 79 "../jnlib/types.h"
typedef unsigned int u32;

# 45 "rmd160.c"
static inline u32
rol (u32 x, int n)
{
  __asm__("roll %%cl,%0"
          :"=r" (x)
          :"0" (x),"c" (n));
  return x;
}

