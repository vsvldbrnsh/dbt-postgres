##
#  Generic dockerfile for dbt image building.
#  See README for operational details
##

# Top level build args
ARG build_for=linux/amd64

##
# base image (abstract)
##
# Please do not upgrade beyond python3.10.7 currently as dbt-spark does not support
# 3.11py and images do not get made properly
FROM --platform=$build_for python:3.10.7-slim-bullseye as base

# N.B. The refs updated automagically every release via bumpversion
ARG dbt_core_ref=dbt-core@v1.8.0a1
ARG dbt_postgres_ref=dbt-postgres@v1.8.0a1

# System setup
RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends \
    git \
    ssh-client \
    vim \
    software-properties-common \
    make \
    build-essential \
    ca-certificates \
    libpq-dev \
  && apt-get clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

# Env vars
ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8

# Update python
RUN python -m pip install --upgrade pip setuptools wheel --no-cache-dir

##
# dbt-core
##
FROM base as dbt-core
RUN python -m pip install --no-cache-dir "git+https://github.com/dbt-labs/${dbt_core_ref}#egg=dbt-core&subdirectory=core"

##
# dbt-postgres
##
FROM base as dbt-postgres
#RUN python -m pip install --no-cache-dir "git+https://github.com/dbt-labs/${dbt_postgres_ref}#egg=dbt-postgres"
RUN python -m pip install dbt-postgres

# Set user and working directory
RUN mkdir -p /usr/app/dbt \
  && mkdir -p /home/dbtuser/.dbt \
  && useradd -m dbtuser \
  #Make sure dbtuser owns the working directory
  && chown -R dbtuser:dbtuser /usr/app/dbt

# Copy the profiles.yml file into the .dbt directory
COPY --chown=dbtuser:dbtuser profiles.yml /home/dbtuser/.dbt/profiles.yml

USER dbtuser
WORKDIR /usr/app/dbt/

# ENTRYPOINT ["dbt"]

# Check dbt version and PATH again
RUN echo $PATH && dbt --version

# CMD dbt deps && dbt build --profiles-dir profiles && sleep infinity
# CMD ["tail", "-f", "/dev/null"]
CMD sleep infinity
