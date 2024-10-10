

import Foundation

class MyMovieModel: NSObject {
    static let MY_MOVIE_JSON = "MY_MOVIE_JSON.json"

    var id: String = ""
    var date: String = ""
    var posterStr: String = ""
    var title: String = ""
    var urlSt: String = ""
    var overview: String = ""
    var tags: String = ""
    var mediaListStr: String = ""
    
    init(id: String,date: String ,posterStr: String, urlSt: String, overview: String, title: String, tags: String, mediaListStr: String) {
        self.id = id
        self.date = date
        self.posterStr = posterStr
        self.urlSt = urlSt
        self.overview = overview
        self.title = title
        self.tags = tags
        self.mediaListStr = mediaListStr
    }
    
    override init() {
        
    }
    
    init(_ dictionary: Dictionary) {
        if let val = dictionary["id"]  as? String {id = val}
        if let val = dictionary["date"]  as? String {date = val}
        if let val = dictionary["posterStr"]  as? String {posterStr = val}
        if let val = dictionary["title"]  as? String {title = val}
        if let val = dictionary["urlSt"]  as? String {urlSt = val }
        if let val = dictionary["overview"]  as? String {overview = val }
        if let val = dictionary["tags"]  as? String {tags = val }
        if let val = dictionary["mediaListStr"]  as? String {mediaListStr = val }
    }
    func toString() -> Dictionary {
        return [
            "id": id,
            "date": date,
            "posterStr": posterStr,
            "title": title,
            "urlSt": urlSt,
            "overview": overview,
            "tags": tags,
            "mediaListStr": mediaListStr
        ]
    }
   
    static func readSaveFileJson() -> [MyMovieModel] {
        let string = readString(fileName: MY_MOVIE_JSON)
        if string == nil || string == "" {
            return [MyMovieModel]()
        }
        let data: [Dictionary] = convertDataToJSON(data: (string?.data(using: .utf8))!) as! [[String: Any]]
        var result = [MyMovieModel]()
        for item in data {
            let model = MyMovieModel(item)
            result.append(model)
        }
        return result
    }
    
    static func saveFile(movieModel: MyMovieModel) {
        var list = MyMovieModel.readSaveFileJson()
        list.insert(movieModel, at: 0)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: list.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(string: jsonString, fileName: MY_MOVIE_JSON)
            }
        }catch {
            
        }
    }
    
    static func removeFile(movieModel: MyMovieModel) {
        var list = MyMovieModel.readSaveFileJson()
        list.removeAll { model in
            return model.id == movieModel.id
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: list.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                writeString(string: jsonString, fileName: MY_MOVIE_JSON)
            }
        }catch {
            
        }
    }
    
}
