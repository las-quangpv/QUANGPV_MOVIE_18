import UIKit

class MGenreVM: BaseViewModel {
    private (set) var data : [Genre] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }
    
    static let shared = MGenreVM()
    
    override init() {
        super.init()
        self.apiService = MovieAPI()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        isLoading = true
        
        (self.apiService as! MovieAPI).fetchGenre { result in
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

