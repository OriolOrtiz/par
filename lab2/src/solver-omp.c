#include "heat.h"
#include <omp.h>
#include <stdlib.h>

#define GAUSS_BLOCK_SIZE_Y 4

#define min(a,b) ( ((a) < (b)) ? (a) : (b) )

/*
 * Blocked Jacobi solver: one iteration step
 */
double relax_jacobi (double *u, double *utmp, unsigned sizex, unsigned sizey)
{
    double diff, sum=0.0;
    int nbx, bx, nby, by;

    nbx = omp_get_max_threads();
    bx = sizex/nbx;
    nby = 1;
    by = sizey/nby;
    #pragma omp parallel for private(diff) reduction(+:sum)
    for (int ii=0; ii<nbx; ii++) {
	for (int jj=0; jj<nby; jj++) {
	    for (int i=1+ii*bx; i<=min((ii+1)*bx, sizex-2); i++){
                for (int j=1+jj*by; j<=min((jj+1)*by, sizey-2); j++) {
	            utmp[i*sizey+j]= 0.25 * (u[ i*sizey     + (j-1) ]+  // left
					     u[ i*sizey     + (j+1) ]+  // right
				             u[ (i-1)*sizey + j     ]+  // top
				             u[ (i+1)*sizey + j     ]); // bottom
	            diff = utmp[i*sizey+j] - u[i*sizey + j];
	            sum += diff * diff;
	        }
	    }
	}
    }
    return sum;
}

/*
 * Blocked Gauss-Seidel solver: one iteration step
 */
double relax_gauss (double *u, unsigned sizex, unsigned sizey)
{
    double unew, diff, sum=0.0;
    int nbx, bx, nby, by;

    int num_threads = omp_get_max_threads();

    int *processed = malloc(num_threads * sizeof(int));

    #pragma omp parallel for
    for (int i = 0; i < num_threads; i++)
	processed[i] =  -1;

    nbx = num_threads;
    bx = sizex/nbx;
    nby = GAUSS_BLOCK_SIZE_Y;
    by = sizey/nby;
    #pragma omp parallel for private(diff, unew) reduction(+:sum)
    for (int ii=0; ii<nbx; ii++) {
	int thread_id = omp_get_thread_num();
	for (int jj=0; jj<nby; jj++) {
	    while (thread_id > 0 && processed[thread_id - 1] < jj) {
                 #pragma omp flush(processed)
	    }
            for (int i=1+ii*bx; i<=min((ii+1)*bx, sizex-2); i++) {
                for (int j=1+jj*by; j<=min((jj+1)*by, sizey-2); j++) {
	            unew= 0.25 * (    u[ i*sizey	+ (j-1) ]+  // left
				      u[ i*sizey	+ (j+1) ]+  // right
				      u[ (i-1)*sizey	+ j     ]+  // top
				      u[ (i+1)*sizey	+ j     ]); // bottom
	            diff = unew - u[i*sizey+ j];
	            sum += diff * diff;
	            u[i*sizey+j]=unew;
                }
	    }
	    processed[thread_id] = jj;
            #pragma omp flush(processed)
	}
    }

    return sum;
}
