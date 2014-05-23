#!/bin/csh
# following option makes sure the job will run in the current directory
#$ -cwd
# following option makes sure the job has the same environmnent variables as the submission shell
#$ -V

setenv PROG multisort-omp-tree

set size = 16384 
set recur_size = 1
set MAX_RECUR_SIZE = 8192 
echo "OpenMP execution with 8 threads" > $PROG.recursivity.txt

while ($recur_size <= $MAX_RECUR_SIZE)
    echo "Multisort with $size Kelements and sort-merge size = $recur_size Kelements" >>  $PROG.recursivity.txt
    setenv OMP_NUM_THREADS 8
    ./$PROG $size $recur_size $recur_size >>  $PROG.recursivity.txt
    @ recur_size = $recur_size * 2
end
