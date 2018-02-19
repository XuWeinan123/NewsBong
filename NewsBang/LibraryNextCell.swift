//
//  LibraryNextCell.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/2/18.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit

class LibraryNextCell: UITableViewCell {

    @IBOutlet var callNumber:UILabel!
    @IBOutlet var location:UILabel!
    @IBOutlet var code:UILabel!
    @IBOutlet var status:UILabel!
    @IBOutlet var codeImage: UIImageView!
    @IBOutlet var spline: UIView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
