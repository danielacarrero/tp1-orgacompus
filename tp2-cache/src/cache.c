#include "cache.h"

#define OFFSET_MASK 63
#define INDEX_MASK 1984
#define TAG_MASK 63488
#define OFFSET_TO_ZERO 65472
#define ERROR 9

struct cache_t* cache;
struct memory_t* memory;

unsigned int time = 0;

unsigned int make_address(unsigned int tag, unsigned int set, unsigned offset){

    tag = tag << 11;
    set = set << 6;
    
    return (tag | set | offset);
}

void init() {

    if(!cache || !memory) return;

    memset(cache, 0, sizeof(struct cache_t));
    memset(memory, 0, sizeof(struct memory_t));
    
}

unsigned int get_offset (unsigned int address) {
    return (address & OFFSET_MASK); // Pone todo en cero y se queda con los bits de offset
}

unsigned int find_set(unsigned int address) {
    return ((address & INDEX_MASK) >> 6); // Pone todo en cero y se queda con los bits de index
}

char get_tag(unsigned int address) {
    return (char)((address & TAG_MASK) >> 11); // Pone todo en cero y se queda con los bits de tag
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

    char tag = get_tag(address);
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
        read_tocache(address & OFFSET_TO_ZERO, way, set);
        cache->data[set + (way * WAYSIZE)].tag = tag;
    }

    cache->data[set + (way * WAYSIZE)].timestamp = time++;

    return cache->data[set + (way * WAYSIZE)].data[offset];
}

void write_byte(unsigned int address, unsigned char value) {
    
    cache->accesses++;

    char tag = get_tag(address);
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
        unsigned int old_address = make_address((unsigned int)cache->data[set + (way * WAYSIZE)].tag, set, 0);
        write_tomem(old_address, way, set);
        memset(cache->data[set + (way * WAYSIZE)].data, 0, BLOCKSIZE*sizeof(char));
    }

    cache->data[set + (way * WAYSIZE)].timestamp = time++;
    
    cache->data[set + (way * WAYSIZE)].data[offset] = value;

    if (!found) {
        cache->misses++;
        cache->data[set + (way * WAYSIZE)].validation = 1;
        cache->data[set + (way * WAYSIZE)].tag = tag;
    }
}

void write_tomem(unsigned int blocknum, unsigned int way, unsigned int set) {
    
    for (unsigned int i = 0; i < BLOCKSIZE; i++) {
        memory->data[blocknum + i] = cache->data[set + (way * WAYSIZE)].data[i];
    }
}

float get_miss_rate() {

    if (cache->accesses == 0) return -1;

    return (cache->misses / cache->accesses);
}

int create_cache_and_memory(){
    cache = (struct cache_t*) calloc(1, sizeof(struct cache_t));

    if (!cache) {
        free(cache);
        return -1;
    }

    memory = (struct memory_t*) calloc(1, sizeof(struct memory_t));

    if (!memory) {
        destroy_cache_and_memory();
        return -1;
    }

    return 0;
}

void destroy_cache_and_memory(){
    free(cache);
    free(memory);
}