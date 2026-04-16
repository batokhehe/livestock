# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Firebase
-keep class com.google.firebase.** { *; }

-dontwarn io.flutter.embedding.**
-ignorewarnings

# Firebase App Distribution
-keep class com.google.firebase.appdistribution.** { *; }
-keep class com.android.build.api.dsl.** { *; }
-keep class com.android.build.gradle.internal.dsl.** { *; }

# Retain generic signatures of TypeToken and its subclasses if R8 version 3.0 full-mode is enabled.
# https://r8.googlesource.com/r8/+/refs/heads/master/compatibility-faq.md#r8-full-mode
-keepattributes Signature
# For using GSON @Expose annotation
-keepattributes Annotation