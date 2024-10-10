

import Foundation


class SaveVideoModel: NSObject {
    static  let SAVE_VIDEO_JSON = "SAVE_VIDEO_JSON.json"

    var fileName: String = ""
    var duration: String = "00:00"
    var url: URL?
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    override init() {
        
    }
    
    func toString() -> Dictionary {
        return [
            "fileName": fileName
        ]
    }
   
    
    init(_ dictionary: Dictionary) {
        if let val = dictionary["fileName"]  as? String {
            fileName = val
            url = fileName.getUrlFromFileName()
            if let url = url {
                duration = getVideoDuration(from: url)
            }
           
           
        }
    }
    
    static func readSaveFileJson() -> [SaveVideoModel] {
        let string = readString(fileName: SAVE_VIDEO_JSON)
        if string == nil || string == "" {
            return [SaveVideoModel]()
        }
        let data: [Dictionary] = convertDataToJSON(data: (string?.data(using: .utf8))!) as! [Dictionary]
        var result = [SaveVideoModel]()
        for item in data {
            let model = SaveVideoModel(item)
            result.append(model)
        }
        return result
    }
    
    static func saveFile(fileModel: SaveVideoModel, completion: ((Bool) -> Void)) {
        var list = SaveVideoModel.readSaveFileJson()
        list.insert(fileModel, at: 0)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: list.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(string: jsonString, fileName: SAVE_VIDEO_JSON)
                completion(true)
                return
            }
        }catch {
            completion(false)
        }
        
    }
    
    static func removeFile(fileModel: SaveVideoModel) {
        var list = SaveVideoModel.readSaveFileJson()
        list.removeAll { model in
            return model.fileName == fileModel.fileName
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: list.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(string: jsonString, fileName: SAVE_VIDEO_JSON)
            }
        }catch {
            
        }
    }
    
    static func getFileSize(fileURL: URL) -> Int64? {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
            if let fileSize = attributes[.size] as? Int64 {
                return fileSize
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
