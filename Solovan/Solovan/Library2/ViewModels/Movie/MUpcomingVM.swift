import UIKit

class MUpcomingVM: BaseViewModel {
    private (set) var data : [Movie] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }
    private (set) var page: Int = 1
    private (set) var isNextPage: Bool = true
    
    override init() {
        super.init()
        self.page = 1
        self.isNextPage = true
        self.apiService = MovieAPI()
    }
    
    func loadPage(data: [Movie], page: Int){
        self.page = page
        self.data = data
        self.isNextPage = true
    }
    
    func loadData() {
        if !isNextPage {
            self.bindViewModelToController()
            return
        }
        
        (self.apiService as! MovieAPI).fetchUpcoming(page: self.page) { result in
            switch result {
            case .success(let response):
                self.data += response.results
                self.isNextPage = response.results.count > 0
                self.page = self.isNextPage ? self.page + 1 : self.page
            case .failure(let error):
                self.error = error
                self.isNextPage = false
            }
        }
    }
}
