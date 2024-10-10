import UIKit

private let number_display_on_header: Int = 3

class TVSByGenreVM: BaseViewModel {
    private (set) var headerData : [TvShow] = [] // get 3 items first
    private (set) var data : [TvShow] = [] {
        didSet {
            self.bindViewModelToController()
        }
    }
    private (set) var id: Int!
    private (set) var page: Int = 1
    private (set) var isNextPage: Bool = true
    
    init(id: Int) {
        super.init()
        self.id = id
        self.page = 1
        self.isNextPage = true
        self.apiService = TVShowAPI()
    }
    
    override init() {
        super.init()
    }
    
    func loadData() {
        if !isNextPage {
            self.bindViewModelToController()
            return
        }
        
        (self.apiService as! TVShowAPI).fetchDiscoverByGenre(genreId: self.id, page: self.page) { result in
            switch result {
            case .success(let response):
                if self.page == 1 {
                    for i in 0..<response.results.count {
                        if i < number_display_on_header {
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
        }
    }
}

