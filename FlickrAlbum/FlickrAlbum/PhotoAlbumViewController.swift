//
//  PhotoAlbumViewController.swift
//  FlickrAlbum
//
//  Created by Student on 11/2/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

class PhotoAlbumViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , NSURLSessionDelegate {
    @IBOutlet weak var sharedBut: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        sharedBut.hidden = true
//        let photopicker = UIImagePickerController()
//        photopicker.delegate = self
//        photopicker.sourceType = .PhotoLibrary
//        self.presentViewController(photopicker, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func captureImage(sender: AnyObject) {
        let photopicker = UIImagePickerController()
        photopicker.delegate = self
        photopicker.sourceType = .Camera
        self.presentViewController(photopicker, animated: true, completion: nil)

    }
    
    @IBAction func sharedSocial(sender: AnyObject) {
        let image: UIImage = uploadImageView.image! as UIImage
        let postItems: [AnyObject] = [image]
        let controller: UIActivityViewController = UIActivityViewController(activityItems: postItems, applicationActivities: nil)
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone {
            self.presentViewController(controller, animated: true, completion: nil)
        }
        else {
            let popup: UIPopoverController = UIPopoverController(contentViewController: controller)
            popup.presentPopoverFromRect(CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 4, 0, 0), inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    

    
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBAction func uploadImageButton(sender: AnyObject) {
    
        let photopicker = UIImagePickerController()
        photopicker.delegate = self
        photopicker.sourceType = .PhotoLibrary
        self.presentViewController(photopicker, animated: true, completion: nil)

    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        uploadImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(false, completion: nil)
        sharedBut.hidden = false

    }

}


