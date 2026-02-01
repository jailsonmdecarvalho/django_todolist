#!/bin/bash

# Run Django migrations
python todolist_project/manage.py migrate

# Execute the main command (gunicorn)
exec "$@"