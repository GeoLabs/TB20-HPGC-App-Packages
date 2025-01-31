FROM geoedf/framework

COPY ./GeoEDF /extractinundationcensustracts/GeoEDF
COPY ./setup.py /extractinundationcensustracts/setup.py

RUN apt-get update && \
    apt-get install -y unzip 

RUN cd /extractinundationcensustracts && \
    pip3 install .

RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate geoedf" >> ~/.bashrc

ENV PATH="/opt/conda/envs/geoedf/bin:${PATH}"
COPY ./main_multi_scenarios.py /app.py

