# EC2 CloudWatch Logging with FastAPI (Terraform) 

This project provisions an EC2 instance using Terraform, runs a FastAPI app, and streams application logs to **Amazon CloudWatch Logs** using the CloudWatch Agent.

Note: Purely meant for Quick reference to understand the concept behind log streaminig. Do not copy exact infrastructure in the Production.

---

## Prerequisites

- Terraform ≥ 1.5
- AWS account (Free trial is enough)
- AWS credentials secret key and access key

---

## Architecture
![cloudwatchec2logging-removebg-preview](https://github.com/user-attachments/assets/fd5bc50f-a5b2-4948-a407-4b6f0c11f387)

## Branch

There are two branches:
- main => Contains Terraform code
- app => Contains FastAPI code

## 1. Clone the Repository

```bash
git clone -b main https://github.com/rahul-08-11/ec2-cloudwatch-logging.git

cd ec2-cloudwatch-logging
```

## 2. Configure AWS Credentials

Before running Terraform, you need to configure your AWS credentials.

#### Step 1: Install AWS CLI (if not already installed)

**For Linux:**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

**Verify installation:**
```bash
aws --version
```

#### Step 2: Configure AWS Credentials

Run the following command and enter your AWS credentials when prompted:
```bash
aws configure
```

You'll be asked to provide:
- **AWS Access Key ID**: Your AWS access key
- **AWS Secret Access Key**: Your AWS secret key  
- **Default region name**: `us-east-1` (or your preferred region)
- **Default output format**: `json` (recommended)

This creates a credentials file at `~/.aws/credentials` that Terraform will automatically use.

#### Step 3: Verify Configuration

Test that your credentials are working:
```bash
aws sts get-caller-identity
```

## 3. Run Terraform

```bash
terraform init
terraform apply
```


## 4. Access the app

After EC2 is created, open in browser:

```
http://<EC2_PUBLIC_IP>:8000
```

Example endpoints:

* `http://<EC2_PUBLIC_IP>:8000/`
* `http://<EC2_PUBLIC_IP>:8000/greet?name=myname`
* `http://<EC2_PUBLIC_IP>:8000/greet/myname`

---

## 5. Logs

Application logs are written to:

```
/app/app.log
/app/setup.log
```

They are automatically shipped to **CloudWatch Logs**:

```
Log Group: /ec2/pythonapp
```
<img width="1642" height="239" alt="image" src="https://github.com/user-attachments/assets/01f406b0-c752-4c45-b129-4e151d31ea9f" />
<img width="1642" height="239" alt="image" src="https://github.com/user-attachments/assets/fdafb6c2-31df-4dbc-9c2f-1b890e1b04e4" />

---

## Notes

* `user_data` runs **only on first boot**
* App is started inside a **detached tmux session**
* Port `8000` is open **for testing only**

---

## 6. Cleanup
Make sure to destroy your resources by running the following command:
```bash
terraform destroy
```





