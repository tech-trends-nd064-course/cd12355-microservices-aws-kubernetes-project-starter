FROM python:3.10-slim-buster

# Update the local package index with the latest packages from the repositories
RUN apt update -y

# Install a couple of packages to successfully install postgresql server locally
RUN apt install build-essential libpq-dev -y

# Update python modules to successfully build the required modules
RUN pip install --upgrade pip setuptools wheel

ENV DB_USERNAME=myuser
ENV DB_PASSWORD=${POSTGRES_PASSWORD}
ENV DB_HOST=127.0.0.1
ENV DB_PORT=5433
ENV DB_NAME=mydatabase

# Set the working directory inside the container
WORKDIR /app

# Copy the app.py file into the container
#COPY app.py /app/
COPY . /app

# Install any dependencies (if required)
COPY requirements.txt /app/
RUN pip install -r requirements.txt

# Command to run your app
CMD ["python", "app.py"]

#COPY app.py /app/app.py
#CMD ["python", "/app.py", "--host", "0.0.0.0", "--port", "5153"]