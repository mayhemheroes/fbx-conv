FROM --platform=linux/amd64 ubuntu:20.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y g++ make wget tar

RUN wget -O premake5.tar.gz https://github.com/premake/premake-core/releases/download/v5.0.0-alpha14/premake-5.0.0-alpha14-linux.tar.gz
RUN tar -xf premake5.tar.gz
ENV PATH=$PATH:/
RUN wget http://download.autodesk.com/us/fbx/2019/2019.0/fbx20190_fbxsdk_linux.tar.gz
RUN tar -xf fbx20190_fbxsdk_linux.tar.gz
RUN chmod +x fbx20190_fbxsdk_linux
RUN mkdir fbx-sdk-linux
RUN yes yes | ./fbx20190_fbxsdk_linux fbx-sdk-linux
ENV FBX_SDK_ROOT=/fbx-sdk-linux
ENV LD_LIBRARY_PATH=/fbx-sdk-linux/lib/gcc4/x64/release
RUN ldconfig
ADD . /repo
WORKDIR /repo
RUN ./generate_makefile
WORKDIR /repo/build/gmake/
RUN make