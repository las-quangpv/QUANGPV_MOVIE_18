import UIKit

class TVSTopRatedVM: BaseViewModel {
    private let number_display_on_header: Int = 5
    private (set) var headerData: [TvShow] = [] //get 5 items
    private (set) var data : [TvShow] = [] {
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
        self.apiService = TVShowAPI()
    }
    
    func loadPage(data: [TvShow], page: Int){
        self.page = page
        self.data = data
        self.isNextPage = true
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
        (self.apiService as! TVShowAPI).fetchTopRated(page: self.page) { result in
            switch result {
            case .success(let response):
                if self.page == 1 {
                    for i in 0..<response.results.count {
                        if i < self.number_display_on_header {
                            self.headerData.append(response.results[i])
                        }
                        else {
                            self.data.append(response.results[i])
                        }
                    }
                }
                else {
                    self.data += response.results
                }
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

