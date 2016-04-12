//
//  FlickrPhoto.swift
//  FlickrAlbum
//
//  Created by Student on 5/2/16.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

class FlickrPhoto {

    var id: String
    var secret: String
    var server: String
    var farm: String
    var title: String
    var url_l: String
    
    init(id: String, secret: String, server: String, farm: String, title: String, url_l: String) {
        self.id = id
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
        self.url_l = url_l
    }
   
}