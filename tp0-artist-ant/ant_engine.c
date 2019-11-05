#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <strings.h>

#include "ant_engine.h"
#include "builders.h"
#include "grid.h"

#ifdef USE_TABLES
typedef void (*step_fn)(ant_t*, uint32_t);

void step_west(ant_t *ant, uint32_t width) {
  adjust(&ant->x, ant->x - 1, width);
}

void step_east(ant_t *ant, uint32_t width) {
  adjust(&ant->x, ant->x + 1, width);
}

void step_north(ant_t *ant, uint32_t height) {
  adjust(&ant->y, ant->y - 1, height);
}

void step_south(ant_t *ant, uint32_t height) {
  adjust(&ant->y, ant->y + 1, height);
}

static step_fn allowed_forward[4] = {step_north, step_south, step_east, step_west};

#endif /* USE_TABLES */

void*
paint(void *artist_ant, void *gridfn, colour_fn next_colour, rule_fn next_rotation, uint64_t iterations)
{
  ant_t* ant = (ant_t*) artist_ant;
  const grid_handler_t *grid_handler = (grid_handler_t *) gridfn;

  uint64_t i;
  uint32_t current_x, current_y;
  orientation_t current_o;
  colour_t current, next;
  rotation_t rule;

  for (i = 0; i < iterations ; i++) {
    /* Ant state */
    current_x = ant->x;
    current_y = ant->y;
    current_o = ant->o;

    current = grid_handler->get(current_x, current_y);

    rule = next_rotation(current);

    /* Paint */
    next = next_colour();
    grid_handler->set(current_x, current_y, next);

    /* Rotate */
    ant->o = new_orientation(current_o, rule);

    /* Move forward */
    ant = move_forward(ant, grid_handler->rows, grid_handler->cols);
  }

  return ant;
}



#ifdef USE_TABLES

ant_t*
move_forward(ant_t *ant, const uint32_t width, const uint32_t height)
{
  uint32_t relevant_bounds[4] = {height, height, width, width};
  uint32_t bound = relevant_bounds[ant->o];
  step_fn go_forward = allowed_forward[ant->o];
  go_forward(ant, bound);

  return ant;
}

orientation_t 
new_orientation(orientation_t orientation, rotation_t rule)
{
  static orientation_t rotation_rules[4][2] = {
    {WEST,EAST},    /* north */
    {EAST,WEST},    /* south */
    {NORTH, SOUTH}, /* east */
    {SOUTH,NORTH}   /* west */
  };

  return rotation_rules[orientation][rule];
}

#else 

static orientation_t
decide(rotation_t d, orientation_t go_left, orientation_t go_right)
{
  return d == RIGHT ? go_right : go_left;
}

orientation_t 
new_orientation(orientation_t orientation, rotation_t rule)
{
  orientation_t updated_orientation;

  switch(orientation) {
  case NORTH:
    updated_orientation = decide(rule, WEST, EAST);
    break;
  case SOUTH:
    updated_orientation = decide(rule, EAST, WEST);
    break;
  case EAST:
    updated_orientation = decide(rule, NORTH, SOUTH);
    break;
  case WEST:
    updated_orientation = decide(rule, SOUTH, NORTH);
    break;
  default:
    panicd("Unknown orientation %d", orientation);
  }

  return updated_orientation;
}

ant_t*
move_forward(ant_t *ant, uint32_t width, uint32_t height) 
{
   
  switch(ant->o) { 
    case NORTH:
      adjust(&ant->y, ant->y - 1, height);
      break;
    case SOUTH:
      adjust(&ant->y, ant->y + 1, height);
      break;
    case EAST:
      adjust(&ant->x, ant->x + 1, width);
      break;
    case WEST:
      adjust(&ant->x, ant->x - 1, width);
      break;
    default:
      panicd("Unknown orientation %d", ant->o);
  }

  return ant;
}
#endif

