Requires Neko (with CUDA or HIP) and DaCe both as subomdules. 

```
git submodule update --init --recursive
```
Set PATHS in setup
```
`setup.sh` assumes neko in `submodules/neko/neko_install` 
Does no assumption on `DACE_PATH` 
```
To build `nekobench`
```
. setup.sh 
make clean
make all
```

To run DaCe backend 
```
./nekobench data/32768.nmsh 8 1000 0
```
To run native backend
```
./nekobench data/32768.nmsh 8 1000 1
```
