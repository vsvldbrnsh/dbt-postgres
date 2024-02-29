# Use the official PostgreSQL image as the base
FROM postgres:latest

# Install unzip utility
USER root
RUN apt-get update \
    && apt-get install -y unzip procps vim\
    && rm -rf /var/lib/apt/lists/*

# Create a directory to store SQL scripts
RUN mkdir /sql

# Copy your SQL dump files into the container
COPY dvdrental.zip /sql/

# Unzip the dump file and find the tar file
RUN unzip /sql/dvdrental.zip -d /sql && \
    rm /sql/dvdrental.zip && \
    find /sql -name '*.tar' -exec mv {} /sql/dvdrental.tar \;

# Change ownership and permissions on the dump file
RUN chmod ugo+w /sql/dvdrental.tar && \
    chown postgres /sql/dvdrental.tar

# Set environment variables for database details
ENV POSTGRES_DB=dvdrental
ENV POSTGRES_USER=user1
ENV POSTGRES_PASSWORD=password

# You need to create 'init-dvdrental.sh' script for initializing the database
# Here is an example script content
COPY init-dvdrental.sh /docker-entrypoint-initdb.d/
RUN chmod u+x /docker-entrypoint-initdb.d/init-dvdrental.sh
