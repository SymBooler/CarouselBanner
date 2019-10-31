//
//  TitleTableViewCell.swift
//  MeetStar
//
//  Created by 张广路 on 2019/10/30.
//  Copyright © 2019 王超. All rights reserved.
//

import UIKit
import Reusable

final class TitleTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessoryImageView: UIImageView!
    @IBOutlet weak var spacer: UIView!
    
    @IBOutlet weak var titleLeading: NSLayoutConstraint!
    @IBOutlet weak var titleTop: NSLayoutConstraint!
    
    var observation: NSKeyValueObservation!
    
    var hideAccessoryView = false {
        didSet {
            accessoryImageView?.isHidden = hideAccessoryView
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryImageView.isHidden = hideAccessoryView
        observation = titleLabel.observe(\.textAlignment, options: [.old, .new]) { [unowned self] (label, change) in
            self.alignmentChanged(alignment: label.textAlignment)
        }
        
//        observation = observe(\.titleLabel.textAlignment, options: [.old, .new], changeHandler: { [unowned self] (label, change) in
//                if change.kind == .setting && change.oldValue != change.newValue {
//                    self.alignmentChanged(alignment: change.newValue)
//                }
//        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        accessoryImageView.isHidden = hideAccessoryView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func alignmentChanged(alignment: NSTextAlignment?) {
        guard let ali = alignment else {
            return
        }
        switch ali {
        case .center:
            spacer.isHidden = false
        case .left:
            spacer.isHidden = true
        case .right:
            spacer.isHidden = true
        default:
            break
        }
    }
    
}
