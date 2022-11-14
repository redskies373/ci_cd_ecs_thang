{
    "requiresCompatibilities": [
        "FARGATE"
    ],
    "inferenceAccelerators": [],
    "containerDefinitions": [
        {
            "name": "${ecr_repo}",
            "image": "${ecr_repo} :00000",
            "resourceRequirements": null,
            "essential": true,
            "portMappings": [
                {
                    "containerPort": "${container_port}",
                    "protocol": "tcp"
                }
                
            ]
        }
    ],
    "volumes": [],
    "networkMode": "awsvpc",
    "memory": "${container_memory}",
    "cpu": "${container_cpu}",
    "executionRoleArn": "${execution_role}",
    "family": "github-actions-task-definition",
    "taskRoleArn": "",
    "placementConstraints": [] 
}