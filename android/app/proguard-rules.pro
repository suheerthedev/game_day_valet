# --- Stripe push provisioning classes ---
-dontwarn com.stripe.android.pushProvisioning.**
-keep class com.stripe.android.pushProvisioning.** { *; }

# --- Keep SLF4J logging bindings ---
-dontwarn org.slf4j.**
-keep class org.slf4j.** { *; }

# --- Google Play Services (if using Google Sign-In / Pay) ---
-dontwarn com.google.android.gms.**
-keep class com.google.android.gms.** { *; }

# --- Kotlin metadata (prevents R8 stripping)
-keep class kotlin.Metadata { *; }
