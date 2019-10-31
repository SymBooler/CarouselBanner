//
//  ShareCell.swift
//  MeetStar
//
//  Created by 张广路 on 2019/10/10.
//  Copyright © 2019 王超. All rights reserved.
//

import UIKit
import Reusable

final class ShareCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func config(type: ShareViewController.ShareType) {
        
        nameLabel.text = type.rawValue
        switch type {
        case .QQ:
            imageView.image = UIImage(named: "share_qq")
        case .Weibo:
            imageView.image = UIImage(named: "share_weibo")
        case .WeiXin:
            imageView.image = UIImage(named: "share_weixin")
        case .PengYouQuan:
            imageView.image = UIImage(named: "share_pyq")
        }
    }
}
