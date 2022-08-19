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

ssh internal-mikikube-host -j bastion
# takes really long to install minikube, check progress with
sudo tail -f /var/log/cloud-init-output

# after reboot
minikube start
kubectl apply -f /opt/github/ipv6-aws-env/templates/kube-charts/helloworld/
curl $(minikube service helloworld --url -n=helloworld)
```