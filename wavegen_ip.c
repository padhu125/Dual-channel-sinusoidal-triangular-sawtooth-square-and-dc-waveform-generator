
#include <stdint.h>          // C99 integer types -- uint32_t
#include <stdbool.h>         // bool
#include <fcntl.h>           // open
#include <sys/mman.h>        // mmap
#include <unistd.h>          // close
#include "../address_map.h"  // address map
#include "wavegen_ip.h"         // gpio


//-------------------------
// Assuming this structure represents the hardware registers
#define MODE                    0
#define RUN                     1
#define FREQ_A                  2
#define FREQ_B                  3
#define OFFSET                  4
#define AMPLITUDE               5
#define DTYCYC                  6
#define CYCLES                  7
// What they mean 
#define DC 0x0 
#define SINE 0x1
#define SAWTOOTH 0x2
#define TRIANGLE 0x3
#define SQUARE 0x4 

// The base address of your device registers
//volatile uint32_t *base = (uint32_t *)0x4C300000;
uint32_t *base = NULL;

bool gpioOpen()
{
    // Open /dev/mem
    int file = open("/dev/mem", O_RDWR | O_SYNC);
    bool bOK = (file >= 0);
    if (bOK)
    {
        // Create a map from the physical memory location of
        // /dev/mem at an offset to LW avalon interface
        // with an aperature of SPAN_IN_BYTES bytes
        // to any location in the virtual 32-bit memory space of the process
        base = mmap(NULL, 32, PROT_READ | PROT_WRITE, MAP_SHARED,   // SPAN_IN_BYTES 32
                    file, 0x43C10000);
        bOK = (base != MAP_FAILED);

        // Close /dev/mem
        close(file);
    }
    return bOK;
}

void setMode_A(uint32_t mode)
{
    *(base + MODE) &=  ~0xFFFFFFC7;
    *(base + MODE) |= mode;
}
void setMode_B(uint32_t mode)
{
    *(base + MODE) &= ~0xFFFFFFF8;
    *(base + MODE) |= (mode << 3);
}

void RunOn_Off_A(uint8_t on)
{
    *(base + RUN) &= ~0xFFFFFFFD;
    *(base + RUN) |= on;
}
void RunOn_Off_B(uint8_t on)
{
    *(base + RUN) &= ~0xFFFFFFFE;
    *(base + RUN) |= (on << 1);
}

void setFrequency_A(uint32_t fre)
{
    *(base + FREQ_A) = fre;
}

void setFrequency_B(uint32_t fre)
{
    *(base + FREQ_B) = fre;
}

void setOffset_A(uint32_t amp)
{
    *(base + OFFSET) &= 0xFFFF0000;  // Clear the lower 16 bits
    *(base + OFFSET) |= amp;
}
void setOffset_B(uint32_t amp)
{
    *(base + OFFSET) &= 0x0000FFFF;  // Clear the lower 16 bits
    *(base + OFFSET) |= (amp << 16);
}

void setAmplitude_A(uint32_t amp)
{
    *(base + AMPLITUDE) &= 0xFFFF0000;  // Clear the lower 16 bits
    *(base + AMPLITUDE) |= amp;
}
void setAmplitude_B(uint32_t amp)
{
    *(base + AMPLITUDE) &= 0x0000FFFF;  // Clear the lower 16 bits
    *(base + AMPLITUDE) |= (amp << 16);
}
void setDtcyc_A(uint32_t duty)
{
    *(base + DTYCYC) &= 0xFFFF0000; // Clear the lower 16 bits
    *(base + DTYCYC) |= duty;
    
}
void setDtcyc_B(uint32_t duty)
{
    *(base + DTYCYC) &= 0xFFFF0000; // Clear the lower 16 bits
    *(base + DTYCYC) |= (duty << 16);

}

void setCycles_A(uint32_t cycle)
{
    *(base + CYCLES) &= 0xFFFF0000; // Clear the lower 16 bits
    *(base + CYCLES) |= cycle;
}
void setCycles_B(uint32_t cycle)
{
    *(base + CYCLES) &= 0x0000FFFF; // Clear the lower 16 bits
    *(base + CYCLES) |= (cycle << 16);
}

