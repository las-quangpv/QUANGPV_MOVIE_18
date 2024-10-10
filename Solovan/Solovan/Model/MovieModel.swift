

import Foundation
class MovieModel: NSObject {
    var backdropPath: String = ""//
    var posterPath: String = ""
    var releaseDate: String = ""
    var title: String = ""
    override init() {
        
    }
    
    init(_ dictionary: Dictionary) {
        
        if let val = dictionary["poster_path"] as? String { posterPath = val }
        if let val = dictionary["backdrop_path"] as? String { backdropPath = val }
        if let val = dictionary["release_date"] as? String { releaseDate = val }
        if let val = dictionary["title"] as? String { title = val }
        
    }
    
    func toString() -> Dictionary {
        return [
            "poster_path": posterPath,
            "backdrop_path": backdropPath,
            "release_date": releaseDate,
            "title": title]
    }
    
}
