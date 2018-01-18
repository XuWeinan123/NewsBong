//
//  CommentCell.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/1/12.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var content: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = avatar.frame.width/2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
