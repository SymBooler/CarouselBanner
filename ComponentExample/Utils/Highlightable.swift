//
//  Highlightable.swift
//  MeetStar
//
//  Created by 张广路 on 2019/9/18.
//  Copyright © 2019 王超. All rights reserved.
//

import Foundation

public protocol Highlightable: class {
    var textValue: String? { get }
    var attributedTextValue: NSAttributedString? { get set }
    
    func highlight(text: String, normal normalAttributes: [NSAttributedString.Key : Any]?, highlight highlightAttributes: [NSAttributedString.Key : Any]?)
}

extension Highlightable {
    public func highlight(text: String, normal normalAttributes: [NSAttributedString.Key : Any]?, highlight highlightAttributes: [NSAttributedString.Key : Any]?) {
        guard let inputText = self.textValue else { return }
        
        let highlightRanges = inputText.ranges(of: text)
        
        guard !highlightRanges.isEmpty else { return }
        
        self.attributedTextValue = NSAttributedString.highlight(
            ranges: highlightRanges,
            at: text,
            in: inputText,
            normal: normalAttributes,
            highlight: highlightAttributes
        )
    }
}
