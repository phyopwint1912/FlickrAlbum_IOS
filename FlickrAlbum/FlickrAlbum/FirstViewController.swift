//
//  FirstViewController.swift
//  FlickrAlbum
//
//  Created by Student on 4/2/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class FirstViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
<<<<<<< HEAD
    private var receivedData: NSDictionary!
    private var flickrPhotos: NSMutableArray!
    private var resultsDictionary: NSDictionary!
=======
    var results: NSMutableDictionary!
    var receivedData: NSDictionary!
    var flickrPhotos = [FlickrPhoto]()
>>>>>>> 0b2e217196788c68a636ad50bcfcea83222dfbdb
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
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        loadingIndicator.hidden = true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        let searchTerm = searchBar.text!
        loadingIndicator.hidden = false
        loadingIndicator.startAnimating()
        self.flickrSearchURLForSearchTerm(searchTerm)
<<<<<<< HEAD
        
=======
>>>>>>> 0b2e217196788c68a636ad50bcfcea83222dfbdb
    }
    
    private func flickrSearchURLForSearchTerm(searchTerm:String) {
        
        Alamofire.request(.GET, FLICKR_URL, parameters: ["method": SEARCH_METHOD, "api_key": FLICKR_API_KEY, "tags":searchTerm,"privacy_filter":PRIVACY_FILTER, "format":FORMAT_TYPE, "nojsoncallback": JSON_CALLBACK, "per_page":LIMIT])
            .responseJSON { (response) in
                if(response.data != nil) {
<<<<<<< HEAD
                     do {
                        self.receivedData = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions()) as? NSDictionary
                    } catch {
                        print(error)
                    }
                    
=======
                    do {
                        self.loadingIndicator.stopAnimating()
                        self.loadingIndicator.hidden = true
                        self.receivedData = try NSJSONSerialization.JSONObjectWithData(response.data!, options:NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                    } catch let error as NSError {
                        print(error);
                    }
                    
                    //print(self.receivedData)
                    self.flickrPhotos = []
>>>>>>> 0b2e217196788c68a636ad50bcfcea83222dfbdb
                    for i in 0 ..< self.LIMIT {
                        let id : String = String(self.receivedData["photos"]!["photo"]!![i]["id"]!!)
                        let farm : String = String(self.receivedData["photos"]!["photo"]!![i]["farm"]!!)
                        let title : String = String(self.receivedData["photos"]!["photo"]!![i]["title"]!!)
                        let server : String = String(self.receivedData["photos"]!["photo"]!![i]["server"]!!)
                        let secret : String = String(self.receivedData["photos"]!["photo"]!![i]["secret"]!!)
                        let url:String = "http://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg"
<<<<<<< HEAD
                        
                        NSLog("photoID \(id)")
                        NSLog("title \(title)")
                        NSLog("url \(url)")
                        
                        let flickrPhoto: FlickrPhoto = FlickrPhoto(id: id, title: title, url_l: url)
                        self.flickrPhotos.addObject(flickrPhoto)
=======
                        let flickrPhoto: FlickrPhoto = FlickrPhoto(id: id, title: title, url_l: url)
                        //                        print(flickrPhoto.id)
                        //                        print(flickrPhoto.title)
                        //                        print(flickrPhoto.url_l)
                       
                        self.flickrPhotos.append(flickrPhoto)
>>>>>>> 0b2e217196788c68a636ad50bcfcea83222dfbdb
                    }
                    self.finishedDownloading(self.flickrPhotos)
                }
        }
        if(flickrPhotos != nil) {
        print(self.flickrPhotos)
        }
    }
    
    // MARK:- Flickr Photo Download
    func finishedDownloading(photos: [FlickrPhoto]) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.flickrPhotos = photos
            NSLog("Result \(self.flickrPhotos.count)")
            self.collectionView?.reloadData()
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Start of the CollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrPhotos.count
    }
    
    // Make a cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
        let photoUrl =  flickrPhotos[indexPath.row].url_l
        NSLog("photoURL \(photoUrl)")
        if let url = NSURL(string: photoUrl) {
            if let data = NSData(contentsOfURL: url) {
                cell.imageView.image = UIImage(data: data)
            }
        }
        let PhotoTitle = flickrPhotos[indexPath.row].title
        cell.caption.text = PhotoTitle
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    
    override func prepareForSegue(
        segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "showDetail")
        {
            let cell = sender as! PhotoCollectionViewCell
            let indexPath = self.collectionView!.indexPathForCell(cell)
            let photo_title = flickrPhotos[indexPath!.row].title
            let photo_url =  flickrPhotos[indexPath!.row].url_l
            let photo_id =  flickrPhotos[indexPath!.row].id
            
            let vc = segue.destinationViewController as! SecondViewController
            
            
            vc.imgtitle = photo_title
            vc.url = photo_url
            vc.id = photo_id
            
            vc.img = UIImage(data: NSData(contentsOfURL: NSURL(string: photo_url)!)!)
            
            
        }
    }
    
}




