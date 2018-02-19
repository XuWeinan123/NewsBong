//
//  LibraryCell.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/2/18.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit

class LibraryCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var author: UILabel!
    @IBOutlet var publish: UILabel!
    @IBOutlet var bio: UILabel!
    @IBOutlet var bookImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
