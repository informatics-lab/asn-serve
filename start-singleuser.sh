#!/bin/bash
set -e

# pull examples notebooks
if cd /usr/local/share/notebooks/Example\ Notebooks; then git pull && cd ..; else git clone https://github.com/met-office-lab/example-notebooks.git /usr/local/share/notebooks/Example\ Notebooks; fi

# start single user server
notebook_arg=""
if [ -n "${NOTEBOOK_DIR:+x}" ]
then
    notebook_arg="--notebook-dir=${NOTEBOOK_DIR}"
fi

mkdir -p /usr/local/share/notebooks/data/mogreps
s3fs mogreps /usr/local/share/notebooks/data/mogreps -o iam_role=jade-secrets


if [ $DEPLO_ENV = "local" ]; then
    exec jupyter notebook
else
    exec jupyterhub-singleuser \
      --port=8888 \
      --ip=0.0.0.0 \
      --user=$JPY_USER \
      --cookie-name=$JPY_COOKIE_NAME \
      --base-url=$JPY_BASE_URL \
      --hub-prefix=$JPY_HUB_PREFIX \
      --hub-api-url=$JPY_HUB_API_URL \
      ${notebook_arg} \
      $@
fi