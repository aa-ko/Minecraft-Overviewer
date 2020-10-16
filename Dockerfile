# Build Minecraft-Overviewer from source
FROM ubuntu:xenial-20200916 AS build

RUN apt-get update
RUN apt-get -y install git build-essential python3 python3-pil python3-dev python3-numpy
RUN mkdir /overviewer
WORKDIR /overviewer
RUN git clone https://github.com/overviewer/Minecraft-Overviewer.git /overviewer
RUN python3 setup.py build

# Mount world directory from host read-only
VOLUME /world
# Mount tmpfs for caching render artifacts
VOLUME /cache
# Mount target directory (web-server root) from host with write permissions
#VOLUME /target
# (Optionally) mount config file
#VOLUME /config

# Copy renderer script
FROM python:3.9.0-alpine3.12

#COPY --from=build /build /overviewer
COPY render.py /overviewer
COPY docker-requirements.txt /overviewer
WORKDIR /overviewer
RUN pip install -r docker-requirements.txt

CMD ["python", "./render.py"]