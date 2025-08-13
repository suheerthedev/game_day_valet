# Stripe push provisioning classes - prevent R8 errors
-dontwarn com.stripe.android.pushProvisioning.**
-keep class com.stripe.android.pushProvisioning.** { *; }
