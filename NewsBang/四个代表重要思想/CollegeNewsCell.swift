//
//  CollegeNewsCell.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/1/8.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit

class CollegeNewsCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var bg: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
