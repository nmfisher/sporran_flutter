import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sporran_flutter/sporran_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('sporran_flutter');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await SporranFlutter.platformVersion, '42');
  });
}
