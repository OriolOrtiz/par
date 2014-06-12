#!/bin/csh
# following option makes sure the job will run in the current directory
#$ -cwd
# following option makes sure the job has the same environmnent variables as the submission shell
#$ -V

setenv PROG sudoku-omp

set level = 5
set MAX_LEVEL = 50
set STEP = 5


echo "OpenMP execution with level $level" > $PROG.level.txt
setenv OMP_NUM_THREADS 8
./$PROG puzzle.in $level >> $PROG.level.txt
@ level = $level + $STEP

while ($level <= $MAX_LEVEL)
    echo "OpenMP execution with level $level" >> $PROG.level.txt
    setenv OMP_NUM_THREADS 8
    ./$PROG puzzle.in $level >> $PROG.level.txt
    @ level = $level + $STEP
end
