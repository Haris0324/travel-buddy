import org.gradle.api.file.Directory // Required for the custom directory logic
import org.gradle.api.tasks.Delete // Required for tasks.register<Delete>

// CRITICAL FIX: The buildscript block tells Gradle where to find build plugins
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies{
        classpath("com.google.gms:google-services:4.4.4")
        // It's also common practice to include the Kotlin Gradle Plugin here for KTS files
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.22")
    }
}
// END CRITICAL FIX

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}