//
//  DetailTableViewController.swift
//  SAM
//
//  Created by Bas on 18/03/2015.
//  Copyright (c) 2015 Bas. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController
{
	@IBOutlet weak var addUserBarButtonItem: UIBarButtonItem!
	
	var project: Project?
	
    override func viewDidLoad()
	{
        super.viewDidLoad()

		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
		
		if let project = self.project
		{
			self.navigationItem.title = project.name
		}
		else
		{
			self.navigationItem.title = "Unknown project"
		}
		
		if let font = UIFont(name: "FontAwesome", size: 20)
		{
			self.addUserBarButtonItem.setTitleTextAttributes([NSFontAttributeName: font], forState: .Normal)
			self.addUserBarButtonItem.title = "\u{f234}"
		}
		else
		{
			println("no font awe")
		}
    }

    override func didReceiveMemoryWarning()
	{
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
	{
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
        // Return the number of rows in the section.
		if let project = self.project
		{
			return project.students.count
		}
		
		return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
        let cell = tableView.dequeueReusableCellWithIdentifier("user", forIndexPath: indexPath) as UserTableViewCell

        // Configure the cell...
		
		if let project = self.project
		{
			cell.nameLabel.text = project.students[indexPath.row].surName
		}

        return cell
    }
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
	{
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
	{
        if editingStyle == .Delete
		{
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
		else if editingStyle == .Insert
		{
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath)
	{

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
	{
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
	
	// MARK: - Actions
	
	@IBAction func addUser(sender: AnyObject)
	{
		println("adding user")
	}
}