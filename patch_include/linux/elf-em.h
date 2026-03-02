#ifndef ELF_EM_SHIM_H
#define ELF_EM_SHIM_H

#include <stdint.h>

#define EM_NONE         0   // No machine
#define EM_M32          1   // AT&T WE 32100
#define EM_SPARC        2   // SPARC
#define EM_386          3   // Intel 80386
#define EM_68K          4   // Motorola 68000
#define EM_88K          5   // Motorola 88000
#define EM_860          7   // Intel 80860
#define EM_ARM          40  // ARM
#define EM_X86_64       62  // AMD x86-64 architecture
#define EM_AARCH64      183 // ARM 64-bit (AArch64)

// typedef struct {
//     uint8_t e_ident[16];   // Magic number and other info
//     uint16_t e_type;       // Object file type
//     uint16_t e_machine;    // Machine type
//     uint32_t e_version;    // Object file version
//     uint64_t e_entry;      // Entry point virtual address
//     uint64_t e_phoff;      // Program header table file offset
//     uint64_t e_shoff;      // Section header table file offset
//     uint32_t e_flags;      // Processor-specific flags
//     uint16_t e_ehsize;     // ELF header size
//     uint16_t e_phentsize;  // Program header table entry size
//     uint16_t e_phnum;      // Number of program header entries
//     uint16_t e_shentsize;  // Section header table entry size
//     uint16_t e_shnum;      // Number of section header entries
//     uint16_t e_shstrndx;   // Section header string table index
// } Elf64_Ehdr;

static inline const char* elf_machine_to_string(uint16_t machine) {
    switch (machine) {
        case EM_NONE:         return "No machine";
        case EM_386:         return "Intel 80386";
        case EM_X86_64:      return "AMD x86-64";
        default:             return "Unknown machine";
    }
}

#endif