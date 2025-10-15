FROM python:3.12.12-slim

RUN apt-get update \
 && apt-get install jq -y \
 && apt-get autoremove -y \
 && apt-get install coreutils -y \
 && apt-get -q install -y gosu graphviz graphviz-dev cmake pkg-config libcairo2-dev \
 && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /requirements.txt

RUN pip install -r /requirements.txt

COPY . /opt/test-runner

WORKDIR /opt/test-runner

RUN chmod +x /opt/test-runner/entrypoint.sh

ENTRYPOINT [ "/opt/test-runner/entrypoint.sh" ]
