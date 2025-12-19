# EC2 CloudWatch Logging with FastAPI (Terraform) 

This project provisions an EC2 instance using Terraform, runs a FastAPI app, and streams application logs to **Amazon CloudWatch Logs** using the CloudWatch Agent.

Note: Purely meant for Quick reference to understand the concept behind log streaminig. Do not copy exact infrastructure in the Production.

---

## Prerequisites

- Terraform ≥ 1.5
- AWS account (Free trial is enough)
- AWS credentials secret key and access key

---

## How to Run

### 1. Configure AWS credentials
Update the provider block in main.tf:

```bash
access_key = "XXXXXXXXXXXXXXXX"
secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

````

---

### 2. Initialize Terraform

```bash
terraform init
```

---

### 3. Deploy infrastructure

```bash
terraform apply
```

Type `yes` when prompted.

---

### 4. Access the app

After EC2 is created, open in browser:

```
http://<EC2_PUBLIC_IP>:8000
```

Example endpoints:

* `/`
* `/greet?name=Rahul`
* `/greet/Rahul`

---

## Logs

Application logs are written to:

```
/app/app.log
/app/setup.log
```

They are automatically shipped to **CloudWatch Logs**:

```
Log Group: /ec2/pythonapp
```

---

## Notes

* `user_data` runs **only on first boot**
* App is started inside a **detached tmux session**
* Port `8000` is open **for testing only**

---

## Cleanup

```bash
terraform destroy
```

Make sure to destroy your resources.


