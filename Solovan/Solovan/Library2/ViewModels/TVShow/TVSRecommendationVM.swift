import Foundation

class TVSRecommendationVM: BaseViewModel {
    private (set) var data : [TvShow] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }
    private (set) var id: Int!
    
    init(id: Int) {
        super.init()
        self.id = id
        self.apiService = TVShowAPI()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        
        isLoading = true
        (self.apiService as! TVShowAPI).fetchRecommendation(id: self.id, page: 1) { result in
            switch result {
            case .success(let tmp):
                self.data = tmp.results
            case .failure(let error):
                self.error = error
            }
            self.isLoading = false
        }
    }
}
