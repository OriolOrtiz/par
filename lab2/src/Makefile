CC     =  gcc

OPTG0 	= -g -O0
OPT3 	= -O3
CFLAGS  = -Wall -std=c99
LFLAGS  = -lm

EXTRAEI	= -I$(EXTRAE_HOME)/include
EXTRAEL	= -L$(EXTRAE_HOME)/lib -lomptrace -L/usr/lib -lrt

CINCL    = -I. -I${TAREADOR_LIB_PATH}
CLIBS    = -L. ${TAREADOR_LIB_PATH}/tareador_hooks.o -lm

TARGETS	= heat heat-2 heat-tareador heat-omp heat-omp-d heat-omp-i
all: $(TARGETS)

misc.o: misc.c
	$(CC) -c $(CFLAGS) $(OPT3) $< -o $@

heat: heat.c solver.c misc.o
	$(CC) $(CFLAGS) $(OPT3) $+ $(LFLAGS) -o $@

heat-2: heat-2.c solver.c misc.o
	$(CC) $(CFLAGS) $(OPT3) $+ $(LFLAGS) -o $@

heat-tareador: heat-tareador.c solver-tareador.c misc.o
	$(CC) $(CFLAGS) $(OPTG0) $+ $(CINCL) -o $@ $(LFLAGS) $(CLIBS)

heat-omp: heat-omp.c solver-omp.c misc.o
	$(CC) $(CFLAGS) $(OPT3) -fopenmp $+ $(LFLAGS) -o $@

heat-omp-d: heat-omp.c solver-omp.c misc.o
	$(CC) $(CFLAGS) $(OPTG0) -fopenmp $+ $(LFLAGS) -o $@

heat-omp-i: heat-omp.c solver-omp.c misc.o
	$(CC) -D_EXTRAE_ $(CFLAGS) $(OPT3) -fopenmp $(EXTRAEI) $+ $(LFLAGS) $(EXTRAEL) -o $@

clean:
	rm -fr $(TARGETS) misc.o .tareador_precomputed*

ultraclean:
	rm -fr $(TARGETS) misc.o heat.ppm .tareador_precomputed* *.prv *.pcf *.row dependency_graph* *.times.txt *.sh.e* *.sh.o*
