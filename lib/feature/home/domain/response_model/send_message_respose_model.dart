// To parse this JSON data, do:
// final sendMessageResposeModel = sendMessageResposeModelFromJson(jsonString);

import 'dart:convert';

SendMessageResposeModel sendMessageResposeModelFromJson(String str) =>
    SendMessageResposeModel.fromJson(json.decode(str));

String sendMessageResposeModelToJson(SendMessageResposeModel data) =>
    json.encode(data.toJson());

class SendMessageResposeModel {
  final bool success;
  final String message;
  final SendMessageData? data;

  SendMessageResposeModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory SendMessageResposeModel.fromJson(Map<String, dynamic> json) =>
      SendMessageResposeModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? null
            : SendMessageData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class SendMessageData {
  final String rideId;
  final String sender;
  final String recipient;
  final String message;
  final bool read;
  final DateTime? readAt;
  final String id;
  final DateTime timestamp;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  SendMessageData({
    required this.rideId,
    required this.sender,
    required this.recipient,
    required this.message,
    required this.read,
    this.readAt,
    required this.id,
    required this.timestamp,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory SendMessageData.fromJson(Map<String, dynamic> json) =>
      SendMessageData(
        rideId: json["rideId"] ?? "",
        sender: json["sender"] ?? "",
        recipient: json["recipient"] ?? "",
        message: json["message"] ?? "",
        read: json["read"] ?? false,
        readAt:
            json["readAt"] == null ? null : DateTime.parse(json["readAt"]),
        id: json["_id"] ?? "",
        timestamp: DateTime.parse(json["timestamp"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "rideId": rideId,
        "sender": sender,
        "recipient": recipient,
        "message": message,
        "read": read,
        "readAt": readAt?.toIso8601String(),
        "_id": id,
        "timestamp": timestamp.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
