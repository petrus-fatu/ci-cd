FROM python:3.6

# update python-dev
RUN apt update && apt install python-dev -y

# App source-code directory
RUN mkdir -p /opt/python/app

# Set Home Directory
WORKDIR /opt/python/app

# Install python dependencies
COPY app/requirements.txt /opt/python/app
RUN pip install --no-cache-dir -r requirements.txt

# Copy src code to Container
COPY app/ /opt/python/app

# Expose ports
EXPOSE 8080

# Set persistent data
VOLUME ["/app-data"]

# Run python app
ENTRYPOINT ["gunicorn", "-b", "0.0.0.0:8080", "--access-logfile", "-", "--error-logfile", "-"]
CMD ["app:app"]