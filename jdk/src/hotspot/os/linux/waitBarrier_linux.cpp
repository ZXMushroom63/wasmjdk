#if defined(__EMSCRIPTEN__)
#include <emscripten/threading.h>
#include <emscripten/atomic.h>
#include <errno.h>
#ifndef FUTEX_WAIT
  #define FUTEX_WAIT 0
#endif
#ifndef FUTEX_WAKE
  #define FUTEX_WAKE 1
#endif
#ifndef FUTEX_WAIT_PRIVATE
  #define FUTEX_WAIT_PRIVATE 128
#endif
#ifndef FUTEX_WAKE_PRIVATE
  #define FUTEX_WAKE_PRIVATE 129
#endif

static long futex(volatile int *addr, int futex_op, int op_arg) {
  // Translate Linux Futex operations to Wasm Atomics
  if (futex_op == FUTEX_WAIT_PRIVATE || futex_op == FUTEX_WAIT) {
    // emscripten_atomic_wait_u32 returns:
    // 0 (on value mismatch / EAGAIN)
    // 1 (timed out)
    // 2 (woken up)
    int res = emscripten_atomic_wait_u32((void*)addr, (uint32_t)op_arg, -1);
    
    if (res == 0) {
      errno = EAGAIN;
      return -1;
    }
    return 0; // Success/Woken
  } 
  
  if (futex_op == FUTEX_WAKE_PRIVATE || futex_op == FUTEX_WAKE) {
    // emscripten_atomic_notify returns the number of threads awoken
    return emscripten_atomic_notify((void*)addr, (uint32_t)op_arg);
  }

  return 0; 
}
#else
static long futex(volatile int *addr, int futex_op, int op_arg) {
  return syscall(SYS_futex, addr, futex_op, op_arg, nullptr, nullptr, 0);
}
#endif