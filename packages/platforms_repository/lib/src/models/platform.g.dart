// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Platform _$PlatformFromJson(Map<String, dynamic> json) => Platform(
      id: json['id'] as String,
      displayName: json['name'] as String,
      iconUrl: json['iconUrl'] as String,
      authentication:
          Authentication.fromJson(json['auth'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlatformToJson(Platform instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.displayName,
      'iconUrl': instance.iconUrl,
      'auth': Authentication.toJson(instance.authentication),
    };

Basic _$BasicFromJson(Map<String, dynamic> json) => Basic();

Map<String, dynamic> _$BasicToJson(Basic instance) => <String, dynamic>{};

OAuth2 _$OAuth2FromJson(Map<String, dynamic> json) => OAuth2(
      url: json['url'] as String,
      redirectScheme: json['redirectScheme'] as String?,
    );

Map<String, dynamic> _$OAuth2ToJson(OAuth2 instance) => <String, dynamic>{
      'url': instance.url,
      'redirectScheme': instance.redirectScheme,
    };
