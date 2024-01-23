
import dace as dc 
import numpy as np
#import scipy as sp
import copy
from dace.dtypes import StorageType, ScheduleType 
from dace.transformation.auto import auto_optimize as aopt

nel = dc.symbol('ne')
lx = 8 #dc.symbol('lx')
dtype = dc.float64

from dace.transformation.dataflow import (DoubleBuffering, MapCollapse, MapExpansion, MapReduceFusion, StripMining, InLocalStorage, AccumulateTransient, AugAssignToWCR)
from dace.transformation.dataflow import (MapFusion, ReduceExpansion,
                                          TrivialMapElimination, Vectorization,
                                          WarpTiling, MapTiling, TaskletFusion)
from dace.transformation.interstate import (GPUTransformSDFG, HoistState,
                                            InlineSDFG, StateFusion)
from dace.transformation.subgraph import MultiExpansion, SubgraphFusion

from dace.transformation.dataflow import (DoubleBuffering, MapCollapse, MapExpansion, MapReduceFusion, StripMining,
                                          InLocalStorage, AccumulateTransient, Vectorization, MapToForLoop, MapUnroll,
                                          MapFusion, MapWCRFusion)

from dace.transformation.interstate import (StateFusion)

from SDFG_Ax_opt import total_opt_pass

@dc.program()
def ax_base(w_d : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global,
          u_d   : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global,
          dx_d  : dc.float64[lx*lx]        @ StorageType.GPU_Global,
          dy_d  : dc.float64[lx*lx]        @ StorageType.GPU_Global,
          dz_d  : dc.float64[lx*lx]        @ StorageType.GPU_Global,
          dxt_d : dc.float64[lx*lx]        @ StorageType.GPU_Global,
          dyt_d : dc.float64[lx*lx]        @ StorageType.GPU_Global,
          dzt_d : dc.float64[lx*lx]        @ StorageType.GPU_Global,
          h1_d  : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global,
          g11_d : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global,
          g22_d : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global,
          g33_d : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global, 
          g12_d : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global, 
          g13_d : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global, 
          g23_d : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global):
   
    for el in dc.map[0:(nel*lx*lx*lx)] @ ScheduleType.GPU_Device:
        w_d[el]=0.0
        u_d[el]=0.0
    for e in dc.map[0:(nel*lx*lx*lx)] @ ScheduleType.GPU_Device:
        h1_d[e] =  0. # +h1[e] 
        g11_d[e] = 0. #+g00[e]
        g22_d[e] = 0. #+g11[e]
        g33_d[e] = 0. #+g22[e]
        g12_d[e] = 0. #+g01[e]
        g13_d[e] = 0. #+g02[e]
        g23_d[e] = 0. #+g12[e]
        
        if(e < lx*lx):
            dx_d[e]  = 0.
            dxt_d[e] = 0.
            dy_d[e]  = 0.
            dyt_d[e] = 0.
            dz_d[e]  = 0.
            dzt_d[e] = 0.

