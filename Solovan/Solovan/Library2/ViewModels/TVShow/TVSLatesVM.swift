import UIKit

class TVSLatestVM: BaseViewModel {
    private (set) var data : TvShow? {
        didSet {
            self.bindViewModelToController()
        }
    }
    
    override init() {
        super.init()
        self.apiService = TVShowAPI()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        
        isLoading = true
        (self.apiService as! TVShowAPI).fetchLatest() { result in
            switch result {
            case .success(let television):
                self.data = television
            case .failure(let error):
                self.error = error
            }
            self.isLoading = false
        }
    }
}

