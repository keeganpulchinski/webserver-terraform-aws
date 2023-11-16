# Web Server in AWS Utilizing Terraform
The Terraform file in this repository will create a basic AWS EC2 instance that will be a web server. This server will be able to host a website or web application. SSH will not be allowed as we will be using SSM to access the server. Follow the instructions below to use correctly use the Terraform file in the repository to successfully create and manage an EC2 instance.

## Prerequisites
To use this repository, you first must install the following software on your machine:

[Terraform](https://developer.hashicorp.com/terraform/downloads)

[AWS CLI](https://aws.amazon.com/cli/)

You must also have an AWS account and an IAM user that has minimal permissions that will be enough to create and manage EC2 instances, along with using SSM. The permissions are already included in the file and will be created for you, but instructions regarding permissions can be found below:

[IAM Roles for EC2 Instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html)
[IAM Permissions for SSM]https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-instance-permissions.html)

## Instructions
1. Clone this repository to your machine
2. Navigate to the cloned repository directory in your terminal
3. Open the 'webserverinit.tf' file and edit the following variables to suit your needs:

    - region: The AWS region in which to create the instance.

    - ami: The ID of the Amazon Machine Image to use for the instance. **Note: AMIs are Region-specific and will not work in another Region**

    - instance_type: The instance type to use for the instance.

4. In your terminal, run terraform init in order to initialize the working directory of Terrafom and to download the provider plugins that are required
   ```
   terraform init
   ```
5. To view the changes that Terraform will make to your infrastructure, run the terraform plan command
    ```
   terraform plan
    ```
6. Run terraform apply to create the AWS resource files that are defined in the 'webserverinit.tf' file, and then confirm by typing 'yes' and then pressing Enter
   ```
   terraform apply
   ```
7. Once completed, go into the Console to ensure that your instance was successfully created
8. Go into SSM to connect to the instance
9. After successful completion, run terraform destroy to remove all of the resources that are defined in the 'webserverinit.tf' file
```
terraform destroy
```