@dc.program()
def ax_1D(w_d   : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global,
          u_d   : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global,
          dx_d  : dc.float64[lx*lx]        @ StorageType.GPU_Global,
          dy_d  : dc.float64[lx*lx]        @ StorageType.GPU_Global,
          dz_d  : dc.float64[lx*lx]        @ StorageType.GPU_Global,
          dxt_d : dc.float64[lx*lx]        @ StorageType.GPU_Global,
          dyt_d : dc.float64[lx*lx]        @ StorageType.GPU_Global,
          dzt_d : dc.float64[lx*lx]        @ StorageType.GPU_Global,
          h1_d  : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global,
          g11_d : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global,
          g22_d : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global,
          g33_d : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global, 
          g12_d : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global, 
          g13_d : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global, 
          g23_d : dc.float64[nel*lx*lx*lx] @ StorageType.GPU_Global):
   
    for e in range(nel): #    #e*lx*lx*lx = e*lx*lx*lx
        ur = np.zeros((lx*lx*lx,),dtype=dtype) # @ StorageType.GPU_Global
        us = np.zeros((lx*lx*lx,),dtype=dtype) # @ StorageType.GPU_Global
        ut = np.zeros((lx*lx*lx,),dtype=dtype) # @ StorageType.GPU_Global

        for k in range(lx): 
            for j in range(lx):
                for i in range(lx):
                    ij = i + j*lx
                    ijk = ij + k*lx*lx 
                    rtmp = 0.0
                    stmp = 0.0
                    ttmp = 0.0

                    for l in range(lx):
                        rtmp += dxt_d[l+i*lx] * u_d[l+j*lx +k*lx*lx+e*lx*lx*lx]
                        stmp += dyt_d[l+j*lx] * u_d[i+l*lx + k*lx*lx+e*lx*lx*lx]
                        ttmp += dzt_d[l+k*lx] * u_d[ij + l*lx*lx+e*lx*lx*lx]
 
                    #G00 = g11_d[i,j,k,e]                   
                    G00 = g11_d[ijk+e*lx*lx*lx]
                    G01 = g12_d[ijk+e*lx*lx*lx]
                    G02 = g13_d[ijk+e*lx*lx*lx]
                    G11 = g22_d[ijk+e*lx*lx*lx]
                    G12 = g23_d[ijk+e*lx*lx*lx]
                    G22 = g33_d[ijk+e*lx*lx*lx]

                    ur[ijk] = G00*rtmp + G01*stmp + G02*ttmp
                    us[ijk] = G01*rtmp + G11*stmp + G12*ttmp
                    ut[ijk] = G02*rtmp + G12*stmp + G22*ttmp

        for k in range(lx):
            for j in range(lx):
                for i in range(lx):
                    ij = i + j*lx
                    ijk = ij + k*lx*lx
                    
                    wijke = 0.0
                    for l in range(lx):
                        wijke += dx_d[l + i*lx] * ur[l+j*lx+k*lx*lx]
                        wijke += dy_d[l + j*lx] * us[i+l*lx+k*lx*lx]
                        wijke += dz_d[l + k*lx] * ut[i+j*lx+l*lx*lx]

                    w_d[ijk+e*lx*lx*lx] = wijke

@dc.program()
def ax_4D(w_d   : dtype[lx,lx,lx,nel] @ StorageType.GPU_Global,
          u_d   : dtype[lx,lx,lx,nel] @ StorageType.GPU_Global,
          dx_d  : dtype[lx,lx]        @ StorageType.GPU_Global,
          dy_d  : dtype[lx,lx]        @ StorageType.GPU_Global,
          dz_d  : dtype[lx,lx]        @ StorageType.GPU_Global,
          dxt_d : dtype[lx,lx]        @ StorageType.GPU_Global,
          dyt_d : dtype[lx,lx]        @ StorageType.GPU_Global,
          dzt_d : dtype[lx,lx]        @ StorageType.GPU_Global,
          h1_d  : dtype[lx,lx,lx,nel] @ StorageType.GPU_Global,
          g11_d : dtype[lx,lx,lx,nel] @ StorageType.GPU_Global,
          g22_d : dtype[lx,lx,lx,nel] @ StorageType.GPU_Global,
          g33_d : dtype[lx,lx,lx,nel] @ StorageType.GPU_Global, 
          g12_d : dtype[lx,lx,lx,nel] @ StorageType.GPU_Global, 
          g13_d : dtype[lx,lx,lx,nel] @ StorageType.GPU_Global, 
          g23_d : dtype[lx,lx,lx,nel] @ StorageType.GPU_Global):
  

    ur = np.zeros((lx,lx,lx,nel),dtype=dtype) 
    us = np.zeros((lx,lx,lx,nel),dtype=dtype) 
    ut = np.zeros((lx,lx,lx,nel),dtype=dtype) 

