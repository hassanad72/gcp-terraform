package test

import (
	"os"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestDevInfrastructure(t *testing.T) {
	projectID := os.Getenv("TERRATEST_GCP_PROJECT")
	if projectID == "" {
		t.Skip("set TERRATEST_GCP_PROJECT to an isolated GCP test project")
	}

	testID := strings.ToLower(random.UniqueId())
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixture",
		Vars: map[string]interface{}{
			"project_id": projectID,
			"region":     "us-central1",
			"test_id":    testID,
		},
		NoColor: true,
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.Init(t, terraformOptions)
	terraform.ApplyAndIdempotent(t, terraformOptions)

	if networkID := terraform.Output(t, terraformOptions, "network_id"); networkID == "" {
		t.Fatal("expected a non-empty network_id output")
	}

	bucketNames := terraform.OutputMap(t, terraformOptions, "bucket_names")
	if bucketNames["application"] == "" {
		t.Fatal("expected an application bucket name")
	}
}
