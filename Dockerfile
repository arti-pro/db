# Use the official PostgreSQL image from Docker Hub
FROM postgres:latest


# Copy the initialization script to the /docker-entrypoint-initdb.d directory
# This will automatically execute when the container starts up
# for creating required databases at start of container
COPY 01-init-database.sh /docker-entrypoint-initdb.d/

# Expose port 5432
EXPOSE 5432
