import UIKit

enum HistoryType: String {
    case movie = "MovieHistory"
    case tvShow = "TvShowHistory"
}

class HistoryService: NSObject {
    
    static let shared: HistoryService = HistoryService()
    
    override init() {}
    
    // MARK: - private
    private func getURLFileJson(type: HistoryType) -> URL? {
        guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileUrl = documentURL.appendingPathComponent("\(type.rawValue).json")
        return fileUrl
    }
    
    private func saveDataJson(data: [Any], type: HistoryType) -> Bool {
        guard let fileUrl = getURLFileJson(type: type) else { return false }
        
        do {
            var listData = [NSDictionary]()
            
            for item in data {
                if type == .movie {
                    listData.append((item as! Movie).dictionary)
                }
                else if type == .tvShow {
                    listData.append((item as! TvShow).dictionary)
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
    func getListHistory(type: HistoryType) -> [Any] {
        guard let url = getURLFileJson(type: type) else { return [] }
        
        do {
            let data = try Data(contentsOf: url)
            
            if type == .movie {
                let listMovie: [Movie] = try JSONDecoder().decode([Movie].self, from: data)
                return listMovie
            }
            else if type == .tvShow {
                let listMovie: [TvShow] = try JSONDecoder().decode([TvShow].self, from: data)
                return listMovie
            }
            
        } catch { }
        return []
    }
    
    @discardableResult
    func addHistory(data: Any, type: HistoryType) -> Bool {
        // [option] delete item ensure on history only a data
        deleteHistory(item: data, type: type)
        
        // re-insert history at index 0
        var listNewData = getListHistory(type: type)
        listNewData.insert(data, at: 0)
        
        // save to file
        return saveDataJson(data: listNewData, type: type)
    }
    
    @discardableResult
    func deleteHistory(item: Any, type: HistoryType) -> Bool {
        if checkIsHistory(item: item, type: type) {
            switch type {
            case .movie:
                guard var listMovie = getListHistory(type: type) as? [Movie] else { return false }
                
                listMovie.removeAll(where: { $0.id == (item as! Movie).id })
                return saveDataJson(data: listMovie, type: type)
                
            case .tvShow:
                guard var listTvShow = getListHistory(type: type) as? [TvShow] else { return false }
                
                listTvShow.removeAll(where: { $0.id == (item as! TvShow).id })
                return saveDataJson(data: listTvShow, type: type)
            }
        }
        return false
    }
    
    @discardableResult
    func checkIsHistory(item: Any, type: HistoryType) -> Bool {
        switch type {
        case .movie:
            guard let listMovie = getListHistory(type: type) as? [Movie] else { return false }
            
            if listMovie.first(where: { $0.id == (item as! Movie).id }) != nil {
                return true
            }
            else {
                return false
            }
        case .tvShow:
            guard let listTvShow = getListHistory(type: type) as? [TvShow] else { return false }
            
            if listTvShow.first(where: { $0.id == (item as! TvShow).id }) != nil {
                return true
            }
            else {
                return false
            }
        }
    }
    
}

