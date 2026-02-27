pipeline {
	agent any
	environment {
		DOCKERFILE_NAME = "Dockerfile"
		DOCKER_DIR = "./01_docker/build-app"
		DOCKER_IMAGE = "ic-webapp"
		DOCKER_TAG = "1.0"
		DOCKERHUB_ID = "slye44"
		DOCKERHUB_PASSWORD = credentials('dockerhub_password')
		PORT_EXT = "8090"
		PORT_APP = "8080"
		IP = "192.168.100.13" // Docker Host IP
		AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
		AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
	}
	stages {
		stage('Build Image'){
			steps{
				script {
					sh '''
					  docker build --network host -f ${DOCKER_DIR}/${DOCKERFILE_NAME} -t ${DOCKERHUB_ID}/${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_DIR}/.
					'''
				}
			}
		}
		stage('Run and Test'){
			steps{
				script {
					sh '''
						docker ps -a | grep -i ${DOCKER_IMAGE} && docker rm -f ${DOCKER_IMAGE}
						docker run --name ${DOCKER_IMAGE} -dp $PORT_EXT:$PORT_APP ${DOCKERHUB_ID}/${DOCKER_IMAGE}:${DOCKER_TAG}
						sleep 5
						curl -I http://$IP:$PORT_EXT | grep -i "200"
					'''
				}
			}
		}
		stage('Stop and Delete Container'){
			steps{
				script {
					sh '''
						docker ps -a | grep -i ${DOCKER_IMAGE} && docker rm -f ${DOCKER_IMAGE}
					'''
				}
			}
		}
		stage('Login and Push Image'){
			steps{
				script {
					sh '''
						echo $DOCKERHUB_PASSWORD | docker login -u ${DOCKERHUB_ID} --password-stdin
						docker push ${DOCKERHUB_ID}/${DOCKER_IMAGE}:${DOCKER_TAG}
					'''
				}
			}
		}
		stage('Create AWS configuration') {
		  steps {
		    script {
		      sh '''
		        mkdir -p ~/.aws
            echo "[default]" > ~/.aws/credentials
            echo -e "aws_access_key_id=$AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
            echo -e "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
            chmod 400 ~/.aws/credentials
		      '''
		    }
		  }
		}
// 		stage('Build Docker EC2'){
// 			agent {
// 				docker {
// 					image 'jenkins/jnlp-agent-terraform'
// 					args '--entrypoint=""'
// 				}
// 			}
// 			steps{
// 				script {
// 					sh '''
// 						cd 02_terraform/
// 						terraform init
// 						terraform apply -var="stack_name=docker" -auto-approve
// 					'''
// 				}
// 			}
// 		}
// 		stage('Ansible deploy apps on docker EC2'){
// 			agent {
// 				docker {
// 					image 'registry.gitlab.com/robconnolly/docker-ansible:latest'
// 				}
// 			}
// 			steps {
// 				script {
// 					sh '''
// 						cd 04_ansible/
// 						ansible docker -m ping --private-key ../02_terraform/keypair/docker.pem
// 						ansible-playbook playbooks/docker/main.yml --private-key ../02_terraform/keypair/docker.pem
// 					'''
// 				}
// 			}
// 		}
// 		stage('destroy Docker instance on AWS with terraform') {
//       steps {
//           input message: "Confirmer vous la suppression de l'instance Docker  dans AWS ?", ok: 'Yes'
//       }
//     }
// 		stage('Destroy Docker EC2'){
// 			agent {
// 				docker {
// 					image 'jenkins/jnlp-agent-terraform'
// 					args '--entrypoint=""'
// 				}
// 			}
// 			steps{
// 				script {
// 					sh '''
// 						cd 02_terraform/
// 						terraform destroy -var="stack_name=docker" -auto-approve
// 					'''
// 				}
// 			}
// 		}
		stage('Build Kubernetes EC2'){
			agent {
				docker {
					image 'jenkins/jnlp-agent-terraform'
					args '--entrypoint=""'
				}
			}
			steps{
				script {
					sh '''
						cd 02_terraform/
						terraform init
						terraform apply -var="stack_name=kubernetes" -auto-approve
					'''
				}
			}
		}
		stage('Ansible on kubernetes EC2'){
			agent {
				docker {
					image 'registry.gitlab.com/robconnolly/docker-ansible:latest'
				}
			}
			steps {
				script {
					sh '''
						cd 04_ansible/
						ansible k3s -m ping --private-key ../02_terraform/keypair/kubernetes.pem
						ansible-playbook playbooks/k3s/main.yml --private-key ../02_terraform/keypair/kubernetes.pem
					'''
				}
			}
		}
		stage('kubectl deploy'){
      agent {
        docker {
            image 'bitnami/kubectl'
            args '--entrypoint=""'
        }
      }
      steps {
        script {
          sh '''
            HOST_IP=$(grep 'ansible_host:' 04_ansible/host_vars/k3s.yml | awk '{print $2}')
            sed -i "s|HOST|$HOST_IP|g" 03_kubernetes/01_ic-webapp/ic-webapp-cm.yaml
            echo "Verifying kubeconfig file..."
            ls -l ../04_ansible/playbooks/k3s/kubeconfig-k3s.yml
            echo "Checking cluster access..."
            kubectl --kubeconfig=04_ansible/playbooks/k3s/kubeconfig-k3s.yml get nodes
            kubectl --kubeconfig=04_ansible/playbooks/k3s/kubeconfig-k3s.yml apply -k 03_kubernetes/ --validate=false -v=9
          '''
        }
      }
    }
		stage('Destroy Kubernetes') {
      steps {
        input message: "Confirmer vous la suppression du Kubernetes dans AWS ?", ok: 'Yes'
      }
    }
		stage('Destroy Kubernetes EC2'){
			agent {
				docker {
					image 'jenkins/jnlp-agent-terraform'
					args '--entrypoint=""'
				}
			}
			steps{
				script {
					sh '''
						cd 02_terraform/
						terraform destroy -var="stack_name=kubernetes" -auto-approve
					'''
				}
			}
		}
	}
}
