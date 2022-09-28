# vpc-aws-project
This project contains terraform code which creates infrastructure and resources on AWS Cloud
This project creates the following infrastructure on aws using terraform variables and functions
	•	VPC and all it's components (subnets, internet gateway, route tables etc.)
	•	EC2 in the created VPC
	•	Clean files (Provider, Backend, Variables, vpc.tf)
The code consist of four terraform files
	1.	The backend file which logs all the terraform states.
	2.	The provider file which references the AWS provider
	3.	The variable file which lists all the variables used in the project
	4.	The VPC file which has the main codes.
