// QE IP Example
// QE Driver (qe_driver.c)
// Jason Losh

//-----------------------------------------------------------------------------
// Hardware Target
//-----------------------------------------------------------------------------

// Target Platform: Xilinx XUP Blackboard

// Hardware configuration:
//
// AXI4-Lite interface
//   Mapped to offset of 0x10000
//
// QE 0 and 1 interface:
//   GPIO[11-10] are used for QE 0 inputs
//   GPIO[9-8] are used for QE 1 inputs

// Load kernel module with insmod qe_driver.ko [param=___]

//-----------------------------------------------------------------------------

#include <linux/kernel.h>     // kstrtouint
#include <linux/module.h>     // MODULE_ macros
#include <linux/init.h>       // __init
#include <linux/kobject.h>    // kobject, kobject_atribute,
                              // kobject_create_and_add, kobject_put
#include <asm/io.h>           // iowrite, ioread, ioremap_nocache (platform specific)
#include "../address_map.h"   // overall memory map


//-----------------------------------------------------------------------------
// Kernel module information
//-----------------------------------------------------------------------------

#define MODE                    0
#define RUN                     1
#define FREQ_A                  2
#define FREQ_B                  3
#define OFFSET                  4
#define AMPLITUDE               5
#define DTYCYC                  6
#define CYCLES                  7

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Rao & Padhu");
MODULE_DESCRIPTION("Wavegen Driver");

//-----------------------------------------------------------------------------
// Global variables
//-----------------------------------------------------------------------------

static unsigned int *base = NULL;

//-----------------------------------------------------------------------------
// Subroutines
//-----------------------------------------------------------------------------

void run_a(uint8_t run_a)
{
    unsigned int value = ioread32(base + RUN);
    iowrite32(value | run_a, base + RUN);
}
void run_b(uint8_t run_b)
{
    unsigned int value = ioread32(base + RUN);
    iowrite32(value | (1 << run_b), base + RUN);
}
void run_a_and_b(uint8_t run_both)
{
    unsigned int value = ioread32(base + RUN);
    iowrite32(value | 3, base + RUN);
}
void stop(uint8_t stop)
{
    unsigned int value = ioread32(base + RUN);
    iowrite32(value & 0, base + RUN);
}
bool is_run_a(void)
{
    return (ioread32(base + RUN)) & 0x1;
}
bool is_run_b(void)
{
    return (ioread32(base + RUN)) & 0x2;
}
bool is_run_a_b(void)
{
    return (((ioread32(base + RUN)) & 0x1) && (ioread32(base + RUN)) & 0x2);
}

// functions for the modes

void mode_a(uint8_t mode)
{
    unsigned int value = ioread32(base + MODE);
    if
    (mode == 0) // dc
    {
        iowrite32(value & 0xFFFFFFF8, base + MODE); // writing zero
    }
    if (mode == 1) // sine
    {
        iowrite32(value & 0xFFFFFFF8, base + MODE);
        iowrite32(0x01, base + MODE);
    }
    if (mode == 2) // saw
    {
        iowrite32(value & 0xFFFFFFF8, base + MODE);
        iowrite32(0x02, base + MODE);
    }
    if (mode == 3) // tri
    {
        iowrite32(value & 0xFFFFFFF8, base + MODE);
        iowrite32(0x03, base + MODE);
    }
    if (mode == 4) // sqaure
    {
        iowrite32(value & 0xFFFFFFF8, base + MODE);
        iowrite32(0x04, base + MODE);
    }
        
}

