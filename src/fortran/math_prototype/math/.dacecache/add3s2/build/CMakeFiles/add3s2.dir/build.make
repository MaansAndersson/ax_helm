# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.20

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /afs/pdc.kth.se/home/m/mansande/.local/lib/python3.9/site-packages/dace/codegen

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/build

# Include any dependencies generated for this target.
include CMakeFiles/add3s2.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/add3s2.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/add3s2.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/add3s2.dir/flags.make

CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/__/__/__/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cuda/cuda_compile_1_generated_add3s2_cuda.cu.o: CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/__/__/__/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cuda/cuda_compile_1_generated_add3s2_cuda.cu.o.depend
CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/__/__/__/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cuda/cuda_compile_1_generated_add3s2_cuda.cu.o: CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/__/__/__/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cuda/cuda_compile_1_generated_add3s2_cuda.cu.o.cmake
CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/__/__/__/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cuda/cuda_compile_1_generated_add3s2_cuda.cu.o: /scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cuda/add3s2_cuda.cu
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building NVCC (Device) object CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/__/__/__/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cuda/cuda_compile_1_generated_add3s2_cuda.cu.o"
	cd /scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/build/CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/__/__/__/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cuda && /usr/bin/cmake -E make_directory /scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/build/CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/__/__/__/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cuda/.
	cd /scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/build/CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/__/__/__/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cuda && /usr/bin/cmake -D verbose:BOOL=$(VERBOSE) -D build_configuration:STRING= -D generated_file:STRING=/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/build/CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/__/__/__/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cuda/./cuda_compile_1_generated_add3s2_cuda.cu.o -D generated_cubin_file:STRING=/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/build/CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/__/__/__/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cuda/./cuda_compile_1_generated_add3s2_cuda.cu.o.cubin.txt -P /scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/build/CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/__/__/__/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cuda/cuda_compile_1_generated_add3s2_cuda.cu.o.cmake

CMakeFiles/add3s2.dir/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp.o: CMakeFiles/add3s2.dir/flags.make
CMakeFiles/add3s2.dir/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp.o: /scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp
CMakeFiles/add3s2.dir/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp.o: CMakeFiles/add3s2.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/add3s2.dir/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp.o"
	/local/spack/linux-centos8-zen/gcc-8.5.0/gcc-11.3.0-lsrw3b6dbtevo63ogo6xhqdwcofcliio/bin/g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/add3s2.dir/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp.o -MF CMakeFiles/add3s2.dir/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp.o.d -o CMakeFiles/add3s2.dir/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp.o -c /scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp

CMakeFiles/add3s2.dir/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/add3s2.dir/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp.i"
	/local/spack/linux-centos8-zen/gcc-8.5.0/gcc-11.3.0-lsrw3b6dbtevo63ogo6xhqdwcofcliio/bin/g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp > CMakeFiles/add3s2.dir/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp.i

CMakeFiles/add3s2.dir/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/add3s2.dir/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp.s"
	/local/spack/linux-centos8-zen/gcc-8.5.0/gcc-11.3.0-lsrw3b6dbtevo63ogo6xhqdwcofcliio/bin/g++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp -o CMakeFiles/add3s2.dir/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp.s

# Object files for target add3s2
add3s2_OBJECTS = \
"CMakeFiles/add3s2.dir/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp.o"

# External object files for target add3s2
add3s2_EXTERNAL_OBJECTS = \
"/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/build/CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/__/__/__/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cuda/cuda_compile_1_generated_add3s2_cuda.cu.o"

libadd3s2.so: CMakeFiles/add3s2.dir/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cpu/add3s2.cpp.o
libadd3s2.so: CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/__/__/__/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cuda/cuda_compile_1_generated_add3s2_cuda.cu.o
libadd3s2.so: CMakeFiles/add3s2.dir/build.make
libadd3s2.so: /local/spack/linux-centos8-zen/gcc-8.5.0/gcc-11.3.0-lsrw3b6dbtevo63ogo6xhqdwcofcliio/lib64/libgomp.so
libadd3s2.so: /lib64/libpthread.so
libadd3s2.so: /usr/local/cuda/lib64/libcudart_static.a
libadd3s2.so: /usr/lib64/librt.so
libadd3s2.so: CMakeFiles/add3s2.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX shared library libadd3s2.so"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/add3s2.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/add3s2.dir/build: libadd3s2.so
.PHONY : CMakeFiles/add3s2.dir/build

CMakeFiles/add3s2.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/add3s2.dir/cmake_clean.cmake
.PHONY : CMakeFiles/add3s2.dir/clean

CMakeFiles/add3s2.dir/depend: CMakeFiles/cuda_compile_1.dir/__/__/__/__/__/__/__/__/__/__/__/scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/src/cuda/cuda_compile_1_generated_add3s2_cuda.cu.o
	cd /scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /afs/pdc.kth.se/home/m/mansande/.local/lib/python3.9/site-packages/dace/codegen /afs/pdc.kth.se/home/m/mansande/.local/lib/python3.9/site-packages/dace/codegen /scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/build /scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/build /scratch/mansande/Plasma-PEPSC/neko/bench/nekobench/dace_wrapper/math/.dacecache/add3s2/build/CMakeFiles/add3s2.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/add3s2.dir/depend

