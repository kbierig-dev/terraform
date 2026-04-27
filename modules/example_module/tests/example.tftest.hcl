# Native Terraform Testing (tftest.hcl)
# Available since Terraform 1.6
# Mocks can also be used here using "mock_provider" blocks.

variables {
  bucket_name = "tftest-bucket-12345"
  environment = "test"
}

# The 'run' block executes an apply against the module code in memory.
run "create_bucket" {
  command = plan # 'apply' is full interaction, 'plan' is validation

  # Assertions to ensure our module behaves as expected
  assert {
    condition     = aws_s3_bucket.this.bucket == "tftest-bucket-12345"
    error_message = "Bucket name did not match expected value"
  }

  assert {
    condition     = aws_s3_bucket.this.tags["Environment"] == "test"
    error_message = "Environment tag was not set correctly"
  }
}
