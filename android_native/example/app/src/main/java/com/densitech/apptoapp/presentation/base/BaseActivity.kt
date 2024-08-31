package com.densitech.apptoapp.presentation.base

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

enum class FlutterEntryPoint(val value: String) {
    CONVERSATION("entryConversationScreen")
}

enum class FlutterMethodChannelType(val value: String) {
    // Primary channel
    PRIMARY_CHANNEL("primaryChannel"),

    // Chat channel
    CHAT_CHANNEL("chatChannel")
}

enum class FlutterCallEvent(val value: String) {
    // Subscribe to the chat channel
    SUBSCRIBE_CHAT_CHANNEL_EVENT("subscribeChatChannelEvent"),

    // Send message event
    SEND_MESSAGE_EVENT("sendMessageEvent")
}

enum class FlutterResponseEvent(val value: String) {
    // On listen message response event
    ON_LISTEN_MESSAGE_RESPONSE_EVENT("onListenMessageResponseEvent")
}

abstract class BaseActivity : FlutterActivity() {
    abstract fun initialRoute(): String

    abstract fun onListenMessageResponse(params: Map<String, Any>)

    // Chat channel
    protected lateinit var chatChannel: MethodChannel

    override fun getInitialRoute(): String? {
        return initialRoute()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Config PRIMARY_CHANNEL
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            FlutterMethodChannelType.PRIMARY_CHANNEL.value
        )
            .setMethodCallHandler { _, result ->
                result.success(result.notImplemented())
            }

        // Config CHAT_CHANNEL
        chatChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            FlutterMethodChannelType.CHAT_CHANNEL.value
        )

        // Register event
        chatChannel.setMethodCallHandler { call, result ->
            val arguments = call.arguments

            when (call.method) {
                FlutterCallEvent.SUBSCRIBE_CHAT_CHANNEL_EVENT.value -> {
                    // TODO: Subscribe to your server-side or whatever
                    result.success(null)
                }

                FlutterCallEvent.SEND_MESSAGE_EVENT.value -> {
                    if (arguments is Map<*, *>) {
                        @Suppress("UNCHECKED_CAST")
                        val argumentsMap =
                            arguments as? Map<String, Any> ?: return@setMethodCallHandler
                        onListenMessageResponse(argumentsMap)
                    } else {
                        // Handle the case where the arguments are not a Map
                        println("Arguments are not of the expected type")
                    }
                    result.success(null)
                }
            }
        }
    }
}