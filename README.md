Requires Neko, DaCe, and CUDA or HIP. 
```
`setup.sh` assumes neko in `submodules/neko/neko_install` 
Does no assumtion on `DACE_PATH` 
```
To build `nekobench`
```
. setup.sh 
make clean
make all
```

To run dace backend 
```
./nekobench data/32768.nmsh 8 1000 0
```
