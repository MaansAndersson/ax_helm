import dace as dc

def unique_label(sdfg, old_str, new_str):
    for node, graph in sdfg.all_nodes_recursive():
        if (old_str in node.label):
            #this is so stupid?
            #print(node.label)
            temp = node.label.replace(old_str,new_str)
            node.label = temp
            #print(node.label)