#    rtmp_ = np.zeros((lx,lx,lx,nel),dtype=dtype)
#    stmp_ = np.zeros((lx,lx,lx,nel),dtype=dtype)
#    ttmp_ = np.zeros((lx,lx,lx,nel),dtype=dtype) 
   
    wijke_ = np.zeros((lx,lx,lx,nel),dtype=dtype)
    #for e, k, j, i in dc.map[0:ne,0:lx,0:lx,0:lx]: #   @ ScheduleType.Sequential:
    for e in dc.map[0:(nel)] @ ScheduleType.GPU_Device:
        #    for k, j, i in dc.map[0:lx,0:lx,0:lx] @ ScheduleType.Sequential:
#        for k in dc.map[0:lx]: #@ ScheduleType.GPU_ThreadBlock:
#            for j in dc.map[0:lx]:
#                for i in dace.map[0:lx]:
        for k in range(lx):
            for j in range(lx):
                for i in range(lx):

                    rtmp_ = 0.
                    stmp_ = 0.
                    ttmp_ = 0.
                    for l in dc.map[0:lx] @ ScheduleType.Unrolled :
                        rtmp_ += dx_d[i,l] * u_d[l,j,k,e]
                        stmp_ += dy_d[j,l] * u_d[i,l,k,e]
                        ttmp_ += dz_d[k,l] * u_d[i,j,l,e]
    

                    G00 = g11_d[i,j,k,e]
                    G01 = g12_d[i,j,k,e]
                    G02 = g13_d[i,j,k,e]
                    G11 = g22_d[i,j,k,e]
                    G12 = g23_d[i,j,k,e]
                    G22 = g33_d[i,j,k,e]
                    H0  = h1_d[i,j,k,e]

                    ur[i,j,k,e] += H0*( G00*rtmp_ + G01*stmp_ + G02*ttmp_)
                    us[i,j,k,e] += H0*( G01*rtmp_ + G11*stmp_ + G12*ttmp_)
                    ut[i,j,k,e] += H0*( G02*rtmp_ + G12*stmp_ + G22*ttmp_)

    
    #for e, k2, j2, i2, l2 in dc.map[0:ne,0:lx,0:lx,0:lx,0:lx]: #@ ScheduleType.Sequential : 
    
    for e in dc.map[0:(nel)] @ ScheduleType.GPU_Device:
        #for k2, j2, i2 in dc.map[0:lx,0:lx,0:lx]: 
        for k2 in range(lx):
            for j2 in range(lx):
                for i2 in range(lx):
       

                    #        for k2 in dc.map[0:lx]: # @ ScheduleType.GPU_ThreadBlock: 
                    #            for j2 in dc.map[0:lx]:
                    #                for i2 in dc.map[0:lx]:    
                    for l2 in dc.map[0:lx] @ ScheduleType.Unrolled :  
                        wijke_[i2,j2,k2,e] += dxt_d[i2,l2] * ur[l2,j2,k2,e]
                        wijke_[i2,j2,k2,e] += dyt_d[j2,l2] * us[i2,l2,k2,e] 
                        wijke_[i2,j2,k2,e] += dzt_d[k2,l2] * ut[i2,j2,l2,e]
                    
                    #wijke = wijke_[i2,j2,k2,e]     
                    #u_d[i2,j2,k2,e] = wijke     
                    #w_d[i2,j2,k2,e] = wijke

    w_d[:] = wijke_[:]

