enum MessageFlow {
  IN_COMMING,
  OUT_GOING;
}

class MessageModel {
  final String message;
  final MessageFlow messageFlow;

  MessageModel({
    required this.message,
    required this.messageFlow,
  });

  MessageModel copyWith({
    String? message,
    MessageFlow? messageFlow,
  }) {
    return MessageModel(
      message: message ?? this.message,
      messageFlow: messageFlow ?? this.messageFlow,
    );
  }
}
