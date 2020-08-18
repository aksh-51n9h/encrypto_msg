class Message {
  final MessageType type;
  Message({this.type});

  factory Message.fromJson(dynamic json) {
    return Message(
      type: MessageType.values[json['type']],
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': MessageType.values.indexOf(type)};
  }
}

enum MessageType {
  keyPairExchange,
  textMessage,
}
