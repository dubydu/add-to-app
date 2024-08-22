import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/model/message_model.dart';
import 'package:flutter_module/service/app_method_channel.dart';
import 'package:flutter_module/service/app_method_channel_delegate.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen>
    with AppMethodChannelDelegate {
  /// AppMethodChannel
  final AppMethodChannel _appMethodChannel = AppMethodChannel();

  /// ScrollController
  final ScrollController scrollController = ScrollController();

  /// Messages
  final List<MessageModel> _messages = [];

  /// StreamController
  final StreamController _streamController =
      StreamController<List<MessageModel>>();

  /// Send message
  Future<void> _sendMessage({
    required String message,
  }) async {
    _messages.add(
        MessageModel(message: message, messageFlow: MessageFlow.OUT_GOING));
    _streamController.sink.add(_messages);
    _scrollToBottom();
    await _appMethodChannel.invokeMethod(
      method: FlutterCallEvent.sendMessageEvent,
      arguments: {
        'message': message,
      },
    );
  }

  /// Scroll to bottom
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () async {
      await scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Future<void> onListenMessageResponse({required Map arguments}) async {
    // For demo purposes, let's assume that the response is a simple message string.
    // If you want to return complex data, you can return it as a json in string format and
    // then use jsonDecode to decode it.
    final newMessage = arguments['message'] as String;
    _messages.add(
        MessageModel(message: newMessage, messageFlow: MessageFlow.IN_COMMING));
    _streamController.sink.add(_messages);
    _scrollToBottom();
  }

  @override
  void initState() {
    super.initState();
    _appMethodChannel.subscribe(
      delegate: this,
      channel: FlutterMethodChannelType.chatChannel,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _appMethodChannel.invokeMethod(
          method: FlutterCallEvent.subscribeChatChannelEvent);
    });
  }

  @override
  void dispose() {
    _streamController.close();
    _appMethodChannel.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter w/ luv'),
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(22)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45.withOpacity(.05),
                      spreadRadius: 2,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: StreamBuilder(
                  stream: _streamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return MessageList(
                        messages: snapshot.data,
                        scrollController: scrollController,
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'Start a conversation.',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            MessageInputField(onSend: (message) {
              _sendMessage(message: message);
            }),
          ],
        ),
      ),
    );
  }
}

class MessageList extends StatelessWidget {
  final List<MessageModel> messages;

  final ScrollController scrollController;

  const MessageList({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.only(top: 4),
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        return MessageItem(message: messages[index]);
      },
    );
  }
}

class MessageItem extends StatelessWidget {
  final MessageModel message;

  const MessageItem({super.key, required this.message});

  bool get _isGoingMessage => message.messageFlow == MessageFlow.OUT_GOING;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 10,
      ),
      child: Align(
        alignment:
            _isGoingMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _isGoingMessage ? Colors.blue[100] : Colors.grey[200],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: _isGoingMessage
                  ? const Radius.circular(20)
                  : const Radius.circular(0),
              bottomRight: _isGoingMessage
                  ? const Radius.circular(0)
                  : const Radius.circular(20),
            ),
          ),
          child: Text(
            message.message,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}

class MessageInputField extends StatefulWidget {
  final Function(String) onSend;

  const MessageInputField({super.key, required this.onSend});

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  /// TextEditingController
  final TextEditingController _controller = TextEditingController();

  /// Focus node
  final FocusNode _focusNode = FocusNode();

  /// Handle send message
  void _handleSend() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSend(_controller.text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 6, top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28.0),
                ),
              ),
            ),
          ),
          Transform.rotate(
            angle: 270,
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: _handleSend,
            ),
          ),
        ],
      ),
    );
  }
}
