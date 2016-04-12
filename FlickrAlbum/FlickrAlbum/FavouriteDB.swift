//
//  FavouriteDB.swift
//  FlickrAlbum
//
//  Created by Student on 7/2/16.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation
import UIKit

//for sqlite
var flickrDB : COpaquePointer = nil;
var insertStatement : COpaquePointer = nil;
var updateStatement : COpaquePointer = nil;
var deleteStatement : COpaquePointer = nil;
var selectAllStatement : COpaquePointer = nil;
var idAll: NSMutableArray = NSMutableArray();
var nameAll: NSMutableArray = NSMutableArray();
var urlAll: NSMutableArray = NSMutableArray();
var cmtAll: NSMutableArray = NSMutableArray();



func openDB()
{
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0]
    print(paths);
    let docsDir = (paths as NSString).stringByAppendingPathComponent("flickr.sqlite")
    print(docsDir)
    if(sqlite3_open(docsDir, &flickrDB) == SQLITE_OK){
        let sql = "CREATE TABLE IF NOT EXISTS FLICKR_FAVOURITE (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT, COMMENT TEXT, IMGURL TEXT)"
        
        //var statement:COpaquePointer = nil
        if(sqlite3_exec(flickrDB, sql, nil, nil, nil) != SQLITE_OK){
            print("Failed to create table")
            print(sqlite3_errmsg(flickrDB));
        }
    } else{
        print("Failed to open table")
        print(sqlite3_errmsg(flickrDB));
    }
    prepareStatement();
}

func prepareStatement()
{
    var sqlString: String
    sqlString = "INSERT INTO FLICKR_FAVOURITE (TITLE, COMMENT, IMGURL) VALUES (?,?,?)"
    var cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
    sqlite3_prepare_v2(flickrDB, cSql!, -1, &insertStatement, nil)
    
    sqlString = "UPDATE FLICKR_FAVOURITE SET COMMENT = ? WHERE ID = ?"
    cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
    sqlite3_prepare_v2(flickrDB, cSql!, -1, &updateStatement, nil)
    
    sqlString = "DELETE FROM FLICKR_FAVOURITE WHERE ID = ?";
    cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
    sqlite3_prepare_v2(flickrDB, cSql!, -1, &deleteStatement, nil)
    
    sqlString = "SELECT ID, TITLE, COMMENT, IMGURL FROM FLICKR_FAVOURITE" ;
    cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
    sqlite3_prepare_v2(flickrDB, cSql!, -1, &selectAllStatement, nil)

}

func createFlickrFav(titleString: String, commentString: String, urlString: String) -> Bool {
    
    sqlite3_bind_text(insertStatement, 1, titleString, -1, nil);
    sqlite3_bind_text(insertStatement, 2, commentString, -1, nil);
    sqlite3_bind_text(insertStatement, 3, urlString, -1, nil);
    
    if(sqlite3_step(insertStatement) == SQLITE_DONE)
    {
        print("success")
        
    }
    else{
        
        print("fail")
    }
    
    sqlite3_reset(insertStatement);
    sqlite3_clear_bindings(insertStatement);
    
    return true;

}

func SelectAllDataFromDB() {
//    nameAll.removeAllObjects()
//    urlAll.removeAllObjects()
//    cmtAll.removeAllObjects()
//    idAll.removeAllObjects()

    while(sqlite3_step(selectAllStatement) == SQLITE_ROW) {
        let id = sqlite3_column_text(selectAllStatement, 0)
        let name = sqlite3_column_text(selectAllStatement, 1)
        let cmt = sqlite3_column_text(selectAllStatement, 2)
        let url = sqlite3_column_text(selectAllStatement, 3)
        print(url)
        nameAll.addObject(String.fromCString(UnsafePointer<CChar>(name))!);
        urlAll.addObject(String.fromCString(UnsafePointer<CChar>(url))!);
        cmtAll.addObject(String.fromCString(UnsafePointer<CChar>(cmt))!);
        idAll.addObject(String.fromCString(UnsafePointer<CChar>(id))!);
    }

    sqlite3_reset(selectAllStatement)
    sqlite3_clear_bindings(selectAllStatement)
}

func deleteContact(idString: String){

    let delID = (idString as NSString).UTF8String
    sqlite3_bind_text(deleteStatement, 1, delID, -1, nil);
    if(sqlite3_step(deleteStatement) == SQLITE_DONE)
    {
        print("Delete Success")

    }else{
        print("Delete Fail")
    }
    sqlite3_reset(deleteStatement);
    sqlite3_clear_bindings(deleteStatement);

}


func updateFavList(idString: String, cmtString: String) -> Bool
{
    
    let upid = (idString as NSString).UTF8String
    let upcomment = (cmtString as NSString).UTF8String
    sqlite3_bind_text(updateStatement, 1, upcomment, -1, nil)
    sqlite3_bind_text(updateStatement, 2, upid, -1, nil)
    
    if(sqlite3_step(updateStatement) == SQLITE_DONE){
        print("fav update success ")
        //println(updateStatement)
    }else{
        print("fav update fail ")
    }
    sqlite3_reset(updateStatement);
    sqlite3_clear_bindings(updateStatement);
    return true
    
}





