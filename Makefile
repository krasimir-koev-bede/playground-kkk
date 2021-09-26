include .\.env

init:
	terraform init


apply:
	terraform apply

plan:
	terraform plan



taint:
	terraform taint $(t)

untaint:
	terraform untaint $(t)
