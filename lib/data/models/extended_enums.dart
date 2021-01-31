import 'enums.dart';

extension GenderExtension on Gender {
  static const _GenderEnumMap = {
    Gender.Man: 'Man',
    Gender.Woman: 'Woman',
  };

  static dynamic toMap(Gender value) => _GenderEnumMap[value];

  static Gender fromMap(dynamic source) {
    final value = _GenderEnumMap.entries
        .singleWhere((e) => e.value == source, orElse: () => null)
        ?.key;

    return value;
  }
}
