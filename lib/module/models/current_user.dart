// ignore_for_file: deprecated_member_use

import 'package:json_annotation/json_annotation.dart';

part 'current_user.g.dart';

@JsonSerializable(
  nullable: true,
  checked: true,
)
class CurrentUser {
  CurrentUser(this.id, this.emailVerified, this.username, this.firstName,
      this.lastName, this.email, this.createdAt, this.updatedAt, this.token);

  @JsonKey(name: '_id')
  String id;
  bool? emailVerified;
  String? username;
  String? firstName;
  String? lastName;
  String? userType;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;
  Object? token;

  factory CurrentUser.fromJson(Map<String, dynamic> json) =>
      _$CurrentUserFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentUserToJson(this);
}
