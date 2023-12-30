

#include <stdlib.h>          // EXIT_ codes
#include <stdio.h>           // printf
#include <string.h>          // strcmp
#include "wavegen_ip.h"         // GPIO IP library
#include <stdint.h> 

int main(int argc, char* argv[])
{
    int fre, amp, off, duty;
    if (argc == 6)
    {
        gpioOpen();
        fre = atoi(argv[2]);
        amp = atoi(argv[3]);
        off = atoi(argv[4]);
        duty = atoi(argv[5]);
        
        if (strcmp(argv[1], "sine_a") == 0)
        {
            setMode_A(0x1);
            setFrequency_A(fre);
            setOffset_A(off);
            setAmplitude_A(amp);
            
        }
        if (strcmp(argv[1], "sine_b") == 0)
        {
            setMode_B(0x1);
            setFrequency_B(fre);
            setOffset_B(off);
            setAmplitude_B(amp);
            
        }
        else if (strcmp(argv[1], "sawtooth_a") == 0)
        {
            setMode_A(0x2);
            setFrequency_A(fre);
            setOffset_A(off);
            setAmplitude_A(amp);
        }
        else if (strcmp(argv[1], "sawtooth_b") == 0)
        {
            setMode_B(0x2);
            setFrequency_B(fre);
            setOffset_B(off);
            setAmplitude_B(amp);
        }
        else if (strcmp(argv[1], "triangle_a") == 0)
        {
            setMode_A(0x3);
            setFrequency_A(fre);
            setOffset_A(off);
            setAmplitude_B(amp);
        }
        else if (strcmp(argv[1], "triangle_b") == 0)
        {
            setMode_B(0x3);
            setFrequency_B(fre);
            setOffset_B(off);
            setAmplitude_B(amp);
        }
        else if (strcmp(argv[1], "square_a") == 0)
        {
            setMode_A(0x4);
            setFrequency_A(fre);
            setOffset_B(off);
            setAmplitude_A(amp);
            setDtcyc_A(duty);
        }
        else if (strcmp(argv[1], "square_b") == 0)
        {
            setMode_B(0x4);
            setFrequency_B(fre);
            setOffset_A(off);
            setAmplitude_B(amp);
            setDtcyc_B(duty);
        }
       
    }
    else if (argc == 3)
    {
        gpioOpen();
        int offset, number;
        offset = atoi(argv[2]);
        number = atoi(argv[2]);
        
         if (strcmp(argv[1], "dc_a") == 0)
        {
            setMode_A(0x0);
            setOffset_A(offset);
        }
        else if (strcmp(argv[1], "dc_b") == 0)
        {
            setMode_B(0x0);
            setOffset_B(offset);
        }
         else if (strcmp(argv[1], "cycles_a") == 0)
        {
            setCycles_A(number);
         }
         else if (strcmp(argv[1], "cycles_b") == 0)
        {
            setCycles_B(number);
         }
         else if ( (strcmp(argv[1], "cycles") == 0 && strcmp(argv[2], "continous" ) ))
        {
             setCycles_A(60000);
             setCycles_B(60000);
        }

    }
    else if (argc == 2)
    {
        gpioOpen();
            if (strcmp(argv[1], "run") == 0)
            {
                RunOn_Off_A(1);
                RunOn_Off_B(1);
            }
        if (strcmp(argv[1], "run_a") == 0)
        {
            RunOn_Off_A(1);
        }
        if (strcmp(argv[1], "run_b") == 0)
        {
            RunOn_Off_B(1);
        }
        if (strcmp(argv[1], "stop_a") == 0)
         {
             RunOn_Off_A(0);
         }
         if (strcmp(argv[1], "stop_b") == 0)
         {
             RunOn_Off_B(0);
         }
         if (strcmp(argv[1], "stop") == 0)
         {
             RunOn_Off_A(0);
             RunOn_Off_B(0);
         }
        
        
    }
             
    else if (argc == 2 && (strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0))
    {
        printf("  See the Project Document");
    }
    else
        printf("  command not understood\n");
    return EXIT_SUCCESS;
}

