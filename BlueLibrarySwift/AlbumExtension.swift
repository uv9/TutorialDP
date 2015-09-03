//
//  AlbumExtension.swift
//  BlueLibrarySwift
//
//  Created by Udit Verma on 9/3/15.
//  Copyright (c) 2015 Raywenderlich. All rights reserved.
//

import Foundation


extension Album{
    func ae_tableRepresentation() -> (titles:[String],values:[String]){
        return (["Artist", "Album", "Genre", "Year"], [artist, title, genre, year])
    }
}