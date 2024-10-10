import UIKit

class PSearchVM: BaseViewModel {
    private (set) var data : [People] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }
    private (set) var term: String!
    private (set) var page: Int = 1
    private (set) var isNextPage: Bool = true
    
    init(term: String) {
        super.init()
        self.term = term
        self.page = 1
        self.isNextPage = true
        self.apiService = PeopleAPI()
    }
    
    func loadData() {
        if isLoading {
            return
        }
        
        if !isNextPage {
            self.bindViewModelToController()
            return
        }
        
        isLoading = true
        (self.apiService as! PeopleAPI).searchPeople(term: self.term, page: self.page) { result in
            switch result {
            case .success(let response):
                self.data += response.results
                self.isNextPage = response.results.count > 0
                self.page = self.isNextPage ? self.page + 1 : self.page
            case .failure(let error):
                self.error = error
                self.isNextPage = false
            }
            self.isLoading = false
        }
    }
}

