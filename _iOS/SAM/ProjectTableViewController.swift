//
//  ProjectTableViewController.swift
//  SAM
//
//  Created by Bas on 10/12/2014.
//  Copyright (c) 2014 Bas. All rights reserved.
//

import UIKit

class ProjectTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate
{
    var projects = [Project]()
    var filteredProjects = [Project]()
    
    required init(coder aDecoder: NSCoder)
    {
        let project1 = Project(name: "SAM")
		let user1 = Student("Bas", lastName: "Broek")
		let user2 = Student("Sunny", lastName: "Feijen")
		let teacher1 = Teacher("Ben", lastName: "Schreur")
		
        project1.addTeacher(teacher1)
        project1.addUser(user1)
        project1.addUser(user2)
        
        let project2 = Project(name: "Pepper's Ghost")
        let project3 = Project(name: "STRP")
        let project4 = Project(name: "KPN")
        
        self.projects += [project1, project2, project3, project4]
        
        self.projects = sorted(self.projects) {$0.name < $1.name}
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Searchbar data source
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool
    {
        self.filterContentForSearchText(searchString)
		
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool
    {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
		
        return true
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
        
        if tableView == self.searchDisplayController!.searchResultsTableView
        {
            return self.filteredProjects.count
        }
        else
        {
            return self.projects.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("default", forIndexPath: indexPath) as DefaultTableViewCell

        // Configure the cell...
        
        var project: Project
        
        if tableView == self.searchDisplayController!.searchResultsTableView
        {
            project = self.filteredProjects[indexPath.row]
        }
        else
        {
            project = self.projects[indexPath.row]
        }
        
        cell.project = project
        cell.defaultLabel.text = project.name

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
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
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //self.performSegueWithIdentifier("detail", sender: indexPath)
    }

    // MARK: - Navigation
	
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "detail"
        {
            let dvc = segue.destinationViewController as DetailViewController
            let cell = sender as DefaultTableViewCell
            
            dvc.project = cell.project
        }
    }
    
    // MARK: - Methods
    
    func filterContentForSearchText(searchText: String)
    {
        self.filteredProjects = self.projects.filter(
		{
			(project: Project) -> Bool in
			
			return project.name.lowercaseString.hasPrefix(searchText.lowercaseString)
		})
    }
}