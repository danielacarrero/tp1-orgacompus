#include <stdio.h>
#include <time.h>

#define WAYJUMP 32

typedef struct {
    char data[64];
    char validation;
    size_t timestamp;
    char tag;
} cache_block;

typedef struct {
    cache_block data[256];
    size_t accesses;
    float miss_rate;
} cache;

typedef struct {
    char data[64];
} memory;

void init();

unsigned int get_offset (unsigned int address);

unsigned int find_set(unsigned int address);

unsigned int select_oldest(unsigned int setnum);

void read_tocache(unsigned int blocknum, unsigned int way, unsigned int set);

unsigned char read_byte(unsigned int address);

void write_byte(unsigned int address, unsigned char value);

float get_miss_rate();