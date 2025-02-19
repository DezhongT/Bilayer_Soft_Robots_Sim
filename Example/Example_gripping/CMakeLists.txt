cmake_minimum_required(VERSION 3.11)
project(soft_robot)

set(CMAKE_CXX_STANDARD 17)

# Set build type
set(CMAKE_BUILD_TYPE Release)  # Change to Debug if needed

# Compiler flags for optimization
set(CMAKE_CXX_FLAGS "-Ofast -DNDEBUG -Wno-deprecated-declarations -fopenmp")
include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-march=native" COMPILER_SUPPORTS_MARCH_NATIVE)
if(COMPILER_SUPPORTS_MARCH_NATIVE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=native")
endif()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "../")

set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)

set(THREADS_PREFER_PTHREAD_FLAG ON)

# Define Eigen and MKL settings
set(MKL_INTERFACE_FULL intel_lp64)
add_definitions(-DEIGEN_USE_MKL_ALL)

# Find required dependencies
find_package(SymEngine REQUIRED)
find_package(GLUT REQUIRED)
find_package(OpenGL REQUIRED)
find_package(MKL CONFIG REQUIRED)
find_package(LAPACK REQUIRED)
find_package(BLAS REQUIRED)
find_package(Threads REQUIRED)
find_package(Eigen3 3.4 REQUIRED)
find_package(OpenMP REQUIRED)

# Set include directories
include_directories(
    ${SYMENGINE_INCLUDE_DIRS}
    /usr/include/eigen3/   # Eigen path from apt
    /opt/intel/oneapi/mkl/2025.0/include/  # MKL headers
    ${OPENGL_INCLUDE_DIRS}
    ${GLUT_INCLUDE_DIRS}
)

# Set library directories
link_directories(
    /opt/intel/oneapi/mkl/2025.0/lib
    /opt/intel/oneapi/compiler/2025.0/lib
)

# Define the executable and include all source files from src/
add_executable(simDER
    src/main.cpp
    src/world.cpp
    src/setInput.cpp
    src/timeStepper.cpp
    src/inertialForce.cpp
    src/externalGravityForce.cpp
    src/dampingForce.cpp
    src/elasticStretchingForce.cpp
    src/elasticBendingForce.cpp
    src/elasticTwistingForce.cpp
    src/elasticPlate.cpp
    src/elasticStretchingBound.cpp
    src/elasticAngleBound.cpp
    src/elasticBendingBound.cpp
    src/elasticTwistingBound.cpp
    src/externalContactForceBody.cpp
)

# Include directories for the target
target_include_directories(simDER PRIVATE src)

# Link necessary libraries
target_link_libraries(simDER PRIVATE
    ${OPENGL_LIBRARIES}
    ${GLUT_LIBRARIES}
    MKL::MKL
    Eigen3::Eigen
    ${LAPACK_LIBRARIES}
    ${BLAS_LIBRARIES}
    lapack
    Threads::Threads
    m
    ${SYMENGINE_LIBRARIES}
)

# Link OpenMP if found
if (OpenMP_CXX_FOUND)
    target_link_libraries(simDER PUBLIC OpenMP::OpenMP_CXX)
endif()
