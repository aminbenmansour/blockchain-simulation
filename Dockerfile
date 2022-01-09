FROM python:3.10

WORKDIR /blockchain

COPY requirements.txt /blockchain/requirements.txt
RUN pip3 install -r requirements.txt

COPY . /blockchain

EXPOSE 5000

CMD python blockchain.py
