// To use this model:
//
// final body = SentMessageBody(
//   rideId: "6936883bf4597c160a13066a",
//   receiverId: "690ae28202690f0799e0d9f5",
//   message: "brtother are you okkk|",
// );
//
// dio.post("your_endpoint", data: body.toJson());

import 'dart:convert';

SentMessageBody sentMessageBodyFromJson(String str) =>
    SentMessageBody.fromJson(json.decode(str));

String sentMessageBodyToJson(SentMessageBody data) =>
    json.encode(data.toJson());

class SentMessageBody {
  final String rideId;
  final String receiverId;
  final String message;

  SentMessageBody({
    required this.rideId,
    required this.receiverId,
    required this.message,
  });

  factory SentMessageBody.fromJson(Map<String, dynamic> json) =>
      SentMessageBody(
        rideId: json["rideId"] ?? "",
        receiverId: json["receiverId"] ?? "",
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "rideId": rideId,
        "receiverId": receiverId,
        "message": message,
      };
}
