import Foundation

struct PeopleResponse: Decodable {
    let results: [People]
}

struct People: Decodable, Identifiable {
    let id: Int
    let name: String
    let popularity: Double
    let known_for_department: String?
    let profile_path: String?
    let biography: String?
    
    let known_for: [PeopleKnowFor]?
    
    let birthday: String?
    let also_known_as: [String]?
    let gender: Int?
    let place_of_birth: String?
    
    var profileURL: URL? {
        return UtilService.makeURLImage(profile_path)
    }
    
    var knowForDepartmentText: String {
        return known_for_department ?? not_available
    }
    
    var birthdayStr: String {
        guard let birthday = self.birthday else {
            return not_available
        }
        
        if let date = UtilService.dateFormatter.date(from: birthday) {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "YYYY-MM-dd"
            return dateFormatterPrint.string(from: date)
        } else {
            return not_available
        }
    }
    
    var yearOld: String {
        let dateFormater = DateFormatter()
            dateFormater.dateFormat = "YYYY-MM-dd"
        guard let birth = birthday else {return ""}
            let dateOfBirth = dateFormater.date(from: birth)

            let calender = Calendar.current

            let dateComponent = calender.dateComponents([.year, .month, .day], from:
            dateOfBirth!, to: Date())

            return "\(dateComponent.year ?? 0)"
    }
    
    var placeOfBirthStr: String {
        return place_of_birth ?? not_available
    }
}

struct PeopleKnowFor: Decodable, Identifiable {
    let id: Int
    let title: String?
    let media_type: String?
    let genre_ids: [Int]?
    let vote_average: Double
    let vote_count: Int
    let overview: String?
    let backdrop_path: String?
    let poster_path: String?
    
    var backdropURL: URL? {
        return UtilService.makeURLImage(backdrop_path)
    }
    
    var posterURL: URL? {
        return UtilService.makeURLImage(poster_path)
    }
    
}

struct PeopleMovieResponse: Decodable {
    let cast: [Movie]
    let crew: [Movie]?
    
}

struct PeopleTelevisionResponse: Decodable {
    let cast: [TvShow]
    let crew: [TvShow]?
}

