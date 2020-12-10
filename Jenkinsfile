node{
   stage('Create Infrastructure'){
     git '' //replace your git url within the quotes
     sh  " terraform plan "
     timeout(time: 1, unit: "HOURS") {
         input message : 'Approve Deploy?', ok: 'Yes'
     }
     sh "terraform apply"
   }
}
