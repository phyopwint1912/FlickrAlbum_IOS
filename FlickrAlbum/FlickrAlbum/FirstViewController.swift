//
//  FirstViewController.swift
//  FlickrAlbum
//
//  Created by Student on 4/2/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSURLSessionDataDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var textFieldSearch: UITextField!
    
    var AllTitle: NSMutableArray = NSMutableArray();
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var AllUrl: NSMutableArray = NSMutableArray();
    var AllID: NSMutableArray = NSMutableArray();
    var flickrPhotos: NSDictionary = NSDictionary()
    var url: NSURL = NSURL()
    //var backgroundMusicPlayer : AVAudioPlayer!
    private let reuseIdentifier = "Cell"
    var resultsDictionary: NSDictionary = NSDictionary()
    
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        self.title = "Search Page"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "vintage_.jpg")!)
        //playBackgroundMusic()
        textFieldSearch.delegate = self
        loadingIndicator.hidden = true
        collectionView.hidden = true
        //loadingIndicator.startAnimating()
       
    }
    @IBAction func buttonSearch(sender: AnyObject) {

        let searchTerm = textFieldSearch.text
        textFieldSearch.resignFirstResponder()
        loadingIndicator.hidden = false
        loadingIndicator.startAnimating()
        url = flickrSearchURLForSearchTerm(searchTerm!)
        
        processDataFromServer()
       
        
    }
    
    func processDataFromServer() {
        let defaultConfigObject:NSURLSessionConfiguration =
        NSURLSessionConfiguration.defaultSessionConfiguration();
        
        let session:NSURLSession = NSURLSession(configuration: defaultConfigObject, delegate: self, delegateQueue: NSOperationQueue.mainQueue());
        session.dataTaskWithURL(url, completionHandler: {(data, response, error) in
            print("I m here");
            print("Done with bytes " + String(data!.length));
            
            if (error != nil) {
                print("Error %@",error!.userInfo);
                print("Error description %@", error!.localizedDescription);
                print("Error domain %@", error!.domain);
               
            }
            
            do {
                self.resultsDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
            } catch let error as NSError {
                print(error);
            }
            
            //print(resultsDictionary);
            let photosContainer = self.resultsDictionary["photos"] as! NSDictionary
            let photosReceived = photosContainer["photo"] as! [NSDictionary]
            
            let flickrPhotos : [FlickrPhoto] = photosReceived.map {
                photoDictionary in
                let photoID = photoDictionary["id"] as? String ?? ""
                let farm = photoDictionary["farm"] as? Int ?? 0
                let server = photoDictionary["server"] as? String ?? ""
                let secret = photoDictionary["secret"] as? String ?? ""
                let title = photoDictionary["title"] as? String ?? ""
                let url = photoDictionary["url_l"] as? String ?? ""
                let flickrPhoto = FlickrPhoto(id: photoID, secret: secret, server: server, farm: String(farm), title: title, url_l: url)
                return flickrPhoto
            }
            
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.reloadData()
            self.AllTitle = NSMutableArray();
            self.AllUrl = NSMutableArray();
            self.AllID = NSMutableArray();
            for fl in flickrPhotos {
                self.AllUrl.addObject(fl.url_l)
                self.AllTitle.addObject(fl.title);
                self.AllID.addObject(fl.id)
            }
            self.loadingIndicator.hidden = true
            self.loadingIndicator.stopAnimating()
            self.collectionView.hidden = false
            
        }).resume();
    }

    private func flickrSearchURLForSearchTerm(searchTerm:String) -> NSURL {
        
        let apiKey:String = "f1b0f588c08905ba232fa983651cdc8e"
        let escapedTerm = searchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=20&extras=url_l&format=json&nojsoncallback=1"
        
        //print(URLString)
        return NSURL(string: URLString)!
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Star of the CollectionView
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("This is flickerPhoto.count \(AllTitle.count)")
        return AllTitle.count
        
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
        let photo =  AllUrl[indexPath.row]
        
        if let url = NSURL(string: photo as! String) {
            if let data = NSData(contentsOfURL: url) {
                cell.imageView.image = UIImage(data: data)
            }
        }
        let PhotoTitle = AllTitle[indexPath.row]
        
        cell.caption.text = PhotoTitle as? String
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
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
            let photo_title = AllTitle[indexPath!.row]
            let photo_url =  AllUrl[indexPath!.row]
            let photo_id =  AllID[indexPath!.row]
            let vc = segue.destinationViewController as! SecondViewController
            
            
            vc.imgtitle = photo_title as! String
            vc.url = photo_url as! String
            vc.id = photo_id as! String
            
            print(NSURL(string: photo_url as! String))
            
            
            if (vc.url == "")
            {
                print("don't")
                var path: String!
                path = NSBundle.mainBundle().pathForResource("404", ofType: "png")
                print("path is \(path)")
                vc.url = path
                //print(vc.url)
                
            }
            else
            {
                print("do")
                vc.img = UIImage(data: NSData(contentsOfURL: NSURL(string: photo_url as! String)!)!)
                print("Copy...\(vc.url)")
            }
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textFieldSearch.resignFirstResponder()
        return true;
    }
    
   

}




