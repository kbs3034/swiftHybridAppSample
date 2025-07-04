//
//  ViewController.swift
//  mEtopia
//
//  Created by sbk on 7/3/25.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler {
    
    var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let contentController = WKUserContentController()
        contentController.add(self, name: "NativeCall")

        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        self.webView = WKWebView(frame: .zero, configuration: config)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.webView)

        // Auto Layout 수동 설정
        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: view.topAnchor),
            self.webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        self.webView.configuration.userContentController = contentController
        self.webView.isInspectable = true
        
        // 기존 userAgent 불러와서 iOSApp 추가
        self.webView.evaluateJavaScript("navigator.userAgent") { result, error in
            if let ua = result as? String {
                let customUA = ua + " ETOPIA_IOS"
                self.webView.customUserAgent = customUA
            }
        }
        
        // 외부 또는 내부 HTML 파일 로드 (예시: 내부 파일)
        if let htmlPath = Bundle.main.path(forResource: "index", ofType: "html") {
            let htmlURL = URL(fileURLWithPath: htmlPath)
            self.webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL)
        }
        
    }
    
    // JavaScript → Swift 호출 처리
    func userContentController(_ userContentController: WKUserContentController, didReceive message:WKScriptMessage) {
        let webBridge = WebBridgeMessageHandler(viewController: self, webView: self.webView)
        webBridge.handle(message: message);
        
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "JS 호출", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

