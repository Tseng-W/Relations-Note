//
//  LobbyScheduleCell.swift
//  PersonBook
//
//  Created by 曾問 on 2021/5/3.
//

import UIKit
import TagListView

class LobbyEventTableCell: UITableViewCell {
    
    @IBOutlet var userIcon: UIImageView!
    @IBOutlet var eventLabel: UILabel!
    @IBOutlet var moreUserView: UIView!
    @IBOutlet var tagListView: TagListView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
