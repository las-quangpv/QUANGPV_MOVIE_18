

import Foundation

class PlaylistModel: NSObject {
    static let PLAYLIST_JSON = "PLAYLIST_JSON.json"
    
    var id: String = ""
    var icon: String = ""
    var title: String = ""
    var color: Int = 0x000000
    var movieStrList: String = ""
    
    init(id: String, icon: String,title: String, color: Int, movieStrList: String) {
        self.id = id
        self.icon = icon
        self.title = title
        self.color = color
        self.movieStrList = movieStrList
    }
    
    override init() {
        
    }
    
    
    init(_ dictionary: Dictionary) {
        if let val = dictionary["id"]  as? String {id = val}
        if let val = dictionary["title"]  as? String {title = val}
        if let val = dictionary["icon"]  as? String {icon = val}
        if let val = dictionary["color"]  as? Int {color = val}
        if let val = dictionary["movieStrList"]  as? String  {movieStrList = val}
    }
    func toString() -> Dictionary {
        return [
            "id": id,
            "title": title,
            "icon": icon,
            "color": color,
            "movieStrList": movieStrList
        ]
    }
   
    static func readSaveFileJson() -> [PlaylistModel] {
        let string = readString(fileName: PLAYLIST_JSON)
        if string == nil || string == "" {
            return [PlaylistModel]()
        }
        let data: [Dictionary] = convertDataToJSON(data: (string?.data(using: .utf8))!) as! [[String: Any]]
        var result = [PlaylistModel]()
        for item in data {
            let model = PlaylistModel(item)
            result.append(model)
        }
        return result
    }
    
    static func saveFile(playListModel: PlaylistModel) {
        var list = PlaylistModel.readSaveFileJson()
        list.insert(playListModel, at: 0)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: list.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(string: jsonString, fileName: PLAYLIST_JSON)
            }
        }catch {
            
        }
    }
    
    static func removeFile(playListModel: PlaylistModel) {
        var list = PlaylistModel.readSaveFileJson()
        list.removeAll { model in
            return model.id == playListModel.id
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: list.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(string: jsonString, fileName: PLAYLIST_JSON)
            }
        }catch {
            
        }
    }
}
