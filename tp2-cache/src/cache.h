#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MEMSIZE 65536
#define BLOCKSIZE 64
#define WAYSIZE 32
#define WAYS 8
#define UCHARMAX 255

struct cache_block_t {
    char data[BLOCKSIZE];
    char validation;
    size_t timestamp;
    char tag;
};

struct cache_t {
    struct cache_block_t data[WAYS * WAYSIZE];
    float accesses;
    float misses;
};

struct memory_t {
    char data[MEMSIZE];
};

void init();

unsigned int get_offset (unsigned int address);

unsigned int find_set(unsigned int address);

char get_tag(unsigned int address);

unsigned int select_oldest(unsigned int setnum);

void read_tocache(unsigned int blocknum, unsigned int way, unsigned int set);

unsigned char read_byte(unsigned int address);

void write_byte(unsigned int address, unsigned char value);

void write_tomem(unsigned int blocknum, unsigned int way, unsigned int set);

float get_miss_rate();

int create_cache_and_memory();

void destroy_cache_and_memory();