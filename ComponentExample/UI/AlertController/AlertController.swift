//
//  AlertController.swift
//  AegeanProperty
//
//  Created by 张广路 on 2019/5/17.
//  Copyright © 2019 Redstar. All rights reserved.
//

import UIKit

class AlertController: UIViewController {
    
    static let date: Date = Date()
    static let reuseIdentifier = String(describing: UITableViewCell.self)
    static let actionButtonHeight: CGFloat = 49
    
    private var transition: PresentTransitionHandler?
    private var style: ModalStyle = .alert
    
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet weak var actionContainer: UIView!
    @IBOutlet private weak var alertContainerView: UIView!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!
    
    @IBOutlet weak var actionSheetContainer: UIView!
    @IBOutlet weak var actionsheetTableView: UITableView!
    @IBOutlet weak var cancelSeparatorView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var cancelSeparatorHeight: NSLayoutConstraint!
    
    var alertActions =  [AlertAction]()
    var isMultiMode = false
    var itemTitles =  [String]()
    var callback: ((Int, String) -> Void)?
    var tintColor = UIColor(hexString: "#1D85FE")
    var normalColor = UIColor(hexString: "#666666")
    
    @objc var cancelAction: AlertAction? = AlertAction(title: "取消", style: .cancel, handler: nil) {
        didSet {
            cancelButton?.setTitle(cancelAction?.title, for: .normal)
        }
    }
    var actionButtons = [UIButton]()
    var separatorViews = [UIView]()
    
    convenience init(style: ModalStyle, title: String?, confrimBlock: @escaping AlertAction.Handler) {
        self.init(with: style, title: title)
        let cancel = AlertAction(title: "取消", style: .cancel, handler: nil)
        let confirm = AlertAction(title: "确定", style: .confirm, handler: confrimBlock)
        addAction(alertAction: cancel)
        addAction(alertAction: confirm)
    }
    
