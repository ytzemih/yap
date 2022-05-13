FROM ubuntu:kinetic-20220428

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    wget \
    git \
    zip \
    # Java
    default-jre-headless \
    openjdk-17-jdk-headless \
    maven \
    jarwrapper \
    # C++ build tools
    build-essential \
    ninja-build \
    libc++-dev \
    libc++abi-dev \
    # Yap dependencies
    python3 \
    python3-pip \
    graphviz \
    texlive-extra-utils \
    && pip install matplotlib pandas cmake \
    && mkdir -p /usr/lib/jvm/java-14-openjdk-amd64/bin/
    
RUN ln -s  /usr/lib/jvm/java-17-openjdk-amd64/bin/java /usr/lib/jvm/java-14-openjdk-amd64/bin/java

ENV YAP_VERSION=0.8.1+20220513-1
ENV LIBFSMTEST_VERSION=063004276aee20192fad4a9629bd36ca961f12aa
ENV PRISM_VERSION=v4.7
ENV EVOCHECKER_VERSION=v1.1

# Download and install Yap (and its dependencies)
RUN wget https://gleirscher.at/mg/yap/dl/yapp_${YAP_VERSION}_all.deb \
    && dpkg -iG yapp_${YAP_VERSION}_all.deb \
    && rm yapp_${YAP_VERSION}_all.deb

# Download and build the libfsmtest
RUN mkdir -p /opt \
    && cd /opt \
    && git clone https://bitbucket.org/JanPeleska/libfsmtest.git \
    && cd libfsmtest/ \
    && git checkout ${LIBFSMTEST_VERSION}

RUN cd /opt/libfsmtest/ \
    && cmake -B build -S src -GNinja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=true -DCMAKE_CXX_FLAGS=-fPIC  \
    && cd build \
    && ninja \
    && cp libfsmtest/libfsmtest.so /usr/lib

# Download and build PRISM
RUN cd /opt \
    && git clone --depth 1 --branch ${PRISM_VERSION} https://github.com/prismmodelchecker/prism.git \
    && cd prism/prism/ \
    && make \
    && cd .. \
    && ln -s /opt/prism/prism/bin /opt/prism/ \
    && ./prism/install.sh 

# Download and build EvoChecker
RUN cd /opt \
    && git clone --depth 1 --branch ${EVOCHECKER_VERSION} https://github.com/gerasimou/EvoChecker.git \
    && cd EvoChecker \
    && mvn package \
    && cp target/*.jar .

VOLUME [ "/root/files" ]

RUN mkdir -p /root/files \
    && cd /root/files \
    && cp -r /usr/share/yapp/examples/ yap-examples/ \
    && ln -s /opt/prism/prism/lib /opt/prism
WORKDIR /root/files

CMD ./run_hrc2.sh