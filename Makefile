##DACE_PATH =/afs/pdc.kth.se/home/m/mansande/.local/lib/python3.9/site-packages/dace

lib=ax
lib2=add3s2
SRC_PATH=${PWD}/src/fortran
AX_PATH=${SRC_PATH}/../python/.dacecache/${lib}
ADD3S2_PATH=${SRC_PATH}/../python/.dacecache/${lib2}

FCLAGS  = `pkg-config --cflags neko`
LIBS    = `pkg-config --libs neko`
FC      = `pkg-config --variable=compiler neko`

DEST    = nekobench
SRC	= ${SRC_PATH}/dace_math.F90 ${SRC_PATH}/dace_ax_helm_device.F90 driver.F90
#driver_small.F90
OBJ	= ${SRC:.F90=.o}

mv_obj: $(OBJ)
	mv *dace*.o ${SRC_PATH}

install:

clean:
	-rm -f *.o core *.core *.mod $(OBJ) $(DEST)

$(DEST): mv_obj
	$(FC) $(FCLAGS) ${OBJ} -o $@ $(LIBS) -I${AX_PATH}/include -L${AX_PATH}/build -I${ADD3S2_PATH}/include -L${ADD3S2_PATH}/build  -l${lib} -l${lib2}

%.o: %.F90
	${FC} ${FCLAGS} -c $<


