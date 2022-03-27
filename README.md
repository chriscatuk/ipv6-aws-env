# ipv6-aws-env

Training env in AWS for IPv6 only resources

## Details

Training environement in AWS to deploy IPv6-only resources with:
- dualstack edges
- access to IPv4 resources (NAT64 + DNS64)

## Usage Example

```bash
# set your default profile for AWS to your training account
export AWS_DEFAULT_REGION=eu-west-1
export AWS_PROFILE=training

terraform init
terraform apply  -var-file=terraform.tfvars  -var-file=terraform.safe.tfvars
```