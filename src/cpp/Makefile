IDIR=include
DACE_DIR=-I ${DACE_PATH}/include
CXX=CC
SDFGCC=sdfgcc

LDIR=lib
LIBS=-lm -lax2 -lax3 -lax4 -lax5 -lax6 -lax7 -lax8 -ladd3s2

all: sdfg slib

slib:
	$(CXX) -shared -O3 ax.cpp ${LIBS} -I ${IDIR} ${DACE_DIR} -L ${LDIR} -o ${LDIR}/libax.so

sdfg:
	$(SDFGCC) ../sdfg/ax_2.sdfg.gz -o .
	$(SDFGCC) ../sdfg/ax_3.sdfg.gz -o .
	$(SDFGCC) ../sdfg/ax_4.sdfg.gz -o .
	$(SDFGCC) ../sdfg/ax_5.sdfg.gz -o .
	$(SDFGCC) ../sdfg/ax_6.sdfg.gz -o .
	$(SDFGCC) ../sdfg/ax_7.sdfg.gz -o .
	$(SDFGCC) ../sdfg/ax_8.sdfg.gz -o .
	$(SDFGCC) ../sdfg/add3s2.sdfg.gz -o .
	mv *so $(LDIR)
	mv *h $(IDIR)


.PHONY: clean

clean:
	rm -rf $(LDIR)/*.so .dacecache/ 
