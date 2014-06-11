#include <stdio.h>
#include <stdlib.h>
#include "sudoku_lib.h"
#if _EXTRAE_
#include "extrae_user_events.h" // Extrae instrumentation
#endif
#if _TAREADOR_
#include "tareador_hooks.h"
#endif

#if _EXTRAE_
// Extrae constants
#define LOCATION        1000
#define GUESS           2000
#define END             0
#endif

unsigned long num_solutions = 0;
int* first_solution = NULL;

int solve(int size, int* g, int loc)
{
   int i, solved=0;
   int len = size*size*size*size;
   int allGuesses[size*size]; // vector to store all possible solutions for node loc
   int num_guesses; // number of possible solutions for node loc

   /* maximum depth? */
   if (loc == len) {
	num_solutions++; 
	if (!first_solution) first_solution = new_grid(size, g); // store first solution found
        return 1;
   }

   /* if this node has a solution (given by puzzle), move to next node */
   if (g[loc] != 0) {
      solved = solve(size, g, loc+1);
      return solved;
   }

   /* try each number (unique to row, column and square) */
   all_guesses(size, loc, g, allGuesses, &num_guesses);
   for (i = 0; i < num_guesses; i++) {
#if _TAREADOR_
      char buffer[50];
      sprintf(buffer, "solve_%d-%d", loc, allGuesses[i]);
      //sprintf(buffer, "solve");
      tareador_start_task(buffer);
#endif
#if _EXTRAE_
      Extrae_event(LOCATION, loc+1);
      Extrae_event(GUESS, allGuesses[i]);
#endif

      g[loc] = allGuesses[i];
#if _TAREADOR_
      tareador_disable_object(&solved);
//      tareador_disable_object(&size);
      tareador_disable_object(g);
#endif
      if (solve(size, g, loc+1)) solved = 1;;
#if _TAREADOR_
      tareador_enable_object(&solved);
      tareador_enable_object(g);
#endif
      g[loc] = 0;

#if _EXTRAE_
      Extrae_event(LOCATION, END);
      Extrae_event(GUESS, END);
#endif
#if _TAREADOR_
      tareador_end_task();
#endif
   }   
   return solved;
}


int main(int argc, char **argv) {
   int solved; // variable used to indicate if solution to puzzle has been found
   int size;   // number of elements in square (usually 3 for a 3 x 3 x 3 x 3 puzzle))

   if (argc != 2) {
   	fprintf(stderr, "Usage: %s <puzzle_filename> \n", argv[0]);
   	return(0);
   }

   FILE* fd = fopen(argv[1], "r");
   if (fd == NULL) {
      printf("Error: Failed to open file with initial puzzle\n");
      return(0);
      }

#if _EXTRAE_
   Extrae_init();
#else
   double stamp=getusec_();
#endif

   solved = fscanf(fd, "%d", &size);
   int* g = new_grid(size, NULL);

   read_puzzle(size, g, fd);
   printf("\nInitial puzzle (size %d):\n", size);
   write_puzzle(size, g);

#if _TAREADOR_
   tareador_ON();
#endif

   solved = solve(size, g, 0);

#if _TAREADOR_
   tareador_OFF();
#endif

   if (solved == 1) {
      printf("\nFound %lu solutions, first one being:\n", num_solutions);
      write_puzzle(size, first_solution);
      printf("\n"); 
   }
   else 
      printf("\nFailed to find a solution\n");

#if _EXTRAE_
   Extrae_fini();
#else
   stamp=getusec_()-stamp;
   stamp=stamp/1e6;
   printf ("Execution time for Sudoku puzzle: %0.6fs\n\n", stamp);
#endif

   return(!solved);
}
