.DEFAULT_GOAL := hello_world

export TF_VAR_profile?=harshvardhan 
export TF_VAR_environment=sandbox
export ssm_env?=sandbox

hello_world:
	@echo "Hello world"

Infra_Plan: format validate plan 

destroy:
	terraform destroy -auto-approve

init:
	terraform init

workspace : 
	terraform workspace select ${workspace} 

plan:
	terraform plan

apply:
	terraform apply -auto-approve

format:
	terraform fmt -recursive

validate:
	terraform validate

docker: image_build image_push

image_build:
	docker build -t ${name} ${path}

image_push:
	docker push ${name}

ssm:
	bash ../scripts/ssm.sh


ssm_param:
ifeq ($(profile),)
	@aws --region=us-west-2 ssm get-parameter --name ${ssm_prefix}${param} --with-decryption --output text --query Parameter.Value 
else
	@aws --region=us-west-2 --profile $(profile) ssm get-parameter --name ${ssm_prefix}${param} --with-decryption --output text --query Parameter.Value
endif

ecr:
ifeq ($(profile),)
	@aws ecr describe-repositories --repository-names $(name)
else
	@aws ecr describe-repositories --repository-names $(name) --profile $(profile)
endif