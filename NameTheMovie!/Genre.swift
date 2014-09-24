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
        
        let plistArray = NSArray(contentsOfFile: path!)
        
        for obj in plistArray {
            if let genre = obj as? Dictionary<String, String> {
                let name = genre["name"] as String!
                let id = genre["id"] as String!
                genres.append(Genre(name: name, id: id))
            }
        }
        //Sort from A-Z
        genres.sort{$1.name > $0.name}
        return genres
    }
    
}