    @objc required init(with style: ModalStyle, title: String?) {
        
        super.init(nibName: String(describing: AlertController.self), bundle: nil)
        self.style = style
        self.title = title
        
        initTransition()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let gestures = bgView?.gestureRecognizers {
            for g in gestures {
                bgView.removeGestureRecognizer(g)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isMultiMode {
            addActionButtons()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutActionButtons()
    }
    
    func initTransition() {
        
        switch style {
        case .alert:
            transition = PresentTransitionHandler(animator: PresentScaleAnimator())
        default:
            transition = PresentTransitionHandler(animator: PresentCoverVerticalAnimator())
        }
        transitioningDelegate = transition
        modalPresentationStyle = .overFullScreen
    }
    
    func appearanceSetup() {
        
        switch style {
        case .alert:
            alertAppearanceSetup()
        default:
            actionSheetAppearanceSetup()
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true) { [unowned self] in
            if let action = self.cancelAction {
                action.handler?(action)
            }
        }
    }
    
    @objc func addAction(alertAction: AlertAction) {
        
        switch style {
        case .actionSheet:
            switch alertAction.style {
            case .cancel:
                cancelAction = alertAction
            default:
                alertActions.append(alertAction)
            }
        case .alert:
            alertActions.append(alertAction)
            
        default:
            break
        }
    }
    
    @objc func addActions(alertActions: [AlertAction], hasCancel: Bool) {
        
        self.alertActions.append(contentsOf: alertActions)
        switch style {
        case .actionSheet:
            cancelAction = AlertAction(title: "取消", style: .cancel, handler: nil)
            
        default:
            break
        }
    }
    
    func addActions(_ titles: [String], callback: ((Int, String)->())? = nil) {
        if style == .alert {
            return
        }
        isMultiMode = true
        itemTitles = titles
        self.callback = callback
    }
    
    func actionSheetAppearanceSetup() {
        actionSheetContainer.isHidden = false
        actionsheetTableView.register(UITableViewCell.self, forCellReuseIdentifier: AlertController.reuseIdentifier)
        actionsheetTableView.backgroundColor = ColorConst.background
        actionsheetTableView.separatorColor = ColorConst.separator
        actionsheetTableView.separatorInset = UIEdgeInsets.zero
        cancelSeparatorView.backgroundColor = ColorConst.background
        cancelButton.setTitle(cancelAction?.title, for: .normal)
        var height: CGFloat = CGFloat(alertActions.count * 49)
        if isMultiMode {
            height = CGFloat(itemTitles.count * 49)
        }
        if cancelAction == nil {
            cancelSeparatorView.isHidden = true
            cancelButton.isHidden = true
            cancelSeparatorHeight.constant = 0
            cancelButtonHeight.constant = 0
        }
        tableHeightConstraint.constant = height
        actionSheetContainer.layoutIfNeeded()
        
        let gesture = UITapGestureRecognizer { [weak self] (gesture) in
            self?.actionSheetDismiss()
        }
        bgView.addGestureRecognizer(gesture)
    }
    
    func dismiss(completion: @escaping () -> (Void)) {
        view.isUserInteractionEnabled = false
        dismiss(animated: true) {
            completion()
        }
    }
}

extension AlertController {
    
    func alertAppearanceSetup() {
        
        alertContainerView.isHidden = false
//        actionButtons.append(leftButton)
//        actionButtons.append(rightButton)
//        let count = min(actionButtons.count, alertActions.count)
//
//        for i in 0 ..< count {
//            let button = actionButtons[i]
//            let action = alertActions[i]
//            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//            switch action.style {
//            case .confirm:
//                button.setTitleColor(UIColor(hexString: "#25B5C6"), for: .normal)
//            default:
//                button.setTitleColor(UIColor(hexString: "#666666"), for: .normal)
//            }
//        }
        titleLabel.textColor = UIColor(hexString: "#666666")
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        titleLabel.text = title
        alertContainerView.layer.cornerRadius = 4
    }
    
    @IBAction func leftTaped(_ sender: Any) {
        
        dismiss {
            if let action = self.alertActions.first, let handler = action.handler {
                handler(action)
            }
        }
    }
    @IBAction func rightTaped(_ sender: Any) {
        if let action = alertActions.last, let handler = action.handler {
            handler(action)
        }
        dismiss {
            if let action = self.alertActions.first, let handler = action.handler {
                handler(action)
            }
        }
    }
    
    func addActionButtons() {
        
        for action in alertActions {
            let button = UIButton(type: .custom)
            button.setTitle(action.title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.backgroundColor = .white
            switch action.style {
            case .confirm:
                button.setTitleColor(tintColor, for: .normal)
            default:
                button.setTitleColor(normalColor, for: .normal)
            }
            actionContainer.addSubview(button)
            actionButtons.append(button)
            button.addTarget(self, action: #selector(alertActionButtonTapped(sender:)), for: .touchUpInside)
        }
        
        for _ in 0 ..< alertActions.count - 1 {
            let separatorView = UIView(frame: CGRect.zero)
            separatorView.backgroundColor = UIColor(hexString: "#E4E4E4")
            actionContainer.addSubview(separatorView)
            separatorViews.append(separatorView)
        }
    }
    
    func layoutActionButtons() {
        var rect = actionContainer.frame
        if actionButtons.count < 3 {
            
            let itemHeight = AlertController.actionButtonHeight
            actionContainer.frame = rect
            rect = alertContainerView.frame
            rect.size.height = itemHeight + titleContainer.frame.size.height
            alertContainerView.frame = rect
            
            rect = actionContainer.frame
            
            let itemWidth = rect.size.width / CGFloat(actionButtons.count)
            for (i, button) in actionButtons.enumerated() {
                button.frame = CGRect(x: CGFloat(i) * itemWidth, y: 0, width: itemWidth, height: itemHeight)
            }
            for (i, view) in separatorViews.enumerated() {
                view.frame = CGRect(x: itemWidth * CGFloat(i + 1), y: 0, width: 0.5, height: itemHeight)
                view.superview?.bringSubviewToFront(view)
            }
        } else {
            
            let itemHeight = AlertController.actionButtonHeight
            let actionHeight = itemHeight * CGFloat(actionButtons.count)
            actionContainer.frame = rect
            rect = alertContainerView.frame
            rect.size.height = actionHeight + titleContainer.frame.size.height
            alertContainerView.frame = rect
            
            rect = actionContainer.frame
            
            let itemWidth = rect.size.width
            for (i, button) in actionButtons.enumerated() {
                button.frame = CGRect(x: 0, y: CGFloat(i) * AlertController.actionButtonHeight, width: itemWidth, height: itemHeight)
            }
            for (i, view) in separatorViews.enumerated() {
                view.frame = CGRect(x: 0, y: itemHeight * CGFloat(i + 1), width: itemWidth, height: 0.5)
                view.superview?.bringSubviewToFront(view)
            }
        }
    }
    
    @objc func alertActionButtonTapped(sender: UIButton) {
        
        dismiss {
            if let index = self.actionButtons.firstIndex(of: sender), let handler = self.alertActions[index].handler {
                handler(self.alertActions[index])
            }
        }
    }
}

extension AlertController {
    
    @objc public enum ModalStyle : Int {
        
        case actionSheet
        case alert
    }
}

extension AlertController: PresentControllerProtocol {
    
    //MARK: PresentProtocol
    var backgroundView: UIView {
        get {
            return bgView
        }
    }
    var foregroundView: UIView {
        get {
            switch style {
            case .alert:
                return alertContainerView
            default:
                return actionSheetContainer
            }
        }
    }
}

extension AlertController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMultiMode {
            return itemTitles.count
        }
        return alertActions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlertController.reuseIdentifier) else { return UITableViewCell(style: .default, reuseIdentifier: AlertController.reuseIdentifier) }
        
        cell.textLabel?.textColor = UIColor(hexString: "#444444")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textAlignment = .center
        cell.selectionStyle = .none
        switch indexPath.section {
        case 1:
            cell.textLabel?.text = cancelAction?.title
            cell.textLabel?.textColor = UIColor(hexString: "#666666")
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat.greatestFiniteMagnitude)
        default:
            if isMultiMode {
                cell.textLabel?.text = itemTitles[indexPath.row]
            } else {
                cell.textLabel?.text = alertActions[indexPath.row].title
                if alertActions[indexPath.row].style == .destructive {
                    cell.textLabel?.textColor = UIColor(hexString: "#E85043")
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        switch section {
//        case 0:
//            return 0
//        default:
//            return 0
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        debugPrint("AlertController:// didSelectRowAt \(Date().timeIntervalSince(AlertController.date as Date))")
        switch indexPath.section {
        case 0:
            if isMultiMode {
                dismiss(animated: true) {
                    self.callback?(indexPath.row, self.itemTitles[indexPath.row])
                }
            } else {
                actionSheetDismiss(action: alertActions[indexPath.row])
            }
        default:
            actionSheetDismiss(action: cancelAction)
        }
    }
    
    func actionSheetDismiss(action a: AlertAction? = nil) {
        
        dismiss(animated: true) {
            debugPrint("AlertController:// dismiss block \(Date().timeIntervalSince(AlertController.date as Date))")
            if let action = a, let handler = a?.handler {
                handler(action)
            }
        }
    }
}

@objc class AlertAction : NSObject {
    
    public typealias Handler = (AlertAction) -> Void
    
    var title: String?
    var style: AlertStyle = .default
    var handler: Handler?
    
    override init() {
        super.init()
    }
    
    @objc convenience init(title: String?, style: AlertStyle, handler: Handler?) {
        self.init()
        self.title = title
        self.style = style
        self.handler = handler
    }
    
    
    @objc public enum AlertStyle : Int {
        
        case `default`
        case confirm
        case cancel
        case destructive
    }
}

