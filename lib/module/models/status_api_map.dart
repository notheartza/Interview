import 'package:json_annotation/json_annotation.dart';

part 'status_api_map.g.dart';

@JsonSerializable()
class StatusAPIMap {
  StatusAPIMap(this.status, this.message);

  int status;
  Map<String, dynamic> message;

  factory StatusAPIMap.fromJson(Map<String, dynamic> json) =>
      _$StatusAPIMapFromJson(json);

  Map<String, dynamic> toJson() => _$StatusAPIMapToJson(this);
}