void mode_b(uint8_t mode)
{
    unsigned int value = ioread32(base + MODE);
    if
    (mode == 0) // dc
    {
        iowrite32(value & 0xFFFFFFC7, base + MODE); // writing zero
    }
    if (mode == 1) // sine
    {
        iowrite32(value & 0xFFFFFFC7, base + MODE);
        iowrite32(0x01 << 3, base + MODE);
    }
    if (mode == 2) // saw
    {
        iowrite32(value & 0xFFFFFFC7, base + MODE);
        iowrite32(0x02 << 3, base + MODE);
    }
    if (mode == 3) // tri
    {
        iowrite32(value & 0xFFFFFFC7, base + MODE);
        iowrite32(0x03 << 3, base + MODE);
    }
    if (mode == 4) // sqaure
    {
        iowrite32(value & 0xFFFFFFC7, base + MODE);
        iowrite32(0x04 << 3, base + MODE);
    }
        
}
// OFF A AND B
void mode_a_0ff(uint8_t mode)
{
    unsigned int value = ioread32(base + MODE);
    if
    (mode == 0) // dc
    {
        iowrite32(value & 0xFFFFFFF8, base + MODE); // writing zero
    }
    if (mode == 1) // sine
    {
        iowrite32(value & 0xFFFFFFF8, base + MODE); // writing zero
    }
    if (mode == 2) // saw
    {
        iowrite32(value & 0xFFFFFFF8, base + MODE); // writing zero
    }
    if (mode == 3) // tri
    {
        iowrite32(value & 0xFFFFFFF8, base + MODE); // writing zero
    }
    if (mode == 4) // sqaure
    {
        iowrite32(value & 0xFFFFFFF8, base + MODE); // writing zero
    }
        
}

void mode_b_0ff(uint8_t mode)
{
    unsigned int value = ioread32(base + MODE);
    if
    (mode == 0) // dc
    {
        iowrite32(value & 0xFFFFFFC7, base + MODE); // writing zero
    }
    if (mode == 1) // sine
    {
        iowrite32(value & 0xFFFFFFC7, base + MODE); // writing zero
    }
    if (mode == 2) // saw
    {
        iowrite32(value & 0xFFFFFFC7, base + MODE); // writing zero
    }
    if (mode == 3) // tri
    {
        iowrite32(value & 0xFFFFFFC7, base + MODE); // writing zero
    }
    if (mode == 4) // sqaure
    {
        iowrite32(value & 0xFFFFFFC7, base + MODE); // writing zero
    }
        
}

bool is_mode_a(uint8_t mode)
{
    
    if
    (mode == 0) // dc
    {
        return !((ioread32(base + MODE) & 0x3) & (ioread32(base + MODE) & 0x2) & (ioread32(base + MODE) & 0x1))  ;
    }
    if (mode == 1) // sine
    {
        return (ioread32(base + MODE) | 0x1);
    }
    if (mode == 2) // saw
    {
        return (ioread32(base + MODE) | 0x2);
    }
    if (mode == 3) // tri
    {
        return ( (ioread32 (base + MODE) | 0x1) && (ioread32(base + MODE) | 0x2) );
    }
    if (mode == 4) // sqaure
    {
        return (ioread32(base + MODE) | 0x4);
    }
    return -1;
        
}
                
bool is_mode_b (uint8_t mode)
{
    
    if(mode == 0) // dc
    {
        return !(ioread32(base + MODE) | 0x00010000);
    }
    if (mode == 1) // sine
    {
        return (ioread32(base + MODE) | 0x00010000);
    }
    if (mode == 2) // saw
    {
        return (ioread32(base + MODE) | 0x00020000);
    }
    if (mode == 3) // tri
    {
        return ( (ioread32(base + MODE) | 0x00010000) && (ioread32(base + MODE) | 0x00020000) );
    }
    if (mode == 4) // sqaure
    {
        return (ioread32(base + MODE) | 0x00040000);
    }

    return -1;
        
}
                
void setFrequency_A(int fre)
{
 iowrite32(fre, base + FREQ_A); // writing zero
}

void setFrequency_B(int fre)
{
  iowrite32(fre, base + FREQ_B); // writing zero
}

uint32_t getFrequency_A(void)
{
     return ioread32(base + FREQ_A);
}

uint32_t getFrequency_B(void)
{
    return ioread32(base + FREQ_B);
}

