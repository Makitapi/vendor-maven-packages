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

# Impinj Java SDK 6.0.0.0

The current Impinj Java SDK files are published as separate Maven artifacts:

- `impinj/ltkjava-13.0.0.0.jar` -> `com.makitapi.vendor:impinj-ltkjava:13.0.0.0`
- `impinj/OctaneSDKJava-6.0.0.0.jar` -> `com.makitapi.vendor:impinj-octanesdkjava:6.0.0.0`

Deploy the current Impinj artifacts with:

```bash
mvn deploy:deploy-file \
-DgroupId=com.makitapi.vendor \
-DartifactId=impinj-ltkjava \
-Dversion=13.0.0.0 \
-Dpackaging=jar \
-Dfile=/Users/lsoares/Documents/GithubMakitapi/vendor-maven-packages/impinj/ltkjava-13.0.0.0.jar \
-DrepositoryId=github-vendor \
-Durl=https://maven.pkg.github.com/Makitapi/vendor-maven-packages

mvn deploy:deploy-file \
-DgroupId=com.makitapi.vendor \
-DartifactId=impinj-octanesdkjava \
-Dversion=6.0.0.0 \
-Dpackaging=jar \
-Dfile=/Users/lsoares/Documents/GithubMakitapi/vendor-maven-packages/impinj/OctaneSDKJava-6.0.0.0.jar \
-DrepositoryId=github-vendor \
-Durl=https://maven.pkg.github.com/Makitapi/vendor-maven-packages
```

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
    link-os-android/
      2.17.5585/
        ZSDK_ANDROID_API.jar
        snmp6_1z.jar
        ... bundled third-party JARs ...
    rfid-api3/
      2.0.5.292/
        rfidapi3lib-2.0.5.292.aar
      2.0.5.297/
        rfidapi3lib-2.0.5.297.aar
```

Current local path prepared in this repository:

- `/Users/lsoares/Documents/GithubMakitapi/vendor-maven-packages/zebra/link-os/2.15.5553/ZSDK_API.jar`
- `/Users/lsoares/Documents/GithubMakitapi/vendor-maven-packages/zebra/link-os/2.15.5553/snmp6_1z.jar`
- `/Users/lsoares/Documents/GithubMakitapi/vendor-maven-packages/zebra/rfid-api3/2.0.5.292/rfidapi3lib-2.0.5.292.aar`
- `/Users/lsoares/Documents/GithubMakitapi/vendor-maven-packages/zebra/rfid-api3/2.0.5.297/rfidapi3lib-2.0.5.297.aar`

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

## Zebra Link-OS Android SDK

The Link-OS Android 2.17.5585 SDK is separate from the Java SDK above. The shared artifact manifest configures both the local installation and GitHub Packages deployment scripts to process:

- `com.makitapi.vendor:zebra-linkos-android-sdk:2.17.5585` from `zebra/link-os-android/2.17.5585/ZSDK_ANDROID_API.jar`
- `com.makitapi.vendor:zebra-linkos-android-snmp:2.17.5585` from `zebra/link-os-android/2.17.5585/snmp6_1z.jar`

For an Android project using Gradle, add the SDK and the bundled SNMP library:

```gradle
implementation 'com.makitapi.vendor:zebra-linkos-android-sdk:2.17.5585'
implementation 'com.makitapi.vendor:zebra-linkos-android-snmp:2.17.5585'
```

The SDK directory also contains third-party JARs supplied with the Zebra distribution. These are not published by the manifest, and the generated Maven POMs do not declare them as transitive dependencies. Consumers must supply any required third-party dependencies separately, using suitable Maven coordinates or the bundled files, and account for version conflicts with their existing dependencies.

## Zebra RFID API3 SDK

Zebra RFID API3 versions 2.0.5.292 and 2.0.5.297 are provided as Android Archives. Their Maven coordinates are:

- `com.makitapi.vendor:zebra-rfid-api3:2.0.5.292`
- `com.makitapi.vendor:zebra-rfid-api3:2.0.5.297`

Version 2.0.5.297 is listed in `deploy/artifacts.csv` for automated deployment. To deploy it manually to GitHub Packages, run from the repository root:

```bash
mvn deploy:deploy-file \
-DgroupId=com.makitapi.vendor \
-DartifactId=zebra-rfid-api3 \
-Dversion=2.0.5.297 \
-Dpackaging=aar \
-Dfile=zebra/rfid-api3/2.0.5.297/rfidapi3lib-2.0.5.297.aar \
-DrepositoryId=github-vendor \
-Durl=https://maven.pkg.github.com/Makitapi/vendor-maven-packages
```

In an Android consumer project, add the dependency alongside the other vendor artifacts:

```xml
<dependency>
  <groupId>com.makitapi.vendor</groupId>
  <artifactId>zebra-rfid-api3</artifactId>
  <version>2.0.5.297</version>
  <type>aar</type>
</dependency>
```

## Upgrade flow

1. Create a new folder: `zebra/link-os/<new-version>/`
2. Replace JARs with files from the new Zebra SDK version.
3. Run `mvn deploy:deploy-file` with `-Dversion=<new-version>`.
4. In consumer projects, update `zebra.linkos.version` only.

For Zebra RFID API3, create a new folder under `zebra/rfid-api3/<new-version>/` and publish the AAR with `-Dpackaging=aar`.

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

## Release notes

### Unreleased - Deployment reliability

- Fixed repeated deployments failing with Maven `HTTP Status: 409` despite `SKIP_EXISTING=true`. The script now checks the exact artifact file URL and recognizes multiple Maven conflict message formats.
- Existing JAR and AAR artifacts are skipped; missing artifacts are deployed. Authentication, authorization, network, and server errors during the existence check remain fatal.
- The release artifact list is recorded in the [changelog](CHANGELOG.md#v105---2026-10-30).

Run the workflow from a branch or new tag containing the fix. Re-running the original failed workflow uses its original code and does not pick up these changes.

Validation: all 14 mocked regression tests, ShellCheck, and whitespace checks passed. No live packages were published during verification. Run the regression tests locally with:

```bash
bash deploy/test-deploy-artifacts.sh
```

## Release and changelog policy

- Repository release versioning uses Git tags (for example, `v1.0.0`, `v1.1.0`).
- Artifact versions remain independent and are defined in [`deploy/artifacts.csv`](deploy/artifacts.csv).
- Every repository release must be recorded in [`CHANGELOG.md`](CHANGELOG.md).
- Each changelog release entry must include an `Existing artifacts in this release` section listing all artifact coordinates present in that release.

Initial baseline release is documented as [`v1.0.0`](CHANGELOG.md:7).
