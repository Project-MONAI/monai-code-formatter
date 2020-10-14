FROM python:3.8

RUN apt-get update && apt-get install -y git jq
RUN pip install black

# COPY LICENSE README.md /

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
