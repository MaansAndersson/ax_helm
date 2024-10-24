import dace as dc


sdfg = dc.SDFG.from_file("math.sdfg")

for node in sdfg._nodes:
    print(node.label)
    node.label = "lol"


sdfg.save('math_.sdfg')
