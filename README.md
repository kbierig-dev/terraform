# Engineering Infrastructure - Terraform Repository

This repository manages cloud infrastructure using Terraform, adhering to a strict Test-Driven Development (TDD) workflow.

## Repository Structure

```text
.
├── .github/workflows/   # CI/CD pipelines (GitHub Actions)
├── environments/        # Concrete environment definitions (dev, staging, prod)
│   └── dev/             # Development environment - where modules are instantiated
├── modules/             # Reusable, versionable infrastructure components
│   └── example_module/  # An example module with native tests
│       └── tests/       # Native Terraform 1.6+ tests (*.tftest.hcl)
├── test/                # End-to-end integration tests using Terratest (Go)
├── .pre-commit-config.yaml # Automation for linting, security, and formatting
├── Makefile             # Developer task runner
└── .tflint.hcl          # TFLint configuration for AWS-specific rules
```

## Getting Started

### Prerequisites

You will need the following tools installed locally:
- [Terraform](https://www.terraform.io/downloads.html) (>= 1.6.0)
- [Go](https://golang.org/doc/install) (>= 1.21)
- [pre-commit](https://pre-commit.com/)
- [TFLint](https://github.com/terraform-linters/tflint)
- [tfsec](https://github.com/aquasecurity/tfsec)

### Initial Setup

1. Install pre-commit hooks:
   ```bash
   make setup
   ```

2. Initialize your local environment:
   ```bash
   cd environments/dev
   terraform init
   ```

## Development Workflow (TDD)

1. **Write a Native Test**: Add a `.tftest.hcl` file in your module's `tests/` directory.
2. **Implement Logic**: Write the corresponding HCL in `main.tf`.
3. **Validate**: Run `make test-native` to verify logic without deploying.
4. **Integration Test**: Update/Add a Terratest suite in `test/` for real-world verification.
5. **Format & Lint**: Run `make lint` before committing.

## Automation

Common tasks are abstracted in the `Makefile`:
- `make format`: Auto-format all code.
- `make lint`: Run all pre-commit checks.
- `make test-native`: Run Terraform's internal unit tests.
- `make test-go`: Run Terratest integration tests.
- `make test`: Run everything.
