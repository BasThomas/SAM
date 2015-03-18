//
//  UserTableViewCell.swift
//  SAM
//
//  Created by Bas on 18/03/2015.
//  Copyright (c) 2015 Bas. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell
{
	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	
    override func awakeFromNib()
	{
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
	{
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
