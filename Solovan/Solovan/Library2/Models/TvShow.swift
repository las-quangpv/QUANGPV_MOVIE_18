import Foundation
import UIKit

struct TvShowResponse: Decodable {
    let results: [TvShow]
}

struct TvShow: Decodable, Identifiable {
    //
    let id: Int
    let name: String
    let backdrop_path: String?
    let poster_path: String?
    let overview: String
    let vote_average: Double
    let vote_count: Int
    let first_air_date: String?
    let genre_ids: [Int]?
    let original_language: String?
    
    let character: String?
    
    //
    let genres: [Genre]?
    let credits: TvShowCreditResponse?
    let videos: TvShowVideoResponse?
    let images: TvShowImageResponse?
    let networks: [TvShowNetwork]?
    let seasons: [TvShowSeason]?
    
    var dictionary: NSDictionary  {
        return ["id": id,
                "name": name,
                "backdrop_path": backdrop_path as Any,
                "poster_path": poster_path  as Any,
                "overview": overview,
                "vote_average": vote_average,
                "vote_count": vote_count,
                "first_air_date": first_air_date  as Any,
                "genre_ids": genre_ids  as Any,
                "character": character  as Any,
                
                "genres": genreList  as Any,
                "credits": credits?.dictionary  as Any,
                "videos": videos?.dictionary as Any,
                "images": images?.dictionary  as Any,
                "networks": tvNetworkList  as Any,
                "seasons": seasonList
                ]
    }
    
    var backdropURL: URL? {
        return UtilService.makeURLImage(backdrop_path)
    }
    
    var posterURL: URL? {
        return UtilService.makeURLImage(poster_path)
    }
    
    var imdbStr: String {
        return String(format: "%.1f/10", vote_average)
    }
    
    var voteAverageStr: String {
        return String(format: "%.1f", vote_average)
    }
    
    var ratingStr: String {
        return String(format: "%.1f/10 IMDb", vote_average)
    }
    
    var ratingStar: NSMutableAttributedString {
        let rating = Int(vote_average/2)
        
        let fullString = NSMutableAttributedString()
        
        let starActive = NSTextAttachment()
        starActive.image = UIImage(named: "ic_star.png")
        let starActiveStr = NSAttributedString(attachment: starActive)
        
        let starInActive = NSTextAttachment()
        starInActive.image = UIImage(named: "ic_star_inactive.png")
        let starInActiveStr = NSAttributedString(attachment: starInActive)
        
        for _ in 0..<rating {
            fullString.append(NSAttributedString(string: " "))
            fullString.append(starActiveStr)
        }
        for _ in rating..<5 {
            fullString.append(NSAttributedString(string: " "))
            fullString.append(starInActiveStr)
        }
        
        fullString.append(NSAttributedString(string: " "))
        fullString.append(NSAttributedString(string: voteAverageStr))
        return fullString
    }
    
    var firstAirStr: String {
        guard let first_air_date = self.first_air_date else {
            return not_available
        }
        
        if let date = UtilService.dateFormatter.date(from: first_air_date) {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd, yyyy"
            return dateFormatterPrint.string(from: date)
        } else {
            return not_available
        }
    }
    
    var firstYearStr: String {
        guard let first_air_date = self.first_air_date else {
            return not_available
        }
        guard let date = UtilService.dateFormatter.date(from: first_air_date) else {
            return not_available
        }
        return UtilService.yearFormatter.string(from: date)
    }
    
    var firstAirTimestamp: TimeInterval {
        guard let first_air_date = self.first_air_date else {
            return 0
        }
        
        if let date = UtilService.dateFormatter.date(from: first_air_date) {
            return date.timeIntervalSince1970
        }
        return 0
    }
    
    var releaseCompany: String {
        guard let releaseDate = self.first_air_date else {
            return not_available
        }
        
        if let date = UtilService.dateFormatter.date(from: releaseDate) {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd/MM/yyyy"
            return dateFormatterPrint.string(from: date) + " (" + (original_language?.uppercased() ?? not_available ) + ")"
        } else {
            return not_available
        }
    }
    
