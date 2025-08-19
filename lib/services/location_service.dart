import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  /// Ensures location services are enabled and permission is granted,
  /// then returns "City, Country" (best-effort).
  Future<String> getCityAndCountry() async {
    // 1) Services enabled?
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Optionally: prompt user to enable
      await Geolocator.openLocationSettings();
      throw Exception('Location services are disabled.');
    }

    // 2) Permission flow
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied.');
    }
    if (permission == LocationPermission.deniedForever) {
      // iOS/Android: user must enable from Settings
      await Geolocator.openAppSettings();
      throw Exception('Location permission permanently denied.');
    }

    // 3) Get coordinates
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low, // city-level is enough
    );

    // 4) Reverse geocode -> Placemark
    final placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) throw Exception('No placemark found.');

    final p = placemarks.first;

    // Some regions don’t fill locality; try useful fallbacks
    final city = (p.locality != null && p.locality!.isNotEmpty)
        ? p.locality!
        : (p.subAdministrativeArea?.isNotEmpty == true
            ? p.subAdministrativeArea!
            : (p.administrativeArea ?? ''));

    final country = p.country ?? '';

    final parts = [city, country].where((s) => s.trim().isNotEmpty).toList();
    if (parts.isEmpty) throw Exception('Failed to resolve city/country.');

    return parts.join(', ');
  }
}
