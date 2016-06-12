//
//  FavDetailViewController.swift
//  FlickrAlbum
//
//  Created by Student on 8/2/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import Social
class FavDetailViewController: UIViewController, UITextFieldDelegate {

    
    var url: String!
    @IBOutlet weak var textFieldFavCmt: UITextField!
    var imgtitle: String!
    var cmt: String!
    var id: String!
    var img: UIImage?
    var cmtString: String!

    @IBOutlet weak var btnUpdate: UIButton!
    
    @IBOutlet weak var btnEditComment: UIButton!
    
    @IBOutlet weak var textFieldFavTitle: UILabel!
    @IBOutlet weak var favImageView: UIImageView!
    var favDb = FavouriteDB()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favourite Detail Page"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "vintage_2.jpg")!)
        self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
        favDb.openDB()
        self.textFieldFavTitle.text = imgtitle
        self.favImageView.image = img
        textFieldFavCmt.delegate = self
        //Default checking and disabling of the Button
        textFieldFavCmt.text = cmt;
        textFieldFavCmt.enabled = false
        btnUpdate.hidden = true
        print(id)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sharedTwitter(sender: AnyObject) {
        
        let image: UIImage = favImageView.image! as UIImage
        let str: String = textFieldFavTitle.text!
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
    
    @IBAction func editComment(sender: AnyObject) {
        textFieldFavCmt.enabled = true
        btnUpdate.hidden = false
        btnEditComment.hidden = true
        
    }
    @IBAction func updateComment(sender: AnyObject) {
        
        cmtString = textFieldFavCmt.text
        let result1 = favDb.updateFavList(id as String, cmtString: cmtString as String)
        if(result1 == true) {
            printMessage("Comment is updated successfully");
        }
        textFieldFavCmt.resignFirstResponder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func printMessage(name:String) {
        let alertPopUp:UIAlertController = UIAlertController(title: "Alert", message: name, preferredStyle: UIAlertControllerStyle.Alert);
        
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel) {
            action -> Void in }
        
        alertPopUp.addAction(cancelAction);
        
        self.presentViewController(alertPopUp, animated: true, completion: nil)
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textFieldFavCmt.resignFirstResponder();
    return true
    
    }

}
