import 'package:json_annotation/json_annotation.dart';

part 'status_api.g.dart';

@JsonSerializable()
class StatusAPI {
  StatusAPI(this.status, this.message);

  int status;
  String message;

  factory StatusAPI.fromJson(Map<String, dynamic> json) =>
      _$StatusAPIFromJson(json);

  Map<String, dynamic> toJson() => _$StatusAPIToJson(this);
}
