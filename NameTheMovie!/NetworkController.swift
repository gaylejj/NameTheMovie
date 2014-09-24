//
//  NetworkController.swift
//  Movie Game
//
//  Created by Jeff Gayle on 8/11/14.
//  Copyright (c) 2014 Jeff Gayle. All rights reserved.
//

import Foundation

class NetworkController: NSObject {
    
    //MARK: Session property
    var session = NSURLSession.sharedSession()
    
    //MARK: Parse functions
    func parseResponse(responseData: NSData) -> [Movie] {
        var movies = [Movie]()
        
        if let responseDict = NSJSONSerialization.JSONObjectWithData(responseData, options: nil, error: nil) as? NSDictionary {
            
            if let results = responseDict["results"] as? NSArray {
                
                for result in results {
                    
                    if let resultDict = result as? NSDictionary {
                        
                        let movie = Movie(resultDict: resultDict)
                        movies.append(movie)
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
        }
        return movie
    }

    //MARK: Fetch functions
    //Get movie overview
    func fetchMovieForGame(movie: Movie!, callback: (movie: Movie!, errorDescription: String?) -> Void) {
        
        var movieID = "\(movie!.id!)"
        
        if !movieID.isEmpty {
            var url = NSURL(string: "http://api.themoviedb.org/3/movie/\(movieID)?api_key=\(API.apiKey())")
            
            var request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = "GET"
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            var task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                if (error != nil) {
                    //Handle error
                    callback(movie: nil, errorDescription: "\(error.localizedDescription)")
                } else {
                    if let httpResponse = response as? NSHTTPURLResponse {
                        switch httpResponse.statusCode {
                        case 200:
                            callback(movie: self.parseResponseForMovieID(data), errorDescription: nil)
                        case 401:
                            callback(movie: nil, errorDescription: "Authentication Failed: You do not have permissions to access this service")
                        case 404:
                            callback(movie: nil, errorDescription: "URL Not found")
                        case 503:
                            callback(movie: nil, errorDescription: "Being Rate Limited")
                        default:
                            callback(movie: nil, errorDescription: "Please try again in a few minutes \(httpResponse.statusCode)")
                        }
                    }
                }
            })
            
            task.resume()
        }
        
    }
    
    //Get movies from genre
    func discoverMovie(genre: Genre, callback: (movies: [Movie]?, errorDescription: String?) -> Void) {
        
        var page = arc4random_uniform(11)
        
        if let genrePicked = genre.id as String! {
            
            var urlString = "http://api.themoviedb.org/3/discover/movie?api_key=\(API.apiKey())&include_adult=false&vote_count.gte=90&page=\(page)&with_genres=\(genrePicked)"
            let discoverURL = NSURL(string: urlString)
            
            var request = NSMutableURLRequest(URL: discoverURL)
            
            request.HTTPMethod = "GET"
            
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                
                if (error != nil) {
                    // Handle error...
                    callback(movies: nil, errorDescription: "\(error.localizedDescription)")
                } else {
                    if let httpResponse = response as? NSHTTPURLResponse {
                        switch httpResponse.statusCode {
                        case 200:
                            callback(movies: self.parseResponse(data), errorDescription: nil)
                        default:
                            callback(movies: nil, errorDescription: "Please try again in a few minutes \(httpResponse.statusCode)")
                        }
                    }
                }
            })
            task.resume()
        }
    }
}