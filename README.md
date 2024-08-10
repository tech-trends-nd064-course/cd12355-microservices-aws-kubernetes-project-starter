# Coworking Space 
The Coworking Space Service is a set of APIs that enables users to request one-time tokens and administrators to authorize access to a coworking space. This service follows a microservice pattern and the APIs are split into distinct services that can be deployed and managed independently of one another.

For this project, you are a DevOps engineer who will be collaborating with a team that is building an API for business analysts. The API provides business analysts basic analytics data on user activity in the service. The application they provide you functions as expected locally and you are expected to help build a pipeline to deploy it in Kubernetes.

### Dependencies
You'll need a Python environment (3.6+), Docker CLI, `kubectl` for your local environment. For remote resources, you'll need AWS CodeBuild, AWS ECR, a Kubernetes environment with AWS EKS, AWS CloudWatch, and GitHub.

### Setup
#### 1. Install and Configure a Database

```bash
apt update
apt install postgresql postgresql-contrib
export DB_PASSWORD=mypassword
PGPASSWORD="$DB_PASSWORD" psql --host 127.0.0.1 -U myuser -d mydatabase -p 5433 < <FILE_NAME.sql>
```

## Apply YAML configurations Postgres database and verify the db connection

Go to db folder ad apply the yml file by running the following commands 

```bash
kubectl apply -f pvc.yaml
kubectl apply -f pv.yaml
kubectl apply -f postgresql-deployment.yaml
```

##  Connecting to postgresql via Port Forwarding 

Before you expose your database, you will need to create a service, and then expose it using port-forwarding approach.
```bash
kubectl port-forward --namespace default svc/<SERVICE_NAME>-postgresql 5432:5432 &
    PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432
```

## Run Seed Files
 Run the seed files in order to create the tables and populate them with data.

```bash
apt update
apt install postgresql postgresql-contrib
export DB_PASSWORD=mypassword
PGPASSWORD="$DB_PASSWORD" psql --host 127.0.0.1 -U myuser -d mydatabase -p 5433 < <FILE_NAME.sql>
```
## ### 2. Running the Analytics Application

Set these environment variables to run the application. They can be set for the session by running export KEY=VALUE in the command line

* export `DB_USERNAME`
* export `DB_PASSWORD`
* export `DB_HOST` (default: `127.0.0.1`)
* export `DB_PORT` (default: `5432`)
* export `DB_NAME` (default: `postgres`)

Run app.py:
```bash
python app.py
```
## Verifying The Application
* Generate report for check-ins grouped by dates
`curl <BASE_URL>/api/reports/daily_usage`

* Generate report for check-ins grouped by users
`curl <BASE_URL>/api/reports/user_visits`

# Deploy the Analytics Application

## Create a `Dockerfile` for the Python application.

1. Create a Dockerfile in `analytics/` folder.
2. Added instruction to the Dockerfile to run the python application.
3. For its FROM instruction, use Docker image with a Python version (prefer the slim version of the image).
4. Add a parameter -y to your apt commands.
5. Build and test your Docker image.

```bash
apt update
apt install docker-ce docker-ce-cli containerd.io
docker build -t test-coworking-analytics .
docker run --network="host" test-coworking-analytics
```

## Project Instructions

1. Create an Amazon ECR repository.
2. Write a simple build pipeline `buildspec.yaml` with AWS CodeBuild to build and push a Docker image into AWS ECR.
3. `buildspec.yaml` file that will be triggered whenever the project repository is updated.
   - pre-build: Set up Docker login with aws ecr get-login-password
   - Build the coworking analytics application using docker build
   - Tag the image with the docker tag command, and replace `$IMAGE_TAG` with `$CODEBUILD_BUILD_NUMBER`
   - post-build: Push the image to your Amazon ECR account with docker push
4. Add appropriate environment variables through your AWS console and Update the permission of the IAM role created by CodeBuild.
5. Update IAM role permissions for CodeBuild to access ECR.
6. Verify: click "Start Build" in CodeBuild console and check ECR for the Docker image.



## Deploy the Application.

1. **ConfigMap**: Create a ConfigMap for plaintext variables (DB_HOST, DB_USERNAME, DB_PORT, DB_NAME). 

2. **Secret**: Store sensitive variables (DB_PASSWORD) in a Secret.

3. **Deployment**: Create a deploy.yaml file to deploy the Docker image from your ECR repository to your Kubernetes. you can reference them in the Deployment manifest file using either `env` or `envFrom`.


## Setup CloudWatch Logging
You can setup CloudWatch logging using the Container Insights feature. Refer to the Operationalizing Kubernetes lesson for setup instructions.

