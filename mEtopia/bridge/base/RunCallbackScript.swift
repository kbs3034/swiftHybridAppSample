//
//  RunCallbackScript.swift
//  mEtopia
//
//  Created by sbk on 7/4/25.
//

class RunCallbackScript {
    func runCallbackScript(callbackString:String, resultCode:String, msg:String, returnValue:Any) {}
    func runCallbackScript(callbackString:String, returnValue:Any){
        self.runCallbackScript(callbackString: callbackString, resultCode: "0", msg: "처리 완료되었습니다.", returnValue: returnValue)
    }
}
