//
//  SecondViewController.swift
//  FlickrAlbum
//
//  Created by Student on 4/2/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import Social

class SecondViewController: UIViewController, UITextFieldDelegate {
    //@IBOutlet weak var NavigationToBack: UINavigationBar!
    
    var id: String!
    @IBOutlet weak var btnAddtoFav: UIButton!
    var url: String!
    var imgtitle: String!
    var comment: String!
    var img: UIImage?
    
    @IBOutlet weak var textFieldComment: UITextField!
    
    @IBOutlet weak var textFieldTitle: UILabel!
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search Detail Page"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "vintage_2.jpg")!)
        self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem
        openDB()
        self.textFieldTitle.text = imgtitle
        self.detailImageView.image = img
        //print("This is imagetitle \(imgtitle)");
       // print("This is image url" + url)
        textFieldComment.delegate = self
        //Default checking and disabling of the Button
        if textFieldComment.text!.isEmpty {
        btnAddtoFav.backgroundColor = UIColor.grayColor()
        btnAddtoFav.enabled = false // Disabling the button
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func sharedTwit(sender: AnyObject) {
//        if(SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)){
//            let controller = SLComposeViewController(
//                forServiceType: SLServiceTypeTwitter)
//            
//            controller.setInitialText("This is a tweet from IOS 9 Social Framework");
//            
//            let url = NSURL(string: self.url)
//            controller.addURL(url);
//            let data = NSData(contentsOfURL: url!)
//            controller.addImage(UIImage(data: data!));
//            
//            self.presentViewController(controller,animated: true, completion: nil)
//        }
//        else{
//            print("no twitter account found on device")
//        }
//        
//    }
    
    @IBAction func sharedOnSocial(sender: AnyObject) {
        
        let image: UIImage = detailImageView.image! as UIImage
        let str: String = textFieldTitle.text!
        let postItems: [AnyObject] = [str, image]
        let controller: UIActivityViewController = UIActivityViewController(activityItems: postItems, applicationActivities: nil)
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone {
            self.presentViewController(controller, animated: true, completion: nil)
        }
        else {
            let popup: UIPopoverController = UIPopoverController(contentViewController: controller)
            popup.presentPopoverFromRect(CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 4, 0, 0), inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }

        
    }
    
//    @IBAction func sharedFacebook(sender: AnyObject) {
//        
//        if(SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)){
//            let controller = SLComposeViewController(
//                forServiceType: SLServiceTypeFacebook)
//            
//            controller.setInitialText(imgtitle);
//            
//            let url = NSURL(string: self.url)
//            controller.addURL(url);
//            let data = NSData(contentsOfURL: url!)
//            controller.addImage(UIImage(data: data!));
//            
//            self.presentViewController(controller,animated: true, completion: nil)
//        }
//        else{
//            print("no facebook account found on device")
//        }
//    }

    //Start SQLite Things
    
    
    @IBAction func addToFav(sender: AnyObject) {
        
        let titleStr = textFieldTitle.text
        let urlStr = self.url as NSString
        let commentStr = textFieldComment.text
        
        let result = createFlickrFav(titleStr! as String, commentString: commentStr! as String,urlString: urlStr as String)
        if(result == true) {
                printMessage("Favourite is added successfully");
        }
            
        else {
            printMessage("Favourite is not added");
            
        }
        textFieldComment.resignFirstResponder()
    
    }
    
    func printMessage(name:String) {
        let alertPopUp:UIAlertController = UIAlertController(title: "Alert", message: name, preferredStyle: UIAlertControllerStyle.Alert);
    
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel) {
        action -> Void in }
    
        alertPopUp.addAction(cancelAction);
    
        self.presentViewController(alertPopUp, animated: true, completion: nil)
    
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let text = (textFieldComment.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if !text.isEmpty {
            btnAddtoFav.backgroundColor = UIColor.purpleColor()
            btnAddtoFav.enabled = true
        }
        else {
            btnAddtoFav.backgroundColor = UIColor.grayColor()
            btnAddtoFav.enabled = false
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textFieldComment.resignFirstResponder()
        return true;
    }
}





