FROM cld1994/dev-env:latest

ENV ESP_HOME /root/esp

WORKDIR $ESP_HOME

ENV PATH=$ESP_HOME/xtensa-esp32-elf/bin:$PATH \
	ADF_PATH=$ESP_HOME/esp-adf \
	IDF_PATH=$ESP_HOME/esp-adf/esp-idf

RUN apt-get update \
	&& apt-get install -y \
		python2.7 \
		gcc \
		git \
		wget \
		make \
		libncurses-dev \
		flex \
		bison \
		gperf \
	&& ln -s /usr/bin/python2.7 /usr/local/bin/python \
	&& curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
	&& python get-pip.py && rm get-pip.py \
	&& pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple/ \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -fsSLO --compressed "https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz" \
	&& tar -xzf xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz \
	&& rm xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz

RUN git clone --recursive https://github.com/espressif/esp-adf.git

ARG ADF_VERSION=v1.0-22-g40c38ef
ARG IDF_VERSION=v3.3-beta1-4-g23b6d40c5

WORKDIR $ADF_PATH
RUN git checkout -f $ADF_VERSION && git submodule update -f --init --recursive

WORKDIR $IDF_PATH
RUN git checkout -f $IDF_VERSION && git submodule update -f --init --recursive

RUN python -m pip install --user -r $IDF_PATH/requirements.txt

WORKDIR $ESP_HOME

CMD [ "fish" ]

