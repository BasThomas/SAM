//
//  DefaultTableViewCell.swift
//  SAM
//
//  Created by Bas on 10/12/2014.
//  Copyright (c) 2014 Bas. All rights reserved.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {
    @IBOutlet weak var defaultLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
