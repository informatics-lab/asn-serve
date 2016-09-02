FROM quay.io/informaticslab/asn-extensions

# Add Tini
ENV TINI_VERSION v0.10.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Setup the JupyterHub single user entrypoint
RUN pip --no-cache-dir install 'jupyterhub==0.5'

RUN wget -q https://raw.githubusercontent.com/jupyter/jupyterhub/master/scripts/jupyterhub-singleuser -O /usr/local/bin/jupyterhub-singleuser && \
    chmod 755 /usr/local/bin/jupyterhub-singleuser && \
    mkdir -p /srv/singleuser/
ADD start-singleuser.sh /srv/singleuser/singleuser.sh 
RUN chmod 755 /srv/singleuser/singleuser.sh

RUN jupyter notebook --generate-config
ADD jupyter_notebook_config.py /root/.jupyter/

RUN mkdir -p /usr/local/share/notebooks
WORKDIR /usr/local/share/notebooks

RUN echo "#!/usr/bin/env python3\nfrom jupyterhub.singleuser import main\nimport logging\nif __name__ == '__main__':\n    logging.basicConfig(level=logging.DEBUG)\n    main()" > /usr/local/bin/jupyterhub-singleuser

EXPOSE 8888
CMD /srv/singleuser/singleuser.sh