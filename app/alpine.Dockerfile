# multi-stage build
FROM python:3.10-alpine as build
RUN apk --update add gcc build-base linux-headers
#RUN apk add --no-cache --virtual .build-deps gcc musl-dev linux-headers \
#     && pip install cython \
#     && apk del .build-deps gcc musl-dev
# install dependencies in a venv
WORKDIR /usr/app
RUN python -m venv /usr/app/venv
ENV PATH="/usr/app/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install -r requirements.txt

# deterministic image reference
FROM python:3.10-alpine

ARG USER=nonroot
ENV HOME /home/$USER

# install sudo as root
RUN apk add --update sudo
RUN apk add --no-cache bash

# add new user
RUN addgroup --system --gid 2999 $USER && \
    adduser --system --home $HOME --uid 2999 $USER $USER && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER && \
    chmod 0440 /etc/sudoers.d/$USER

USER 2999
WORKDIR $HOME

# copy in venv fromb build and app source files
COPY --from=build /usr/app/venv $HOME/venv
COPY --chown=nonroot:nonroot . .
RUN sudo chown -R $USER:$USER $HOME

# add venv to the path
ENV PATH="$HOME/venv/bin:$PATH"
ENV PORT 8080
ENV GUNICORN_CMD_ARGS="--workers 2 --threads 2 -b 0.0.0.0:8080 --chdir $HOME"
# Run the web service on container startup.
CMD ["gunicorn", "app:app"]