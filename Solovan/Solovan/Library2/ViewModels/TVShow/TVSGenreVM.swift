import UIKit

class TVSGenreVM: BaseViewModel {
    private (set) var data : [Genre] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }
    
    static let shared = TVSGenreVM()
    
    override init() {
        super.init()
        self.apiService = TVShowAPI()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        isLoading = true
        
        (self.apiService as! TVShowAPI).fetchGenre { result in
            switch result {
            case .success(let genre):
                self.data = genre.genres
            case .failure(let error):
                self.error = error
            }
            self.isLoading = false
        }
    }
}

