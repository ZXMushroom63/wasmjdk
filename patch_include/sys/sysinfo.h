#ifndef SYSINFO_SHIM_H
#define SYSINFO_SHIM_H

#include <cstdint>

struct sysinfo {
    long uptime;
    unsigned long loads[3];
    long totalram;
    long freeram;
    long sharedram;
    long bufferram;
    long totalswap;
    long freeswap;
    unsigned short procs;
    char _f[22];
    char _ss[64];
};

int sysinfo(struct sysinfo *info) {
    if (!info) {
        return -1;
    }

    info->uptime = 0;
    info->totalram = 8 * 1024 * 1024 * 1024;  // 8 gb total
    info->freeram = 4 * 1024 * 1024 * 1024;   // 4 gb free
    info->loads[0] = 10;            // fake load avg
    info->loads[1] = 5;             // fake load avg
    info->loads[2] = 2;             // fake load avg
    info->procs = 100;              // fake proc #

    info->sharedram = 0;
    info->bufferram = 0;
    info->totalswap = 0;
    info->freeswap = 0;
    info->_f[0] = '\0';
    info->_ss[0] = '\0';

    return 0; // success
}

#endif // SYSINFO_SHIM_H