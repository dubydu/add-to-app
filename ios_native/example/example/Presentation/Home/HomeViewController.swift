/*
  Copyright © 2021 DUBYDU

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

import UIKit

class HomeViewController: BaseFlutterViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(entryPoint: .conversation)
        super.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        generateAutoMessage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation(isHidden: true, titleString: "Home", hidesBackButton: true)
    }
    
    private func generateReplyMessage(params: [String : Any]) {
        let f = DateFormatter()
        f.dateFormat = "YY, MMM d, HH:mm:ss"
        let outGoingMessage = params["message"] as? String
        let inCommingMessage = "Reply to message: \(outGoingMessage ?? "") \nAt \(f.string(from: Date()))"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.chatChannel!.invokeMethod(
                FlutterResponseEvent.onListenMessageResponseEvent.rawValue,
                arguments: ["message": inCommingMessage]
            )
        }
    }
    
    private func generateAutoMessage() {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            let f = DateFormatter()
            f.dateFormat = "YY, MMM d, HH:mm:ss"
            let inCommingMessage = "Auto message \nAt \(f.string(from: Date()))"
            self.chatChannel!.invokeMethod(
                FlutterResponseEvent.onListenMessageResponseEvent.rawValue,
                arguments: ["message": inCommingMessage]
            )
        }
    }
}

/// MARK: - BaseFlutterViewDelegate
extension HomeViewController: BaseFlutterViewDelegate {
    func onListenMessageResponse(params: [String : Any]) {
        generateReplyMessage(params: params)
    }
}
