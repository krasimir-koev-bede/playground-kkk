include ./.env
export

init:
	terraform init


apply:
	terraform apply

plan:
	terraform plan

destroy:
	terraform destroy



taint:
	terraform taint $(t)

untaint:
	terraform untaint $(t)
