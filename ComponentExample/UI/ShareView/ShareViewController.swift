//
//  ShareViewController.swift
//  MeetStar
//
//  Created by 张广路 on 2019/10/10.
//  Copyright © 2019 王超. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    enum ShareType: String {
        case QQ = "QQ"
        case Weibo = "新浪微博"
        case WeiXin = "微信"
        case PengYouQuan = "朋友圈"
    }
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var collectionViewLeading: NSLayoutConstraint!
    
    private var transition: PresentTransitionHandler?
    private var callback: ((ShareType)->Void)?
    
    var list: [ShareType] = []
    
    convenience init(callback: @escaping (ShareType)->Void) {
        self.init(nibName: String(describing: ShareViewController.self), bundle: nil)
        transition = PresentTransitionHandler(animator: PresentCoverVerticalAnimator())
        transitioningDelegate = transition
        modalPresentationStyle = .overCurrentContext
        self.callback = callback
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPlatform()
        collectionViewConfig()
    }
    
    func initPlatform() {
        
        if UIDevice.current.systemVersion == "12.4.1" {
            list.append(.WeiXin)
            list.append(.PengYouQuan)
            list.append(.Weibo)
            return
        }
        if let umManger = UMSocialManager.default() {
            if umManger.isInstall(.wechatSession) {
                list.append(.WeiXin)
            }
            if umManger.isInstall(.wechatTimeLine) {
                list.append(.PengYouQuan)
            }
            list.append(.Weibo)
        }
    }
    
    func collectionViewConfig() {
        
        if list.count == 1 {
            collectionViewLeading.constant = (YYScreenSize().width - flowLayout.itemSize.width) / 2
        } else {
            let spacing = floor(YYScreenSize().width - 40 - flowLayout.itemSize.width * CGFloat(list.count))
            flowLayout.minimumInteritemSpacing = spacing / CGFloat((list.count - 1))
        }
        
        collectionView.register(cellType: ShareCell.self)
    }

    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        cancel()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        cancel()
    }
    
    func cancel() {
        dismiss(animated: true)
    }
}
//MARK:- UICollectionViewDataSource
extension ShareViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ShareCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.config(type: list[indexPath.item])
        return cell
    }
}

extension ShareViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = list[indexPath.item]
        dismiss(animated: true) {
            self.callback?(type)
        }
    }
}

extension ShareViewController: PresentControllerProtocol {
    
    //MARK: PresentProtocol
    var backgroundView: UIView {
        get {
            return bgView
        }
    }
    var foregroundView: UIView {
        get {
           return containerView
        }
    }
}
