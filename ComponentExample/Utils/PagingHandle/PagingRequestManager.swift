//
//  PagingRequestManager.swift
//  MeetStar
//
//  Created by 张广路 on 2019/9/25.
//  Copyright © 2019 王超. All rights reserved.
//

import UIKit

struct PagingListResponse {
    var allData = [Any]()
    var currentData: [Any]? {
        didSet {
            if let cd = currentData {
                allData.append(contentsOf: cd)
            }
        }
    }
    var isReset = true
    var result: DataModel.Result?
    var message: String?
    
    mutating func clear() {
        allData.removeAll()
        currentData = nil
        isReset = true
        result = nil
    }
}

class PagingRequestManager<PageModel: PagableRequestProtocol>: NSObject, RequestPagingListParseProtocol {
    
    var api: API
    let tableView: UITableView
    var pageModel: PageModel = PageModel()
    var response = PagingListResponse()
    var delegate: PagingListProtocol?
    
    
    required init(api: API, tableView: UITableView, delegate: PagingListProtocol? = nil) {
        self.api = api
        self.tableView = tableView
        self.delegate = delegate
        super.init()
        tableView.mj_header = MJRefreshHeaderBridge.createHeader(refreshingBlock: { [unowned self] in
            self.request(isReset: true)
        })
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self] in
            self.request(next: true)
        })
        footer?.setTitle("到底了", for: .noMoreData)
        tableView.mj_footer = footer
        tableView.autoHideMjFooter = true
    }
}

extension PagingRequestManager {
    
    func request(isReset: Bool = false, next: Bool = false) {
        
        if next {
            pageModel.next()
        }
        if isReset {
            pageModel.first()
        }
        var parameters: [String: Any] = pageModel.toDictionary()
        switch api.method {
        case .get:
            if let p = api.params {
                parameters.merge(p) { _, custom in custom}
            }
            api.params = parameters
        case .post:
            if let b = api.body {
                parameters.merge(b) { _, custom in custom}
            }
            api.body = parameters
        default:break
        }
        
        NetworkHandler.request(api: api) {
            switch $0 {
            case .failure(let e):
                self.request(result: .failure, model: e.info, isReset: isReset)
            case .success(let m):
                self.request(result: .success, model: m, isReset: isReset)
            }
        }
    }
    
    func request(result: DataModel.Result, model: NetworkResultModel?, isReset: Bool) {
        
        MBProgressHUD.hiddenHUD()
        switch result {
        case .success:
            if isReset {
                response.clear()
            }
            guard let networkModel = model,
                let pageModel = PageModel(fromDictionary: networkModel.data) else {
                    response.currentData = nil
                    response.isReset = isReset
                    response.message = "数据解析出错"
                    handle(result: .failure, response: response)
                    return;
            }
            
            self.pageModel = pageModel
            if let _delegate = delegate {
                response.currentData = _delegate.transform(data: networkModel.data)
            } else {
                response.currentData = transform(data: networkModel.data)
            }
            response.result = .success
            response.isReset = isReset
            handle(result: .success, response: response)
            
        default:
            handle(result: .failure, response: response)
        }
    }
    
    func handle(result: DataModel.Result, response: PagingListResponse) {
        
        DispatchQueue.main.async {
            self.stopLoadingAnimationAndHide()
            self.delegate?.result(response: response)
            
            switch result {
            case .failure:
                self.tableView.reloadData()
                self.handleNetworkError()
            case .success:
                self.tableView.reloadData()
                self.checkMjfooter(self.pageModel)
                self.checkNoneData()
            default:break
            }
        }
    }
}

extension PagingRequestManager {
    
    func stopLoadingAnimationAndHide() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer?.endRefreshing()
        tableView.pl_hidenDefaultView()
        MBProgressHUD.hiddenHUD()
    }
    
    func checkNoneData() {
        if response.allData.count <= 0 {
            tableView.showDefaultViewForNoContent()
        }
    }
    
    func handleNetworkError() {
        if response.allData.count <= 0 {
            tableView.showDefaultViewForNetworkError(refreshBlock: { [weak self] in
                self?.tableView.mj_header.beginRefreshing()
            })
        }
    }
    
    func checkMjfooter(_ model: PageModel) {
        if !model.hasNext {
            tableView.mj_footer?.endRefreshingWithNoMoreData()
        } else {
            tableView.mj_footer.resetNoMoreData()
        }
    }
}

extension PagingRequestManager {
    func enableLoading(enable: Bool = false) {
        tableView.ignoreAutoHideMjFooter = !enable
        tableView.mj_header?.isHidden = !enable
        tableView.mj_footer?.isHidden = !enable
        if enable {
            checkMjfooter(pageModel)
        }
    }
}
