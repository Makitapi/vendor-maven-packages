mvn deploy:deploy-file \
-DgroupId=com.makitapi.vendor \
-DartifactId=impinj-ltkjava \
-Dversion=12.2.0.0 \
-Dpackaging=jar \
-Dfile=/Users/lsoares/Documents/GithubMakitapi/vendor-maven-packages/impinj/ltkjava-12.2.0.0.jar \
-DrepositoryId=github-vendor \
-Durl=https://maven.pkg.github.com/Makitapi/vendor-maven-packages


mvn deploy:deploy-file \
-DgroupId=com.makitapi.vendor \
-DartifactId=impinj-octanesdkjava \
-Dversion=5.1.0.0 \
-Dpackaging=jar \
-Dfile=/Users/lsoares/Documents/GithubMakitapi/vendor-maven-packages/impinj/OctaneSDKJava-5.1.0.0.jar \
-DrepositoryId=github-vendor \
-Durl=https://maven.pkg.github.com/Makitapi/vendor-maven-packages

mvn deploy:deploy-file \
-DgroupId=com.makitapi.vendor \
-DartifactId=nordicid-nurapi \
-Dversion=1.0.0 \
-Dpackaging=jar \
-Dfile=/Users/lsoares/Documents/GithubMakitapi/vendor-maven-packages/brady/NurApi.jar \
-DrepositoryId=github-vendor \
-Durl=https://maven.pkg.github.com/Makitapi/vendor-maven-packages

mvn deploy:deploy-file \
-DgroupId=com.makitapi.vendor \
-DartifactId=nordicid-nurapi-socket-transport \
-Dversion=1.0.0 \
-Dpackaging=jar \
-Dfile=/Users/lsoares/Documents/GithubMakitapi/vendor-maven-packages/brady/NurApiSocketTransport.jar \
-DrepositoryId=github-vendor \
-Durl=https://maven.pkg.github.com/Makitapi/vendor-maven-packages