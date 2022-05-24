pipeline {
    agent any
	parameters {

        choice(name: 'CHOICE', choices: ['Apply', 'Destroy', 'Update'], description: 'Pick')

       
    }
    stages {
        stage('Copy to s3') {
            steps {
                withAWS(credentials: 'aws', region: 'eu-central-1') {
                   s3Upload(file:'component_infra', bucket:'artifacts.build.eu-central-1.ccoe.luxoft.com', path: env.BRANCH_NAME)
                    
                }
            }
        }
		stage('Deploy') {
            steps {
			script{
                if (params.CHOICE == 'Apply')
				{
					echo " i am here"
				}
				}
            }
        }
		
		stage('Destroy') {
            steps {
                
                    echo " i am in destroy"
                }
            }
        }
		
		
    }
