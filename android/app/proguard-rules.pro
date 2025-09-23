# ---------- Razorpay SDK ----------
-keep class com.razorpay.** { *; }
-keepclassmembers class * {
    @com.razorpay.** <fields>;
    @com.razorpay.** <methods>;
}

# ---------- Annotations ----------
-keep class proguard.annotation.** { *; }
-dontwarn proguard.annotation.**

# ---------- Flutter ----------
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# ---------- Kotlin ----------
-dontwarn kotlin.**
