#!/bin/bash
set -e

# Restore the database from the dump file
echo "Restoring dvdrental database from dump file..."
pg_restore -U "$POSTGRES_USER" --no-owner -d dvdrental /sql/dvdrental.tar

echo "Database dvdrental restored successfully."