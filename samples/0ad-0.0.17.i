# 139 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __time_t;

# 175 "/usr/include/i386-linux-gnu/bits/types.h"
typedef long int __syscall_slong_t;

# 120 "/usr/include/time.h"
struct timespec
  {
    __time_t tv_sec; /* Seconds.  */
    __syscall_slong_t tv_nsec; /* Nanoseconds.  */
  };

# 63 "/usr/include/sched.h"
extern int sched_yield (void);

# 334 "/usr/include/time.h"
extern int nanosleep (const struct timespec *__requested_time,
        struct timespec *__remaining);

# 35 "/usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp"
inline int atomic_exchange_and_add( int * pw, int dv )
{
    // int r = *pw;
    // *pw += dv;
    // return r;

    int r;

    __asm__ __volatile__
    (
        "lock\n\t"
        "xadd %1, %0":
        "=m"( *pw ), "=r"( r ): // outputs (%0, %1)
        "m"( *pw ), "1"( dv ): // inputs (%2, %3 == %1)
        "memory", "cc" // clobbers
    );

    return r;
}

# 55 "/usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp"
inline void atomic_increment( int * pw )
{
    //atomic_exchange_and_add( pw, 1 );

    __asm__
    (
        "lock\n\t"
        "incl %0":
        "=m"( *pw ): // output (%0)
        "m"( *pw ): // input (%1)
        "cc" // clobbers
    );
}

# 69 "/usr/include/boost/smart_ptr/detail/sp_counted_base_gcc_x86.hpp"
inline int atomic_conditional_increment( int * pw )
{
    // int rv = *pw;
    // if( rv != 0 ) ++*pw;
    // return rv;

    int rv, tmp;

    __asm__
    (
        "movl %0, %%eax\n\t"
        "0:\n\t"
        "test %%eax, %%eax\n\t"
        "je 1f\n\t"
        "movl %%eax, %2\n\t"
        "incl %2\n\t"
        "lock\n\t"
        "cmpxchgl %2, %0\n\t"
        "jne 0b\n\t"
        "1:":
        "=m"( *pw ), "=&a"( rv ), "=&r"( tmp ): // outputs (%0, %1, %2)
        "m"( *pw ): // input (%3)
        "cc" // clobbers
    );

    return rv;
}

# 96 "/usr/include/boost/smart_ptr/detail/yield_k.hpp"
inline void yield( unsigned k )
{
    if( k < 4 )
    {
    }

    else if( k < 16 )
    {
        __asm__ __volatile__( "rep; nop" : : : "memory" );
    }

    else if( k < 32 || k & 1 )
    {
        sched_yield();
    }
    else
    {
        // g++ -Wextra warns on {} or {0}
        struct timespec rqtp = { 0, 0 };

        // POSIX says that timespec has tv_sec and tv_nsec
        // But it doesn't guarantee order or placement

        rqtp.tv_sec = 0;
        rqtp.tv_nsec = 1000;

        nanosleep( &rqtp, 0 );
    }
}

# 91 "../../../source/lib/sysdep/cpu.h"
inline void cpu_Pause()
{



 __asm__ __volatile__( "rep; nop" : : : "memory" );

}

# 49 "/usr/include/stdint.h"
typedef unsigned short int uint16_t;

# 51 "/usr/include/stdint.h"
typedef unsigned int uint32_t;

# 58 "/usr/include/stdint.h"
typedef unsigned long long int uint64_t;

# 101 "/usr/include/SDL/SDL_stdinc.h"
typedef uint16_t Uint16;

# 103 "/usr/include/SDL/SDL_stdinc.h"
typedef uint32_t Uint32;

# 108 "/usr/include/SDL/SDL_stdinc.h"
typedef uint64_t Uint64;

# 75 "/usr/include/SDL/SDL_endian.h"
static __inline__ Uint16 SDL_Swap16(Uint16 x)
{
 __asm__("xchgb %b0,%h0" : "=q" (x) : "0" (x));
 return x;
}

# 108 "/usr/include/SDL/SDL_endian.h"
static __inline__ Uint32 SDL_Swap32(Uint32 x)
{
 __asm__("bswap %0" : "=r" (x) : "0" (x));
 return x;
}

# 144 "/usr/include/SDL/SDL_endian.h"
static __inline__ Uint64 SDL_Swap64(Uint64 x)
{
 union {
  struct { Uint32 a,b; } s;
  Uint64 u;
 } v;
 v.u = x;
 __asm__("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
         : "=r" (v.s.a), "=r" (v.s.b)
         : "0" (v.s.a), "1" (v.s.b));
 return v.u;
}

# 26 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned int __u32;

# 30 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned long long __u64;

# 7 "/usr/include/i386-linux-gnu/asm/swab.h"
static __inline__ __u32 __arch_swab32(__u32 val)
{
 __asm__("bswapl %0" : "=r" (val) : "0" (val));
 return val;
}

# 14 "/usr/include/i386-linux-gnu/asm/swab.h"
static __inline__ __u64 __arch_swab64(__u64 val)
{

 union {
  struct {
   __u32 a;
   __u32 b;
  } s;
  __u64 u;
 } v;
 v.u = val;
 __asm__("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
     : "=r" (v.s.a), "=r" (v.s.b)
     : "0" (v.s.a), "1" (v.s.b));
 return v.u;




}

