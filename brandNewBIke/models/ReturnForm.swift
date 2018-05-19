

import Foundation

public struct ReturnForm: Codable {
    var location: Location
    var cancel: Bool
    
    init(location:Location, cancel: Bool){
        self.location = location
        self.cancel = cancel
    }
}
