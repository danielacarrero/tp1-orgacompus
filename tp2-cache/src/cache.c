#include "cache.h"

#define OFFSET_MASK 63
#define INDEX_MASK 1984

struct cache_t* cache;
struct memory_t* memory;

void init() {
    cache = (struct cache_t*) calloc(1 , sizeof(struct cache_t));

    if (!cache) {
        free(cache);
        panic("rompiste todo: cache en calloc");
    }

    memory = (struct memory_t*) calloc(1, sizeof(struct memory_t));

    if (!memory) {
        free(memory);
        panic("rompiste todo: memory en calloc");
    }
}

unsigned int get_offset (unsigned int address) {
    return (address & OFFSET_MASK); //Pone todo en cero y se queda con los bits de offset
}

unsigned int find_set(unsigned int address) {
    return (address & INDEX_MASK); //Pone todo en cero y se queda con los bits de index
}

unsigned int select_oldest(unsigned int setnum) {
    unsigned int way = 0;
    size_t oldest_timestamp = -1;
    for (unsigned int i = 0; i < WAYS; i++) {
        size_t way_timestamp = cache->data[setnum + (i * WAYSIZE)].timestamp;
        if ( oldest_timestamp > way_timestamp) {
            way = i;
            oldest_timestamp = way_timestamp;
        }
    }
    return way;
}

void read_tocache(unsigned int blocknum, unsigned int way, unsigned int set) {

}

unsigned char read_byte(unsigned int address) {

}

void write_byte(unsigned int address, unsigned char value) {

}

float get_miss_rate() {
    return cache->miss_rate;
}