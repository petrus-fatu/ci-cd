FROM python:3.6

# App source-code directory
RUN mkdir -p /usr/src/app

# Set Home Directory
WORKDIR /opt/python/app

# Install python dependencies
COPY requirements.txt /opt/python/app
RUN pip install --no-cache-dir -r requirements.txt

# Copy src code to Container
COPY . /opt/python/app

# Env variables
ENV PORT 8080

# Expose ports
EXPOSE $PORT

# Set persistent data
VOLUME ["/app-data"]

# Run python app
CMD gunicorn -b :$PORT -c gunicorn.conf.py main:app