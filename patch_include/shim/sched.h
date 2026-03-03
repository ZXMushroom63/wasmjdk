#ifndef SCHED_GETAFFINITY_SHIM_H
#define SCHED_GETAFFINITY_SHIM_H

#include <sched.h>
#include <cstring>

#define MAX_CPUS 8

// typedef struct {
//     unsigned long __bits[(MAX_CPUS + 63) / 64];
// } cpu_set_t;

int sched_getaffinity(pid_t pid, size_t cpusetsize, cpu_set_t *mask) {
    if (!mask) {
        return -1;
    }

    memset(mask, 0, cpusetsize);
    for (size_t i = 0; i < MAX_CPUS; ++i) {
        CPU_SET(i, mask);
    }

    return 0;
}

int __sched_cpucount(size_t setsize, const cpu_set_t *set) {
    int count = 0;
    for (size_t i = 0; i < MAX_CPUS * setsize; i++) {
        if (CPU_ISSET(i, set)) count++;
    }
    return count;
}

// #define CPU_SET(cpuid, set) ((set)->__bits[(cpuid) / 64] |= (1UL << ((cpuid) % 64)))

// #define CPU_CLR(cpuid, set) ((set)->__bits[(cpuid) / 64] &= ~(1UL << ((cpuid) % 64)))

// #define CPU_ISSET(cpuid, set) ((set)->__bits[(cpuid) / 64] & (1UL << ((cpuid) % 64)))

#endif // SCHED_GETAFFINITY_SHIM_H
