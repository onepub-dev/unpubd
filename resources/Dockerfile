# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.12)
#FROM dart:stable AS build
# FROM ubuntu:21.04 AS build
FROM google/dart as build

RUN mkdir /src
WORKDIR /src
RUN git clone https://github.com/bsutton/unpubd.git


ENV TZ=${TZ} 
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone RUN dpkg-reconfigure -f noninteractive tzdata

WORKDIR /src/unpubd

RUN dart pub get
RUN dart compile exe /src/unpubd/bin/unpubd.dart -o /unpubd


# Build minimal  image from AOT-compiled `/batman`
FROM build

COPY --from=build /unpubd /unpubd
WORKDIR /



ENV MONGO_INITDB_ROOT_USERNAME=${MONGO_INITDB_ROOT_USERNAME}
ENV MONGO_INITDB_ROOT_PASSWORD=${MONGO_INITDB_ROOT_PASSWORD}
ENV MONGO_INITDB_DATABASE=${MONGO_INITDB_DATABASE}
ENV UNPUBD_PORT=${UNPUBD_PORT}

EXPOSE ${UNPUBD_PORT}

#ENTRYPOINT ["/unpub", "--database", "mongodb+srv://${MONGO_INITDB_ROOT_USERNAME}:${MONGO_INITDB_ROOT_PASSWORD}@mongodb:27017/dart_pub", "--host", "0.0.0.0", "--port", "4000"]

ENTRYPOINT /unpubd 