    var genresName: [String] {
        if let _genres = genres {
            return _genres.map({ $0.name })
        }
        else {
            if let _ids = genre_ids {
                return TVSGenreVM.shared.data.filter({ _ids.contains($0.id) }).map({ $0.name })
            }
        }
        return []
    }
    
    var genreStr: String {
        if let _genres = genres {
            return _genres.map({ $0.name }).joined(separator: ", ")
        }
        else {
            if let _ids = genre_ids {
                return TVSGenreVM.shared.data.filter({ _ids.contains($0.id) }).map({ $0.name }).joined(separator: ", ")
            }
        }
        return not_available
    }
    
    var genreList: [NSDictionary] {
        var listGenres = [NSDictionary]()
        
        guard let genres = genres else {
            return []
        }
        for genre in genres {
            listGenres.append(genre.dictionary)
        }
        return listGenres
    }
    
    var tvNetworkList: [NSDictionary] {
        var listNetwork = [NSDictionary]()
        
        guard let networks = networks else {
            return []
        }

        for network in networks {
            listNetwork.append(network.dictionary)
        }
        return listNetwork
    }
    
    var seasonList: [NSDictionary] {
        var listSeason = [NSDictionary]()
        
        guard let seasons = seasons else {
            return []
        }

        for season in seasons {
            listSeason.append(season.dictionary)
        }
        return listSeason
    }
    
    var directors: [TvShowCrew]? {
        crew?.filter {
            $0.job.lowercased() == "director"
        }
    }
    
    var cast: [TvShowCast]? {
        credits?.cast
    }
    
    var crew: [TvShowCrew]? {
        credits?.crew
    }
    var youtubeTrailers: [TvShowVideo]? {
        videos?.results.filter {
            $0.youtubeURL != nil
        }
    }
}

struct TvShowCreditResponse: Decodable {
    let cast: [TvShowCast]
    let crew: [TvShowCrew]
    
    var dictionary : NSDictionary {
        return [
            "cast":tvShowCastList,
            "crew":tvShowCrewList
        ]
    }
    
    var tvShowCastList: [NSDictionary] {
        var listCast = [NSDictionary]()
        for castObject in cast {
            listCast.append(castObject.dictionary)
        }
        return listCast
    }
    
    var tvShowCrewList: [NSDictionary] {
        var listCrew = [NSDictionary]()
        for crewObject in crew {
            listCrew.append(crewObject.dictionary)
        }
        return listCrew
    }
}

struct TvShowCast: Decodable, Identifiable {
    let id: Int
    let character: String
    let name: String
    let known_for_department: String?
    let profile_path: String?
    
    var dictionary: NSDictionary {
        return [
                "id": id,
                "character": character,
                "name": name,
                "known_for_department": known_for_department as Any,
                "profile_path": profile_path as Any
                ]
    }
    
    var profileURL: URL? {
        return UtilService.makeURLImage(profile_path)
    }
    
}
struct TvShowCrew: Decodable, Identifiable {
    let id: Int
    let job: String
    let name: String
    let known_for_department: String?
    let profile_path: String?
    
    var dictionary: NSDictionary {
        return [
                "id": id,
                "job": job,
                "name": name,
                "known_for_department": known_for_department as Any,
                "profile_path": profile_path as Any
                ]
    }
    
    var profileURL: URL? {
        return UtilService.makeURLImage(profile_path)
    }
}

struct TvShowVideoResponse: Decodable {
    let results: [TvShowVideo]
    
    var dictionary : NSDictionary {
        return [
            "results":movieVideoList
        ]
    }
    
    var movieVideoList: [NSDictionary] {
        var listVideo = [NSDictionary]()
        for video in results {
            listVideo.append(video.dictionary)
        }
        return listVideo
    }
}

