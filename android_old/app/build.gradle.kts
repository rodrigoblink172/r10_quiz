plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")   // precisa estar AQUI no .kts
}

android {
    namespace = "com.seu.pacote"           // ajuste para o seu
    compileSdk = 34

    defaultConfig {
        applicationId = "com.seu.pacote"   // ajuste para o seu
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
        multiDexEnabled = true
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")
    // Suas outras deps Android puras (se houver). As deps Flutter ficam no pubspec.
}
