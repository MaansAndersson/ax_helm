##DACE_PATH =/afs/pdc.kth.se/home/m/mansande/.local/lib/python3.9/site-packages/dace

SRC_PATH=${PWD}/src/fortran
AX_PATH=${PWD}/src/python/.dacecache

FCLAGS  = `pkg-config --cflags neko`
LIBS    = `pkg-config --libs neko`
FC      = `pkg-config --variable=compiler neko`

DEST    = nekobench
SRC		 	= ${SRC_PATH}/dace_ax8.F90 \
					${SRC_PATH}/dace_ax7.F90 \
					${SRC_PATH}/dace_ax6.F90 \
					${SRC_PATH}/dace_ax5.F90 \
					${SRC_PATH}/dace_ax4.F90 \
					${SRC_PATH}/dace_ax3.F90 \
					${SRC_PATH}/dace_ax2.F90 \
					${SRC_PATH}/dace_ax1.F90 \
					${SRC_PATH}/dace_math.F90\
					${SRC_PATH}/dace_ax_helm_device.F90 driver.F90

OBJ		 	= ${SRC:.F90=.o}

foo := ax7 ax6 ax5 ax8 ax4 ax3 ax2 ax1 add3s2 
dace_libs_1 := $(foreach wrd,$(foo),-I${AX_PATH}/$(wrd)/include) 
dace_libs_2 := $(foreach wrd,$(foo),-L${AX_PATH}/$(wrd)/build) 
dace_libs_3 := $(foreach wrd,$(foo),-l$(wrd)) 
#dace_libs_4 := -lallax

mv_obj: $(OBJ)
	mv *dace*.o ${SRC_PATH}
	
my_test:  	
	@echo $(dace_libs)

install:

mod:
	-rm -f *.mod

clean:
	-rm -f *.o core *.core *.mod out0.* $(OBJ) $(DEST)

$(DEST): mv_obj 
	$(FC) $(FCLAGS) ${OBJ} -o $@ $(LIBS) $(dace_libs_2) $(dace_libs_3) 

%.o: %.F90
	${FC} ${FCLAGS} -c $<


