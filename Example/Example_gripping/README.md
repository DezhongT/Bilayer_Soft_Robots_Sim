1. Set additional environment variable
   ```bash
   export LD_LIBRARY_PATH=/opt/intel/oneapi/mkl/2025.0/lib/intel64:/opt/intel/oneapi/compiler/2025.0/lib/:$LD_LIBRARY_PATH
   ```

2. Configure the simulation engine
   ```bash
   mkdir build && cd build
   cmake ..
   make -j4
   cd ..
   ```

3. To simulate the bilayer robot with customized setting parameters, run
   ```bash
   ./simDER ./option.txt
   ```
