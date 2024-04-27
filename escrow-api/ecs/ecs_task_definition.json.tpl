[
    {
      "name": "escrow-api-container",
      "image": "${docker_image_name}",
      "cpu": 256,
      "memory": 512,
      "portMappings": [
        {
          "containerPort": ${env_var_port},
          "hostPort": ${env_var_port},
          "protocol": "tcp"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "${awslogs_region}",
          "awslogs-group": "${env_var_awslogs_group}",
          "awslogs-stream-prefix": "${env_var_awslogs_stream_prefix}",
          "awslogs-create-group": "${env_var_awslogs_create_group}"
         }
      },
      "environment": [
        {
          "name": "SPRING_PROFILES_ACTIVE",
          "value": "${env_var_profile}"
        },
        {
          "name": "SERVER_PORT",
          "value": "${env_var_port}"
        },
        {
          "name": "DB_URL",
          "value": "${env_var_db_url}"
        },
        {
          "name": "DB_USERNAME",
          "value": "${env_var_db_username}"
        },
        {
          "name": "DB_PASSWORD",
          "value": "${env_var_db_password}"
        },
        {
          "name": "JWT_SECRET",
          "value": "${env_var_jwt_secret}"
        },
        {
          "name": "STRIPE_SECRET",
          "value": "${env_var_stripe_secret}"
        },
        {
          "name": "LOG_APP",
          "value": "${env_var_log_level}"
        },
        {
          "name": "LOG_HTTP_REQUESTS",
          "value": "${env_var_log_http_request}"
        },
        {
          "name": "LOG_HTTP",
          "value": "${env_var_log_http}"
        },
        {
          "name": "LOG_APP",
          "value": "${env_var_log_level}"
        }
    ]
  }
]
  