void setOffset_A(int16_t off)
{
 iowrite32(0xFFFF0000, base + OFFSET); // writing zero
 iowrite32(off, base + OFFSET); // writing zero
}

void setOffset_B(int16_t off)
{
iowrite32(0x0000FFFF, base + OFFSET); // writing zero
iowrite32((off << 16), base + OFFSET); // writing zero
}

int16_t getOffset_A(void)
{
    return (int16_t)(ioread32(base + OFFSET) & 0X0000FFFF);
}

int16_t getOffset_B(void)
{
   return (int16_t)((ioread32(base + OFFSET) & 0xFFFF0000) >> 16);
}
            // amplitude
void setamp_A(uint32_t amp)
{
 iowrite32(0xFFFF0000, base + AMPLITUDE); // writing zero
 iowrite32(amp, base + AMPLITUDE); // writing zero
}
void setamp_B(uint32_t amp)
{
 iowrite32(0x0000FFFF, base + AMPLITUDE); // writing zero
 iowrite32((amp << 16), base + AMPLITUDE); // writing zero
}
uint16_t getamp_A(void)
{
    return (ioread32(base + AMPLITUDE) & 0X0000FFFF);
}

uint16_t getamp_B(void)
{
    return (ioread32(base + AMPLITUDE) & 0xFFFF0000);
            
}
void setcycles_A(uint16_t cycles)
{
 iowrite32(0xFFFF0000, base + CYCLES); // writing zero
 iowrite32(cycles, base + CYCLES); // writing zero
}
void setcycles_B(uint16_t cycles)
{
iowrite32(0x0000FFFF, base + CYCLES); // writing zero
iowrite32((cycles << 16), base + CYCLES); // writing zero
}
uint16_t getcycles_A(void)
{
    return (uint16_t)(ioread32(base + CYCLES) & 0X0000FFFF);
}

uint16_t getcycles_B(void)
{
    return (uint16_t)((ioread32(base + CYCLES) & 0xFFFF0000) >> 16);
            
}
void setduty_A(uint16_t duty)
{
 iowrite32(0xFFFF0000, base + DTYCYC); // writing zero
 iowrite32(duty, base + DTYCYC); // writing zero
}
void setduty_B(uint16_t duty)
{
iowrite32(0x0000FFFF, base + DTYCYC); // writing zero
iowrite32((duty << 16), base + DTYCYC); // writing zero
}
uint16_t getduty_A(void)
{
    return (uint16_t)(uint16_t)(ioread32(base + DTYCYC) & 0x0000FFFF);
}

uint16_t getduty_B(void)
{
    return (uint16_t)((ioread32(base + DTYCYC) & 0xFFFF0000) >> 16);
}

                
                
                
                
                
                
                
                

// kernel obkects
static bool RUN_A = 0;
module_param(RUN_A, bool, S_IRUGO);
MODULE_PARM_DESC(RUN_A, " Run a");

static ssize_t RUN_AStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    if (strncmp(buffer, "run_a", strlen("run_a")) == 0)
    {
        run_a(1);
        RUN_A = true;
    }
    else
        if (strncmp(buffer, "false", strlen("false")) == 0)
        {
            run_a(0);
            RUN_A = false;
        }
    return count;
}

static ssize_t RUN_AShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{

    RUN_A = is_run_a();
    if (RUN_A)
        strcpy(buffer, "true");
    else
        strcpy(buffer, "false");

    return strlen(buffer);
}
static struct kobj_attribute RUN_aAttr = __ATTR(RUN_A, S_IRUGO | S_IWUSR, RUN_AShow, RUN_AStore);

// run_b

static bool RUN_B = 0;
module_param(RUN_B, bool, S_IRUGO);
MODULE_PARM_DESC(RUN_B, " Run b");

static ssize_t RUN_BStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    if (strncmp(buffer, "run_b", strlen("run_b")) == 0)
    {
        run_b(1);
        RUN_B = true;
    }
    else
        if (strncmp(buffer, "false", strlen("false")) == 0)
        {
            run_b(0);
            RUN_B = false;
        }
    return count;
}

