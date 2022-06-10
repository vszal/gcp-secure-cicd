# multi-stage build
FROM python:3.9-slim as build
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
build-essential gcc 
# install dependencies in a venv

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the virtualenv into a distroless image (use :debug-nonroot for tools)
FROM gcr.io/distroless/python3:nonroot

COPY --chown=nonroot:nonroot --from=build /opt/venv /opt/venv
COPY --chown=nonroot:nonroot . /home/nonroot
# gunicorn needs this path
ENV PYTHONPATH=/opt/venv/lib/python3.9/site-packages
#ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /opt/venv/bin
# Service must listen to $PORT environment variable.
ENV PORT 8080
ENV GUNICORN_CMD_ARGS="--workers 2 --threads 2 -b 0.0.0.0:8080 --chdir /home/nonroot"
# Run the web service on container startup.
CMD ["gunicorn",  "app:app"]