FROM python:3.9-alpine as build

RUN apk add git
RUN git clone --depth 1 https://github.com/BYVoid/OpenCC /src
WORKDIR /src

RUN apk add make cmake g++ doxygen
RUN make -j6 python-dist

WORKDIR /src/dist
RUN mv $(ls) $(ls | sed 's,manylinux1,linux,g')

###

FROM python:3.9-alpine
COPY --from=build /src/dist/*.whl /tmp/
RUN apk add --no-cache libstdc++ && pip install --no-cache-dir /tmp/*.whl flask

WORKDIR /app
COPY main.py .

# ENTRYPOINT [ "/bin/sh" ]
ENTRYPOINT [ "python3", "main.py" ]
EXPOSE 80