static ssize_t RUN_BShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{

    RUN_B = is_run_b();
    if (RUN_B)
        strcpy(buffer, "true");
    else
        strcpy(buffer, "false");

    return strlen(buffer);
}
static struct kobj_attribute RUN_bAttr = __ATTR(RUN_B, S_IRUGO | S_IWUSR, RUN_BShow, RUN_BStore);

// BOTH A AND B

static bool RUN_A_B = 0;
module_param(RUN_A_B, bool, S_IRUGO);
MODULE_PARM_DESC(RUN_A_B, " Run b");

static ssize_t RUN_A_BStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    if (strncmp(buffer, "run_a_b", strlen("run_a_b")) == 0)
    {
        run_a_and_b(1);
        RUN_A_B = true;
    }
    else
        if (strncmp(buffer, "false", strlen("false")) == 0)
        {
            stop(0);
            RUN_A_B = false;
        }
    return count;
}

static ssize_t RUN_A_BShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{

    RUN_A_B = is_run_a_b();
    if (RUN_A_B)
        strcpy(buffer, "true");
    else
        strcpy(buffer, "false");

    return strlen(buffer);
}
static struct kobj_attribute RUN_A_BAttr = __ATTR(RUN_A_B, S_IRUGO | S_IWUSR, RUN_A_BShow, RUN_A_BStore);

// now the waves dc_a

static bool dc_a = 0;
module_param(dc_a, bool, S_IRUGO);
MODULE_PARM_DESC(dc_a, " dc_a");

static ssize_t dc_aStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    if (strncmp(buffer, "dc_a", strlen("dc_a")) == 0)
    {
        mode_a(0);
        dc_a = true;
    }
    else
        if (strncmp(buffer, "false", strlen("false")) == 0)
        {
            mode_a_0ff(0);
            dc_a = false;
        }
    return count;
}

static ssize_t dc_aShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{

    dc_a = is_mode_a(0);
    if (dc_a)
        strcpy(buffer, "true");
    else
        strcpy(buffer, "false");

    return strlen(buffer);
}

static struct kobj_attribute dc_aAttr = __ATTR(dc_a, S_IRUGO | S_IWUSR, dc_aShow, dc_aStore);
                
 //dc_b
                
static bool dc_b = 0;
module_param(dc_b, bool, S_IRUGO);
MODULE_PARM_DESC(dc_b, " dc_b");

static ssize_t dc_bStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    if (strncmp(buffer, "dc_b", strlen("dc_b")) == 0)
    {
        mode_b(0);
        dc_b = true;
    }
    else
        if (strncmp(buffer, "false", strlen("false")) == 0)
        {
            mode_b_0ff(0);
            dc_a = false;
        }
    return count;
}

static ssize_t dc_bShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{

    dc_a = is_mode_b(0);
    if (dc_b)
        strcpy(buffer, "true");
    else
        strcpy(buffer, "false");

    return strlen(buffer);
}

