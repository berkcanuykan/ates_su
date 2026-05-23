import 'package:flutter_test/flutter_test.dart';
import 'package:ates_su/config.dart';

void main() {
  test('Açıklık açısı makul aralıkta', () {
    expect(GameConfig.openingDegrees, greaterThan(0));
    expect(GameConfig.openingDegrees, lessThan(360 / GameConfig.openingCount));
  });

  test('Maksimum iniş, temel inişten büyük', () {
    expect(GameConfig.maxDescent, greaterThanOrEqualTo(GameConfig.baseDescent));
  });

  test('Alev ekran içinde başlar', () {
    expect(GameConfig.fireXFactor, inInclusiveRange(0.0, 1.0));
    expect(GameConfig.fireStartYFactor, inInclusiveRange(0.0, 1.0));
  });
}
