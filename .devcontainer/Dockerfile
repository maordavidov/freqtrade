FROM python:3.9.2-slim-buster as base

# Setup env
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1
ENV PATH=/root/.local/bin:$PATH

# Prepare environment
RUN mkdir /freqtrade
WORKDIR /freqtrade

# Install dependencies
FROM base as python-deps
RUN apt-get update \
    && apt-get -y install curl build-essential libssl-dev git \
    && apt-get clean \
    && pip install --upgrade pip

# Install TA-lib
COPY build_helpers/* /tmp/
RUN cd /tmp && /tmp/install_ta-lib.sh && rm -r /tmp/*ta-lib*
ENV LD_LIBRARY_PATH /usr/local/lib

# Install dependencies
COPY requirements.txt requirements-hyperopt.txt /freqtrade/
RUN  pip install --user --no-cache-dir numpy \
  && pip install --user --no-cache-dir -r requirements-hyperopt.txt

# Copy dependencies to runtime-image
FROM base as runtime-image
COPY --from=python-deps /usr/local/lib /usr/local/lib
ENV LD_LIBRARY_PATH /usr/local/lib

COPY --from=python-deps /root/.local /root/.local

# Install dependencies
COPY requirements* /freqtrade/
COPY docs/requirements-docs.txt /freqtrade/docs/

RUN apt-get update \ 
    && apt-get -y install git mercurial sudo vim \
    && apt-get clean 

WORKDIR /freqtrade

RUN  pip install autopep8 -r docs/requirements-docs.txt -r requirements-dev.txt --no-cache-dir \
    && useradd -u 1000 -U -m ftuser \
    && mkdir -p /home/ftuser/.vscode-server /home/ftuser/.vscode-server-insiders /home/ftuser/commandhistory \
    && echo "export PROMPT_COMMAND='history -a'" >> /home/ftuser/.bashrc \
    && echo "export HISTFILE=~/commandhistory/.bash_history" >> /home/ftuser/.bashrc \
    && mv /root/.local /home/ftuser/.local/ \
    && chown ftuser:ftuser -R /home/ftuser/.local/ \
    && chown ftuser: -R /home/ftuser/

USER ftuser

# Empty the ENTRYPOINT to allow all commands
ENTRYPOINT []
