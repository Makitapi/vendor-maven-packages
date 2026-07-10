# Changelog

All notable changes to this repository are documented in this file.

This project follows repository release tags (for example, `v1.0.0`).

## v1.0.2 - 2026-07-10

### Added

- Added Zebra RFID API3 v2.0.5.275 as an Android Archive (AAR).

### Existing artifacts in this release

- `com.makitapi.vendor:zebra-rfid-api3:2.0.5.275`

## v1.0.1 - 2026-06-26

### Added

- Added repository `.gitignore` rules for IDE metadata, OS files, logs, temporary files, build outputs, and local environment files.
- Added Impinj Java Octane v5.2.0.0 and Java LTK v12.4.0.0

### Existing artifacts in this release

- `com.makitapi.vendor:impinj-ltkjava:12.4.0.0`
- `com.makitapi.vendor:impinj-octanesdkjava:5.2.0.0`
- `com.makitapi.vendor:impinj-ltkjava:12.2.0.0`
- `com.makitapi.vendor:impinj-octanesdkjava:5.1.0.0`
- `com.makitapi.vendor:nordicid-nurapi:1.0.0`
- `com.makitapi.vendor:nordicid-nurapi-socket-transport:1.0.0`
- `com.makitapi.vendor:zebra-linkos-sdk:2.15.5553`
- `com.makitapi.vendor:zebra-linkos-snmp:2.15.5553`

## v1.0.0 - 2026-03-06

### Added

- Initial automated vendor deployment model.
- Versioned Zebra SDK folder layout under `zebra/link-os/<version>/`.
- Local deployment automation using `deploy/deploy-artifacts.sh` and `deploy/artifacts.csv`.
- GitHub Actions deployment workflow on tag push.

### Existing artifacts in this release

- `com.makitapi.vendor:impinj-ltkjava:12.2.0.0`
- `com.makitapi.vendor:impinj-octanesdkjava:5.1.0.0`
- `com.makitapi.vendor:nordicid-nurapi:1.0.0`
- `com.makitapi.vendor:nordicid-nurapi-socket-transport:1.0.0`
- `com.makitapi.vendor:zebra-linkos-sdk:2.15.5553`
- `com.makitapi.vendor:zebra-linkos-snmp:2.15.5553`
