on:
  push:
    branches:
      - master 

name: Deploy Hello World

jobs:
  start-runner:
    name: Start self-hosted EC2 runner
    runs-on: ubuntu-latest
    outputs:
      label: ${{ steps.start-ec2-runner.outputs.label }}
      ec2-instance-id: ${{ steps.start-ec2-runner.outputs.ec2-instance-id }}
    steps:
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
      - name: Start EC2 runner
        id: start-ec2-runner
        uses: machulav/ec2-github-runner@v2
        with:
          mode: start
          github-token: ${{ secrets.GH_PERSONAL_ACCESS_TOKEN }}
          ec2-image-id: ami-09d48adfe35882a23
          ec2-instance-type: t3.nano
          subnet-id: subnet-5b55ac16
          security-group-id: sg-02dc0adeec9fa615f

  deploy:
    name: Deploy
    needs: start-runner # required to start the main job when the runner is ready
    runs-on: ${{ needs.start-runner.outputs.label }} # run the job on the newly created runner

    steps:
    # - name:
    #  Check commit status
    #   id: commit-status
    #   run: |
    #     # Check the status of the Git commit
    #     CURRENT_STATUS=$(curl --url https://api.github.com/repos/${{ github.repository }}/commits/${{ github.sha }}/status --header 'authorization: Bearer ${{ secrets.GITHUB_TOKEN }}' | jq -r '.state');
    #     echo "Current status is: $CURRENT_STATUS"
    #     while [ "${CURRENT_STATUS^^}" = "PENDING" ]; 
    #       do sleep 10; 
    #       CURRENT_STATUS=$(curl --url https://api.github.com/repos/${{ github.repository }}/commits/${{ github.sha }}/status --header 'authorization: Bearer ${{ secrets.GITHUB_TOKEN }}' | jq -r '.state');
    #     done;
    #     echo "Current status is: $CURRENT_STATUS"
    #     if [ "${CURRENT_STATUS^^}" = "FAILURE" ]; 
    #       then echo "Commit status failed. Canceling execution"; 
    #       exit 1; 
    #     fi
        
    - name: Checkout
      uses: actions/checkout@v1
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1    
    - name: Login to Amazon ECR
      id: login-ecr
      #uses: aws-actions/amazon-ecr-login@v1
      run: |
        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 966510751703.dkr.ecr.us-east-1.amazonaws.com
    - name: Build, tag, and push image to Amazon ECR
      id: build-image
      env:
        #ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
        ECR_REGISTRY: 966510751703.dkr.ecr.us-east-1.amazonaws.com
        ECR_REPOSITORY: github-actions
        IMAGE_TAG: ${{ github.sha }}
      run: |
        # Build a docker container and
        # push it to ECR so that it can
        # be deployed to ECS.
        docker build . -t "$ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG"
        docker push "$ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG"
        echo "::set-output name=image::$ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG"         
    - name: Fill in the new image ID in the Amazon ECS task definition
      id: task-def
      uses: aws-actions/amazon-ecs-render-task-definition@v1
      with:
        task-definition: task-definition.json
        container-name: github-actions
        image: ${{ steps.build-image.outputs.image }}
    - name: Deploy Amazon ECS task definition
      uses: aws-actions/amazon-ecs-deploy-task-definition@v1
      with:
        task-definition: ${{ steps.task-def.outputs.task-definition }}
        service: github-actions-service
        cluster: github-actions-cluster
        wait-for-service-stability: true

  stop-runner:
    name: Stop self-hosted EC2 runner
    needs:
      - start-runner # required to get output from the start-runner job
      - deploy # required to wait when the main job is done
    runs-on: ubuntu-latest
    if: ${{ always() }} # required to stop the runner even if the error happened in the previous jobs

    steps:
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
      - name: Stop EC2 runner
        uses: machulav/ec2-github-runner@v2
        with:
          mode: stop
          github-token: ${{ secrets.GH_PERSONAL_ACCESS_TOKEN }}
          label: ${{ needs.start-runner.outputs.label }}
          ec2-instance-id: ${{ needs.start-runner.outputs.ec2-instance-id }}