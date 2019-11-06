#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cache.h"

char **splitline(char* line){

    char **words;
    char *found;
    int i = 0;

    while((found = strsep(&line, " ,\n")) != NULL){
        if (strcmp(found, "") == 0) continue;
        words[i] = found;
        i++;
    }

    return words;
}

int main(int argc, char** argv) {

    if(argc != 2){
        printf("No se ingreso ningun archivo\n");
        exit(-1);
    }

    if (create_cache_and_memory() < 0){
        printf("Error creando cache y memoria principal\n");
        exit(-1);
    }

    FILE *comandos;
    comandos = fopen(argv[1], "r");
    if(!comandos){
        printf("No se pudo abrir el archivo\n");
        exit(-1);
    }

    char line[20];
    fgets(line, 20, comandos);
    while(!feof(comandos)){
        
        if (line[0] == '\n') continue;

        char **words = splitline(line);

        if(strcmp(words[0], "FLUSH") == 0){
            init();
        }
        else if(strcmp(words[0], "R") == 0){

            unsigned int address = atoi(words[1]);
            unsigned char byte = read_byte(address);

            printf("El valor del byte leido es de: %c\n", byte);
        }
        else if(strcmp(words[0], "W") == 0){

            unsigned int address = atoi(words[1]);
            unsigned int value = atoi(words[2]);

            write_byte(address, (char)value);
        }
        else if(strcmp(words[0], "MR") == 0){
            
            float miss_rate = get_miss_rate();
            
            if(miss_rate == -1) printf("No se tuvo ningun acceso todavia\n");
            else printf("El miss rate es de: %f\n", miss_rate);

        }else{
            printf("Error introduciendo comando\n");
            fclose(comandos);
            exit(-1);
        }

        fgets(line, 20, comandos);
    }
    
    fclose(comandos);

    exit(0);
}