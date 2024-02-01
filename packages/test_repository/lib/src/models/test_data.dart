import 'package:json_annotation/json_annotation.dart';

part 'test_data.g.dart';

/// {@template test}
/// A test that contains the project.
/// {@endtemplate}
@JsonSerializable()
class TestData {
  /// {@macro test}
  const TestData({
    required this.id,
    required this.description,
    required this.name,
  });

  /// From json
  factory TestData.fromJson(Map<String, dynamic> json) =>
      _$TestDataFromJson(json);

  /// To json
  Map<String, dynamic> toJson() => _$TestDataToJson(this);

  /// The kick-off id.
  final String id;

  /// The description of the test data.
  final String description;

  /// The name of the test data.
  final String name;
}
