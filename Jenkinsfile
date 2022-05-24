pipeline {
    agent any
    parameters {
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')

        text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')

        booleanParam(name: 'TOGGLE', defaultValue: true, description: 'Toggle this value')

        choice(name: 'CHOICE', choices: ['Apply', 'Destroy', 'Update'], defaultValue: 'Apply' ,description: 'Pick An Action form following')
    }

       
    
    stages {
        stage('Copy to s3') {
            steps {
                withAWS(credentials: 'aws', region: 'eu-central-1') {
                   s3Upload(file:'component_infra', bucket:'artifacts.build.eu-central-1.ccoe.luxoft.com', path: env.BRANCH_NAME)
                    
                }
            }
            }
        stage('Deploy to AWS') {
    
            steps {
				script{
					
                echo "Choice: ${params.CHOICE}"
				}
                    
                }
            }
			
            

        stage('Destroy') {
            
            steps {
			script{
				
                echo "Choice: ${params.CHOICE}"
                    
                }
				}
            }
			
            
       
    }
    }
