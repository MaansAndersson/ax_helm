Requires Neko, DaCe, and CUDA or HIP. 
```
cd src/python
python3 gen_ax_hem.py
```
`setup.sh` assumes neko in `$PWD/../neko/neko_install`
```
. setup.sh 
make clean
make nekobench
```

To run dace backend 
```
./nekobench data/32768.nmsh 8 1000 0
```
