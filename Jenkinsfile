pipeline{
    agent any
    stages{
        //stage('Fetch Gitee Codes') {
        //    steps {
        //       git credentialsId: '138gitee', url: 'https://gitee.com/osgisOne/atmgitops.git'
        //    }
        //}
        stage('Build and Jar') {
            steps {
                bat '''mkdir target
                cd source
                javac atm/*.java atm/physical/*.java atm/transaction/*.java banking/*.java simulation/*.java -d ../target/
                cd ..
                cd target
                jar cfe ../atmgitops.jar atm.ATMMain atm/*.class atm/physical/*.class atm/transaction/*.class banking/*.class simulation/*.class'''
            }
        }
        stage('Test oneStage'){
            steps{
                echo "Test Stage"
            }
        }
        stage('Jar Signer') {
            steps {
                bat '''
                keytool -genkey -alias mykey -keystore mykeystore.store -storetype PKCS12 -storepass mystorepass -storepass mystorepass -dname "CN=liudongliang, OU=chzu, L=xxxy, S=chuzhou, O=anhui, C=CH"
                keytool -export -keystore mykeystore.store -alias mykey -validity 365 -file mykeystore.cert -storepass mystorepass
                jarsigner -keystore myKeystore.store atmgitops.jar mykey -storepass mystorepass
                echo keystore "file:myKeystore.store","PKCS12"; grant signedBy "mykey" { permission java.io.FilePermission"<<ALL FILES>>","read";};>myKeystore.policy
                del mykeystore.*
                rd /S/Q target'''
            }
        }
        stage('Package War') {
            steps {
                bat 'jar cf atmgitops.war *'
            }
        }
        stage('Test twoStage'){
            steps{
                echo "Test Stage"
            }
        }
        stage('Deploy War to tomcat'){
            steps{
                deploy adapters: [tomcat9(credentialsId: 'tomcatidpwd', path: '', url: 'http://localhost:8080')], contextPath: '/atmgitops', war: 'atmgitops.war'
            }
        }
        stage('Clean War'){
            steps{
                bat 'del atmgitops.war'
            }
        }
        stage('Run WebMall'){
            steps{
               bat '"C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe" http://localhost:8080/atmgitops/index.html' 
            }
        }
    }   
}