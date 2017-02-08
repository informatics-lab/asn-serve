FROM quay.io/informaticslab/asn-extensions:v1.0.0

# Mount s3 bucket for data
RUN apt-get update -y && apt-get install -y automake autotools-dev g++ git libcurl4-gnutls-dev libfuse-dev libssl-dev libxml2-dev make pkg-config

WORKDIR /root
RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git

WORKDIR /root/s3fs-fuse
RUN ./autogen.sh && ./configure && make && make install

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
ADD ipython_kernel_config.py /root/.ipython/

RUN mkdir -p /usr/local/share/notebooks
WORKDIR /usr/local/share/notebooks

RUN echo "#!/usr/bin/env python3\nfrom jupyterhub.singleuser import main\nimport logging\nif __name__ == '__main__':\n    logging.basicConfig(level=logging.DEBUG)\n    main()" > /usr/local/bin/jupyterhub-singleuser

EXPOSE 8888
CMD /srv/singleuser/singleuser.sh
