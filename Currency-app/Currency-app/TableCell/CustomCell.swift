//
//  CustomCell.swift
//  Currency-app
//
//  Created by giorgi obgaidze on 2/7/21.
//  Copyright © 2021 giorgi obgaidze. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    @IBOutlet weak var currancyFullname: UILabel!
    @IBOutlet weak var currancyShortName: UILabel!
    @IBOutlet weak var courseValue: UILabel!
    @IBOutlet weak var changeValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
