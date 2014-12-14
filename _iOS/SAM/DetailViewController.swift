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
    @IBOutlet weak var timeSwitch: UISwitch!
    var titleText: String?

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set the Title for this view.
        if let titleText = self.titleText
        {
            self.navigationItem.title = self.titleText
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
