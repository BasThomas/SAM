//
//  ProjectTableViewController.swift
//  SAM
//
//  Created by Bas on 10/12/2014.
//  Copyright (c) 2014 Bas. All rights reserved.
//

import UIKit
import SAMKit

class ProjectTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate, RequestDelegate
{
    var projects = [Project]()
    var filteredProjects = [Project]()
	var students = Set<Student>()
    
    required init(coder aDecoder: NSCoder)
	{
        super.init(coder: aDecoder)
		
		let req = Request(delegate: self)
		req.get(request: "userinfo.php", withParams: ["pcn": "300486", "key": "SAMjson"])
    }
	
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		
		self.searchDisplayController!.searchBar.tintColor = .fontysColor()
		
		// Fix hairline
		self.searchDisplayController!.searchBar.layer.borderColor = UIColor.searchBarColor().CGColor
		self.searchDisplayController!.searchBar.layer.borderWidth = 1
	}
	
    override func viewDidLoad()
    {
        super.viewDidLoad()
		
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.searchDisplayController!.searchResultsTableView
        {
            return self.filteredProjects.count
        }
		
		return self.projects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("default", forIndexPath: indexPath) as! DefaultTableViewCell
		
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
            let dvc = segue.destinationViewController as! DetailTableViewController
            let cell = sender as! DefaultTableViewCell
            
            dvc.project = cell.project
        }
    }
	
	// MARK: - Request delegate
	func handleJSON(json: NSDictionary, forRequest request: String, withParams params: [String : String])
	{
		switch (request)
		{
			case "userinfo.php":
				self.setupProjects(json)
			
			case "projectinfo.php":
				self.setupUsers(json, forProject: params["id"])
			
			default:
				return
		}
	}
	
	func handleError(error: NSError)
	{
		println("handleError(): \(error.localizedDescription)")
	}
	
	func handleActionFeedback(forMethod method: String)
	{
		println("handleActionFeedback (for method \(method))")
	}
    
    // MARK: - Methods
	
	private func setupProjects(json: NSDictionary)
	{
		println(json)
		if let projects = json["projects"] as? NSArray
		{
			for project in projects
			{
				var id: Int!
				var name: String!
				var startDate: NSDate!
				var endDate: NSDate?
				
				if let _id = project["id"] as? String
				{
					id = _id.toInt()
				}
				
				if let _name = project["name"] as? String
				{
					name = _name
				}
				
				if let _startDate = project["startdate"] as? String
				{
					let formatter = NSDateFormatter()
					formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
					
					startDate = formatter.dateFromString(_startDate)
					
					if let _endDate = project["enddate"] as? String
					{
						let tempEndDate = formatter.dateFromString(_endDate)
						
						if startDate < tempEndDate
						{
							endDate = tempEndDate
						}
					}
				}
				
				if id != nil && name != nil && startDate != nil
				{
					let project = Project(id: id, name: name, startDate: startDate, endDate: endDate)
					println("Project enddate for \(project.name) is \(project.endDate)")
					self.projects.append(project)

					let req = Request(delegate: self)
					req.get(request: "projectinfo.php", withParams: ["key": "SAMjson", "id": "\(id)"])
				}
			}
			
			self.sortProjects()
		}
	}
	
	private func setupUsers(json: NSDictionary, forProject project: String?)
	{
		//println(json)
		if let id = project
		{
			if let project = self.project(forID: id.toInt())
			{
				if let students = json["students"] as? NSArray
				{
					for student in students
					{
						var code: Int!
						var surName: String!
						
						if let _code = student["checkedin"] as? Int
						{
							code = _code
						}
						
						if let _surName = student["pcn"] as? String
						{
							surName = _surName
						}
						
						if surName != nil &&
							code != nil
						{
							let student = Student(surName, code: code)
							project.addStudent(student)
							
							self.students.insert(student)
						}
					}
				}
			}
		}
	}
    
    private func filterContentForSearchText(searchText: String)
    {
        self.filteredProjects = self.projects.filter(
		{
			(project: Project) -> Bool in
			
			return project.name.lowercaseString.hasPrefix(searchText.lowercaseString)
		})
    }
	
	private func sortProjects()
	{
		self.projects = sorted(self.projects) {$0.name < $1.name}
		tableView.reloadData()
	}
	
	private func project(forID id: Int?) -> Project?
	{
		if let id = id
		{
			for project in self.projects
			{
				if project.id == id
				{
					return project
				}
			}
		}
		
		return nil
	}
}