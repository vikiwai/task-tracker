//
//  TrackerTableViewCell.swift
//  task-tracker
//
//  Created by vikiwai on 27/05/2019.
//  Copyright © 2019 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class TrackerTableViewCell: UITableViewCell {

    @IBOutlet weak var checkmarkImage: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
