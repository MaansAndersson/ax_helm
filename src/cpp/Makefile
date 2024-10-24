
#clang++ -shared -O3 ax.cpp -lax1 -lax2 -lax3 -lax4 -lax5 -lax6 -lax7 -lax8 -ladd3s2 -I $PWD/include/ -I $PWD/../../../../scivenv/lib/python3.12/site-packages/dace/runtime/include/ -L $PWD/build/ -o build/libax.so

IDIR =include
DACE_DIR=-I $PWD/../../../../scivenv/lib/python3.12/site-packages/dace/runtime/include/

CC=gcc
SDFGCC=sdfgcc
CFLAGS=-I$(IDIR)

ODIR=obj
LDIR =lib

LIBS=-lm -lax2 -lax3 -lax4 -lax5 -lax6 -lax7 -lax8 -ladd3s2


#_DEPS = ax.h
#DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))
#
#_OBJ = ax.o 
#OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

AXX=ax.cpp

$(ODIR)/%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

sdfg:
	$(SDFGCC) ../sdfg/ax_2.sdfg.gz -o .
	$(SDFGCC) ../sdfg/ax_3.sdfg.gz -o .
	$(SDFGCC) ../sdfg/ax_4.sdfg.gz -o .
	$(SDFGCC) ../sdfg/ax_5.sdfg.gz -o .
	$(SDFGCC) ../sdfg/ax_6.sdfg.gz -o .
	$(SDFGCC) ../sdfg/ax_7.sdfg.gz -o .
	$(SDFGCC) ../sdfg/ax_8.sdfg.gz -o .
	$(SDFGCC) ../sdfg/add3s2.sdfg.gz -o .
#$(SDFGCC) ../sdfg/ax*.sdfg.gz
	mv *so lib
	mv *h include


make: sdfg
	$(CC) -o -shared $(AXX) $(LIBS)
	# $@ $^ $(CFLAGS) $(LIBS) 

.PHONY: clean

clean:
	rm -f $(ODIR)/*.o *~ core $(INCDIR)/*~
