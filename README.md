# A Virtual Playground for the Bilayer Soft Robotics

### [Paper](https://arxiv.org/abs/2502.00714) | [Video](https://github.com/DezhongT/Bilayer_Soft_Robots_Sim/blob/main/assets/videos/demo.mp4)

## Overview

This study introduces a novel simulation framework based on the Discrete Elastic Rod (DER) model to accurately capture the dynamic behavior of bilayer soft robots, particularly in contact interactions. By leveraging discrete differential geometry, the approach enables efficient modeling of complex deformations, facilitating the design and control of advanced soft robotic systems.

<div align="center">
  <img src="assets/videos/demo.gif" alt="Bilayer robot">
</div>

## Prerequisites

- [Ubuntu 18.04 or above](https://ubuntu.com/tutorials/install-ubuntu-desktop#1-overview)
- C++ dependencies

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/DezhongT/Bilayer_Soft_Robots_Sim.git
   cd Bilayer_Soft_Robots_Sim
   ```
   
2. Install C++ dependencies

- **Note**: Some of these packages are installed to the system library for convenience. You may want to install locally to e.g., `~/.local` to avoid conflicts with system libraries. Add the `cmake` flag: `-D CMAKE_INSTALL_PREFIX=~/.local`. Then `sudo` is not required to install. You'll need to ensure subsequent builds know where to find the build libraries.
- Update the package list:
  ```bash
  sudo apt update
  ```
    
- [Eigen 3.4.0](http://eigen.tuxfamily.org/index.php?title=Main_Page)
  - Eigen is a C++ template library for linear algebra.
  - Install via APT:
    ```bash
    sudo apt update
    sudo apt install libeigen3-dev
    ```
  - (Optional) Verify installation
    ```bash
    dpkg -s libeigen3-dev | grep Version
    ```

- [LLVM](https://releases.llvm.org/download.html)
  - LLVM is a collection of tools for building compilers and optimizing code.
  - Install via APT:
    ```bash
    sudo apt-get install llvm
    ```
  - (Optional) Verify installation
    ```bash
    llvm-config --version
    ```
    
- [GMP](https://gmplib.org/)
  - GMP is a free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating-point numbers.
  - Install via APT:
    ```bash
    sudo apt install libgmp-dev
    ```
  - (Optional) Verify installation
    ```bash
    dpkg -l | grep libgmp
    ```
  
- [SymEngine](https://github.com/symengine/symengine)
  - SymEngine is used for symbolic differentiation and function generation.
  - Install from source:
    ```bash
    git clone https://github.com/symengine/symengine
    cd symengine && mkdir build && cd build
    cmake -D WITH_LLVM=on -D BUILD_BENCHMARKS=off -D BUILD_TESTS=off ..
    make -j4
    sudo make install
    ```

- [Intel oneAPI Math Kernel Library (oneMKL)](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl-download.html?operatingsystem=linux&distributions=webdownload&options=online)
  - Necessary for access to Pardiso, which is used as a sparse matrix solver.
  - Intel MKL is also used as the BLAS / LAPACK backend for Eigen.
  - Install via APT following the [official instruction](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl-download.html?operatingsystem=linux&linux-install=apt) Be sure to walk through both "Prerequisites for First-Time Users" and "Install with APT".
  - Check the installation version:
    By default, the installation directory path should be at `/opt/intel/oneapi/mkl`.
    Look for the folder named `mkl`, for example `/opt/intel/oneapi/mkl/2025.0`.
  - Set the MKL environment variable:
    ```bash
    export MKL_DIR=/opt/intel/oneapi/mkl/2025.0     # for newer versions
    ```
  - Add the above corresponding environment variable to your `.bashrc` file.
    ```bash
    nano ~/.bashrc
    ```
  - Reload the `.bashrc` file to apply the changes:
    ```bash
    source ~/.bashrc
    ```
  - (Optional) Verify the MKL installation:
    ```bash
    echo $MKL_DIR
    ```

- [OpenGL / GLUT](https://www.opengl.org/)
  - OpenGL / GLUT is used for rendering the knot through a simple graphic.
  - Install via APT
    ```bash
    sudo apt-get install libglu1-mesa-dev freeglut3-dev mesa-common-dev`
    ```

- [Lapack](https://www.netlib.org/lapack/) (*included in MKL*)

3. Configure the simulation engine
   ```bash
   mkdir build && cd build
   cmake ..
   make -j4
   cd ..
   ```

4. To simulate the bilayer robot with customized setting parameters, run
   ```bash
   ./simDER ./option.txt
   ```
   The parameters are specified in the ```option.txt``` with specifications as follows (SI units):
   - ```render (0 or 1) ```- Flag indicating whether OpenGL visualization should be rendered.
   - ```saveData (0 or 1)``` - Flag indicating whether positions should be recorded.
   - ```YoungM``` - Young's modulus.
   - ```totalTime``` - Total simulation time.
   - ```deltaTime``` - Time step size.
   - ```rodRadius``` - Cross-sectional radius of the beam.
   - ```density``` - Material density.
   - ```stol``` - A small number used in solving the linear system.
   - ```forceTol``` - Force tolerance.
   - ```maxIter``` - Maximum iteration.
   - ```viscosity``` - Viscosity.
   - ```scaleRendering``` - Dimension scale of rendering.
   - ```gVector``` - Gravitational vector.
   - ```Possion``` - Possion ratio.

   The simulation data of robot configuration will be saved to `datafiles/` directory, with each column in the file corresponding to `x`, `y`, `z`.

### Citation
If our work has helped your research, please cite the following paper.
```
@article{li2025harnessing,
  title={Harnessing Discrete Differential Geometry: A Virtual Playground for the Bilayer Soft Robotics},
  author={Li, Jiahao and Tong, Dezhong and Hao, Zhuonan and Zhu, Yinbo and Wu, Hengan and Liu, Mingchao and Huang, Weicheng},
  journal={arXiv preprint arXiv:2502.00714},
  year={2025}
}
```