@dc.program
def ax_5D(w_d   : dtype[lx,lx,lx,nel]@ StorageType.GPU_Global,
          u_d   : dtype[lx,lx,lx,nel]@ StorageType.GPU_Global,
          dx_d  : dtype[lx,lx]       @ StorageType.GPU_Global,
          dy_d  : dtype[lx,lx]       @ StorageType.GPU_Global,
          dz_d  : dtype[lx,lx]       @ StorageType.GPU_Global,
          dxt_d : dtype[lx,lx]       @ StorageType.GPU_Global,
          dyt_d : dtype[lx,lx]       @ StorageType.GPU_Global,
          dzt_d : dtype[lx,lx]       @ StorageType.GPU_Global,
          h1_d  : dtype[lx,lx,lx,nel]@ StorageType.GPU_Global,
          g11_d : dtype[lx,lx,lx,nel]@ StorageType.GPU_Global,
          g22_d : dtype[lx,lx,lx,nel]@ StorageType.GPU_Global,
          g33_d : dtype[lx,lx,lx,nel]@ StorageType.GPU_Global,
          g12_d : dtype[lx,lx,lx,nel]@ StorageType.GPU_Global,
          g13_d : dtype[lx,lx,lx,nel]@ StorageType.GPU_Global,
          g23_d : dtype[lx,lx,lx,nel]@ StorageType.GPU_Global):


    ur = np.zeros((lx,lx,lx,nel),dtype=dtype)
    us = np.zeros((lx,lx,lx,nel),dtype=dtype)
    ut = np.zeros((lx,lx,lx,nel),dtype=dtype)

    rtmp = np.zeros((lx,lx,lx,lx,nel),dtype=dtype)
    stmp = np.zeros((lx,lx,lx,lx,nel),dtype=dtype)
    ttmp = np.zeros((lx,lx,lx,lx,nel),dtype=dtype)

    rtmp_ = np.zeros((nel,),dtype=dtype)
    stmp_ = np.zeros((nel,),dtype=dtype)
    ttmp_ = np.zeros((nel,),dtype=dtype)

    wijke_ = np.zeros((lx,lx,lx,nel),dtype=dtype)
    for  k, j, i, l, e, in dc.map[0:lx,0:lx,0:lx,0:lx,0:ne]:
        rtmp[i,j,k,l,e] = dx_d[i,l] * u_d[l,j,k,e]
        stmp[i,j,k,l,e] = dy_d[j,l] * u_d[i,l,k,e]
        ttmp[i,j,k,l,e] = dz_d[k,l] * u_d[i,j,l,e]

    dc.reduce(lambda a, b: a+b, rtmp, rtmp_, axis=[0,1,2,3])
    dc.reduce(lambda a, b: a+b, stmp, stmp_, axis=[0,1,2,3])
    dc.reduce(lambda a, b: a+b, ttmp, ttmp_, axis=[0,1,2,3])

    #combine rst
    #dc.reduce(lambda a, b, c, d: a+b+c+d, tmp, tmp_, axis=[0,1,2,3])

    for k, j, i, l, e in dc.map[0:lx,0:lx,0:lx,0:lx,0:ne]:
        G00 = g11_d[i,j,k,e]
        G01 = g12_d[i,j,k,e]
        G02 = g13_d[i,j,k,e]
        G11 = g22_d[i,j,k,e]
        G12 = g23_d[i,j,k,e]
        G22 = g33_d[i,j,k,e]
        H0  = h1_d[i,j,k,e]
        rtmp__ = rtmp_[e]
        stmp__ = stmp_[e]
        ttmp__ = ttmp_[e]
        ur[i,j,k,e] += H0*( G00*rtmp__ + G01*stmp__ + G02*ttmp__)
        us[i,j,k,e] += H0*( G01*rtmp__ + G11*stmp__ + G12*ttmp__)
        ut[i,j,k,e] += H0*( G02*rtmp__ + G12*stmp__ + G22*ttmp__)


    for k2, j2, i2, l2, e in dc.map[0:lx,0:lx,0:lx,0:lx,0:ne]:
        wijke_[i2,j2,k2,e] += dxt_d[i2,l2] * ur[l2,j2,k2,e]
        wijke_[i2,j2,k2,e] += dyt_d[j2,l2] * us[i2,l2,k2,e]
        wijke_[i2,j2,k2,e] += dzt_d[k2,l2] * ut[i2,j2,l2,e]

    w_d[:] = wijke_[:]

