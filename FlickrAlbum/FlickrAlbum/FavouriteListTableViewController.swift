//
//  FavouriteListTableViewController.swift
//  FlickrAlbum
//
//  Created by Student on 8/2/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

class FavouriteListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favourites"
        self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem
        openDB()
        tableView.reloadData()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.clearsSelectionOnViewWillAppear = false
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        SelectAllDataFromDB()
        tableView.reloadData()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        nameAll = NSMutableArray()
        urlAll  = NSMutableArray()
        cmtAll = NSMutableArray()
        idAll = NSMutableArray()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nameAll.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavCell", forIndexPath: indexPath) as! FavListTableCell
        //let cell = UITableViewCell()
        let data_head = nameAll[indexPath.row] as! String
        let obj_image = urlAll[indexPath.row] as! String
        //let obj_cmt = cmtAll[indexPath.row] as! String
        //let obj_id = idAll[indexPath.row] as! String
        //print(obj_image)
        cell.title?.text = data_head
        cell.favimageView?.image = UIImage(data: NSData(contentsOfURL: NSURL(string: obj_image)!)!)
          return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            nameAll.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            let id_select = idAll[indexPath.row];
            print(id_select);
            deleteContact(id_select as! String)
            SelectAllDataFromDB()
            tableView.reloadData()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //print("wananananaanan" )
        //print("You selected cell #\(indexPath.row)!")
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(
        segue: UIStoryboardSegue, sender: AnyObject?) {
            
            if(segue.identifier == "FavDetailSegue")
            {
                let cell = sender as! UITableViewCell
                let indexPath = self.tableView!.indexPathForCell(cell)
                let photo_title = nameAll[indexPath!.row]
                let photo_url =  urlAll[indexPath!.row]
                let photo_cmt =  cmtAll[indexPath!.row]
                let photo_id =  idAll[indexPath!.row]
                let vc = segue.destinationViewController as! FavDetailViewController
                vc.id = photo_id as! String
                vc.imgtitle = photo_title as! String
                vc.url = photo_url as! String
                vc.cmt = photo_cmt as! String
                vc.img = UIImage(data: NSData(contentsOfURL: NSURL(string: photo_url as! String)!)!)
            }
    }


}
