//
//  CarouselView.swift
//  MeetStar
//
//  Created by 张广路 on 2019/7/8.
//  Copyright © 2019 王超. All rights reserved.
//

import UIKit
import Reusable

final class CarouselView: UIView, NibOwnerLoadable {
    
    enum AutoPagingMode {
        case `default`
        case paging
        case userStop
        case suspend
    }
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var stackWidth: NSLayoutConstraint!
    
    @objc var dataSource: [String]? {
        didSet {
            initContent()
        }
    }
    
    @objc var cycleScroll = true
    
    private var parallax = true
    private let offsetRate: CGFloat = 0.3
    private var imageViewSwapped = false
    private var timer: Timer?
    private var pagingMode = AutoPagingMode.default
    
    private var beginOffsetX: CGFloat = 0
    private var targetOffsetX: CGFloat = -1
    private var initOffsetForCycle = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNibContent()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func didMoveToWindow() {
        
        let beginIndex = stackView.arrangedSubviews.count / 2
        scrollView.contentOffset.x = CGFloat(beginIndex) * scrollView.frame.size.width
    }
    
    func createImageViews() {
//        UIImageView
    }
    
    func initContent() {
        scrollView.isPagingEnabled = false
        
        if cycleScroll {
            initContentForCycle()
        } else {
            initContentForLinear()
        }
        
        pageControl.numberOfPages = self.dataSource?.count ?? 1
        pageControl.hidesForSinglePage = true
    }
    
    func initContentForLinear() {
        let count = min(dataSource?.count ?? 0, stackView.arrangedSubviews.count)
        for i in 0 ..< count {
            let imageView = stackView.arrangedSubviews[i] as! UIImageView
            if let imageName = dataSource?[i] {
                imageView.image = UIImage(named: imageName)
            }
        }
        
        let removeItems = stackView.arrangedSubviews.count - count
        if removeItems > 0 {
            for _ in 0 ..< removeItems {
                if let lastView = stackView.arrangedSubviews.last {
                    stackView.removeArrangedSubview(lastView)
                }
            }
            let widthConstraint = NSLayoutConstraint(item: stackView!, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: CGFloat(count), constant: 0)
            widthConstraint.priority = .required
            NSLayoutConstraint.activate([widthConstraint])
        }
    }
    
    func initContentForCycle() {
        
        guard let imageNames = dataSource, cycleScroll else {
            return
        }
        imageViewSwapped = true
        let beginIndex = stackView.arrangedSubviews.count / 2
        for i in 0..<stackView.arrangedSubviews.count {
            let index = (beginIndex + i) % stackView.arrangedSubviews.count
            let imageIndex = (i + imageNames.count) % imageNames.count
            if let imageView = stackView.arrangedSubviews[index] as? UIImageView {
                imageView.image = UIImage(named: imageNames[imageIndex])
            }
        }
    }
    
    @objc func beginAutoPaging() {
//        return
        initOffsetForCycle = false
        pagingMode = .paging
        if let timer = self.timer {
            timer.fire()
        } else {
            let timer = Timer(timeInterval: 2.0, repeats: true) { [weak self] (timer) in
            guard let strongSelf = self else {
                return
            }
            let offset = strongSelf.scrollView.contentOffset
            var offsetX = (offset.x + strongSelf.pageWidth())
            if offsetX >= strongSelf.scrollView.contentSize.width, !strongSelf.cycleScroll {
                offsetX = 0
                strongSelf.resetImageViewsForAutoPaging()
            }
            strongSelf.beginOffsetX = offset.x
            strongSelf.targetOffsetX = offsetX
            strongSelf.scrollView.setContentOffset(CGPoint(x: offsetX, y: offset.y), animated: true)
            }
            RunLoop.main.add(timer, forMode: .default)
            self.timer = timer
        }
    }
    
    @objc func stopAutoPaging() {
        stopAutoPaging(byUser: true)
    }
    
