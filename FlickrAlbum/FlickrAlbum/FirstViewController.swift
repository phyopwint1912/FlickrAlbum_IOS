//
//  FirstViewController.swift
//  FlickrAlbum
//
//  Created by Student on 4/2/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import Alamofire

class FirstViewController: UIViewController, UISearchBarDelegate {
    
    private let FLICKR_API_KEY:String = "f1b0f588c08905ba232fa983651cdc8e"
    private let FLICKR_URL:String = "https://api.flickr.com/services/rest/"
    private let SEARCH_METHOD:String = "flickr.photos.search"
    private let FORMAT_TYPE:String = "json"
    private let JSON_CALLBACK:Int = 1
    private let PRIVACY_FILTER:Int = 1
    private let LIMIT = 10
    private let reuseIdentifier = "Cell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private var receivedData: NSDictionary!
    private var flickrPhotos: NSMutableArray!
    private var resultsDictionary: NSDictionary!
    private var AllUrl: NSMutableArray!
    private var AllId: NSMutableArray!
    private var AllTitle: NSMutableArray!
    private var url: NSURL!
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        self.title = "Search Page"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "vintage_.jpg")!)
        //playBackgroundMusic()
        searchBar.delegate = self
        //self.collectionView.dataSource = self
        //self.collectionView.delegate = self
        loadingIndicator.hidden = true
        collectionView.hidden = true
        //loadingIndicator.startAnimating()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        let searchTerm = searchBar.text!
        loadingIndicator.hidden = false
        loadingIndicator.startAnimating()
        self.flickrSearchURLForSearchTerm(searchTerm)
        
    }
    
    private func flickrSearchURLForSearchTerm(searchTerm:String) {
        //Alamofire.request(.GET, FLICKR_URL, parameters: ["method": SEARCH_METHOD, "api_key": FLICKR_API_KEY, "tags":searchTerm,"privacy_filter":PRIVACY_FILTER, "format":FORMAT_TYPE, "nojsoncallback": JSON_CALLBACK, "per_page": LIMIT])
        
        Alamofire.request(.GET, FLICKR_URL, parameters: ["method": SEARCH_METHOD, "api_key": FLICKR_API_KEY, "tags":searchTerm,"privacy_filter":PRIVACY_FILTER, "format":FORMAT_TYPE, "nojsoncallback": JSON_CALLBACK, "per_page":LIMIT])
            .responseJSON { (response) in
                if(response.data != nil) {
                     do {
                        self.receivedData = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions()) as? NSDictionary
                    } catch {
                        print(error)
                    }
                    
                    for i in 0 ..< self.LIMIT {
                        let id : String = String(self.receivedData["photos"]!["photo"]!![i]["id"]!!)
                        let farm : String = String(self.receivedData["photos"]!["photo"]!![i]["farm"]!!)
                        let title : String = String(self.receivedData["photos"]!["photo"]!![i]["title"]!!)
                        let server : String = String(self.receivedData["photos"]!["photo"]!![i]["server"]!!)
                        let secret : String = String(self.receivedData["photos"]!["photo"]!![i]["secret"]!!)
                        let url:String = "http://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
                        
                        NSLog("photoID \(id)")
                        NSLog("title \(title)")
                        NSLog("url \(url)")
                        
                        let flickrPhoto: FlickrPhoto = FlickrPhoto(id: id, title: title, url_l: url)
                        self.flickrPhotos.addObject(flickrPhoto)
                    }
                }
        }
        if(flickrPhotos != nil) {
        print(self.flickrPhotos)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Star of the CollectionView
    // tell the collection view how many cells to make
    //    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //
    //       // print("This is flickerPhoto.count \(AllTitle.count)")
    //        return AllTitle.count
    //
    //    }
    //
    //    // make a cell for each cell index path
    //    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    //
    //        // get a reference to our storyboard cell
    //        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
    //        let photo =  AllUrl[indexPath.row]
    //
    //        if let url = NSURL(string: photo as! String) {
    //            if let data = NSData(contentsOfURL: url) {
    //                cell.imageView.image = UIImage(data: data)
    //            }
    //        }
    //        let PhotoTitle = AllTitle[indexPath.row]
    //
    //        cell.caption.text = PhotoTitle as? String
    //
    //        return cell
    //    }
    //
    //    // MARK: - UICollectionViewDelegate protocol
    //
    //    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    //        // handle tap events
    //        print("You selected cell #\(indexPath.item)!")
    //    }
    //
    //
    //    override func prepareForSegue(
    //        segue: UIStoryboardSegue, sender: AnyObject?) {
    //
    //        if(segue.identifier == "showDetail")
    //        {
    //            let cell = sender as! PhotoCollectionViewCell
    //            let indexPath = self.collectionView!.indexPathForCell(cell)
    //            let photo_title = AllTitle[indexPath!.row]
    //            let photo_url =  AllUrl[indexPath!.row]
    //            let photo_id =  AllId[indexPath!.row]
    //            let vc = segue.destinationViewController as! SecondViewController
    //
    //
    //            vc.imgtitle = photo_title as! String
    //            vc.url = photo_url as! String
    //            vc.id = photo_id as! String
    //
    //            print(NSURL(string: photo_url as! String))
    //
    //
    //            if (vc.url == "")
    //            {
    //                print("don't")
    //                var path: String!
    //                path = NSBundle.mainBundle().pathForResource("404", ofType: "png")
    //                print("path is \(path)")
    //                vc.url = path
    //                //print(vc.url)
    //
    //            }
    //            else
    //            {
    //                print("do")
    //                vc.img = UIImage(data: NSData(contentsOfURL: NSURL(string: photo_url as! String)!)!)
    //                print("Copy...\(vc.url)")
    //            }
    //        }
    //    }
    //
    //
}




