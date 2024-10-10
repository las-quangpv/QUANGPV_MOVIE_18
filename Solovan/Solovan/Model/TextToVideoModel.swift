//
//  TextToVideoModel.swift
//  GeneralVideo
//
//  Created by Mac on 14/7/24.
//

import Foundation
class TextToVideoModel: NSObject {
    var tip: String = ""
    var id: Int = 0
    var status: String = ""
    var output: [String] = []
    
    override init() {
        
    }
    
    init(dic: [String: Any]) {
        if let val = dic["tip"] as? String {
            tip = val
        }
        
        if let val = dic["id"] as? Int {
            id = val
        }
        
        if let val = dic["status"] as? String {
            status = val
        }
        
        if let val = dic["output"] as? [String] {
            output = val
        }
    }
}
