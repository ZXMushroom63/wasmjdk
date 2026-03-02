#define FUTEX_WAIT 0
#define FUTEX_WAKE 1
#define FUTEX_WAIT_PRIVATE 128
#define FUTEX_WAKE_PRIVATE 129
#include <emscripten/threading.h>
#include <emscripten/atomic.h>
#include <errno.h>


static long futex(volatile int *addr, int futex_op, int op_arg) {
  if (futex_op == FUTEX_WAIT_PRIVATE || futex_op == FUTEX_WAIT) {
    // 0 (on value mismatch / EAGAIN)
    // 1 (timed out)
    // 2 (woken up)
    int res = emscripten_atomic_wait_u32((void*)addr, (uint32_t)op_arg, -1);
    
    if (res == 0) {
      errno = EAGAIN;
      return -1;
    }
    return 0; // successfully woken
  } 
  
  if (futex_op == FUTEX_WAKE_PRIVATE || futex_op == FUTEX_WAKE) {
    // returns the number of threads awoken
    return emscripten_atomic_notify((void*)addr, (uint32_t)op_arg);
  }

  return 0; 
}