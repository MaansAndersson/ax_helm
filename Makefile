SRC_PATH=${PWD}/src/fortran
AX_PATH=${PWD}/src/cpp

FCLAGS  = `pkg-config --cflags neko`
LIBS    = `pkg-config --libs neko`
FC      = `pkg-config --variable=compiler neko`

DRIVER  = driver_test.F90

DEST    = nekobench
SRC     = ${SRC_PATH}/wrapper/dace_ax.F90 \
          ${SRC_PATH}/wrapper/dace_math.F90\
          ${SRC_PATH}/wrapper/dace_ax_helm_device.F90\
					${SRC_PATH}/straggler/pc_inexact.F90 \
					${SRC_PATH}/straggler/pc_inexact_device.F90 \
					${DRIVER}

OBJ     = ${SRC:.F90=.o}

lib := ax
dace_libs_1 := $(foreach wrd,$(lib),-I${AX_PATH}/include) 
dace_libs_2 := $(foreach wrd,$(lib),-L${AX_PATH}/lib) 
dace_libs_3 := $(foreach wrd,$(lib),-l$(wrd)) 

$(DEST): mv_obj
	$(FC) $(FCLAGS) ${OBJ} -o $@ $(LIBS) $(dace_libs_2) $(dace_libs_3)

all: sdfg slib $(DEST)

mv_obj: $(OBJ)
	mv *dace*.o ${SRC_PATH}/wrapper
	mv *pc_inexact*.o ${SRC_PATH}/straggler

mod:
	-rm -f *.mod

clean:
	-rm -f *.o core *.core *.mod out0.* $(OBJ) $(DEST)

sdfg:
	make -C src/cpp sdfg

slib:
	make -C src/cpp slib

make: $(DEST)

%.o: %.F90
	${FC} ${FCLAGS} -c $<


