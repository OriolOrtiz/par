#!/bin/csh
# following option makes sure the job will run in the current directory
#$ -cwd
# following option makes sure the job has the same environmnent variables as the submission shell
#$ -V

setenv PROG multisort-omp-leaf-i
#setenv PROG multisort-omp-tree-i

setenv OMP_NUM_THREADS 8

./$PROG 8192 512 128
mpi2prv -f TRACE.mpits -o ${PROG}_${OMP_NUM_THREADS}.prv -e $PROG -paraver
