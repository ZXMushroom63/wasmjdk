#ifndef PRCTL_SHIM_H
#define PRCTL_SHIM_H

#include <stdint.h>

#define PR_SET_NAME        15
#define PR_GET_NAME        16
#define PR_SET_PIDFD      24
#define PR_GET_PIDFD      25

static inline int prctl(int option, ...) {
    return 0;
}

static inline int prctl_set_name(const char *name) {
    return 0;
}

static inline int prctl_get_name(char *name, size_t size) {
    if (size > 0) {
        name[0] = '\0';
    }
    return 0;
}

#endif