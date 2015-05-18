//
//  TabBarViewController.swift
//  SAM
//
//  Created by Bas on 01/04/2015.
//  Copyright (c) 2015 Bas. All rights reserved.
//

import UIKit
import SAMKit

class TabBarViewController: UITabBarController
{
    override func viewDidLoad()
	{
        super.viewDidLoad()
		
		UITabBar.appearance().tintColor = .fontysColor()
    }

    override func didReceiveMemoryWarning()
	{
        super.didReceiveMemoryWarning()
    }
}