struct TvShowVideo: Decodable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    
    var dictionary: NSDictionary {
        return [
                "id": id,
                "key": key,
                "name": name,
                "site": site
                ]
    }
    
    var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://youtube.com/embed/\(key)")
    }
    
    var youtubeThumbnailURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://i.ytimg.com/vi/\(key)/hqdefault.jpg")
    }
}

struct TvShowImageResponse: Decodable {
    let backdrops: [TvShowImageItem]
    let logos: [TvShowImageItem]
    let posters: [TvShowImageItem]
    
    var dictionary : NSDictionary {
        return [
            "backdrops":tvShowImageList(data: backdrops),
            "logos":tvShowImageList(data: logos),
            "posters":tvShowImageList(data: posters)
        ]
    }
    
    func  tvShowImageList(data:[TvShowImageItem]) -> [NSDictionary] {
        var listImage = [NSDictionary]()
        for image in data {
            listImage.append(image.dictionary)
        }
        return listImage
    }
}

struct TvShowImageItem: Decodable {
    let aspect_ratio: Double
    let height: Int?
    let width: Int?
    let iso_639_1: String?
    let file_path: String?
    let vote_average: Double?
    let vote_count: Int?
    
    var dictionary: NSDictionary {
        return [
                "aspect_ratio": aspect_ratio,
                "height": height as Any,
                "width": width as Any,
                "iso_639_1": iso_639_1 as Any,
                "file_path": file_path as Any,
                "vote_average": vote_average as Any,
                "vote_count": vote_count as Any
                ]
    }
    
    var filePathURL: URL? {
        return UtilService.makeURLImage(file_path)
    }
}

struct TvShowNetwork: Decodable, Identifiable {
    let id: Int
    let name: String?
    let logo_path: String?
    let origin_country: String?
    
    var dictionary: NSDictionary {
        return [
                "id": id,
                "name": name as Any,
                "logo_path": logo_path as Any,
                "origin_country": origin_country as Any
                ]
    }
    
    var logoURL: URL? {
        return UtilService.makeURLImage(logo_path)
    }
}

struct TvShowSeason: Decodable, Identifiable {
    let id: Int
    let air_date: String?
    let episode_count: Int?
    let name: String?
    let overview: String?
    let poster_path: String?
    let season_number: Int?
    let episodes: [TvShowEpisode]?
    
    var dictionary: NSDictionary {
        return [
                "id": id,
                "air_date": air_date as Any,
                "episode_count": episode_count as Any,
                "name": name as Any,
                "overview": overview as Any,
                "poster_path": poster_path as Any,
                "season_number": season_number as Any,
                "episodes": episodeList
                ]
    }
    
    var posterURL: URL? {
        return UtilService.makeURLImage(poster_path)
    }
    
    var episodeList: [NSDictionary] {
        var listEpisode = [NSDictionary]()
        guard let episodes = episodes else {
            return []
        }

        for episode in episodes {
            listEpisode.append(episode.dictionary)
        }
        return listEpisode
    }
}

struct TvShowEpisode: Decodable, Identifiable {
    let id: Int
    let name: String?
    let overview: String?
    let air_date: String?
    let still_path: String?
    let vote_average: Double?
    let vote_count: Int?
    let episode_number: Int?
    
    var dictionary: NSDictionary {
        return [
                "id": id,
                "name": name as Any,
                "overview": overview as Any,
                "air_date": air_date as Any,
                "still_path": still_path as Any,
                "vote_average": vote_average as Any,
                "vote_count": vote_count as Any,
                "episode_number": episode_number as Any
                ]
    }
    
    var backdropURL: URL? {
        return UtilService.makeURLImage(still_path)
    }
    
    var airDateStr: String {
        guard let air_date = self.air_date else {
            return not_available
        }
        
        if let date = UtilService.dateFormatter.date(from: air_date) {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd, yyyy"
            return dateFormatterPrint.string(from: date)
        } else {
            return not_available
        }
    }
}

struct TVSExternalIds: Decodable, Identifiable {
    var id: Int
    var imdb_id: String?
}

