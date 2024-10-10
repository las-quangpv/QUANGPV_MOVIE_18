import Foundation

struct ActingHisNew {
    let title: [String]
    let releaseTimestamp: TimeInterval
    let year: String
    
    var yearText: String {
        let date = Date(timeIntervalSince1970: releaseTimestamp)
        return UtilService.yearFormatter.string(from: date)
    }
}

