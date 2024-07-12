resource "aws_ecs_cluster" "this" {
  count      = var.enabled ? 1 : 0
  depends_on = [time_sleep.wait_container_insight_logs]
  name       = var.name
  tags       = var.tags

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  count              = var.enabled ? 1 : 0
  cluster_name       = aws_ecs_cluster.this[0].name
  capacity_providers = ["FARGATE"]
}

# Wait before deleting the Container Insights log group since AWS still logs data even 2-3 minutes after the ECS cluster has been deleted. CLOUD-456
resource "time_sleep" "wait_container_insight_logs" {
  count            = var.enabled ? 1 : 0
  depends_on       = [aws_cloudwatch_log_group.this]
  destroy_duration = var.enable_container_insights ? "240s" : "0s"
}

resource "aws_cloudwatch_log_group" "this" {
  count             = var.enable_container_insights && var.enabled ? 1 : 0
  name              = "/aws/ecs/containerinsights/${var.git}/performance"
  retention_in_days = var.log_retention
  tags              = merge(local.tags, var.tags)

  lifecycle {
    ignore_changes = [name]
  }
}
