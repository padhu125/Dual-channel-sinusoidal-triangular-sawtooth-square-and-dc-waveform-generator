#ifndef WAVEGEN_DRIVERS_LINUX_H
#define WAVEGEN_DRIVERS_LINUX_H

#include <stdint.h>
#include <stdbool.h>

//-----------------------------------------------------------------------------
// Subroutines
//-----------------------------------------------------------------------------

bool gpioOpen();

void run_a(uint8_t run_a);
void run_b(uint8_t run_b);
void run_a_and_b(uint8_t run_both);
void stop(uint8_t stop);
bool is_run_a();
bool is_run_b();
bool is_run_a_b();
void mode_a(uint8_t mode);
void mode_b(uint8_t mode);
void mode_a_0ff(uint8_t mode);
void mode_b_0ff(uint8_t mode);
bool is_mode_a(uint8_t mode);
bool is_mode_b (uint8_t mode);
void setFrequency_A(uint32_t fre);
void setFrequency_B(uint32_t fre);
uint32_t getFrequency_A();
uint32_t getFrequency_B();
void setOffset_A(int16_t off);
void setOffset_B(int16_t off);
int16_t getOffset_A();
int16_t getOffset_B();
void setamp_A(uint32_t amp);
void setamp_B(uint32_t amp);
uint16_t getamp_A();
uint16_t getamp_B();
void setcycles_A(uint16_t cycles);
void setcycles_B(uint16_t cycles);
uint16_t getcycles_A();
uint16_t getcycles_B();
void setduty_A(uint16_t duty);
void setduty_B(uint16_t duty);
uint16_t getduty_A();
uint16_t getduty_B();





#endif