//
//  resTableViewCell.swift
//  projectX
//
//  Created by Eli Bunimovich on 19/11/2017.
//  Copyright © 2017 Eli Bunimovich. All rights reserved.
//

import UIKit

class repTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var stargazerscount: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
