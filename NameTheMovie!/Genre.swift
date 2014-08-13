//
//  Genre.swift
//  Name That Movie!
//
//  Created by Jeff Gayle on 8/4/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import Foundation

class Genre: NSObject {
    
    var name : String?
    var id : String?
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
    
    class func genreFromPlist() -> Array<Genre> {
        var genres = Array<Genre>()
        
        let path = NSBundle.mainBundle().pathForResource("GenrePList", ofType: "plist")
        
        let plistArray = NSArray(contentsOfFile: path)
        
        for obj in plistArray {
            if let genre = obj as? Dictionary<String, String> {
                let name = genre["name"] as String!
                let id = genre["id"] as String!
                genres.append(Genre(name: name, id: id))
            }
        }
        genres.sort{$1.name > $0.name}
        return genres
    }
    
//    let action = Genre(name: "Action", id: 28)
//    let adventure = Genre(name: "Adventure", id: 12)
//    let animation = Genre(name: "Animation", id: 16)
//    let comedy = Genre(name: "Comedy", id: 35)
//    let crime = Genre(name: "Crime", id: 80)
//    let disaster = Genre(name: "Disaster", id: 105)
//    let documentary = Genre(name: "Documentary", id: 99)
//    let drama = Genre(name: "Drama", id: 18)
//    let family = Genre(name: "Family", id: 10751)
//    let fantasy = Genre(name: "Fantasy", id: 14)
//    let romance = Genre(name: "Romance", id: 10749)
//    let scienceFiction = Genre(name: "Science Fiction", id: 878)
//    let suspense = Genre(name: "Suspense", id: 10748)
//    let thriller = Genre(name: "Thriller", id: 53)
//    let western = Genre(name: "Western", id: 37)
    
    
    
}