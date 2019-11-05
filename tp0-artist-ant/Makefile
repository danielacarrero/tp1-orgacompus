
all: tp0_if tp0_tables

prof: tp0_if_pf tp0_tables_pf

tp0_if: square_grid.c builders.c palette.c rules.c square_grid.c ant_engine.c artist_ant.c 
	gcc -g $^ -o $@

tp0_if_pf: square_grid.c builders.c palette.c rules.c square_grid.c ant_engine.c artist_ant.c 
	gcc -no-pie -pg -g -DSANITY_CHECK $^ -o $@

tp0_if_col_major: square_grid.c builders.c palette.c rules.c square_grid.c ant_engine.c artist_ant.c 
	gcc -no-pie -pg -g -DUSE_COL_MAJOR $^ -o $@

tp0_tables: square_grid.c builders.c palette.c rules.c square_grid.c ant_engine.c artist_ant.c 
	gcc -g -DUSE_TABLES $^ -o $@

tp0_tables_pf: square_grid.c builders.c palette.c rules.c square_grid.c ant_engine.c artist_ant.c 
	gcc -no-pie -pg -g -DUSE_TABLES $^ -o $@

tp0_tables_col_major: square_grid.c builders.c palette.c rules.c square_grid.c ant_engine.c artist_ant.c 
	gcc -no-pie -pg -g -DUSE_TABLES -DUSE_COL_MAJOR $^ -o $@
clean:
	rm tp0_*