static struct kobj_attribute dc_bAttr = __ATTR(dc_b, S_IRUGO | S_IWUSR, dc_bShow, dc_bStore);
                
                
    // sine_a

    static bool sine_a = 0;
    module_param(sine_a, bool, S_IRUGO);
    MODULE_PARM_DESC(sine_a, " sine_a");

    static ssize_t sine_aStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
    {
        if (strncmp(buffer, "sine_a", strlen("sine_a")) == 0)
        {
            mode_a(1);
            sine_a = true;
        }
        else
            if (strncmp(buffer, "false", strlen("false")) == 0)
            {
                mode_a_0ff(1);
                sine_a = false;
            }
        return count;
    }

    static ssize_t sine_aShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
    {

        sine_a = is_mode_a(1);
        if (sine_a)
            strcpy(buffer, "true");
        else
            strcpy(buffer, "false");

        return strlen(buffer);
    }

    static struct kobj_attribute sine_aAttr = __ATTR(sine_a, 0664, sine_aShow, sine_aStore);

    // sine_b

    static bool sine_b = 0;
    module_param(sine_b, bool, S_IRUGO);
    MODULE_PARM_DESC(sine_b, " sine_b");

    static ssize_t sine_bStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
    {
        if (strncmp(buffer, "sine_b", strlen("sine_b")) == 0)
        {
            mode_b(1);
            sine_b = true;
        }
        else
            if (strncmp(buffer, "false", strlen("false")) == 0)
            {
                mode_b_0ff(1);
                sine_b = false;
            }
        return count;
    }

    static ssize_t sine_bShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
    {

        sine_b = is_mode_b(1);
        if (sine_b)
            strcpy(buffer, "true");
        else
            strcpy(buffer, "false");

        return strlen(buffer);
    }

    static struct kobj_attribute sine_bAttr = __ATTR(sine_b, S_IRUGO | S_IWUSR, sine_bShow, sine_bStore);

// sawtooth_a

static bool sawtooth_a = 0;
module_param(sawtooth_a, bool, S_IRUGO);
MODULE_PARM_DESC(sawtooth_a, " sawtooth_a");

static ssize_t sawtooth_aStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    if (strncmp(buffer, "sawtooth_a", strlen("sawtooth_a")) == 0)
    {
        mode_a(2);
        sawtooth_a = true;
    }
    else if (strncmp(buffer, "false", strlen("false")) == 0)
    {
        mode_a_0ff(2);
        sawtooth_a = false;
    }
    return count;
}

static ssize_t sawtooth_aShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    sawtooth_a = is_mode_a(2);
    if (sawtooth_a)
        strcpy(buffer, "true");
    else
        strcpy(buffer, "false");

    return strlen(buffer);
}

static struct kobj_attribute sawtooth_aAttr = __ATTR(sawtooth_a, S_IRUGO | S_IWUSR, sawtooth_aShow, sawtooth_aStore);

// sawtooth_b

static bool sawtooth_b = 0;
module_param(sawtooth_b, bool, S_IRUGO);
MODULE_PARM_DESC(sawtooth_b, " sawtooth_b");

static ssize_t sawtooth_bStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    if (strncmp(buffer, "sawtooth_b", strlen("sawtooth_b")) == 0)
    {
        mode_b(2);
        sawtooth_b = true;
    }
    else if (strncmp(buffer, "false", strlen("false")) == 0)
    {
        mode_b_0ff(2);
        sawtooth_b = false;
    }
    return count;
}

static ssize_t sawtooth_bShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    sawtooth_b = is_mode_b(2);
    if (sawtooth_b)
        strcpy(buffer, "true");
    else
        strcpy(buffer, "false");

    return strlen(buffer);
}

static struct kobj_attribute sawtooth_bAttr = __ATTR(sawtooth_b, S_IRUGO | S_IWUSR, sawtooth_bShow, sawtooth_bStore);

           
// triangle_a

static bool triangle_a = 0;
module_param(triangle_a, bool, S_IRUGO);
MODULE_PARM_DESC(triangle_a, " triangle_a");

static ssize_t triangle_aStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    if (strncmp(buffer, "triangle_a", strlen("triangle_a")) == 0)
    {
        mode_a(3);
        triangle_a = true;
    }
    else if (strncmp(buffer, "false", strlen("false")) == 0)
    {
        mode_a_0ff(3);
        triangle_a = false;
    }
    return count;
}

static ssize_t triangle_aShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    triangle_a = is_mode_a(3);
    if (triangle_a)
        strcpy(buffer, "true");
    else
        strcpy(buffer, "false");

    return strlen(buffer);
}

static struct kobj_attribute triangle_aAttr = __ATTR(triangle_a, S_IRUGO | S_IWUSR, triangle_aShow, triangle_aStore);

// triangle_b

static bool triangle_b = 0;
module_param(triangle_b, bool, S_IRUGO);
MODULE_PARM_DESC(triangle_b, " triangle_b");