@dc.program
def ax_6D(w_d   : dtype[lx,lx,lx,nel]   ,
          u_d   : dtype[lx,lx,lx,lx,nel],
          dx_d  : dtype[lx,lx]        ,
          dy_d  : dtype[lx,lx]        ,
          dz_d  : dtype[lx,lx]        ,
          dxt_d : dtype[lx,lx]        ,
          dyt_d : dtype[lx,lx]        ,
          dzt_d : dtype[lx,lx]        ,
          h1_d  : dtype[lx,lx,lx,nel] ,
          g11_d : dtype[lx,lx,lx,nel] ,
          g22_d : dtype[lx,lx,lx,nel] ,
          g33_d : dtype[lx,lx,lx,nel] ,
          g12_d : dtype[lx,lx,lx,nel] ,
          g13_d : dtype[lx,lx,lx,nel] ,
          g23_d : dtype[lx,lx,lx,nel] ):
    
    rtmp = np.ndarray([lx,lx,lx,nel],dtype=dtype)
    stmp = np.ndarray([lx,lx,nel],dtype=dtype)
    ttmp = np.ndarray([lx,lx,lx,nel],dtype=dtype)
    
    #for e, k, j, i, l, in dc.map[0:nel, 0:lx, 0:lx, 0:lx, 0:lx]:
    #for e, k, j, i in dc.map[0:nel, 0:lx, 0:lx, 0:lx]:
    #    with dace.tasklet: 
           # dx_dil << dx_d[i, l]
           # dy_djl << dy_d[j, l]
           # dz_dkl << dz_d[k, l]
           # u_dljk << u_d[l, j, k, e]
           # u_dilk << u_d[i, l, k, e]
           # u_dijl << u_d[i, j, l, e]
           # out1 >> rtmp[i, j, k, l, e]
           # out2 >> stmp[i, j, k, l, e]
           # out3 >> ttmp[i, j, k, l, e]            
           # out1 = dx_dil * u_dljk
           # out2 = dy_djl * u_dilk
           # out3 = dz_dkl * u_dijl

        #rtmp[i,j,k,l,e] = dx_d[i,l] * u_d[l,j,k,e]
        #stmp[i,j,k,l,e] = dy_d[j,l] * u_d[i,l,k,e]
        #ttmp[i,j,k,l,e] = dz_d[k,l] * u_d[i,j,l,e]
    
    dc.reduce(lambda a, b: a + b, u_d, w_d, axis=1) #identity=0)
    #dc.reduce(lambda a, b: a + b, tmp, C, axis=2, identity=0)

if __name__ == "__main__":                     
 #   
    dc.Config.set('compiler', 'default_data_types', value='C') 


    lx_const = [];
    print('to_sdfg()')
    ax_sdfg = ax_6D.to_sdfg()
    ax_sdfg.name = 'ax' #+str(lx_const)
    
    print('simplify()')
    ax_sdfg.simplify()
    print('GPU()')
    #ax_sdfg.apply_gpu_transformations()
    #ax_sdfg.apply_transformations(MapReduceFusion)
    #ax_sdfg.apply_transformations(MapReduceFusion)
    #ax_sdfg.apply_transformations_repeated(MapExpansion) 
    #ax_sdfg.apply_transformations(ReduceExpansion)
    #ax_sdfg.apply_transformations(MapReduceFusion)

    #ax_sdfg.apply_transformations(ReduceExpansion)
    
    #total_opt_pass(ax_sdfg)
    print('simplify()')
    #ax_sdfg.simplify()
    #ax_sdfg.apply_transformations_repeated(StateFusion) 
    #aopt.auto_optimize(ax_sdfg, dc.DeviceType.GPU)
    print('validate()')
    #ax_sdfg.validate()
    print('compile()')
    ax_sdfg.compile()




