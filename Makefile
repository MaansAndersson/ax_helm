##DACE_PATH =/afs/pdc.kth.se/home/m/mansande/.local/lib/python3.9/site-packages/dace

lib=ax
SRC_PATH=${PWD}/src/fortran
AX_PATH=${SRC_PATH}/../python/.dacecache/${lib}


FCLAGS  = `pkg-config --cflags neko`
LIBS    = `pkg-config --libs neko`
FC      = `pkg-config --variable=compiler neko`

DEST    = run.bin
#SRC	= ax_temp.F90 driver.F90  ${SRC_PATH}/ax_temp.F90
SRC	= ${SRC_PATH}/ax.F90 ${SRC_PATH}/dace_ax_helm_device.F90 ${SRC_PATH}/dace_ax_helm_fctry.F90 driver.F90
#driver_small.F90
OBJ	= ${SRC:.F90=.o}

all: $(DEST)

install:

clean:
	-rm -f *.o core *.core *.mod $(OBJ) $(DEST)

$(DEST): ${OBJ}
	$(FC) $(FCLAGS) ${OBJ} -o $@ $(LIBS) -I${AX_PATH}/include -L${AX_PATH}/build -l${lib} 

%.o: %.F90
	${FC} ${FCLAGS} -c $<