    func stopAutoPaging(byUser: Bool) {
        self.timer?.invalidate()
        self.timer = nil
        if byUser {
            pagingMode = .default
        } else {
            pagingMode = .suspend
        }
    }
    
    func resumeAutoPaging() {
        guard pagingMode == .suspend else {
            return
        }
        beginAutoPaging()
    }
    
    deinit {
        stopAutoPaging()
    }
}

extension CarouselView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoPaging(byUser: false)
        beginOffsetX = round(scrollView.contentOffset.x / scrollView.frame.size.width) * scrollView.frame.size.width
        initOffsetForCycle = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if cycleScroll, initOffsetForCycle {
            let beginIndex = stackView.arrangedSubviews.count / 2
            scrollView.contentOffset.x = CGFloat(beginIndex) * scrollView.frame.size.width
            return
        }
        if abs(scrollView.contentOffset.x - targetOffsetX) < 0.5, targetOffsetX >= 0 {
            
            let beginX = beginOffsetX
            let targetX = targetOffsetX
            
            targetOffsetX = -1
            beginOffsetX = -1
            handleUserPaging(beginOffsetX: beginX, targetOffsetX: targetX)
            resumeAutoPaging()
        }
        if parallax, beginOffsetX >= 0 {
            nextPageMove(currentMoveX: scrollView.contentOffset.x - beginOffsetX)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView.isPagingEnabled {
            targetOffsetX = targetContentOffset.pointee.x
            return
        }
        let result = targetOffsetX(with: scrollView.contentOffset.x, velocityX: velocity.x)
        targetContentOffset.pointee.x = result.1
        targetOffsetX = result.1
        if !result.0 {
            scrollView.setContentOffset(CGPoint(x: result.1, y: targetContentOffset.pointee.y), animated: true)
        }
    }
    
    func targetOffsetX(with offsetX: CGFloat, velocityX: CGFloat) -> (Bool, CGFloat) {
        
        let width = pageWidth()
        let moveX = offsetX - beginOffsetX
        let goNext = abs(moveX) >= width * 0.4 || (abs(velocityX) > 0 && abs(moveX) >= width * 0.1)
        if goNext {
            
            if moveX > 0 {
                return (true, beginOffsetX + width)
            }
            return (true, beginOffsetX - width)
        }
        return (false, beginOffsetX)
    }
    
    func handleUserPaging(beginOffsetX: CGFloat, targetOffsetX: CGFloat) {
        
        let movePage = Int(round((targetOffsetX - beginOffsetX) / pageWidth()))
        let distance = stackView.arrangedSubviews.count / 2
        var page = pageControl.currentPage + movePage
        if cycleScroll {
            page = (page + pageControl.numberOfPages) % pageControl.numberOfPages
        }
        guard let imageNames = dataSource, imageNames.count > stackView.arrangedSubviews.count || cycleScroll else {
            pageControl.currentPage = page
            if parallax {
                resetImageViewsAfterPagingForParallax(page: page, movePage: movePage)
            }
            return
        }
        guard let direction = Direction(rawValue: movePage) else {
            return
        }
        
        switch direction {
        case .right:
            var replacedPage = page + distance
            if cycleScroll {
                replacedPage = replacedPage % imageNames.count
            }
            //            replacedPage < imageNames.count
            if parallax {
                resetImageViewsAfterPagingForParallax(page: page, movePage: movePage)
            }
            if needReset(x: beginOffsetX) {
                resetImageViews(fromIndex: 0, toIndex: stackView.arrangedSubviews.count - 1, imageIndex: replacedPage)
            }
            
        case .left:
            var replacedPage = page - distance
            if cycleScroll {
                replacedPage = (replacedPage + imageNames.count) % imageNames.count
            }
            if parallax {
                resetImageViewsAfterPagingForParallax(page: page, movePage: movePage)
            }
            if needReset(x: beginOffsetX), replacedPage >= 0 {
                resetImageViews(fromIndex: stackView.arrangedSubviews.count - 1, toIndex: 0, imageIndex: replacedPage)
            }
        }
        pageControl.currentPage = page
        
    }
    
    func pageWidth() -> CGFloat {
        
        if parallax {
            return scrollView.frame.size.width / (1 + offsetRate);
        }
        return scrollView.frame.size.width
    }
    
    func resetImageViews(fromIndex: Int, toIndex: Int, imageIndex: Int) {
        
        guard let imageNames = dataSource else {
            return
        }
        let imageView: UIImageView = stackView.arrangedSubviews[fromIndex] as! UIImageView
        stackView.insertArrangedSubview(imageView, at: toIndex)
        if imageIndex < imageNames.count {
            imageView.image = UIImage(named: imageNames[imageIndex])
        }
        scrollView.contentOffset = CGPoint(x: CGFloat(stackView.arrangedSubviews.count / 2) * scrollView.frame.size.width, y: 0)
        imageViewSwapped = true
    }
    
    func resetImageViewsForAutoPaging() {
        let count = min(dataSource?.count ?? 0, stackView.arrangedSubviews.count)
        for i in 0 ..< count {
            let imageView = stackView.arrangedSubviews[i] as! UIImageView
            if let imageName = dataSource?[i] {
                imageView.image = UIImage(named: imageName)
            }
        }
        pageControl.currentPage = 0
    }
    
    //MARK: for parallax
    func nextPageMove(currentMoveX: CGFloat) {
        
        guard currentMoveX != 0, parallax else {
            return
        }
        let currentPage = pageControl.currentPage
        if currentMoveX > 0 {
            let nextPage = currentPage + 1;
            if let nextView = imageView(page: nextPage, movePage: 1) {
                nextView.transform = CGAffineTransform(translationX: -currentMoveX * offsetRate, y: 0)
                stackView.bringSubviewToFront(nextView)
            }
        } else {
            let nextPage = currentPage - 1;
            if let nextView = imageView(page: nextPage, movePage: -1) {
                nextView.transform = CGAffineTransform(translationX: -currentMoveX * offsetRate, y: 0)
                stackView.bringSubviewToFront(nextView)
            }
        }
    }
    func resetImageViewsAfterPagingForParallax(page: Int, movePage: Int) {
        guard parallax else {
            return
        }
        if !imageViewSwapped {
//            let p = (page + pageControl.numberOfPages) % pageControl.numberOfPages
            scrollView.contentOffset.x = CGFloat(page) * scrollView.frame.size.width
        }
        
        guard let imageView = imageView(page: page, movePage: movePage) else {
            return
        }
        imageView.transform = .identity
    }
    
    func imageView(page: Int, movePage: Int) -> UIImageView? {
        
        guard imageViewSwapped else {
            
            guard case 0 ..< stackView.arrangedSubviews.count = page else {
                return nil
            }
            return stackView.arrangedSubviews[page] as? UIImageView
        }
        let targetIndex = stackView.arrangedSubviews.count / 2 + movePage
        return stackView.arrangedSubviews[targetIndex] as? UIImageView
    }
    
    func needSwapContentView() -> Bool {
        return dataSource?.count ?? 0 > stackView.arrangedSubviews.count
    }
    
    func resetOffset(page: Int) {
        scrollView.contentOffset.x = CGFloat(page) * scrollView.frame.size.width
    }
    
    func needReset(x: CGFloat) -> Bool {
        return Int(x / scrollView.frame.size.width) == stackView.arrangedSubviews.count / 2
    }
}

extension CarouselView {
    
    enum Direction: Int {
        case left
        case right
        init?(rawValue: Int) {
            
            if rawValue > 0 {
                self = .right
            } else if rawValue < 0 {
                self = .left
            } else {
                return nil
            }
        }
    }
}
