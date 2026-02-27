#ifndef PTRACE_SHIM_H
#define PTRACE_SHIM_H

#include <stdint.h>

#define PTRACE_TRACEME      0
#define PTRACE_PEEKTEXT     1
#define PTRACE_PEEKDATA     2
#define PTRACE_POKETEXT     4
#define PTRACE_POKEDATA     5
#define PTRACE_CONT         7
#define PTRACE_KILL         8
#define PTRACE_GETREGS      12
#define PTRACE_SETREGS      13

typedef struct {
    uint64_t rax;
    uint64_t rbx;
    uint64_t rcx;
    uint64_t rdx;
} user_regs_struct;

static inline int ptrace(int request, pid_t pid, void *addr, void *data) {
    return 0;
}

static inline int ptrace_getregs(pid_t pid, user_regs_struct *regs) {
    return 0;
}

static inline int ptrace_setregs(pid_t pid, user_regs_struct *regs) {
    return 0;
}

#endif