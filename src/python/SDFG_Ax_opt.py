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
from dace.transformation.dataflow import BufferTiling, RedundantArray, TrivialTaskletElimination
from dace.transformation.interstate import (StateFusion, LoopUnroll, LoopPeeling)
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
    sdfg.apply_gpu_transformations()
    sdfg.apply_transformations(MapExpansion)
    MapCollapse.apply_to(sdfg, outer_map_entry=find_map_by_param(sdfg, 'k'),
                               inner_map_entry=find_map_by_param(sdfg, 'j'))
    MapCollapse.apply_to(sdfg, outer_map_entry=find_map_by_param(sdfg, 'j'),
                               inner_map_entry=find_map_by_param(sdfg, 'i'))
    entry = find_map_by_param(sdfg, 'e')
    exit  = find_map_by_param(sdfg, 'k')
    exit.schedule = dc.ScheduleType.GPU_ThreadBlock 
    data_containers = ['dx_d', 'dy_d', 'dz_d', 'u_d',
                       'g11_d', 'g12_d', 'g13_d', 'g22_d', 'g23_d', 'g33_d', 'h1_d']
    for data in data_containers:
        InLocalStorage.apply_to(sdfg, dict(array=data), node_a=entry, node_b=exit) 
   
    ## Section 2 
    entry = find_map_by_param(sdfg, 'e2')
    MapExpansion.apply_to(sdfg, map_entry=entry)
    MapCollapse.apply_to(sdfg, outer_map_entry=find_map_by_param(sdfg, 'k2'),
                               inner_map_entry=find_map_by_param(sdfg, 'j2'))
    MapCollapse.apply_to(sdfg, outer_map_entry=find_map_by_param(sdfg, 'j2'),
                               inner_map_entry=find_map_by_param(sdfg, 'i2'))
    exit = find_map_by_param(sdfg,'k2')
    exit.schedule = dc.ScheduleType.GPU_ThreadBlock
    data_containers = ['dxt_d','dyt_d', 'dzt_d',
                       'uttmp','ustmp','urtmp']
    for data in data_containers: 
        InLocalStorage.apply_to(sdfg, dict(array=data), node_a=entry, node_b=exit) 
    sdfg.apply_transformations_repeated(RedundantArray)
    sdfg.apply_transformations(MapFusion)
    sdfg.simplify()
    
    print(sdfg.apply_transformations_repeated(TrivialTaskletElimination))
    return sdfg 

def exp_pass(sdfg : dc.SDFG):
    print('exp opt pass') 
    sdfg.name += 'exp'
    sdfg.apply_gpu_transformations()
#    sdfg.apply_transformations(MapExpansion)
    sdfg.apply_transformations(MapExpansion)

    MapCollapse.apply_to(sdfg, outer_map_entry=find_map_by_param(sdfg, 'k'),
                               inner_map_entry=find_map_by_param(sdfg, 'j'))
    MapCollapse.apply_to(sdfg, outer_map_entry=find_map_by_param(sdfg, 'j'),
                               inner_map_entry=find_map_by_param(sdfg, 'i'))

    sdfg.apply_transformations(MapTiling)
    #sdfg.apply_transformations(MapCollapse)
    #sdfg.apply_transformations(MapCollapse)
    #entry = find_map_by_param(sdfg, 'e')
    #exit  = find_map_by_param(sdfg, 'k')
    #exit.schedule = dc.ScheduleType.GPU_ThreadBlock 
    #data_containers = ['dx_d', 'dy_d', 'dz_d', 'u_d',
    #                   'g11_d', 'g12_d', 'g13_d', 'g22_d', 'g23_d', 'g33_d', 'h1_d']
    #for data in data_containers:
    #    InLocalStorage.apply_to(sdfg, dict(array=data), node_a=entry, node_b=exit) 
   
    ### Section 2 
    entry = find_map_by_param(sdfg, 'e2')
    MapExpansion.apply_to(sdfg, map_entry=entry) 
    MapTiling.apply_to(sdfg, map_entry=find_map_by_param(sdfg, 'e2'), name='tile_e')   
    MapCollapse.apply_to(sdfg, outer_map_entry=find_map_by_param(sdfg, 'k2'),
                               inner_map_entry=find_map_by_param(sdfg, 'j2'))
    MapCollapse.apply_to(sdfg, outer_map_entry=find_map_by_param(sdfg, 'j2'),
                               inner_map_entry=find_map_by_param(sdfg, 'i2'))
   
    #exit = find_map_by_param(sdfg,'k2')
    #exit.schedule = dc.ScheduleType.GPU_ThreadBlock
    #data_containers = ['dxt_d','dyt_d', 'dzt_d',
    #                   'uttmp','ustmp','urtmp']
    #for data in data_containers: 
    #    InLocalStorage.apply_to(sdfg, dict(array=data), node_a=entry, node_b=exit) #sdfg.apply_transformations_repeated(RedundantArray) #sdfg.apply_transformations(LoopUnroll)

    ## Section 3
    #MapTiling.apply_to(sdfg, map_entry=find_map_by_param(sdfg, 'e'))   


    entry = find_map_by_param(sdfg, 'tile_e')
    exit  = find_map_by_param(sdfg, 'e')
    data_containers = ['uttmp','ustmp','urtmp']
                       
    
    for data in data_containers: 
        InLocalStorage.apply_to(sdfg, dict(array=data), node_a=entry, node_b=exit) 
    sdfg.add_symbol('tile_e2', stype=dc.int32) 
        
    sdfg.apply_transformations(MapFusion)

    #sdfg.apply_transformations(BufferTiling)
    #sdfg.apply_transformations(MapTiling)
    #sdfg.apply_transformations(MapTiling)
    print(sdfg.symbols)

    
    #sdfg.simplify()
    #
    ##print(sdfg.apply_transformations_repeated(TaskletFusion))
    #print(sdfg.apply_transformations_repeated(TrivialTaskletElimination))
    
    #sdfg.remove_symbol('lxx')# ,stype=dc.int64)    
    #a_node_list = sdfg.states()
    #sdfg.apply_transformations(LoopPeeling)
    #sdfg.apply_transformations(LoopPeeling)
    #sdfg.apply_transformations(LoopPeeling)
    #sdfg.apply_transformations(LoopUnroll)
    return sdfg 

