#include "cache.h"

int main(int argc, char** argv) {
    
    if (create_cache_and_memory() < 0){
        printf("Error creando cache y memoria principal");
        return -1;
    }
    
    FILE *comandos;
    comandos = fopen(argv[0], "r");
    if(!comandos){
        printf("No se pudo abrir el archivo");
        fclose(comandos);
        return -1;
    }

    
    


}