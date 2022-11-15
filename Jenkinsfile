pipeline {
    agent any
	parameters {

        choice(name: 'CHOICE', choices: ['Apply', 'Destroy', 'Update'], description: 'Pick')

       
    }
    stages {
        stage('Copy to s3') {
            steps {
                withAWS( region: 'eu-central-1') {
                   s3Upload(file:'component_infra', bucket:'artifacts.build.eu-central-1.ccoe.luxoft.com', path: env.BRANCH_NAME)
                    
                }
            }
        }
		stage('Deploy') {
			when {
        expression {
            return params.CHOICE == 'Apply';
        }
    }
            steps {
			script{
                if (params.CHOICE == 'Apply')
				{
					echo " i am here"
					sh "ls -lrt"
					sh "python3 Convert.py"
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
