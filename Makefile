.PHONY: help setup format lint test test-native test-go clean

help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

setup: ## Install pre-commit hooks and initialize go modules
	pre-commit install
	cd test && go mod tidy

format: ## Format Terraform and Go code
	terraform fmt -recursive
	cd test && go fmt ./...

lint: ## Run pre-commit hooks on all files
	pre-commit run --all-files

test-native: ## Run Terraform 1.6+ native tests on modules
	@echo "Running native Terraform tests..."
	@find modules/ -maxdepth 1 -mindepth 1 -type d | xargs -I {} bash -c 'cd {} && terraform init -backend=false && terraform test'

test-go: ## Run Terratest (Go) integration tests
	@echo "Running Go integration tests..."
	cd test && go test -v -timeout 30m ./...

test: test-native test-go ## Run all tests (Native + Go)

clean: ## Clean up Terraform state caches and Go test caches
	@find . -type d -name ".terraform" -exec rm -rf {} +
	@find . -type f -name ".terraform.lock.hcl" -exec rm -f {} +
	@find . -type f -name "terraform.tfstate*" -exec rm -f {} +
	@find . -type f -name "crash.log" -exec rm -f {} +
	go clean -testcache
