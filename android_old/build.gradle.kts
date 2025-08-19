// Top-level build file
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.5.2")
        classpath("com.google.gms:google-services:4.4.2")
        // Não coloque dependências do app aqui.
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
