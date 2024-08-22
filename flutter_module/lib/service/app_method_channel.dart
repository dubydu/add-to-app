import 'package:flutter/services.dart';
import 'app_method_channel_delegate.dart';

/// FlutterMethodChannelType
enum FlutterMethodChannelType {
  // Primary channel
  primaryChannel,

  // Chat channel
  chatChannel;
}

/// FlutterCallEvent
enum FlutterCallEvent {
  // Subscribe to the chat channel
  subscribeChatChannelEvent,

  // Send message event
  sendMessageEvent;

  static FlutterCallEvent? type(String value) =>
      FlutterCallEvent.values.firstWhere((type) => type.name == value);
}

/// FlutterResponseEvent
enum FlutterResponseEvent {
  // On listen message response event
  onListenMessageResponseEvent;

  static FlutterResponseEvent? type(String value) =>
      FlutterResponseEvent.values.firstWhere((type) => type.name == value);
}

/// AppMethodChannel
class AppMethodChannel {
  /// Method channel
  late MethodChannel _methodChannel;

  /// Delegation
  AppMethodChannelDelegate? _delegate;

  /// Subscribe method channel
  void subscribe({
    required AppMethodChannelDelegate delegate,
    FlutterMethodChannelType channel = FlutterMethodChannelType.primaryChannel,
  }) async {
    _delegate = delegate;
    _methodChannel = MethodChannel(channel.name);
    _methodChannel.setMethodCallHandler(_platformCallHandler);
  }

  /// Unsubscribe method channel
  void unsubscribe() {
    _delegate = null;
  }

  /// Invoke method
  Future<T?> invokeMethod<T>({
    required FlutterCallEvent method,
    dynamic arguments,
  }) async {
    return await _methodChannel.invokeMethod<T>(method.name, arguments);
  }

  /// Invoke list method
  Future<List<T>?> invokeListMethod<T>({
    required FlutterCallEvent method,
    dynamic arguments,
  }) async {
    return await _methodChannel.invokeListMethod(method.name, arguments);
  }

  /// Platform listeners
  Future<dynamic> _platformCallHandler(MethodCall call) async {
    if (_delegate == null) return;
    final args = call.arguments as Map<dynamic, dynamic>;
    switch (FlutterResponseEvent.type(call.method)) {
      case FlutterResponseEvent.onListenMessageResponseEvent:
        await _delegate!.onListenMessageResponse(arguments: args);
      default:
        break;
    }
  }
}
