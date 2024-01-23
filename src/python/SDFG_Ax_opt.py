import dace as dc
import numpy as np 
#import cupy as cp


from dace.codegen.compiled_sdfg import CompiledSDFG
from dace.sdfg.utils import load_precompiled_sdfg
from dace.transformation.dataflow import (DoubleBuffering, MapCollapse, MapExpansion, MapReduceFusion, StripMining, InLocalStorage, AccumulateTransient, AugAssignToWCR, GPUTransformLocalStorage)
from dace.transformation.dataflow import (MapFusion, ReduceExpansion,
                                          TrivialMapElimination, Vectorization,
                                          WarpTiling, MapTiling, TaskletFusion)
from dace.transformation.interstate import (GPUTransformSDFG, HoistState,
                                            InlineSDFG, StateFusion)
from dace.transformation.subgraph import MultiExpansion, SubgraphFusion

from dace.transformation import helpers as xfutil


def find_map_by_param(sdfg: dc.SDFG, pname: str) -> dc.nodes.MapEntry:
    """ Finds the first map entry node by the given parameter name. """
    return next(n for n, _ in sdfg.all_nodes_recursive() if isinstance(n, dc.nodes.MapEntry) and pname in n.params)


def find_map_and_state_by_param(sdfg: dc.SDFG, pname: str): # -> tuple[dc.nodes.MapEntry, dc.SDFGState]:
    """ Finds the first map entry node by the given parameter name. """
    return next(
        (n, p) for n, p in sdfg.all_nodes_recursive() if isinstance(n, dc.nodes.MapEntry) and pname in n.params)


def find_mapexit_by_param(sdfg: dc.SDFG, pname: str) -> dc.nodes.MapExit:
    """ Finds the first map exit node by the given parameter name. """
    entry, state = find_map_and_state_by_param(sdfg, pname)
    return state.exit_node(entry)


## SDFG Passes

def add_local_storage(sdfg: dc.SDFG):

    ktile = find_map_by_param(sdfg, 'tile_k')
    smem_a = InLocalStorage.apply_to(sdfg, dict(array='A'), node_a=ktile, node_b=btile)
    smem_b = InLocalStorage.apply_to(sdfg, dict(array='B'), node_a=ktile, node_b=btile)
    sdfg.arrays[smem_a.data].storage = dace.StorageType.GPU_Shared
    sdfg.arrays[smem_b.data].storage = dace.StorageType.GPU_Shared
    return sdfg 

def transient_reuse():
    return sdfg


def total_opt_pass(sdfg : dc.SDFG):
    print('total opt pass') 
    m, n, k = 256, 256, 256
    
    entry = find_map_by_param(sdfg, 'e') # Entery for large parallel loop
    divides_evenly = False #(m % 64 == 0) and (n % 64 == 0) and (k % 8 == 0)
    xfutil.tile(sdfg, entry, divides_evenly, True, e=4) 
    
    #entry = find_map_by_param(sdfg, 'tile_e')
    #xfutil.tile(sdfg, entry, divides_evenly, True, tile_e=64)
    #entry_tile_e = find_map_by_param(sdfg, 'tile_e') 
    
    #entry = find_map_by_param(sdfg, 'tile_e')
    #entry.schedule = dc.ScheduleType.GPU_ThreadBlock
 
    entry = find_map_by_param(sdfg, 'tile_e')
    exit = find_map_by_param(sdfg, 'e')
    
    #find_map_by_param(sdfg,'l').map.unroll = True
    #find_map_by_param(sdfg,'l2').map.unroll = True

    InLocalStorage.apply_to(sdfg=sdfg,
                            node_a=entry,
                            node_b=exit,
                            options={
                                "array": "dx",
                                "create_array": True,
                                "prefix": "sh"
                            },
                            save=True)
    sh_rtmp = InLocalStorage.apply_to(sdfg, dict(array='u_d'), node_a=entry, node_b=exit)
    sh_rtmp1 = InLocalStorage.apply_to(sdfg, dict(array='rtmp'), node_a=entry, node_b=exit)
    sh_rtmp2 = InLocalStorage.apply_to(sdfg, dict(array='rtmp'), node_a=entry, node_b=exit)
    sh_rtmp3 = InLocalStorage.apply_to(sdfg, dict(array='rtmp'), node_a=entry, node_b=exit)
    #sdfg.arrays[sh_rtmp.data].storage = dc.StorageType.GPU_Shared     
    sdfg.arrays[sh_rtmp1.data].storage = dc.StorageType.GPU_Shared     
    sdfg.arrays[sh_rtmp2.data].storage = dc.StorageType.GPU_Shared     
    sdfg.arrays[sh_rtmp3.data].storage = dc.StorageType.GPU_Shared     
   

    #smem_dx = InLocalStorage.apply_to(sdfg, dict(array='dx_d'), node_a=entry, node_b=exit)
    #smem_dy = InLocalStorage.apply_to(sdfg, dict(array='dy_d'), node_a=entry, node_b=exit)
    #smem_dz = InLocalStorage.apply_to(sdfg, dict(array='dz_d'), node_a=entry, node_b=exit)
    ##
    #smem_dtx = InLocalStorage.apply_to(sdfg, dict(array='dxt_d'), node_a=entry, node_b=exit)
    #smem_dty = InLocalStorage.apply_to(sdfg, dict(array='dyt_d'), node_a=entry, node_b=exit)
    #smem_dtz = InLocalStorage.apply_to(sdfg, dict(array='dzt_d'), node_a=entry, node_b=exit)
    #
    #sdfg.arrays[smem_dx.data].storage = dc.StorageType.GPU_Shared     
    #sdfg.arrays[smem_dy.data].storage = dc.StorageType.GPU_Shared     
    #sdfg.arrays[smem_dz.data].storage = dc.StorageType.GPU_Shared     
   
    #sdfg.arrays[smem_dtx.data].storage = dc.StorageType.GPU_Shared     
    #sdfg.arrays[smem_dty.data].storage = dc.StorageType.GPU_Shared     
    #sdfg.arrays[smem_dtz.data].storage = dc.StorageType.GPU_Shared     
  
    #DoubleBuffering.apply_to(sdfg, map_entry=ktile, transient=smem_a)#

    #xfutil          -- Warps                      
    #MapTiling       -- Warps
    #Scheduler       -- dace.ScheduleType.GPU_ThreadBlock
    #InLocalStorage  -- smem_b = InLocalStorage.apply_to(sdfg, dict(array='B'), node_a=ktile, node_b=btile)
    #Shared          -- sdfg.arrays[smem_b.data].storage = dace.StorageType.GPU_Shared
    #Registers?      -- 
    #Unroll inner    -- .map.unroll = True
    return sdfg 
