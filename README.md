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

## Automated deployment

### Source of truth for deployable artifacts

All vendor artifacts are listed in [`deploy/artifacts.csv`](deploy/artifacts.csv).

CSV format:

```text
path,groupId,artifactId,version,packaging
```

Example entry:

```text
zebra/link-os/2.15.5553/ZSDK_API.jar,com.makitapi.vendor,zebra-linkos-sdk,2.15.5553,jar
```

### Local deployment script

Use [`deploy/deploy-artifacts.sh`](deploy/deploy-artifacts.sh:1) to publish all configured artifacts in one run.

Prerequisites:

1. Maven installed and available in PATH.
2. Credentials configured for repository id `github-vendor` in Maven `settings.xml`.

Minimal `~/.m2/settings.xml` server entry:

```xml
<settings>
  <servers>
    <server>
      <id>github-vendor</id>
      <username>${env.GITHUB_ACTOR}</username>
      <password>${env.GITHUB_TOKEN}</password>
    </server>
  </servers>
</settings>
```

Run manually:

```bash
export GITHUB_ACTOR=<your-github-username>
export GITHUB_TOKEN=<your-github-pat-with-packages-write>
./deploy/deploy-artifacts.sh
```

Optional behavior:

- `SKIP_EXISTING=true ./deploy/deploy-artifacts.sh` skips artifacts that already exist.
- `ARTIFACTS_FILE=deploy/artifacts.csv ./deploy/deploy-artifacts.sh` deploys from a custom CSV path.

### GitHub Actions deployment on tag push

Workflow file: [`deploy-vendor-artifacts.yml`](.github/workflows/deploy-vendor-artifacts.yml)

Trigger:

- Push tag matching `v*` (for example `v2026.03.1`), or run manually from `workflow_dispatch`.

What it does:

1. Checks out repository.
2. Configures Java/Maven with server id `github-vendor`.
3. Runs [`deploy/deploy-artifacts.sh`](deploy/deploy-artifacts.sh:1) with `SKIP_EXISTING=true`.

This makes the deployment idempotent for repeated tags/workflow re-runs.
