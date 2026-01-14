@Library('shared_libs') _
pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "mrsinghdocker/gemini-clone"
        IMAGE_TAG = "${BUILD_NUMBER}"
        GIT_BRANCH = "master"
    }
    stages {
        stage('Cleaning Workspace') {
            steps{
                script{
                    cleanWorkspace()
                }
            }
        }
        stage('Cloning') {
            steps{
                script{
                    gitClone("https://github.com/Gagandeepsingh9/Project-gemini-clone.git","master")
                }
            }
        }
        stage('building') {
            steps {
                script{
                    dockerBuild(
                        image: env.DOCKER_IMAGE,
                        tag: env.IMAGE_TAG,
                        dockerfile: 'Dockerfile',
                        dockercontext: '.'
                        )
                }
            }
        }
        stage('Trivy Image Scan') {
            steps {
                sh 'trivy image $DOCKER_IMAGE:$IMAGE_TAG'
            }
        }
        stage('Pushing Image to DockerHub') {
            steps{
                script{
                    dockerPush(
                        docker_creds_id: 'DOCKER_CREDS',
                        docker_image: env.DOCKER_IMAGE,
                        image_tag: env.IMAGE_TAG
                    )
                }
                }
            }
        stage('updating manifest files') {
            steps {
                script{
                    updateGitrepo(
                        git_creds_id: 'GITHUB_CREDS',
                        docker_image: env.DOCKER_IMAGE,
                        image_tag: env.IMAGE_TAG,
                        k8s_deployment_file_path: 'gemini-clone-app/k8s/gemini-deployment.yml',
                        github_repo_name: 'platform-gitops',
                        git_branch_name: 'main'
                    )
                }
            }
        }
    }
}