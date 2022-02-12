# cf. https://github.com/NVIDIA-AI-IOT/deepstream_python_apps/blob/master/bindings/README.md
FROM nvcr.io/nvidia/deepstream:6.0-triton
# for gst-python submodule
ENV GIT_SSL_NO_VERIFY=1

RUN apt-get update
# Ubuntu - 20.04 [use python-3.8, python-3.6 will not work]
RUN apt-get install -y --no-install-recommends \
    python3-gi python3-dev python3-gst-1.0 python-gi-dev git python-dev \
    python3 python3-pip python3.8-dev cmake g++ build-essential libglib2.0-dev \
    libglib2.0-dev-bin python-gi-dev libtool m4 autoconf automake

RUN python3 -m pip install --upgrade pip
# extracted from docker_python_setup.sh
RUN pip3 install numpy opencv-python

WORKDIR /opt/nvidia/deepstream/deepstream-6.0
RUN cd sources && \
    git clone --recursive https://github.com/NVIDIA-AI-IOT/deepstream_python_apps.git
# Installing Gst-python
RUN cd sources/deepstream_python_apps/3rdparty/gst-python && \
    ./autogen.sh && \
    make && \
    make install
# Quick build (x86-ubuntu-20.04 | python 3.8 | Deepstream 6.0)
RUN cd sources/deepstream_python_apps/bindings && \
    mkdir build && \
    cd build && \
    cmake .. -DPYTHON_MAJOR_VERSION=3 -DPYTHON_MINOR_VERSION=8 && \
    make -j$(NPROC) && \
    pip3 install ./pyds-1.1.0-py3-none*.whl
