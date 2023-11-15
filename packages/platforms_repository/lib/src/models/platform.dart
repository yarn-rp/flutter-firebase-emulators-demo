import 'package:json_annotation/json_annotation.dart';

part 'platform.g.dart';

/// {@template platform}
/// A platform that contains the project.
/// {@endtemplate}
@JsonSerializable()
class Platform {
  /// {@macro platform}
  const Platform({
    required this.id,
    required this.displayName,
    required this.iconUrl,
    required this.authentication,
  });

  /// From json
  factory Platform.fromJson(Map<String, dynamic> json) =>
      _$PlatformFromJson(json);

  /// The kick-off id.
  final String id;

  /// The display name of the platform.
  @JsonKey(name: 'name')
  final String displayName;

  /// The URL of the icon for the platform.
  final String iconUrl;

  /// The authentication configuration for the platform.
  @JsonKey(
    name: 'auth',
    fromJson: Authentication.fromJson,
    toJson: Authentication.toJson,
  )
  final Authentication authentication;

  /// To json
  Map<String, dynamic> toJson() => _$PlatformToJson(this);
}

/// {@template authentication}
/// The authentication configuration for the platform.
/// {@endtemplate}
sealed class Authentication {
  /// {@macro authentication}
  const Authentication();

  /// Converts a json object to an [Authentication] instance.
  factory Authentication.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'oauth2':
        return OAuth2.fromJson(json);
      case 'basic':
        return Basic.fromJson(json);
      default:
        throw Exception('Unknown type: ${json['type']}');
    }
  }

  /// Converts an [Authentication] instance to a json object.
  static Map<String, dynamic> toJson(Authentication authentication) {
    return switch (authentication) {
      Basic() => authentication.toJson(),
      OAuth2() => authentication.toJson(),
    };
  }
}

/// {@template basic_authentication}
/// Basic authentication configuration for authenticating with a platform using
/// a username and password.
/// {@endtemplate}
@JsonSerializable()
class Basic extends Authentication {
  /// {@macro basic_authentication}
  Basic();

  /// Converts a json object to a [Basic] instance.
  factory Basic.fromJson(Map<String, dynamic> json) => _$BasicFromJson(json);

  /// Converts a [Basic] instance to a json object.
  Map<String, dynamic> toJson() => _$BasicToJson(this);
}

/// {@template oauth2_authentication}
/// OAuth2 authentication configuration for authenticating with a platform using
/// an OAuth2 flow.
/// {@endtemplate}
@JsonSerializable()
class OAuth2 extends Authentication {
  /// {@macro oauth2_authentication}
  OAuth2({
    required this.url,
    this.redirectScheme,
  });

  /// Converts a json object to an [OAuth2] instance.
  factory OAuth2.fromJson(Map<String, dynamic> json) => _$OAuth2FromJson(json);

  /// The URL to use for authentication.
  Map<String, dynamic> toJson() => _$OAuth2ToJson(this);

  /// The URL to use for authentication.
  final String url;

  /// The redirect scheme to use for authentication.
  final String? redirectScheme;
}
