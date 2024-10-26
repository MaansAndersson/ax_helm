SRC_PATH=${PWD}/src/fortran
AX_PATH=${PWD}/src/cpp

FCLAGS  = `pkg-config --cflags neko`
LIBS    = `pkg-config --libs neko`
FC      = `pkg-config --variable=compiler neko`

DEST    = nekobench
SRC     = ${SRC_PATH}/dace_ax.F90 \
          ${SRC_PATH}/dace_math.F90\
          ${SRC_PATH}/dace_ax_helm_device.F90 driver.F90

OBJ     = ${SRC:.F90=.o}

foo := ax
dace_libs_1 := $(foreach wrd,$(foo),-I${AX_PATH}/include) 
dace_libs_2 := $(foreach wrd,$(foo),-L${AX_PATH}/lib) 
dace_libs_3 := $(foreach wrd,$(foo),-l$(wrd)) 

$(DEST): mv_obj
	$(FC) $(FCLAGS) ${OBJ} -o $@ $(LIBS) $(dace_libs_2) $(dace_libs_3)

all: sdfg slib $(DEST)

mv_obj: $(OBJ)
	mv *dace*.o ${SRC_PATH}

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


