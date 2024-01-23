import numpy as np
import dace as dc

from dace.transformation.auto import auto_optimize as aopt
from dace.dtypes import StorageType, ScheduleType



nel = dc.symbol('NE')
dtype = np.float64

# a = c1 * b + c2 * c
@dc.program()
def add3s2(a : dc.float64[nel] @ StorageType.GPU_Global, 
           b : dc.float64[nel] @ StorageType.GPU_Global, 
           c : dc.float64[nel] @ StorageType.GPU_Global, 
           c1 : dc.float64 , c2 : dc.float64):
    #a[:] = c1*b[:] + c2*c[:];
    for i in dc.map[0:nel] @ ScheduleType.GPU_Device:
        a[i] = c1*b[i] + c2*c[i]; #c1 * b[i] + c2 * c[i];




from dace.transformation.dataflow import (DoubleBuffering, MapCollapse, MapExpansion, MapReduceFusion, StripMining,
                                          InLocalStorage, AccumulateTransient, Vectorization, MapToForLoop, MapUnroll,
                                          MapFusion, MapWCRFusion)

from dace.transformation.interstate import (StateFusion)

if __name__ == "__main__":
    print('to_sdfg()')
    _sdfg = add3s2.to_sdfg()
    _sdfg.simplify()
    _sdfg.apply_gpu_transformations()
    aopt.auto_optimize(_sdfg, dc.DeviceType.GPU)
    #_sdfg.apply_transformations_repeated(StateFusion)
    print('Validate()')
    _sdfg.validate()
    print('Compile()')
    _sdfg.compile()
