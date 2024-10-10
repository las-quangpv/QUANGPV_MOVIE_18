
import Foundation
class Response: NSObject{
    var data: Any?
    var error: String?
    var totalPage: Double = 1
    
    init(error: String?) {
        self.error = error
    }
    
    init(_data: Any?){
        self.data = _data
        self.error = "00";
    }
    
    init(data: Any?, totalPage: Double = 1) {
        self.data = data
        self.totalPage = totalPage
    }
    
    init( _data: Any?, _error: String){
        self.error = _error
        self.data = _data
    }
}
