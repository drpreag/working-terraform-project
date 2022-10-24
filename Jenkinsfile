def DOCKER_TAG
def TAGGED_BUILD=false

pipeline {
    agent any

    options {
        ansiColor('xterm')
        disableConcurrentBuilds()
        disableResume()
        skipStagesAfterUnstable()
    }

    environment {
        GITHUB_CREDENTIALS = "github_pat"
        AWS_CREDENTIALS = "terraform-aws-user"
        ECR = "016682580984.dkr.ecr.eu-west-1.amazonaws.com"
        ECR_REGION = "eu-central-1"
    }

    stages {
        stage('Executing terraform') {
            steps {
                script {
                    sh """
#!/bin/bash
echo "Terraform init"
terraform init
echo "Terraform validate"
terraform validate
echo "Terraform fmt"
terraform fmt -recursive -check
echo "Terraform plan"
terraform plant -out tf1
echo "Terraform apply"
terraform apply tf1
                    """
                }
            }
        }
    }

    post {
        failure {
            emailext body: '''${SCRIPT, template="groovy-html.template"}''',
                mimeType: 'text/html',
                subject: "Jenkins job ${env.JOB_BASE_NAME} #${env.BUILD_DISPLAY_NAME} failed",
                to: "${env.GIT_COMMITTER_EMAIL}",
                replyTo: "${env.GIT_COMMITTER_EMAIL}",
                recipientProviders: [[$class: 'CulpritsRecipientProvider']]
        }
    }
}
