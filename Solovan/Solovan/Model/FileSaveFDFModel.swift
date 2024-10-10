

import Foundation


class FileSaveFDFModel: NSObject {
    static  let FILE_PDF_JSON = "FILE_PDF_JSON.json"

    var fileName: String = ""
    var fileSize: Int64?
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
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).pdf")
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                url = fileURL
                fileSize = FileSaveFDFModel.getFileSize(fileURL: fileURL)
            }
        }
    }
    
    static func readSaveFileJson() -> [FileSaveFDFModel] {
        let string = readString(fileName: FILE_PDF_JSON)
        if string == nil || string == "" {
            return [FileSaveFDFModel]()
        }
        let data: [Dictionary] = convertDataToJSON(data: (string?.data(using: .utf8))!) as! [Dictionary]
        var result = [FileSaveFDFModel]()
        for item in data {
            let model = FileSaveFDFModel(item)
            result.append(model)
        }
        return result
    }
    
    static func saveFile(fileModel: FileSaveFDFModel, completion: ((Bool) -> Void)) {
        var list = FileSaveFDFModel.readSaveFileJson()
        list.insert(fileModel, at: 0)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: list.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(string: jsonString, fileName: FILE_PDF_JSON)
                completion(true)
                return
            }
        }catch {
            completion(false)
        }
        
    }
    
    static func removeFile(fileModel: FileSaveFDFModel) {
        var list = FileSaveFDFModel.readSaveFileJson()
        list.removeAll { model in
            return model.fileName == fileModel.fileName
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: list.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(string: jsonString, fileName: FILE_PDF_JSON)
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
