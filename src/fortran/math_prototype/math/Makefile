##DACE_PATH =/afs/pdc.kth.se/home/m/mansande/.local/lib/python3.9/site-packages/dace

AX_PATH=${PWD}/.dacecache/add3s2
#AX_PATH=/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_kernels/.dacecache/ax_opt/
#AX_PATH=/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_kernels/.dacecache/ax_parallel_direct_GPU/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/.dacecache/add3s2/build/

FCLAGS  = `pkg-config --cflags neko`
LIBS    = `pkg-config --libs neko`
FC      = `pkg-config --variable=compiler neko`

DEST    = run.bin
SRC	= math.F90 driver.F90
OBJ	= ${SRC:.F90=.o}

all: $(DEST)

install:

clean:
	-rm -f *.o core *.core *.mod $(OBJ) $(DEST)

$(DEST): ${OBJ}
	$(FC) $(FCLAGS) ${OBJ} -o $@  $(LIBS) -I${AX_PATH}/include -L${AX_PATH}/build -ladd3s2

%.o: %.F90
	${FC} ${FCLAGS} -c $<


