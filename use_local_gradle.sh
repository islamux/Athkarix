#!/bin/bash
export JAVA_HOME="/home/islamux/android-studio/jbr"
export GRADLE_HOME="/mnt/Ext4_Free/gradle/wrapper/dists/gradle-8.6-all/3mbtmo166bl6vumsh5k2lkq5h/gradle-8.6"
export GRADLE_USER_HOME="/mnt/Ext4_Free/gradle"
export PATH="$JAVA_HOME/bin:$GRADLE_HOME/bin:$PATH"

echo "Environment configured:"
echo "JAVA_HOME=$JAVA_HOME"
echo "GRADLE_HOME=$GRADLE_HOME"
echo "GRADLE_USER_HOME=$GRADLE_USER_HOME"
echo ""
echo "Java version:"
java -version
echo ""
echo "Gradle version:"
gradle --version
