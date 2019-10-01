#include "builders.h"
#include "ant_engine.h"

void 
doPanic(char *s)
{
  panic(s);
}

void
doAdjust(uint32_t *p ,uint32_t v, uint32_t limit)
{
  adjust(p, v, limit);
}
