#!/bin/csh
# following option makes sure the job will run in the current directory
#$ -cwd
# following option makes sure the job has the same environmnent variables as the submission shell
#$ -V

#setenv PROG multisort-omp-leaf
setenv PROG multisort-omp-tree

set size = 8192
set MAX_SIZE = 8192 # 8192, 16384, 32768
set recur_size = 512
echo "Start Multisort Analsys" > $PROG.scalability.txt
while ($size <= $MAX_SIZE)
    echo "Multisort with $size Kelements and sort-merge size = $recur_size elememts" >> $PROG.scalability.txt
    echo "Sequential execution"  >> $PROG.scalability.txt
    ./multisort $size $recur_size $recur_size >> $PROG.scalability.txt
    echo "OpenMP execution with 1 thread"  >> $PROG.scalability.txt
    setenv OMP_NUM_THREADS 1
    ./$PROG $size $recur_size $recur_size >> $PROG.scalability.txt
    set n_threads = 2
    set MAX_THREADS = 12
    while ($n_threads <= $MAX_THREADS)
        echo "OpenMP execution with $n_threads threads"  >> $PROG.scalability.txt
        setenv OMP_NUM_THREADS $n_threads
        ./$PROG $size $recur_size $recur_size >> $PROG.scalability.txt
        @ n_threads = $n_threads + 2  >> $PROG.scalability.txt
    end
    @ size = $size * 2
end
