import UIKit

enum BookmarkType: String {
    case movie = "MovieBookmark"
    case tvShow = "TvShowBookmark"
    case cast = "CastBookmark"
    
    case movieNotAvaiable = "MovieNotAvaiable"
    case tvShowNotAvaiable = "TvShowNotAvaiable"
}

class BookmarkService: NSObject {
    
    static let shared: BookmarkService = BookmarkService()
    
    override init() {}
    
    // MARK: - private
    private func getURLFileJson(type: BookmarkType) -> URL? {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileUrl = documentURL.appendingPathComponent("\(type.rawValue).json")
        return fileUrl
    }
    
    private func saveDataJson(data: [Any], type: BookmarkType) -> Bool {
        guard let fileUrl = getURLFileJson(type: type) else { return false }
        
        do {
            var listData = [NSDictionary]()
            
            for item in data {
                if type == .movie {
                    listData.append((item as! Movie).dictionary)
                } else if type == .tvShow {
                    listData.append((item as! TvShow).dictionary)
                } else if type == .cast {
                    listData.append((item as! MovieCast).dictionary)
                } else if type == .movieNotAvaiable {
                    listData.append((item as! VideoTrailer).dictionary)
                } else if type == .tvShowNotAvaiable {
                    listData.append((item as! VideoTrailer).dictionary)
                }
            }
            
            let data = try JSONSerialization.data(withJSONObject: listData, options: .prettyPrinted)
            try data.write(to: fileUrl, options: [])
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - public
    func getListBookmark(type: BookmarkType) -> [Any] {
        guard let url = getURLFileJson(type: type) else { return [] }
        
        do {
            let data = try Data(contentsOf: url)
            
            if type == .movie {
                let listMovie: [Movie] = try JSONDecoder().decode([Movie].self, from: data)
                return listMovie
            } else if type == .tvShow {
                let listMovie: [TvShow] = try JSONDecoder().decode([TvShow].self, from: data)
                return listMovie
            } else if type == .cast {
                let listMovie: [MovieCast] = try JSONDecoder().decode([MovieCast].self, from: data)
                return listMovie
            } else if type == .movieNotAvaiable {
                let listMovie: [VideoTrailer] = try JSONDecoder().decode([VideoTrailer].self, from: data)
                return listMovie
            } else if type == .tvShowNotAvaiable {
                let listMovie: [VideoTrailer] = try JSONDecoder().decode([VideoTrailer].self, from: data)
                return listMovie
            }
        } catch { }
        return []
    }
    
    @discardableResult
    func addBookmark(data: Any, type: BookmarkType) -> Bool {
        if checkIsBookmark(item: data, type: type) {
            return false
        }
        else {
            // insert history at index 0
            var listNewData = getListBookmark(type: type)
            listNewData.insert(data, at: 0)
            
            // save to file
            return saveDataJson(data: listNewData, type: type)
        }
    }
    
    @discardableResult
    func deleteBookmark(item: Any, type: BookmarkType) -> Bool {
        if checkIsBookmark(item: item, type: type) {
            switch type {
            case .movie:
                guard var listMovie = getListBookmark(type: type) as? [Movie] else { return false }
                
                listMovie.removeAll(where: { $0.id == (item as! Movie).id })
                return saveDataJson(data: listMovie, type: type)
                
            case .tvShow:
                guard var listTvShow = getListBookmark(type: type) as? [TvShow] else { return false }
                
                listTvShow.removeAll(where: { $0.id == (item as! TvShow).id })
                return saveDataJson(data: listTvShow, type: type)
            case .cast:
                guard var listCast = getListBookmark(type: type) as? [MovieCast] else { return false }
                
                listCast.removeAll(where: { $0.id == (item as! MovieCast).id })
                return saveDataJson(data: listCast, type: type)
            case .movieNotAvaiable:
                guard var listMovie = getListBookmark(type: type) as? [VideoTrailer] else { return false }
                
                listMovie.removeAll(where: { $0.id == (item as! VideoTrailer).id })
                return saveDataJson(data: listMovie, type: type)
                
            case .tvShowNotAvaiable:
                guard var listTvShow = getListBookmark(type: type) as? [VideoTrailer] else { return false }
                
                listTvShow.removeAll(where: { $0.id == (item as! VideoTrailer).id })
                return saveDataJson(data: listTvShow, type: type)
            }
        }
        return false
    }
    
    @discardableResult
    func checkIsBookmark(item: Any, type: BookmarkType) -> Bool {
        switch type {
        case .movie:
            return checkIsBookmark(id: (item as! Movie).id, type: type)
        case .tvShow:
            return checkIsBookmark(id: (item as! TvShow).id, type: type)
        case .cast:
            return checkIsBookmark(id: (item as! MovieCast).id, type: type)
        case .movieNotAvaiable:
            return checkIsBookmark(id: (item as! VideoTrailer).id, type: type)
        case .tvShowNotAvaiable:
            return checkIsBookmark(id: (item as! VideoTrailer).id, type: type)
        }
    }
    
    @discardableResult
    func checkIsBookmark(id: Int, type: BookmarkType) -> Bool {
        switch type {
        case .movie:
            guard let listMovie = getListBookmark(type: type) as? [Movie] else { return false }
            
            if listMovie.first(where: { $0.id == id }) != nil {
                return true
            }
            else {
                return false
            }
        case .tvShow:
            guard let listTvShow = getListBookmark(type: type) as? [TvShow] else { return false }
            
            if listTvShow.first(where: { $0.id == id }) != nil {
                return true
            }
            else {
                return false
            }
        case .cast:
            guard let listTvShow = getListBookmark(type: type) as? [MovieCast] else { return false }
            
            if listTvShow.first(where: { $0.id == id }) != nil {
                return true
            }
            else {
                return false
            }
        case .movieNotAvaiable:
            guard let listMovie = getListBookmark(type: type) as? [VideoTrailer] else { return false }
            
            if listMovie.first(where: { $0.id == id && $0.type == type.rawValue}) != nil {
                return true
            }
            else {
                return false
            }
        case .tvShowNotAvaiable:
            guard let listTvShow = getListBookmark(type: type) as? [VideoTrailer] else { return false }
            
            if listTvShow.first(where: { $0.id == id && $0.type == type.rawValue}) != nil {
                return true
            }
            else {
                return false
            }
        }
    }
    
    @discardableResult
    func resetBookmark(type: BookmarkType)  -> Bool{
        switch type {
        case .movie:
            guard var listMovie = getListBookmark(type: type) as? [Movie] else { return false }
            listMovie.removeAll(where: { $0.id != 0 })
            return saveDataJson(data: listMovie, type: type)
            
        case .tvShow:
            guard var listTvShow = getListBookmark(type: type) as? [TvShow] else { return false }
            listTvShow.removeAll(where: { $0.id != 0 })
            return saveDataJson(data: listTvShow, type: type)
        case .cast:
            guard var listCast = getListBookmark(type: type) as? [MovieCast] else { return false }
            listCast.removeAll(where: { $0.id != 0 })
            return saveDataJson(data: listCast, type: type)
        case .movieNotAvaiable:
            return true
        case .tvShowNotAvaiable:
            return true
        }
    }
    
}
