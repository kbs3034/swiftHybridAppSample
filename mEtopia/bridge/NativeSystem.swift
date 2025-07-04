//
//  NativeSystem.swift
//  mEtopia
//
//  Created by sbk on 7/4/25.
//


import Foundation
import WebKit

class NativeSystem: BaseWebBridge {
    
    //NativeSystem에서 callback script 실행전 특별 처리가 필요하거나, 커스텀이 필요하면 아래 함수 overriding 코드 주석을 해제하여
    //NativeSyste의 runCallbackScript를 재정의 한다.
    //override func runCallbackScript(callbackString: String, resultCode: String, msg: String, returnValue: Any) {
        //custom callback;
    //}
    
    override func exec(functionKey: String, param: [String: Any]) {
            var result: Any = "";
            var functionStr = "nativeSystem.\(functionKey)"
            var callbackString = param["callback"] ?? ""
            var data = param["data"] as? [String: Any]

            switch functionKey {

            case "bridgeTest":
                result = ["msg": "bridge test!!"]

            case "getAppVersionCode":
                if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                    result = version
                } else {
                    result = "version code not found"
                }

            case "getAppVersionName":
                if let versionName = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    result = versionName
                } else {
                    result = "version name not found"
                }

            case "buildType":
                #if DEBUG
                    result = "dev"
                #else
                    result = "prod"
                #endif

            case "copyClipboard":
                var str = data?["copyStr"] as? String
                UIPasteboard.general.string = str
                result = ["str": str]

            case "showToast":
                var message = data?["message"] as? String
                if let vc = viewController {
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    vc.present(alert, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        alert.dismiss(animated: true)
                    }
                }

            case "getDeviceInfo":
                result = [
                    "manufacturer": "Apple",
                    "model": UIDevice.current.model,
                    "osVersion": UIDevice.current.systemVersion
                ]

            case "restart":
                // iOS는 앱을 프로그래밍적으로 재시작할 수 없음
                result = "restart not supported on iOS"

            case "closeApp":
                exit(0)

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