static ssize_t triangle_bStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    if (strncmp(buffer, "triangle_b", strlen("triangle_b")) == 0)
    {
        mode_b(3);
        triangle_b = true;
    }
    else if (strncmp(buffer, "false", strlen("false")) == 0)
    {
        mode_b_0ff(3);
        triangle_b = false;
    }
    return count;
}

static ssize_t triangle_bShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    triangle_b = is_mode_b(3);
    if (triangle_b)
        strcpy(buffer, "true");
    else
        strcpy(buffer, "false");

    return strlen(buffer);
}

static struct kobj_attribute triangle_bAttr = __ATTR(triangle_b, S_IRUGO | S_IWUSR, triangle_bShow, triangle_bStore);

// square_a

static bool square_a = 0;
module_param(square_a, bool, S_IRUGO);
MODULE_PARM_DESC(square_a, " square_a");

static ssize_t square_aStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    if (strncmp(buffer, "square_a", strlen("square_a")) == 0)
    {
        mode_a(4);
        square_a = true;
    }
    else if (strncmp(buffer, "false", strlen("false")) == 0)
    {
        mode_a_0ff(4);
        square_a = false;
    }
    return count;
}

static ssize_t square_aShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    square_a = is_mode_a(4);
    if (square_a)
        strcpy(buffer, "true");
    else
        strcpy(buffer, "false");

    return strlen(buffer);
}

static struct kobj_attribute square_aAttr = __ATTR(square_a, S_IRUGO | S_IWUSR, square_aShow, square_aStore);

// square_b

static bool square_b = 0;
module_param(square_b, bool, S_IRUGO);
MODULE_PARM_DESC(square_b, " square_b");

static ssize_t square_bStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    if (strncmp(buffer, "square_b", strlen("square_b")) == 0)
    {
        mode_b(4);
        square_b = true;
    }
    else if (strncmp(buffer, "false", strlen("false")) == 0)
    {
        mode_b_0ff(4);
        square_b = false;
    }
    return count;
}

static ssize_t square_bShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    square_b = is_mode_b(4);
    if (square_b)
        strcpy(buffer, "true");
    else
        strcpy(buffer, "false");

    return strlen(buffer);
}

static struct kobj_attribute square_bAttr = __ATTR(square_b, S_IRUGO | S_IWUSR, square_bShow, square_bStore);
                
// Frequency for fre_a
static int fre_a = 1;  // Default frequency: 1kHz
module_param(fre_a, int, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(fre_a, "Frequency for fre_a (1 Hz to 25 kHz)");

static ssize_t fre_aStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    int result = kstrtoint(buffer, 0, &fre_a);
    if (result == 0 && fre_a >= 1 && fre_a <= 25000) {
        setFrequency_A(fre_a);
    }
    return count;
}

static ssize_t fre_aShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    fre_a = getFrequency_A();
    return sprintf(buffer, "%u\n", fre_a);
}

static struct kobj_attribute fre_aAttr = __ATTR(fre_a, 0664, fre_aShow, fre_aStore);

// Frequency for fre_b
static int fre_b = 1;  // Default frequency: 1kHz
module_param(fre_b, int, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(fre_b, "Frequency for fre_b (1 Hz to 25 kHz)");

static ssize_t fre_bStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    int result = kstrtoint(buffer, 0, &fre_b);
    if (result == 0 && fre_b >= 1 && fre_b <= 25000) {
        setFrequency_B(fre_b);
    }
    return count;
}

static ssize_t fre_bShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    fre_b = getFrequency_B();
    return sprintf(buffer, "%u\n", fre_b);
}

static struct kobj_attribute fre_bAttr = __ATTR(fre_b, 0664, fre_bShow, fre_bStore);
                
