//
//  NativeSystem.swift
//  mEtopia
//
//  Created by sbk on 7/4/25.
//


import Foundation
import WebKit

class RxBusBridge: BaseWebBridge {
    
    
//    override func runCallbackScript(callbackString: String?, resultCode: String, msg: String, returnValue: (Any)?) {
//    }
    
    override func exec(functionKey: String, param: [String: Any]) {
            var result: Any = "";
            var functionStr = "RxBus.\(functionKey)"
            var callbackString = param["callback"] ?? ""
            var data = param["data"] as? [String: Any]

            switch functionKey {

            case "RxBusTest":
            #if DEBUG
                //RxBus 1회성 구독
                RxBus.shared.observe(RxTestEvent.self).take(1)
                    .subscribe(onNext: { event in
                        self.runCallbackScript(callbackString: callbackString as! String, returnValue: event.data)
                    })
                    .disposed(by: RxBus.shared.disposeBag)
                    
                // 테스트 화면 띄우기
                let testVC = RxBusTestViewController()
                testVC.modalPresentationStyle = .fullScreen
                self.viewController?.present(testVC, animated: true)
                
                //콜백 안타고 넘어가도록.
                return
            #endif

            default:
            #if DEBUG
                let msg = "\(functionStr)는 미개발된 기능입니다. 네이티브 담당자 확인이 필요합니다."
                let script = "console.log('\(msg)')"
                webView.evaluateJavaScript(script, completionHandler: nil)
            #endif
            }

            // 콜백 스크립트 실행
            self.runCallbackScript(callbackString: callbackString as! String, returnValue: result)
        }
}
