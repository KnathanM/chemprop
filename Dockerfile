# Dockerfile
#
# Builds a Docker image containing Chemprop and its required dependencies.
#
# Build this image with:
#  git clone https://github.com/chemporp/chemporp.git
#  cd chemporp
#  docker build --tag=chemporp:latest .
#
# Run the built image with:
#  docker run --name chemporp_container -it chemporp:latest
#
# Note:
# This image only runs on CPU - we do not provide a Dockerfile
# for GPU use (see installation documentation). 

# Parent Image
FROM continuumio/miniconda3:latest

# Install libxrender1 (required by RDKit) and then clean up
RUN apt-get update && \
    apt-get install -y \
    libxrender1 && \
    apt-get autoremove -y && \
    apt-get clean -y

WORKDIR /opt/chemporp

# build an empty conda environment with appropriate Python version
RUN conda create --name chemporp_env python=3.11*

# This runs all subsequent commands inside the chemporp_env conda environment
#
# Analogous to just activating the environment, which we can't actually do here
# since that requires running conda init and restarting the shell (not possible
# in a Dockerfile build script)
SHELL ["conda", "run", "--no-capture-output", "-n", "chemporp_env", "/bin/bash", "-c"]

# Follow the installation instructions then clear the cache
ADD chemporp chemporp
ENV PYTHONPATH /opt/chemporp
ADD LICENSE.txt pyproject.toml README.md ./
RUN conda install pytorch cpuonly -c pytorch && \
    conda clean --all --yes && \
    python -m pip install . && \
    python -m pip cache purge

# when running this image, open an interactive bash terminal inside the conda environment
RUN echo "conda activate chemporp_env" > ~/.bashrc
ENTRYPOINT ["/bin/bash", "--login"]
