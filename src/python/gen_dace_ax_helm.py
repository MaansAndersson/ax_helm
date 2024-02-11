
import dace as dc 
import numpy as np
#import scipy as sp
import copy
from dace.dtypes import StorageType, ScheduleType 
from dace import config, data as dt, dtypes, Memlet, symbolic
from dace.transformation.auto import auto_optimize as aopt
from dace.transformation.auto.auto_optimize import make_transients_persistent

nel = dc.symbol('ne')
lx = 8 
lxx = dc.symbol('lx')
 
dtype = dc.float64

from dace.transformation.dataflow import (DoubleBuffering, MapCollapse, MapExpansion, MapReduceFusion, StripMining, InLocalStorage, AccumulateTransient, AugAssignToWCR)
from dace.transformation.dataflow import (MapFusion, ReduceExpansion,
                                          TrivialMapElimination, Vectorization,
                                          WarpTiling, MapTiling, TaskletFusion, StreamingMemory)
from dace.transformation.interstate import (GPUTransformSDFG, HoistState,
                                            InlineSDFG, StateFusion)
from dace.transformation.subgraph import MultiExpansion, SubgraphFusion, GPUPersistentKernel
from dace.transformation.dataflow import (DoubleBuffering, MapCollapse, MapExpansion, MapReduceFusion, StripMining,
                                          InLocalStorage, AccumulateTransient, Vectorization, MapToForLoop, MapUnroll,
                                          MapFusion, MapWCRFusion)

from dace.transformation.interstate import (StateFusion)

from SDFG_Ax_opt import total_opt_pass


@dc.program()
def ax_4D(w_d   : dtype[nel,lx,lx,lx] @ StorageType.GPU_Global,
          u_d   : dtype[nel,lx,lx,lx] @ StorageType.GPU_Global,
          dx_d  : dtype[lx,lx]    @ StorageType.GPU_Global,
          dy_d  : dtype[lx,lx]    @ StorageType.GPU_Global,
          dz_d  : dtype[lx,lx]    @ StorageType.GPU_Global,
          dxt_d : dtype[lx,lx]    @ StorageType.GPU_Global,
          dyt_d : dtype[lx,lx]    @ StorageType.GPU_Global,
          dzt_d : dtype[lx,lx]    @ StorageType.GPU_Global,
          h1_d  : dtype[nel,lx,lx,lx] @ StorageType.GPU_Global,
          g11_d : dtype[nel,lx,lx,lx] @ StorageType.GPU_Global,
          g22_d : dtype[nel,lx,lx,lx] @ StorageType.GPU_Global,
          g33_d : dtype[nel,lx,lx,lx] @ StorageType.GPU_Global, 
          g12_d : dtype[nel,lx,lx,lx] @ StorageType.GPU_Global, 
          g13_d : dtype[nel,lx,lx,lx] @ StorageType.GPU_Global, 
          g23_d : dtype[nel,lx,lx,lxx] @ StorageType.GPU_Global):
  

    # Seem to be ok to run without init
    stmp   = np.empty((nel,lx,lx,lx),dtype=dtype)
    rtmp   = np.empty((nel,lx,lx,lx),dtype=dtype)
    ttmp   = np.empty((nel,lx,lx,lx),dtype=dtype)
    ur = np.empty((nel,lx,lx,lx),dtype=dtype) 
    us = np.empty((nel,lx,lx,lx),dtype=dtype) 
    ut = np.empty((nel,lx,lx,lx),dtype=dtype)   
    #wijke = np.zeros((nel,lx,lx,lx),dtype=dtype)   

    for e, k, j, i in dc.map[0:ne,0:8,0:8,0:8] @ ScheduleType.GPU_Device:
        for l in range(8):
           r_tmp = rtmp[e,k,j,i]
           s_tmp = stmp[e,k,j,i]
           t_tmp = ttmp[e,k,j,i]

           rtmp[e,k,j,i] =  r_tmp + dx_d[l,i] * u_d[e,k,j,l]
           stmp[e,k,j,i] =  s_tmp + dy_d[l,j] * u_d[e,k,l,i]
           ttmp[e,k,j,i] =  t_tmp + dz_d[l,k] * u_d[e,l,j,i] 
        
        G00 = g11_d[e,k,j,i]
        G01 = g12_d[e,k,j,i]
        G02 = g13_d[e,k,j,i]
        G11 = g22_d[e,k,j,i]
        G12 = g23_d[e,k,j,i]
        G22 = g33_d[e,k,j,i]
        H0  = h1_d[e,k,j,i]

        ur[e,k,j,i] = H0*( G00*rtmp[e,k,j,i] + G01*stmp[e,k,j,i] + G02*ttmp[e,k,j,i])
        us[e,k,j,i] = H0*( G01*rtmp[e,k,j,i] + G11*stmp[e,k,j,i] + G12*ttmp[e,k,j,i])
        ut[e,k,j,i] = H0*( G02*rtmp[e,k,j,i] + G12*stmp[e,k,j,i] + G22*ttmp[e,k,j,i])
      
    for e2, k2, j2, i2 in dc.map[0:ne,0:8,0:8,0:8] @ ScheduleType.GPU_Device:
        w_d[e2,k2,j2,i2] = 0.0
        for l2 in range(8):
            w_d[e2,k2,j2,i2] = w_d[e2,k2,j2,i2] + dxt_d[l2,i2] * ur[e2,k2,j2,l2]
            w_d[e2,k2,j2,i2] = w_d[e2,k2,j2,i2] + dyt_d[l2,j2] * us[e2,k2,l2,i2] 
            w_d[e2,k2,j2,i2] = w_d[e2,k2,j2,i2] + dzt_d[l2,k2] * ut[e2,l2,j2,i2]


if __name__ == "__main__":                     
 #   
    dc.Config.set('compiler', 'default_data_types', value='C') 


    lx_const = [];
    print('to_sdfg()')
    ax_sdfg = ax_4D.to_sdfg()
    ax_sdfg.name = 'ax' #+str(lx_const)
    
    print('simplify()')
    #ax_sdfg.simplify()
    print('GPU()')
    
    ax_sdfg.apply_gpu_transformations()
    ax_sdfg.apply_transformations(MapExpansion)
    ax_sdfg.apply_transformations(MapCollapse)
    ax_sdfg.apply_transformations(MapCollapse)
    #ax_sdfg.apply_transformations(WarpTiling)
    #ax_sdfg.apply_transformations(MapReduceFusion)
    #ax_sdfg.apply_transformations_repeated(MapExpansion) 
    #ax_sdfg.apply_transformations(ReduceExpansion)
    

    make_transients_persistent(ax_sdfg,dtypes.DeviceType.GPU,True) 
    total_opt_pass(ax_sdfg)
    print('simplify()')
    #ax_sdfg.apply_transformations_repeated( TaskletFusion) 
    ax_sdfg.simplify()
    #ax_sdfg.apply_transformations(StreamingMemory) 
    #ax_sdfg.apply_transformations(WarpTiling)
    #aopt.auto_optimize(ax_sdfg, dc.DeviceType.GPU)
    

    print('validate()')
    ax_sdfg.validate()
    print('compile()')
    ax_sdfg.compile()




