//
//  DetailViewController.swift
//  SAM
//
//  Created by Bas on 10/12/2014.
//  Copyright (c) 2014 Bas. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController
{
	@IBOutlet weak var projectLabel: UILabel!
	@IBOutlet weak var studentsLabel: UILabel!
	@IBOutlet weak var teacherLabel: UILabel!
	
    var project: Project?
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // Set the Title for this view.
        if let project = self.project
        {
            self.navigationItem.title = project.name
			
			self.projectLabel.text = "\(project.name) (\(project.id))"
			
			var studNames = [String]()
			
			for student in project.students
			{
				studNames.append(student.fullName)
			}
			
			if studNames != [String]()
			{
				self.studentsLabel.text = " & ".join(studNames)
			}
			else
			{
				self.studentsLabel.text = "No students"
			}
			
			self.teacherLabel.text = project.teacher?.fullName ?? "No teacher"
        }
        else
        {
            self.navigationItem.title = "Unknown project"
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
