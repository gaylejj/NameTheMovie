// Playground - noun: a place where people can play

import Cocoa

let action = 28
let adventure = 12
let animation = 16
let comedy = 35
let crime = 80
let disaster = 105
let documentary = 99
let drama = 18
let family = 10751
let fantasy = 14
let romance = 10749
let scienceFiction = 878
let suspense = 10748
let thriller = 53
let western = 37

class Genre: NSObject {
    
    var id : Int?
    var name : String?
    
    init(name: String, id: Int) {
        self.id = id
        self.name = name
    }
    
    let action = Genre(name: "action", id: 28)
    
    
}
