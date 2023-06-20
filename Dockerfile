FROM python:3.10-alpine
LABEL maintainer="Stefan Padureanu"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /requirements.txt && \
    rm -rf /requirements.txt && \
    apk del .tmp-build-deps
    
RUN adduser -D django-user

ENV PATH="/py/bin:$PATH"

USER django-user
