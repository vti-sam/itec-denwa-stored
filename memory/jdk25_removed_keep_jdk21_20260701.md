---
title: JDK 25 removed, JDK 21 kept as local default
project: itec-denwa
type: gotcha
status: archived
source:
  - Codex session 2026-07-01 local Java cleanup
tags:
  - java
  - jdk21
  - jdk25
  - android
  - local-dev
scope: historical
captured_at: 2026-07-01
validity: historical_context
promote_to_knowledge: false
---

User confirmed removing local JDK 25 after Android Gradle/Kotlin tooling failed with Java `25.0.1`.

Action completed:

- Removed `/Library/Java/JavaVirtualMachines/microsoft-25.jdk` via macOS administrator privilege prompt.
- Kept `/Library/Java/JavaVirtualMachines/microsoft-21.jdk`.
- Verified `/usr/libexec/java_home -V` lists only Microsoft OpenJDK `21.0.9`.
- Verified `java -version` reports Microsoft OpenJDK `21.0.9` LTS.

Context:

- Android tests previously passed with `JAVA_HOME=/Library/Java/JavaVirtualMachines/microsoft-21.jdk/Contents/Home`.
- Java 25 should not be reintroduced for this repo unless Gradle, Kotlin, and Android Gradle Plugin support has been upgraded and verified.
