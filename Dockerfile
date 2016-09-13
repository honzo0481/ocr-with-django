FROM python:3.5

ENV PYTHONBUFFERED 1
ENV TESSDATA_PREFIX /usr/local/share/tessdata

# build tesseract from source
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
  && ldconfig \
  && cd /

RUN git clone https://github.com/tesseract-ocr/tessdata.git \
  && cd tessdata \
  && mv * /usr/local/share/tessdata

WORKDIR /code

COPY ./requirements.txt /code
# installing from requirements.txt fails on Cython for some reason.
# so we install it separately.
RUN pip install Cython==0.24.1
RUN pip install -r requirements.txt
