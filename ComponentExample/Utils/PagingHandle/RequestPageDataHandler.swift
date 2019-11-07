//
//  RequestPageDataHandler.swift
//  AegeanProperty
//
//  Created by 张广路 on 2019/6/14.
//  Copyright © 2019 Redstar. All rights reserved.
//
/*
import UIKit

@objc class RequestPageDataHandler: NSObject {
    
    var tableView: UITableView? ///required
    var url: String? ///required
    var method = HTTPMethod.get ///optional
    var params: [String:Any]? ///optional
    var body: [String:Any]? ///optional
    var pageModel: RequestedPageDataModel = RequestedPageDataModel() ///optional
    weak var delegate:  RequestPageDataProtocol? ///optional
    var itemType: AnyClass?
    var canLoading = true

    var allData = [Any]()

    class func request(url: String, method: HTTPMethod, params:[String:Any]? = nil, body: [String:Any]? = nil, pageModel: RequestedPageDataModel = RequestedPageDataModel(), tableView: UITableView, delegate: RequestPageDataProtocol, itemType: AnyClass? = nil) -> RequestPageDataHandler {

        let handler = RequestPageDataHandler()
        handler.tableView = tableView
        handler.url = url
        handler.method = method
        handler.params = params
        handler.body = body
        handler.pageModel = pageModel
        handler.delegate = delegate
        handler.itemType = itemType
        
        tableView.mj_header = MJRefreshHeaderBridge.createHeader {
            handler.request(clearData: true)
        }
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            handler.request()
        })
        footer?.setTitle("到底了", for: .noMoreData)
        tableView.mj_footer = footer
//        tableView.autoHideMjFooter = true
        return handler
    }

    required override init() {
        super.init()
    }

    @objc convenience init(url: String, method: String, params:[String:Any]?, body: [String:Any]?, pageModel: RequestedPageDataModel?, tableView: UITableView, delegate: RequestPageDataProtocol, itemType: AnyClass) {
        self.init()
        self.tableView = tableView
        self.url = url
        self.method = HTTPMethod(rawValue: method.uppercased()) ?? .get
        self.params = params
        self.body = body
        self.pageModel = pageModel ?? RequestedPageDataModel()
        self.delegate = delegate
        self.itemType = itemType
        tableView.mj_header = MJRefreshHeaderBridge.createHeader(refreshingBlock: {
            self.request(clearData: true)
        })
//        tableView.mj_header.beginRefreshing()
    }

    func request(clearData: Bool = false) {

        guard let u = url else {
            return
        }

        if clearData {
            pageModel.reset()
//            pageModel.pageSize = 4
        }

        if !pageModel.hasNextPage {
            requestResult(result: .error, model: nil, clearData: clearData)
            delegate?.requestResult(result: .error, list: nil, message: "没有更多数据了", model: pageModel, clearData: clearData)
            return
        }
        var parameters: [String: Any] = ["pageNo": pageModel.nextPage, "pageSize": pageModel.pageSize]
        
        switch method {
        case .get:
            if let p = params {
                parameters.merge(p) { first, _ in first}
            }
            params = parameters
        case .post:
            if let b = body {
                parameters.merge(b) { first, _ in first}
            }
            body = parameters
        default:break
        }
        
        NetworkHandler.request(url: u, method: method, parameters: params, body: body) { [weak self] result in
            
            if let strongSelf = self {
                switch result {
                case .failure(let e):
                    strongSelf.requestResult(result: .failure, model: e.info, clearData: clearData)
                case .success(let m):
                    strongSelf.requestResult(result: .success, model: m, clearData: clearData)
                }
            }
        }
    }

    func requestResult(result: DataModel.Result, model: NetworkResultModel?, clearData: Bool) {
        
        switch result {

        case .success:
            if clearData {
                allData.removeAll()
            }
            guard let networkModel = model,
                let pageModel = RequestedPageDataModel.model(withJSON: networkModel.data),
                let unformatedList = pageModel.list else {
                    handle(result: .failure, list: nil, message: "数据解析出错", model: nil, clearData: clearData)
                    return;
            }
            if let type = itemType, let list = NSArray.modelArray(with: type, json: unformatedList) {
                pageModel.list = list
            }
            self.pageModel = pageModel
            if let l = pageModel.list {
                allData.append(contentsOf: l)
            }
            handle(result: .success, list: allData, message: model?.message, model: pageModel, clearData: clearData)

        case .failure:
            handle(result: .failure, list: nil, message: model?.message, model: pageModel, clearData: clearData)
        default:
            handle(result: .error, list: nil, message: model?.message, model: pageModel, clearData: clearData)
            break
        }
    }
    
    func handle(result: DataModel.Result, list: [Any]?, message: String?, model: RequestedPageDataModel?, clearData: Bool) {
        
        DispatchQueue.main.async {
            self.stopLoadingAnimationAndHide()
            self.delegate?.requestResult(result: result, list: list, message: message, model: model, clearData: clearData)
            
            switch result {
            case .failure:
                self.tableView?.pl_hidenDefaultView()
                self.tableView?.reloadData()
                self.handleNetworkError()
            case .success:
                self.tableView?.pl_hidenDefaultView()
                self.tableView?.reloadData()
                self.checkMjfooter(model: model)
                self.checkNoneData()
            default:break
            }
        }
    }
}

extension RequestPageDataHandler {
    
    func stopLoadingAnimationAndHide() {
        tableView?.mj_header.endRefreshing()
        tableView?.mj_footer?.endRefreshing()
        MBProgressHUD.hiddenHUD()
    }
    
    func checkNoneData() {
        if allData.count <= 0 {
            tableView?.showDefaultViewForNoContent()
        }
    }
    
    func handleNetworkError() {
        if allData.count <= 0 {
            tableView?.showDefaultViewForNetworkError(refreshBlock: { [weak self] in
                self?.tableView?.mj_header.beginRefreshing()
            })
        }
    }
    
    func checkMjfooter(model: RequestedPageDataModel?) {
        
        tableView?.autoHideMjFooter = true
        
//        if tableView?.mj_footer == nil {
//            let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self] in
//                self.request()
//            })
//            footer?.setTitle("到底了", for: .noMoreData)
//            tableView?.mj_footer = footer
//        }
        
        if !(model?.hasNextPage ?? false) {
            tableView?.mj_footer?.endRefreshingWithNoMoreData()
        }
    }
}

extension RequestPageDataHandler {
    func enableLoading(enable: Bool = false) {
        tableView?.ignoreAutoHideMjFooter = !enable
        tableView?.mj_header?.isHidden = !enable
        tableView?.mj_footer?.isHidden = !enable
        if enable {
            checkMjfooter(model: pageModel)
        }
    }
}
*/
