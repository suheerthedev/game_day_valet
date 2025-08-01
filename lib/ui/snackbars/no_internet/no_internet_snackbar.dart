import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';

SnackbarConfig getNoInternetSnackbarConfig() {
  return SnackbarConfig(
    backgroundColor: Colors.orange,
    titleColor: Colors.white,
    messageColor: Colors.white70,
    icon: const Icon(
      Icons.wifi_off,
      color: Colors.white,
    ),
    borderRadius: 12,
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    duration: const Duration(seconds: 5),
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    messageTextStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
  );
}
