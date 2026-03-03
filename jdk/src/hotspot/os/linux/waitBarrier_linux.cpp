#define FUTEX_WAIT 0
#define FUTEX_WAKE 1
#define FUTEX_WAIT_PRIVATE 128
#define FUTEX_WAKE_PRIVATE 129
#include <emscripten/threading.h>
#include <errno.h>
#include <mutex>
#include <emscripten.h>
#include <condition_variable>
#include <waitBarrier_linux.hpp>
#include <atomic>


void LinuxWaitBarrier::arm(int barrier_tag) {
  _futex_barrier.store(barrier_tag, std::memory_order_release);
  emscripten_futex_wake(&_futex_barrier, 1);
}

void LinuxWaitBarrier::disarm() {
  _futex_barrier.store(0, std::memory_order_release);
}

void LinuxWaitBarrier::wait(int barrier_tag) {
  while (true) {
    int current_barrier = _futex_barrier.load(std::memory_order_acquire);
    
    if (current_barrier >= barrier_tag) {
      return;
    }

    emscripten_futex_wait(&_futex_barrier, current_barrier, 0);
  }
}


// static long futex(volatile int *addr, int futex_op, int op_arg) {
//   if (futex_op == FUTEX_WAIT_PRIVATE || futex_op == FUTEX_WAIT) {
//     // 0 (on value mismatch / EAGAIN)
//     // 1 (timed out)
//     // 2 (woken up)
//     int res = emscripten_atomic_wait_u32((void*)addr, (uint32_t)op_arg, -1);
    
//     if (res == 0) {
//       errno = EAGAIN;
//       return -1;
//     }
//     return 0; // successfully woken
//   } 
  
//   if (futex_op == FUTEX_WAKE_PRIVATE || futex_op == FUTEX_WAKE) {
//     // returns the number of threads awoken
//     return emscripten_atomic_notify((void*)addr, (uint32_t)op_arg);
//   }

//   return 0; 
// }