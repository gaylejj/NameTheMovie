//
//  Movie.swift
//  Movie Game
//
//  Created by Jeff Gayle on 8/11/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import Foundation

class Movie {
    var title : String?
    var poster_path : String?
    var id : Int?
    var is_adult: Bool?
    var overview : String?
    
    init(resultDict: NSDictionary) {
        self.title = resultDict.objectForKey("title") as? String
        self.poster_path = resultDict.objectForKey("poster_path") as? String
        self.id = resultDict.objectForKey("id") as? Int
        self.is_adult = resultDict.objectForKey("adult") as? Bool
        self.overview = resultDict.objectForKey("overview") as? String
    }
}
