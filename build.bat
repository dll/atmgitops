mkdir target
cd source
javac atm/*.java atm/physical/*.java atm/transaction/*.java banking/*.java simulation/*.java -d ../target/
cd ..
cd target
jar cvfe ../atmgitops.jar atm.ATMMain atm/*.class atm/physical/*.class atm/transaction/*.class banking/*.class simulation/*.class
cd ..
keytool -genkey -alias mykey -keystore mykeystore.store -keypass mykeypass -storepass mystorepass  -validity 365  -dname "CN=liudongliang, OU=chzu, L=xxxy, S=chuzhou, O=anhui, C=CH"
keytool -export -keystore mykeystore.store -alias mykey -validity 365 -file mykeystore.cert -storepass mystorepass
rsigner -keystore myKeystore.store atmgitops.jar mykey -storepass mystorepass -keypass mykeypass
echo keystore "file:myKeystore.store","JKS"; grant signedBy "mykey" { permission java.io.FilePermission"<<ALL FILES>>","read";};>myKeystore.policy
rd /S/Q target
java -jar atmgitops.jar
echo ok