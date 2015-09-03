//
//  Album.swift
//  BlueLibrarySwift
//
//  Created by Udit Verma on 9/2/15.
//  Copyright (c) 2015 Raywenderlich. All rights reserved.
//

import Foundation

class Album : NSObject {
    
    var title : String!
    var artist : String!
    var genre : String!
    var coverUrl : String!
    var year : String!
    
    init(title:String,artist:String,genre:String,coverURL :String,year:String){
        super.init()
        self.title = title
        self.artist = artist
        self.genre = genre
        self.coverUrl = coverURL
        self.year = year
    }
    
    override var description: String {
        return "title: \(title)" +
            "artist: \(artist)" +
            "genre: \(genre)" +
            "coverUrl: \(coverUrl)" +
	       "year: \(year)"
    }
}
