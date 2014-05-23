export PROG=multisort
#export PROG=multisort-i
export OMP_NUM_THREADS=1

./$PROG 8192 512 128
#mpi2prv -f TRACE.mpits -o ${PROG}_${OMP_NUM_THREADS}.prv -e $PROG -paraver
