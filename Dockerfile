FROM node:15-buster

RUN apt update \
  && apt upgrade -y

ENTRYPOINT ["bash"]
