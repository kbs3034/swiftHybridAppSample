//
//  WebBridgeMessageHandler.swift
//  mEtopia
//
//  Created by sbk on 7/4/25.
//
import WebKit

class WebBridgeMessageHandler {
    
    var webView:WKWebView
    var viewController:UIViewController
    
    var nativeSystem:NativeSystem
    
    init(viewController:UIViewController, webView:WKWebView) {
        //viewController:UIViewController, webView:WKWebView, callback:RunCallbackScript
        
           
        self.webView = webView
        self.viewController = viewController
        
        self.nativeSystem = NativeSystem(viewController:viewController, webView:webView)
    }
    
    func handle(message:WKScriptMessage) {
        #if DEBUG
        print("📩 JS에서 받은 메시지:", message.body);
        #endif
        
        if(message.name == "NativeCall") {
            
            var body:[String:Any]? = self.parseJSONString(message.body as? String ?? "{}")
            var group:String = body?["group"] as? String ?? ""
            var functionKey:String = body?["functionKey"] as? String ?? ""
            print("📩 group : ", group);
            
            var bridge: BaseWebBridge?
            
            switch group {
            case "nativeSystem":
                bridge = nativeSystem
            default:
            #if DEBUG
                let msg = "\(String(describing: group))는 미개발된 기능입니다. 네이티브 담당자 확인이 필요합니다."
                let script = "console.log('\(msg)')"
                webView.evaluateJavaScript(script, completionHandler: nil)
            #endif
            }
            
            bridge?.exec(functionKey: functionKey, param: body ?? [:])
        } else {
            //TODO 미개발된 기능 메세지 처리
        }
    }
    
    func parseJSONString(_ json: String) -> [String: Any]? {
        guard let data = json.data(using: .utf8) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    }
 }

