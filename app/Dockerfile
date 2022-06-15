FROM python:3.10-alpine as build
RUN apk --update add gcc build-base linux-headers

# create venv
RUN python -m venv /usr/app/venv
# install deps
COPY requirements.txt .
RUN /usr/app/venv/bin/pip install -r requirements.txt

FROM alpine
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 py3-gunicorn sudo && ln -sf python3 /usr/bin/python

# add new user
ARG USER=nonroot
ENV HOME=/home/$USER

RUN addgroup --system --gid 2999 $USER && \
    adduser --system --home $HOME --uid 2999 $USER $USER && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER && \
    chmod 0440 /etc/sudoers.d/$USER

WORKDIR $HOME
# copy files and python deps
COPY --from=build /usr/app/venv $HOME/venv
COPY --chown=nonroot:nonroot . .
RUN sudo chown -R $USER:$USER $HOME

# for prod, remove busybox (comment out to debug)
RUN apk del sudo
RUN rm -rf /bin/busybox

# change user context to nonroot
USER 2999
# needed for gunicorn
ENV PYTHONPATH=/home/nonroot/venv/lib/python3.10/site-packages
ENV GUNICORN_CMD_ARGS="--workers 2 --threads 2 -b 0.0.0.0:8080 --chdir $HOME"
# Run the web service on container startup.
CMD ["gunicorn",  "app:app"]