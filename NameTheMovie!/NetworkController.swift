//
//  NetworkController.swift
//  Movie Game
//
//  Created by Jeff Gayle on 8/11/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import Foundation

class NetworkController: NSObject {
    
    var session = NSURLSession.sharedSession()
    
    let apiKey = APIKey()
    
    func parseResponse(responseData: NSData) -> [Movie] {
        
        var movies = [Movie]()
        
        if let responseDict = NSJSONSerialization.JSONObjectWithData(responseData, options: nil, error: nil) as? NSDictionary {
            
            if let results = responseDict["results"] as? NSArray {
                
                for result in results {
                    
                    if let resultDict = result as? NSDictionary {
                        
                        let movie = Movie(resultDict: resultDict)
                        movies.append(movie)
                        println("Movie's title is \(movie.title!)")
                        println("Movie's poster path is \(movie.poster_path!)")
                        println("Movie's id is \(movie.id!)")
                        println("Movie's adult status is \(movie.is_adult!)")
                        println("Movie's Overview is \(movie.overview)")
                        
                    }
                }
            }
        }
        return movies
    }
    
    func fetchMovie(searchTerm: String, callback: (movies: [Movie]?, errorDescription: String?) -> Void) {
        var url = NSURL(string: "http://api.themoviedb.org/3/search/movie?api_key=\(apiKey.apiKey)&include_adult=false&query=\(searchTerm)")
        
        var request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request) { (data: NSData!, response: NSURLResponse!, error: NSError!) in
            
            if (error) {
                // Handle error...
                return
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        println("Everything Ok")
                        callback(movies: self.parseResponse(data), errorDescription: nil)
                    default:
                        println("Something happened")
                    }
                }
            }
            //
            //            println(error)
            //            println(response)
            //            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        
        task.resume()
    }
    
    func discoverMovie(genreID: Genre, callback: (movies: [Movie]?, errorDescription: String?) -> Void) {
        
        println("Discover Movie Call: \(genreID.name)")
        println("Discover Movie Call: \(genreID.id)")
        
        if let genrePicked = genreID.id as String! {
            
            var urlString = "http://api.themoviedb.org/3/discover/movie?api_key=\(apiKey.apiKey)&include_adult=false&vote_count.gte=90&with_genres=\(genrePicked)"
            println(apiKey.apiKey)
            
            let discoverURL = NSURL(string: urlString)
            
            println("URL: \(discoverURL)")
            
            var request = NSMutableURLRequest(URL: discoverURL)
            
            request.HTTPMethod = "GET"
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                
                if (error) {
                    // Handle error...
                    println(error.localizedDescription)
                } else {
                    if let httpResponse = response as? NSHTTPURLResponse {
                        switch httpResponse.statusCode {
                        case 200:
                            println("Everything Ok")
                            callback(movies: self.parseResponse(data), errorDescription: nil)
                        default:
                            println("Something happened")
                        }
                    }
                }
            })
            
            task.resume()
            
        }
        
    }
    
    
    
    //    "http://api.themoviedb.org/3/discover/movie" with_genres vote_count.gte include_adult sort_by=vote_average.desc
    //    
    //    http://api.themoviedb.org/3/movie/{id}
    
    
    
    
}