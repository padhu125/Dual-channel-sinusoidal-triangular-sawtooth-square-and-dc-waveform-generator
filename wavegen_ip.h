// Wavegen IP Example
// Wavegen IP Library (Wavegen_ip.h)
// Rao Ali/Padhu

//-----------------------------------------------------------------------------
// Hardware Target
//-----------------------------------------------------------------------------

// Target Platform: Xilinx XUP Blackboard

// Hardware configuration:
//
// AXI4-Lite interface:
//   Mapped to offset of 0
// ---------------------------------------------------------

#ifndef WAVEGEN_IP_H
#define WAVEGEN_IP_H

#include <stdint.h>
#include <stdbool.h>

//-----------------------------------------------------------------------------
// Subroutines
//-----------------------------------------------------------------------------

bool gpioOpen();
void setMode_A(uint32_t mode);
void setMode_B(uint32_t mode);
void RunOn_Off_A(uint8_t on);
void RunOn_Off_B(uint8_t on);
void setFrequency_A(uint32_t fre);
void setFrequency_B(uint32_t fre);
void setOffset_A(uint32_t amp);
void setOffset_B(uint32_t amp);
void setAmplitude_A(uint32_t amp);
void setAmplitude_B(uint32_t amp);
void setCycles_A(uint32_t cycle);
void setCycles_B(uint32_t cycle);
void setCycles_A(uint32_t cycle);
void setCycles_B(uint32_t cycle);
void setDtcyc_A(uint32_t duty);
void setDtcyc_B(uint32_t duty);

#endif
