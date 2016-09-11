FROM python:3.5

ENV PYTHONBUFFERED 1

# the debian:jessie repos only have tesseract v3.03. we need 3.04
# so we build from source.
RUN apt-get update && apt-get install -y \
  libicu-dev \
  libpango1.0-dev \
  libleptonica-dev

RUN git clone https://github.com/tesseract-ocr/tesseract.git \
  && cd tesseract \
  && ./autogen.sh \
  && ./configure \
  && make \
  && make install \
  && ldconfig

WORKDIR /code

COPY ./requirements.txt /code
RUN pip install Cython==0.24.1
RUN pip install -r requirements.txt
