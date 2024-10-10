import UIKit

class TVDetailVM: NSObject {
    
    var error : PMError?  {
        didSet {
            self.bindViewModelToController()
        }
    }
    var apiService: TVShowAPI!
    var isLoadingIds: Bool = false
    var bindViewModelToController : (() -> ()) = {}
    
    private (set) var externalIds: TVSExternalIds? {
        didSet {
        }
    }
    
    private (set) var id: Int!
    
    init(id: Int) {
        super.init()
        self.id = id
        self.apiService = TVShowAPI()
    }
    
    func loadData() {
        if isLoadingIds {
            return
        }

        isLoadingIds = true
        self.apiService.searchIMDB(id: self.id) { result in
            switch result {
            case .success(let ids):
                self.externalIds = ids
            case .failure(let error):
                self.error = error
            }
        }
    }
}

