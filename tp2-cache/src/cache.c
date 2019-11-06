#include "cache.h"

#define OFFSET_MASK 63
#define INDEX_MASK 1984
#define TAG_MASK 63488
#define ERROR 9

struct cache_t* cache;
struct memory_t* memory;

unsigned int time = 0;

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
    return (address & OFFSET_MASK); // Pone todo en cero y se queda con los bits de offset
}

unsigned int find_set(unsigned int address) {
    return (address & INDEX_MASK); // Pone todo en cero y se queda con los bits de index
}

unsigned int get_tag(unsigned int address) {
    return (address & TAG_MASK); // Pone todo en cero y se queda con los bits de tag
}

unsigned int select_oldest(unsigned int setnum) {
    unsigned int way = 0;
    size_t oldest_timestamp = -1;
    for (unsigned int i = 0; i < WAYS; i++) {
        if (cache->data[setnum + (i * WAYSIZE)].validation == 0) continue;

        size_t way_timestamp = cache->data[setnum + (i * WAYSIZE)].timestamp;
        if (oldest_timestamp > way_timestamp) {
            way = i;
            oldest_timestamp = way_timestamp;
        }
    }
    return way;
}

// way tiene que ir de 0 a 7
void read_tocache(unsigned int blocknum, unsigned int way, unsigned int set) {
    for (unsigned int i = 0; i < BLOCKSIZE; i++) {
        cache->data[set + (way * WAYSIZE)].data[i] = memory->data[blocknum + i];
    }
    cache->data[set + (way * WAYSIZE)].validation = 1;
}

unsigned char read_byte(unsigned int address) {
    
    cache->accesses++;

    unsigned int tag = get_tag(address);
    unsigned int set = find_set(address);
    unsigned int offset = get_offset(address);
    unsigned int way = ERROR;
    int found = 0;

    for (unsigned int i = 0; i < WAYS; i++) {
        if (cache->data[set + (i * WAYSIZE)].tag == tag && cache->data[set + (i * WAYSIZE)].validation == 1) {
            way = i;
            found = 1;
            break;
        }

        if (cache->data[set + (i * WAYSIZE)].validation == 0) {
            way = i;
        }
    }

    if (way == ERROR) {
        way = select_oldest(set);
    }

    if (!found) {
        cache->misses++;
        read_tocache(address, way, set);
        cache->data[set + (way * WAYSIZE)].tag = tag;
    }

    cache->data[set + (way * WAYSIZE)].timestamp = time++;

    return cache->data[set + (way * WAYSIZE)].data[offset];
}

void write_byte(unsigned int address, unsigned char value) {
    
    cache->accesses++;

    unsigned int tag = get_tag(address);
    unsigned int set = find_set(address);
    unsigned int offset = get_offset(address);
    unsigned int way = ERROR;
    int found = 0;

    for (unsigned int i = 0; i < WAYS; i++) {
        if (cache->data[set + (i * WAYSIZE)].tag == tag && cache->data[set + (i * WAYSIZE)].validation == 1) {
            way = i;
            found = 1;
            break;
        }

        if (cache->data[set + (i * WAYSIZE)].validation == 0) {
            way = i;
        }
    }

    if (way == ERROR) {
        way = select_oldest(set);
        memset(cache->data[set + (way * WAYSIZE)].data, 0, BLOCKSIZE*sizeof(char));
    }

    cache->data[set + (way * WAYSIZE)].timestamp = time++;
    
    cache->data[set + (way * WAYSIZE)].data[offset] = value;

    if (!found) {
        cache->misses++;
        cache->data[set + (way * WAYSIZE)].validation = 1;
        cache->data[set + (way * WAYSIZE)].tag = tag;
        //Como aca hubo un miss habría que ver cuando hacer el write back y escribirlo en mem
        // principal con la funcion write_tomem()
    }
}

void write_tomem(unsigned int blocknum, unsigned int way, unsigned int set) {
    
    for (unsigned int i = 0; i < BLOCKSIZE; i++) {
        memory->data[blocknum + i] = cache->data[set + (way * WAYSIZE)].data[i];
    }
}

float get_miss_rate() {
    return (cache->misses / cache->accesses);
}