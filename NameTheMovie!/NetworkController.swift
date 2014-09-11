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
    
    func parseResponseForMovieID(responseData: NSData) -> Movie? {
        var movie : Movie?
        
        if let responseDict = NSJSONSerialization.JSONObjectWithData(responseData, options: nil, error: nil) as? NSDictionary {
            movie = Movie(resultDict: responseDict)
            println("Movie's overview is \(movie!.overview!)")
        }
        println(movie!.title)
        
        return movie
    }

    func fetchMovieForGame(movie: Movie!, callback: (movie: Movie!, errorDescription: String?) -> Void) {
        
        println("Click movie is \(movie!.id)")
        println("Click movie title is \(movie.title)")
        
        var movieID = "\(movie!.id)"
        
        let newMovieID = movieID.stringByReplacingOccurrencesOfString("Optional(", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let finalMovieID = newMovieID.stringByReplacingOccurrencesOfString(")", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        if !finalMovieID.isEmpty {
            var url = NSURL(string: "http://api.themoviedb.org/3/movie/\(finalMovieID)?api_key=\(apiKey.apiKey)")
            println(url)
            
            var request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = "GET"
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            var task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                if (error != nil) {
                    //Handle error
                    println(error.localizedDescription)
                } else {
                    if let httpResponse = response as? NSHTTPURLResponse {
                        switch httpResponse.statusCode {
                        case 200:
                            println("Everything Ok")
                            callback(movie: self.parseResponseForMovieID(data), errorDescription: nil)
                        case 401:
                            println("Authentication Failed: You do not have permissions to access this service")
                        case 404:
                            println("URL Not found")
                        case 503:
                            println("Being Rate Limited")
                        default:
                            println("Something happened")
                            println(httpResponse.description)
                        }
                    }
                }
            })
            
            task.resume()
        }
        
    }
        
    func discoverMovie(genre: Genre, callback: (movies: [Movie]?, errorDescription: String?) -> Void) {
        
        println("Discover Movie Call: \(genre.name)")
        println("Discover Movie Call: \(genre.id)")
        
        var page = arc4random_uniform(11)
        
        if let genrePicked = genre.id as String! {
            
            var urlString = "http://api.themoviedb.org/3/discover/movie?api_key=\(apiKey.apiKey)&include_adult=false&vote_count.gte=90&page=\(page)&with_genres=\(genrePicked)"
            println(apiKey.apiKey)
            
            let discoverURL = NSURL(string: urlString)
            
            println("URL: \(discoverURL)")
            
            var request = NSMutableURLRequest(URL: discoverURL)
            
            request.HTTPMethod = "GET"
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                
                if (error != nil) {
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
}