#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MEMSIZE 65536
#define BLOCKSIZE 64
#define WAYSIZE 32
#define WAYS 8

struct cache_block_t {
    char data[BLOCKSIZE];
    char validation;
    size_t timestamp;
    char tag;
};

struct cache_t {
    struct cache_block_t data[WAYS * WAYSIZE];
    size_t accesses;
    float miss_rate;
};

struct memory_t {
    char data[MEMSIZE];
};

void init();

unsigned int get_offset (unsigned int address);

unsigned int find_set(unsigned int address);

unsigned int select_oldest(unsigned int setnum);

void read_tocache(unsigned int blocknum, unsigned int way, unsigned int set);

unsigned char read_byte(unsigned int address);

void write_byte(unsigned int address, unsigned char value);

float get_miss_rate();