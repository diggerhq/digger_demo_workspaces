package test

import (
	"fmt"
	"math/rand"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// An example of how to test the simple Terraform module in examples/terraform-basic-example using Terratest.
func TestTerraform(t *testing.T) {
	randInt := rand.Int()
	expectedText := fmt.Sprintf("abstract-bucket-%d-terratest-us-east-2", randInt)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"name":           fmt.Sprintf("abstract-bucket-%d", randInt),
			"environment":    "terratest",
			"project":        "cloudops",
			"asset_tag":      "test000001",
			"version_tag":    "1.0.0-rc",
			"provisioner":    "terraform://terraform-aws-s3",
			"partner":        "platform engineering",
			"owner":          "platform-tools@redventures.com",
			"classification": "n/a",
			"backup":         "n/a",
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": "us-east-2",
		},
		NoColor: false,
	}

	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	actualText := terraform.Output(t, terraformOptions, "name")

	// Verify we're getting back the variable we expect
	assert.Equal(t, expectedText, actualText)

}

func TestTerraformGlobalName(t *testing.T) {
	randInt := rand.Int()
	expectedText := fmt.Sprintf("abstract-bucket-%d", randInt)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"name":           fmt.Sprintf("abstract-bucket-%d", randInt),
			"environment":    "terratest",
			"project":        "cloudops",
			"asset_tag":      "test000001",
			"version_tag":    "1.0.0-rc",
			"provisioner":    "terraform://terraform-aws-s3",
			"partner":        "platform engineering",
			"owner":          "platform-tools@redventures.com",
			"classification": "n/a",
			"backup":         "n/a",
			"global":         true,
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": "us-east-2",
		},
		NoColor: false,
	}

	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	actualText := terraform.Output(t, terraformOptions, "name")

	// Verify we're getting back the variable we expect
	assert.Equal(t, expectedText, actualText)
}

// Test expiration inputs
func TestTerraformExpiration(t *testing.T) {
	randInt := rand.Int()
	expectedText := fmt.Sprintf("abstract-bucket-%d-terratest-us-east-2", randInt)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"name":                          fmt.Sprintf("abstract-bucket-%d", randInt),
			"environment":                   "terratest",
			"project":                       "cloudops",
			"expiration":                    90,
			"noncurrent_version_expiration": 180,
			"asset_tag":                     "test000001",
			"version_tag":                   "1.0.0-rc",
			"provisioner":                   "terraform://terraform-aws-s3",
			"partner":                       "platform engineering",
			"owner":                         "platform-tools@redventures.com",
			"classification":                "n/a",
			"backup":                        "n/a",
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": "us-east-2",
		},
		NoColor: false,
	}

	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	actualText := terraform.Output(t, terraformOptions, "name")

	// Verify we're getting back the variable we expect
	assert.Equal(t, expectedText, actualText)

}

func TestTerraformDisabled(t *testing.T) {
	t.Parallel()

	expectedText := ""

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"name":           fmt.Sprintf("abstract-bucket-%d", rand.Int()),
			"environment":    "terratest",
			"project":        "cloudops",
			"enable":         false,
			"asset_tag":      "test000001",
			"version_tag":    "1.0.0-rc",
			"provisioner":    "terraform://terraform-aws-s3",
			"partner":        "platform engineering",
			"owner":          "platform-tools@redventures.com",
			"classification": "n/a",
			"backup":         "n/a",
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": "us-east-2",
		},
		NoColor: false,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	actualText := terraform.Output(t, terraformOptions, "name")

	// Verify we're getting back the variable we expect
	assert.Equal(t, expectedText, actualText)
}
