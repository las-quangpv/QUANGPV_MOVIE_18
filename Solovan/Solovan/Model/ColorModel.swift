

import Foundation

class ColorModel: NSObject {
    static let COLOR_SAVE_JSON = "color_save.json"
    
    var colorHex: Int = 0x000000
    var tag: String = ""
    
    init(colorHex: Int, tag: String) {
        self.colorHex = colorHex
        self.tag = tag
    }
    
    func checkEqual(colorModel: ColorModel)-> Bool {
        if(colorHex == colorModel.colorHex && colorModel.tag == tag){
            return true
        }
        
        return false
    }
    
    override init() {
        
    }
    
    init(_ dictionary: Dictionary) {
        if let val = dictionary["colorHex"]  as? Int {
            colorHex = val
        }
        
        if let val = dictionary["tag"]  as? String {
            tag = val
        }
    }
    
    func toString() -> Dictionary {
        return [
            "colorHex": colorHex,
            "tag": tag
        ]
    }
    
    static func readSaveFileJson() -> [ColorModel] {
        let string = readString(fileName: COLOR_SAVE_JSON)
        if string == nil || string == "" {
            return [ColorModel]()
        }
        let data: [Dictionary] = convertDataToJSON(data: (string?.data(using: .utf8))!) as! [[String: Any]]
        var result = [ColorModel]()
        for item in data {
            let model = ColorModel(item)
            result.append(model)
        }
        return result
    }
    
    static func saveFile(colorModel: ColorModel) {
        var list = ColorModel.readSaveFileJson()
        list.insert(colorModel, at: 0)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: list.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(string: jsonString, fileName: COLOR_SAVE_JSON)
            }
        }catch {
            
        }
    }
    
}
