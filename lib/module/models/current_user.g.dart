// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentUser _$CurrentUserFromJson(Map<String, dynamic> json) {
  return $checkedNew('CurrentUser', json, () {
    final val = CurrentUser(
      $checkedConvert(json, '_id', (v) => v as String?),
      $checkedConvert(json, 'username', (v) => v as String?),
      $checkedConvert(json, 'firstName', (v) => v as String?),
      $checkedConvert(json, 'lastName', (v) => v as String?),
      $checkedConvert(json, 'email', (v) => v as String?),
      $checkedConvert(json, 'createdAt',
          (v) => v == null ? null : DateTime.parse(v as String)),
      $checkedConvert(json, 'updatedAt',
          (v) => v == null ? null : DateTime.parse(v as String)),
      $checkedConvert(json, 'image', (v) => v as String?),
    );
    return val;
  }, fieldKeyMap: const {'id': '_id'});
}

Map<String, dynamic> _$CurrentUserToJson(CurrentUser instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'image': instance.image,
    };
