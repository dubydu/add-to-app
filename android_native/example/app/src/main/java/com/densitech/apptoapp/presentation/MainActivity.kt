package com.densitech.apptoapp.presentation

import android.os.Handler
import android.os.Looper
import com.densitech.apptoapp.presentation.base.BaseActivity
import com.densitech.apptoapp.presentation.base.FlutterEntryPoint
import com.densitech.apptoapp.presentation.base.FlutterResponseEvent
import java.text.SimpleDateFormat
import java.util.Locale

class MainActivity : BaseActivity() {
    private val autoReplyHandler = Handler(Looper.getMainLooper())
    private val dateFormatter = SimpleDateFormat("yy, MMM d, HH:mm:ss", Locale.getDefault())

    companion object {
        private const val AUTO_MESSAGE_DELAY_TIME = 10000L
    }

    override fun initialRoute(): String {
        return FlutterEntryPoint.CONVERSATION.value
    }

    override fun onListenMessageResponse(params: Map<String, Any>) {
        generateReplyMessage(params)
    }

    override fun onStart() {
        super.onStart()
        registerAutoReply()
    }

    override fun onStop() {
        super.onStop()
        unRegisterAutoReply()
    }

    private fun generateReplyMessage(params: Map<String, Any>) {
        val outGoingMessage = params["message"] as? String
        val inComingMessage =
            "Reply to message: ${outGoingMessage.orEmpty()} \nAt ${dateFormatter.format(System.currentTimeMillis())}"

        Handler(Looper.getMainLooper()).postDelayed({
            chatChannel.invokeMethod(
                FlutterResponseEvent.ON_LISTEN_MESSAGE_RESPONSE_EVENT.value,
                mapOf("message" to inComingMessage)
            )
        }, 1000)  // 1-second delay
    }

    private fun generateAutoMessage() {
        val inComingMessage =
            "Auto message \nAt ${dateFormatter.format(System.currentTimeMillis())}"
        chatChannel.invokeMethod(
            FlutterResponseEvent.ON_LISTEN_MESSAGE_RESPONSE_EVENT.value,
            mapOf("message" to inComingMessage)
        )
    }

    private val autoReplyRunnable = Runnable {
        run {
            generateAutoMessage()
            registerAutoReply()
        }
    }

    private fun registerAutoReply() {
        autoReplyHandler.postDelayed(autoReplyRunnable, AUTO_MESSAGE_DELAY_TIME)
    }

    private fun unRegisterAutoReply() {
        autoReplyHandler.removeCallbacks(autoReplyRunnable)
    }
}