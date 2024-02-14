import dace as dc
import numpy as np 
#import cupy as cp


from dace import config, data as dt, dtypes, Memlet, symbolic
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

    entry = find_map_by_param(sdfg, 'e')
    #xfutil.permute_map(entry, np.roll([0,1,2,3],0))     

    #divides_evenly = True
    #xfutil.tile(sdfg, entry, divides_evenly, True, e=1) 
    #entry.schedule = dc.ScheduleType.GPU_Default
    
    #MapCollapse.apply_to(sdfg, outer_map_entry=find_map_by_param(sdfg, 'tile_e'),
    #                           inner_map_entry=find_map_by_param(sdfg, 'e'))
    #entry = find_map_by_param(sdfg, 'tile_e')
     
    exit = find_map_by_param(sdfg, 'k')
    exit.schedule = dc.ScheduleType.GPU_ThreadBlock
   
    smem_tt = InLocalStorage.apply_to(sdfg, dict(array='ttmp'), node_a=entry, node_b=exit)
    smem_st = InLocalStorage.apply_to(sdfg, dict(array='stmp'), node_a=entry, node_b=exit)
    smem_rt = InLocalStorage.apply_to(sdfg, dict(array='rtmp'), node_a=entry, node_b=exit)

    smem_u = InLocalStorage.apply_to(sdfg, dict(array='u_d'), node_a=entry, node_b=exit)

    smem_dx = InLocalStorage.apply_to(sdfg, dict(array='dx_d'), node_a=entry, node_b=exit)
    smem_dy = InLocalStorage.apply_to(sdfg, dict(array='dy_d'), node_a=entry, node_b=exit)
    smem_dz = InLocalStorage.apply_to(sdfg, dict(array='dz_d'), node_a=entry, node_b=exit)

    smem_dx = InLocalStorage.apply_to(sdfg, dict(array='G'), node_a=entry, node_b=exit)
    smem_dy = InLocalStorage.apply_to(sdfg, dict(array='G'), node_a=entry, node_b=exit)
    smem_dz = InLocalStorage.apply_to(sdfg, dict(array='G'), node_a=entry, node_b=exit)
    smem_dx = InLocalStorage.apply_to(sdfg, dict(array='G'), node_a=entry, node_b=exit)

    #smem_dy = InLocalStorage.apply_to(sdfg, dict(array='G0d'), node_a=entry, node_b=exit)
    #smem_dz = InLocalStorage.apply_to(sdfg, dict(array='G0d'), node_a=entry, node_b=exit)
    #DoubleBuffering.apply_to(sdfg, map_entry=exit, transient=smem_dx)#
 
    ## Section 2 
    entry = find_map_by_param(sdfg, 'e2')
    MapExpansion.apply_to(sdfg, map_entry=entry)
    MapCollapse.apply_to(sdfg, outer_map_entry=find_map_by_param(sdfg, 'k2'),
                               inner_map_entry=find_map_by_param(sdfg, 'j2'))
    MapCollapse.apply_to(sdfg, outer_map_entry=find_map_by_param(sdfg, 'j2'),
                               inner_map_entry=find_map_by_param(sdfg, 'i2'))
    exit = find_map_by_param(sdfg,'k2')
    exit.schedule = dc.ScheduleType.GPU_ThreadBlock
   
    smem_dtx = InLocalStorage.apply_to(sdfg, dict(array='dxt_d'), node_a=entry, node_b=exit)
    smem_dty = InLocalStorage.apply_to(sdfg, dict(array='dyt_d'), node_a=entry, node_b=exit)
    smem_dtz = InLocalStorage.apply_to(sdfg, dict(array='dzt_d'), node_a=entry, node_b=exit)
    smem_utt = InLocalStorage.apply_to(sdfg, dict(array='uttmp'), node_a=entry, node_b=exit)
    smem_ust = InLocalStorage.apply_to(sdfg, dict(array='ustmp'), node_a=entry, node_b=exit)
    smem_urt = InLocalStorage.apply_to(sdfg, dict(array='urtmp'), node_a=entry, node_b=exit)
    
    return sdfg 

def total_opt_pass_merged(sdfg : dc.SDFG):
    print('total opt pass merge') 

    entry = find_map_by_param(sdfg, 'e')
    exit = find_map_by_param(sdfg, 'k')
    exit.schedule = dc.ScheduleType.GPU_ThreadBlock
   
    smem_tt = InLocalStorage.apply_to(sdfg, dict(array='ttmp'), node_a=entry, node_b=exit)
    smem_st = InLocalStorage.apply_to(sdfg, dict(array='stmp'), node_a=entry, node_b=exit)
    smem_rt = InLocalStorage.apply_to(sdfg, dict(array='rtmp'), node_a=entry, node_b=exit)

    smem_u = InLocalStorage.apply_to(sdfg, dict(array='u_d'), node_a=entry, node_b=exit)

    smem_dx = InLocalStorage.apply_to(sdfg, dict(array='dx_d'), node_a=entry, node_b=exit)
    smem_dy = InLocalStorage.apply_to(sdfg, dict(array='dy_d'), node_a=entry, node_b=exit)
    smem_dz = InLocalStorage.apply_to(sdfg, dict(array='dz_d'), node_a=entry, node_b=exit)

    smem_dx = InLocalStorage.apply_to(sdfg, dict(array='G'), node_a=entry, node_b=exit)
    smem_dy = InLocalStorage.apply_to(sdfg, dict(array='G'), node_a=entry, node_b=exit)
    smem_dz = InLocalStorage.apply_to(sdfg, dict(array='G'), node_a=entry, node_b=exit)
    smem_dx = InLocalStorage.apply_to(sdfg, dict(array='G'), node_a=entry, node_b=exit)
    
    entry = find_map_by_param(sdfg, 'e2')
    MapExpansion.apply_to(sdfg, map_entry=entry)
    MapCollapse.apply_to(sdfg, outer_map_entry=find_map_by_param(sdfg, 'k2'),
                               inner_map_entry=find_map_by_param(sdfg, 'j2'))
    MapCollapse.apply_to(sdfg, outer_map_entry=find_map_by_param(sdfg, 'j2'),
                               inner_map_entry=find_map_by_param(sdfg, 'i2'))
    exit = find_map_by_param(sdfg,'k2')
    exit.schedule = dc.ScheduleType.GPU_ThreadBlock
   

    smem_dtx = InLocalStorage.apply_to(sdfg, dict(array='dxt_d'), node_a=entry, node_b=exit)
    smem_dty = InLocalStorage.apply_to(sdfg, dict(array='dyt_d'), node_a=entry, node_b=exit)
    smem_dtz = InLocalStorage.apply_to(sdfg, dict(array='dzt_d'), node_a=entry, node_b=exit)
    smem_utt = InLocalStorage.apply_to(sdfg, dict(array='uttmp'), node_a=entry, node_b=exit)
    smem_ust = InLocalStorage.apply_to(sdfg, dict(array='ustmp'), node_a=entry, node_b=exit)
    smem_urt = InLocalStorage.apply_to(sdfg, dict(array='urtmp'), node_a=entry, node_b=exit)
    
    return sdfg 
