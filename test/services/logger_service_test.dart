import 'package:flutter_test/flutter_test.dart';
import 'package:game_day_valet/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('LoggerServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
