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


# Zebra Link-OS SDK (versioned vendor layout)

## Folder structure

Store each Zebra SDK release in its own folder so multiple versions can coexist:

```text
vendor-maven-packages/
  zebra/
    link-os/
      2.15.5553/
        ZSDK_API.jar
        snmp6_1z.jar
```

Current local path prepared in this repository:

- `/Users/lsoares/Documents/GithubMakitapi/vendor-maven-packages/zebra/link-os/2.15.5553/ZSDK_API.jar`
- `/Users/lsoares/Documents/GithubMakitapi/vendor-maven-packages/zebra/link-os/2.15.5553/snmp6_1z.jar`

## Deploy Zebra artifacts to GitHub Packages

### Core SDK

```bash
mvn deploy:deploy-file \
-DgroupId=com.makitapi.vendor \
-DartifactId=zebra-linkos-sdk \
-Dversion=2.15.5553 \
-Dpackaging=jar \
-Dfile=/Users/lsoares/Documents/GithubMakitapi/vendor-maven-packages/zebra/link-os/2.15.5553/ZSDK_API.jar \
-DrepositoryId=github-vendor \
-Durl=https://maven.pkg.github.com/Makitapi/vendor-maven-packages
```

### SNMP dependency bundled by Zebra

```bash
mvn deploy:deploy-file \
-DgroupId=com.makitapi.vendor \
-DartifactId=zebra-linkos-snmp \
-Dversion=2.15.5553 \
-Dpackaging=jar \
-Dfile=/Users/lsoares/Documents/GithubMakitapi/vendor-maven-packages/zebra/link-os/2.15.5553/snmp6_1z.jar \
-DrepositoryId=github-vendor \
-Durl=https://maven.pkg.github.com/Makitapi/vendor-maven-packages
```

## Consumer project usage (example: rfid-core-lib)

In the consuming project `pom.xml`, keep versions in properties so upgrades are one-line changes:

```xml
<properties>
  <zebra.linkos.version>2.15.5553</zebra.linkos.version>
</properties>

<dependencies>
  <dependency>
    <groupId>com.makitapi.vendor</groupId>
    <artifactId>zebra-linkos-sdk</artifactId>
    <version>${zebra.linkos.version}</version>
  </dependency>

  <dependency>
    <groupId>com.makitapi.vendor</groupId>
    <artifactId>zebra-linkos-snmp</artifactId>
    <version>${zebra.linkos.version}</version>
  </dependency>
</dependencies>
```

## Upgrade flow

1. Create a new folder: `zebra/link-os/<new-version>/`
2. Replace JARs with files from the new Zebra SDK version.
3. Run `mvn deploy:deploy-file` with `-Dversion=<new-version>`.
4. In consumer projects, update `zebra.linkos.version` only.
