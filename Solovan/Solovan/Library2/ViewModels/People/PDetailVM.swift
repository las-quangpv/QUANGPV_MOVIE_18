import UIKit

class PDetailVM: BaseViewModel {
    private (set) var data : People? {
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
        
        (self.apiService as! PeopleAPI).fetchDetail(id: self.id) { result in
            switch result {
            case .success(let people):
                self.data = people
            case .failure(let error):
                self.error = error
            }
            self.isLoading = false
        }
    }
}