// Offset for channel A
static int16_t offset_a = 0;  // Default offset: 0 mV
module_param(offset_a, short, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(offset_a, "Offset for channel A (0 mV to 65535 mV)");

static ssize_t offset_aStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    int result = kstrtos16(buffer, 0, &offset_a);
    if (result == 0 && offset_a <= 65535) {
        setOffset_A(offset_a);
    }
    return count;
}

static ssize_t offset_aShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    offset_a = getOffset_A();
    return sprintf(buffer, "%u\n", offset_a);
}

static struct kobj_attribute offset_aAttr = __ATTR(offset_a, 0664, offset_aShow, offset_aStore);

// Offset for channel B
static int16_t offset_b = 0;  // Default offset: 0 mV
module_param(offset_b, short, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(offset_b, "Offset for channel B (0 mV to 65535 mV)");

static ssize_t offset_bStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    int result = kstrtos16(buffer, 0, &offset_b);
    if (result == 0 && offset_b <= 65535) {
        setOffset_B(offset_b);
    }
    return count;
}

static ssize_t offset_bShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    offset_b = getOffset_B();
    return sprintf(buffer, "%u\n", offset_b);
}

static struct kobj_attribute offset_bAttr = __ATTR(offset_b, 0664, offset_bShow, offset_bStore);


// amp
// Amplitude for channel A
static uint16_t amp_a = 0;  // Default amplitude: 0
module_param(amp_a, ushort, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(amp_a, "Amplitude for channel A (0 to 25000)");

static ssize_t amp_aStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    int result = kstrtou16(buffer, 0, &amp_a);
    if (result == 0 && amp_a <= 25000) {
        setamp_A(amp_a);
    }
    return count;
}

static ssize_t amp_aShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    amp_a = getamp_A();
    return sprintf(buffer, "%u\n", amp_a);
}

static struct kobj_attribute amp_aAttr = __ATTR(amp_a, 0664, amp_aShow, amp_aStore);

// Amplitude for channel B
static uint16_t amp_b = 0;  // Default amplitude: 0
module_param(amp_b, ushort, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(amp_b, "Amplitude for channel B (0 to 25000)");

static ssize_t amp_bStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    int result = kstrtou16(buffer, 0, &amp_b);
    if (result == 0 && amp_b <= 25000) {
        setamp_B(amp_b);
    }
    return count;
}

static ssize_t amp_bShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    amp_b = getamp_B();
    return sprintf(buffer, "%u\n", amp_b);
}

static struct kobj_attribute amp_bAttr = __ATTR(amp_b, 0664, amp_bShow, amp_bStore);

// Cycles for channel A
static uint16_t cycles_a = 0;  // Default cycles: 0
module_param(cycles_a, ushort, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(cycles_a, "Cycles for channel A (0 to 65000)");

static ssize_t cycles_aStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    uint16_t result = kstrtou16(buffer, 0, &cycles_a);
    if (result == 0 && cycles_a <= 65000) {
        setcycles_A(cycles_a);
    }
    return count;
}

static ssize_t cycles_aShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    cycles_a = getcycles_A();
    return sprintf(buffer, "%u\n", cycles_a);
}

static struct kobj_attribute cycles_aAttr = __ATTR(cycles_a, 0664, cycles_aShow, cycles_aStore);

// Cycles for channel B
static uint16_t cycles_b = 0;  // Default cycles: 0
module_param(cycles_b, ushort, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(cycles_b, "Cycles for channel B (0 to 65000)");

static ssize_t cycles_bStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    int result = kstrtou16(buffer, 0, &cycles_b);
    if (result == 0 && cycles_b <= 65000) {
        setcycles_B(cycles_b);
    }
    return count;
}

static ssize_t cycles_bShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    cycles_b = getcycles_B();
    return sprintf(buffer, "%u\n", cycles_b);
}

static struct kobj_attribute cycles_bAttr = __ATTR(cycles_b, 0664, cycles_bShow, cycles_bStore);
                
