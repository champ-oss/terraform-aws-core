package test

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/cloudwatchlogs"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"testing"
	"time"
)

// TestExamplesComplete tests a typical deployment of this module
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir:  "../../examples/complete",
		BackendConfig: map[string]interface{}{},
		EnvVars:       map[string]string{},
		Vars:          map[string]interface{}{},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	logger.Log(t, "Checking if Container Insights logs exist")
	logs := describeLogGroups("/aws/ecs/containerinsights/terraform-aws-core/performance", "us-west-2")
	assert.NotEmpty(t, logs.LogGroups)

	terraform.Destroy(t, terraformOptions)
	logger.Log(t, "Waiting a few seconds to check if log group is deleted...")
	time.Sleep(60 * time.Second)

	logger.Log(t, "Checking if Container Insights logs have been deleted")
	logs = describeLogGroups("/aws/ecs/containerinsights/terraform-aws-core/performance", "us-west-2")
	assert.Empty(t, logs.LogGroups)
}

func describeLogGroups(name string, region string) *cloudwatchlogs.DescribeLogGroupsOutput {
	sess, err := session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	})
	if err != nil {
		panic(err)
	}

	svc := cloudwatchlogs.New(sess, aws.NewConfig().WithRegion(region))
	logs, err := svc.DescribeLogGroups(&cloudwatchlogs.DescribeLogGroupsInput{
		LogGroupNamePrefix: aws.String(name),
	})
	if err != nil {
		panic(err)
	}
	return logs
}
