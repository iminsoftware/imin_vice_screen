group = "com.imin.vicescreen.imin_vice_screen"
version = "1.0"

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.7.0")
    }
}

rootProject.allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

apply(plugin = "com.android.library")

extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
    namespace = "com.imin.vicescreen.imin_vice_screen"
    compileSdk = 35

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        minSdk = 21
        multiDexEnabled = true
    }

    testOptions {
        // onMethodCall logs through android.util.Log, which is not stubbed on the JVM.
        unitTests.isReturnDefaultValues = true
        unitTests.all {
            it.testLogging {
                events("passed", "skipped", "failed", "standardOut", "standardError")
                showStandardStreams = true
            }
            it.outputs.upToDateWhen { false }
        }
    }
}

dependencies {
    "testImplementation"("junit:junit:4.13.2")
    "testImplementation"("org.mockito:mockito-core:5.23.0")
    "implementation"(files("libs/freeimagelibrary-5-v1.5_2607160235.jar"))
    "implementation"("com.github.bumptech.glide:glide:4.16.0")
}
