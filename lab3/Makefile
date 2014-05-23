CC     =  gcc 
OPTG0 	= -g -O0
OPT2 	= -O2

CFLAGS  = -fopenmp -Wall -std=c99 
LFLAGS  = -lm

EXTRAEI	= -I$(EXTRAE_HOME)/include 
EXTRAEL	= -L$(EXTRAE_HOME)/lib -lomptrace -L/usr/lib -lrt

CINCL    = -I. -I${TAREADOR_LIB_PATH}
CLIBS    = -L. ${TAREADOR_LIB_PATH}/tareador_hooks.o 

TARGETS	= multisort multisort-i multisort-tareador multisort-omp-leaf multisort-omp-tree multisort-omp-leaf-i multisort-omp-tree-i
all: $(TARGETS)

kernels.o: kernels.c 
	$(CC) -c $(CFLAGS) $(OPT2) $^ -o $@ 

multisort: multisort.c kernels.o
	$(CC) $(CFLAGS) $(OPT2) $+ $(LFLAGS) -o $@ 

multisort-i: multisort.c kernels.o
	$(CC) -D_EXTRAE_ $(CFLAGS) $(OPT2) $+ $(EXTRAEI) $(LFLAGS) -o $@ $(EXTRAEL)

multisort-tareador: multisort-tareador.c kernels.o
	$(CC) -D_TAREADOR_ $(CFLAGS) $(OPTG0) $+ $(CINCL) $(LFLAGS) -o $@ $(CLIBS)

multisort-omp-leaf: multisort-omp-leaf.c  kernels.o
	$(CC) $(CFLAGS) $(OPT2) $+ $(LFLAGS) -o $@ 

multisort-omp-tree: multisort-omp-tree.c  kernels.o
	$(CC) $(CFLAGS) $(OPT2) $+ $(LFLAGS) -o $@ 

multisort-omp-leaf-i: multisort-omp-leaf.c  kernels.o
	$(CC) -D_EXTRAE_ $(CFLAGS) $(OPT2) $+ $(EXTRAEI) $(LFLAGS) -o $@ $(EXTRAEL)

multisort-omp-tree-i: multisort-omp-tree.c  kernels.o
	$(CC) -D_EXTRAE_ $(CFLAGS) $(OPT2) $+ $(EXTRAEI) $(LFLAGS) -o $@ $(EXTRAEL)

clean:
	rm -fr $(TARGETS) kernels.o .tareador_precomputed*

ultraclean:
	rm -fr $(TARGETS) kernels.o .tareador_precomputed* *.prv *.pcf *.row dependency_graph* *.times.txt *.sh.e* *.sh.o*
