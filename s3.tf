
removed {
  from = aws_s3_bucket.this 

  lifecycle {
    destroy = false
  }
}

removed {
  from = aws_s3_bucket_server_side_encryption_configuration.this

  lifecycle {
    destroy = false
  }
}  

  removed {
    from = aws_s3_bucket_versioning.this
  lifecycle {
    destroy = false
  }     
} 

removed {
  from = aws_s3_bucket_public_access_block.this
  lifecycle {
    destroy = false
  }
}

removed {
  from = aws_s3_bucket.aws_lb_server_access_log_bucket
  lifecycle {
    destroy = false
  }
} 