// Duty Cycle for channel A
static uint8_t duty_a = 0;  // Default duty cycle: 0
module_param(duty_a, byte, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(duty_a, "Duty Cycle for channel A (0 to 100)");

static ssize_t duty_aStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    int result = kstrtou8(buffer, 0, &duty_a);
    if (result == 0 && duty_a <= 100) {
        setduty_A(duty_a);
    }
    return count;
}

static ssize_t duty_aShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    duty_a = getduty_A();
    return sprintf(buffer, "%u\n", duty_a);
}

static struct kobj_attribute duty_aAttr = __ATTR(duty_a, 0664, duty_aShow, duty_aStore);

// Duty Cycle for channel B
static uint8_t duty_b = 0;  // Default duty cycle: 0
module_param(duty_b, byte, S_IRUGO | S_IWUSR);
MODULE_PARM_DESC(duty_b, "Duty Cycle for channel B (0 to 100)");

static ssize_t duty_bStore(struct kobject *kobj, struct kobj_attribute *attr, const char *buffer, size_t count)
{
    int result = kstrtou8(buffer, 0, &duty_b);
    if (result == 0 && duty_b <= 100) {
        setduty_B(duty_b);
    }
    return count;
}

static ssize_t duty_bShow(struct kobject *kobj, struct kobj_attribute *attr, char *buffer)
{
    duty_b = getduty_B();
    return sprintf(buffer, "%u\n", duty_b);
}

static struct kobj_attribute duty_bAttr = __ATTR(duty_b, 0664, duty_bShow, duty_bStore);
                
// Attributes for channel A
static struct attribute *attrs_A[] = {
    &RUN_aAttr.attr, &sine_aAttr.attr, &sawtooth_aAttr.attr, &square_aAttr.attr, &triangle_aAttr.attr,
    &dc_aAttr.attr,&amp_aAttr.attr, &duty_aAttr.attr, &offset_aAttr.attr, &fre_aAttr.attr, &cycles_aAttr.attr, NULL
};

// Attributes for channel B
static struct attribute *attrs_B[] = {
    &RUN_bAttr.attr, &sine_bAttr.attr, &sawtooth_bAttr.attr, &square_bAttr.attr, &triangle_bAttr.attr,
    &dc_bAttr.attr,&amp_bAttr.attr, &duty_bAttr.attr, &offset_bAttr.attr, &fre_bAttr.attr, &cycles_bAttr.attr, NULL
};
static struct attribute* attrs_C[] = {
  &RUN_A_BAttr.attr, NULL
};

                
// Attribute groups
static struct attribute_group group_A = {
    .name = "channel_A",
    .attrs = attrs_A
};

static struct attribute_group group_B = {
    .name = "channel_B",
    .attrs = attrs_B
};

static struct attribute_group group_C = {
    .name = "runa_b",
    .attrs = attrs_C
};
                
static struct kobject *kobj;

                
static int __init initialize_module(void)
{
int result;

printk(KERN_INFO "Waveform Generator driver: starting\n");

// Create waveform_generator directory under /sys/kernel
kobj = kobject_create_and_add("waveform_generator", kernel_kobj);
if (!kobj)
{
    printk(KERN_ALERT "Waveform Generator driver: failed to create and add kobj\n");
    return -ENOENT;
}

// Create channel_A and channel_B groups
result = sysfs_create_group(kobj, &group_A);
if (result != 0)
    return result;

result = sysfs_create_group(kobj, &group_B);
if (result != 0)
    return result;

result = sysfs_create_group(kobj, &group_C);
if (result != 0)
return result;


// Physical to virtual memory map to access your registers
base = (unsigned int *)ioremap(AXI4_LITE_BASE + 0x10000,
                                32);
if (base == NULL)
    return -ENODEV;

printk(KERN_INFO "Waveform Generator driver: initialized\n");

return 0;
}

static void __exit exit_module(void)
{
kobject_put(kobj);
iounmap(base);
printk(KERN_INFO "Waveform Generator driver: exit\n");
}

module_init(initialize_module);
module_exit(exit_module);





















