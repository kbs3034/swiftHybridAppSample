//
//  baseWebBridge.swift
//  mEtopia
//
//  Created by sbk on 7/4/25.
//

import Foundation
import WebKit

class BaseWebBridge : RunCallbackScript{
    
    var viewController:UIViewController?
    var webView: WKWebView

    init(viewController:UIViewController, webView:WKWebView){
        //브릿지 콜백함수
        self.viewController = viewController
        self.webView = webView
    }
    
    //공통적으로 사용될 콜백 함수
    override func runCallbackScript(callbackString callback: String?, resultCode: String, msg: String, returnValue: Any?) {
        DispatchQueue.main.async {
            do {
                var callbackName = callback ?? ""
                
                // 상태(status) JSON 구성
                let status: [String: Any] = [
                    "code": resultCode,
                    "msg": msg
                ]

                // 전체 응답(response) JSON 구성
                var response: [String: Any] = [
                    "status": status,
                    "data": returnValue ?? ""
                ]
                
                // JSON → 문자열로 변환
                let responseData = try JSONSerialization.data(withJSONObject: response, options: [])
                var responseString = String(data: responseData, encoding: .utf8) ?? "{}"
                
                // 문자열 escape 처리 (큰따옴표나 줄바꿈 등)
                responseString = responseString.replacingOccurrences(of: "'", with: "\\'")
                
                #if DEBUG
                print("📤 콜백으로 보내는 것 >", responseString)
                #endif
                
                if callbackName.isEmpty {
                    #if DEBUG
                    callbackName = "alert"
                    #endif
                }
                
                let js = "\(callbackName)('\(responseString)')"
                self.webView.evaluateJavaScript(js, completionHandler: nil)
                
            } catch {
                print("❌ 콜백 실패:", error.localizedDescription)
            }
        }
    }
    
    //브릿지 실행 함수
    func exec(functionKey:String , param:[String:Any]){};
    
    //필수값 체크 함수
    func validationParam(param:[String: Any], fields:[String], callBackString:String) -> Bool {
        var result:Bool = true
        var emptyField: String = ""
        
        for field in fields {
            if param[field] == nil || (param[field] as? String)?.isEmpty == false {
                result = false
                emptyField = field
                break
            }
        }
        
        if !result {
            self.runCallbackScript(callbackString: callBackString,resultCode: "-1",msg: "Error : "+emptyField+" 입력해주세요.", returnValue: [String: Any]());
        }

        return result;
    }
}
