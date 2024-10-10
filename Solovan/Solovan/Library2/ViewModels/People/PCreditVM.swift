import UIKit

class PCreditVM: BaseViewModel {
    // using for known for
    var data : [Any] {
        return movies + televisions
    }
    
    // using for acting history
    var actings: [ActingHistory] = []
    var actingList: [ActingHisNew] = []
    
    
    //
    private (set) var movies : [Movie] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }
    private (set) var televisions : [TvShow] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }
    private (set) var id: Int!
    
    init(id: Int) {
        super.init()
        self.id = id
        self.apiService = PeopleAPI()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        isLoading = true
        
        (self.apiService as! PeopleAPI).fetchMovieCredits(id: self.id) { result in
            switch result {
            case .success(let tmp):
                self.movies = tmp.cast
            case .failure(let error):
                self.error = error
            }
            self.loadTVsData()
            self.handleSourceActing()
        }
    }
    
    private func loadTVsData() {
        (self.apiService as! PeopleAPI).fetchTVCredits(id: self.id) { result in
            switch result {
            case .success(let tmp):
                self.televisions = tmp.cast
            case .failure(let error):
                self.error = error
            }
            self.isLoading = false
            self.handleSourceActing()
        }
    }
    
    private func handleSourceActing() {
        self.actings.removeAll()
        
        var result: [ActingHistory] = []
        var resultNew: [ActingHisNew] = []
        movies.forEach { item in
            var listTitle: [String] = []
            
            if !(item.title.isEmpty && (item.character ?? "").isEmpty && item.releaseTimestamp == 0) {
                
                result.append(ActingHistory(title: item.title, character: item.character ?? "", overView: item.overview, releaseTimestamp: item.releaseTimestamp))
                
                let date = Date(timeIntervalSince1970: item.releaseTimestamp)
                let yearStr =  UtilService.yearFormatter.string(from: date)
                
                    if let row = resultNew.firstIndex(where: {$0.yearText == yearStr}) {
                        listTitle = resultNew[row].title
                        listTitle.append(item.title + " as " + (item.character ?? ""))
                        resultNew[row] = ActingHisNew(title: listTitle, releaseTimestamp: item.releaseTimestamp, year: yearStr)
                    }
                
                else {
                    listTitle.append(item.title + " as " + (item.character ?? ""))
                    resultNew.append(ActingHisNew(title: listTitle, releaseTimestamp: item.releaseTimestamp, year: yearStr))
                }
                
            }
        }
        
        televisions.forEach { item in
            var listTitle: [String] = []
            if !(item.name.isEmpty && (item.character ?? "").isEmpty && item.firstAirTimestamp == 0) {
                
                result.append(ActingHistory(title: item.name, character: item.character ?? "", overView: item.overview, releaseTimestamp: item.firstAirTimestamp))
                
                let date = Date(timeIntervalSince1970: item.firstAirTimestamp)
                let yearStr =  UtilService.yearFormatter.string(from: date)
                
                if let row = resultNew.firstIndex(where: {$0.yearText == yearStr }) {
                    listTitle = resultNew[row].title
                    listTitle.append(item.name + " as " + (item.character ?? ""))
                    resultNew[row] = ActingHisNew(title: listTitle, releaseTimestamp: item.firstAirTimestamp, year: yearStr)
                }
                else {
                    listTitle.append(item.name + " as " + (item.character ?? ""))
                    resultNew.append(ActingHisNew(title: listTitle, releaseTimestamp: item.firstAirTimestamp, year: yearStr))
                }
            }
        }
        // sort
        self.actings = result.sorted(by: { (a, b) -> Bool in
            return a.releaseTimestamp > b.releaseTimestamp
        })
        
        self.actingList = resultNew.sorted(by: { (a, b) -> Bool in
            return a.releaseTimestamp > b.releaseTimestamp
        })
        self.bindViewModelToController()
    }
}

