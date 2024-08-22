/*
  Copyright © 2024 DUBYDU

  This software is provided 'as-is', without any express or implied warranty.
  In no event will the authors be held liable for any damages arising from
  the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
  claim that you wrote the original software. If you use this software in a
  product, an acknowledgment in the product documentation would be
  appreciated but is not required.

  2. Altered source versions must be plainly marked as such, and must not be
  misrepresented as being the original software.

  3. This notice may not be removed or altered from any source distribution.
 */

import Foundation
import Flutter
import FlutterPluginRegistrant

enum FlutterEntryPoint : String {
    case conversation = "entryConversationScreen"
}

enum FlutterMethodChannelType: String {
    // Primary channel
    case primaryChannel

    // Chat channel
    case chatChannel
}

enum FlutterCallEvent: String {
    // Subscribe to the chat channel
    case subscribeChatChannelEvent
    
    // Send message event
    case sendMessageEvent
}

/// FlutterResponseEvent
enum FlutterResponseEvent: String {
  // On listen message response event
  case onListenMessageResponseEvent
}


class BaseFlutterViewController: FlutterViewController {
    // Main channel
    var mainChannel: FlutterMethodChannel?
    
    // Chat channel
    var chatChannel: FlutterMethodChannel?

    // BaseFlutterViewDelegate
    weak var delegate: BaseFlutterViewDelegate?
    
    init(entryPoint: FlutterEntryPoint) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let newEngine = appDelegate.flutterEngine.makeEngine(
            withEntrypoint: entryPoint.rawValue,
            libraryURI: nil
        )
        GeneratedPluginRegistrant.register(with: newEngine)
        super.init(engine: newEngine, nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Background Color
        self.view.backgroundColor = .white
        
        // Handle the main channel
        mainChannel = FlutterMethodChannel(
            name: FlutterMethodChannelType.primaryChannel.rawValue,
            binaryMessenger: self.engine!.binaryMessenger
        )
        mainChannel!.setMethodCallHandler {[weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let _ = self else {
                result(nil)
                return
            }
            result(FlutterMethodNotImplemented)
        }
        
        // Handle the chat channel
        chatChannel = FlutterMethodChannel(
            name: FlutterMethodChannelType.chatChannel.rawValue,
            binaryMessenger: self.engine!.binaryMessenger
        )
        chatChannel!.setMethodCallHandler {[weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else {
                result(nil)
                return
            }
            let method = FlutterCallEvent(rawValue: call.method)
            let arguments = call.arguments as? [String: Any]
            switch method {
            case .subscribeChatChannelEvent:
                // TODO: Subscribe to your server-side or whatever
                result(nil)
            case .sendMessageEvent:
                guard let arguments = arguments else {
                    result(nil)
                    return
                }
                self.delegate?.onListenMessageResponse(params: arguments)
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    func setNavigation(isHidden: Bool = false, titleString: String = "",
                       hidesBackButton: Bool = false) {
        /// Navigation state
        self.navigationController?.setNavigationBarHidden(isHidden, animated: false)
        self.navigationItem.setHidesBackButton(hidesBackButton, animated: false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

        /// Clear background
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear

        /// Remove 1px bottom line
        appearance.shadowImage = UIImage()
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance

        self.title = titleString
    }
}
