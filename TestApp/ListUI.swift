//
//  ListUI.swift
//  TestApp
//
//  Created by Icon+ Gaenael on 16/05/23.
//

import UIKit

class ListUI: UIViewController {

    //UiKit
    private let stack = UIStackView()
    private let table = UITableView()
    private let search = UISearchBar()
    private let activity = UIActivityIndicatorView(style: .large)
    private let lbl_error = UILabel()
    private let refresh_indicator = UIRefreshControl()
    //Repo
    private let REPO = RepoList()
    //Data
    private var data = [MDBusiness]()
    private var page = 1
    private var keyword = ""
    private var isRefresh = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchList()
    }
    
    private func setupUI(){
        title = "Business"
        search.placeholder = "Search..."
        search.keyboardType = .default
        search.backgroundImage = UIImage()
        search.delegate = self
        search.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(RowList.self, forCellReuseIdentifier: "cell")
        table.register(RowAnimateLoading.self, forCellReuseIdentifier: "cell_loading")
        refresh_indicator.addTarget(self, action: #selector(refreshHandle(_:)), for: .valueChanged)
        table.refreshControl = refresh_indicator
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        stack.spacing = 16
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        lbl_error.translatesAutoresizingMaskIntoConstraints = false
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.startAnimating()
        view.addSubview(stack)
        view.addSubview(activity)
        view.addSubview(lbl_error)
        stack.addArrangedSubview(BaseCapsule(search, 12))
        stack.addArrangedSubview(table)
        NSLayoutConstraint.activate([
            activity.topAnchor.constraint(equalTo: view.topAnchor, constant: 156),
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lbl_error.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lbl_error.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.topAnchor.constraint(equalTo: view.topAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            search.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

extension ListUI{
    private func redirectToDetail(_ id: String){
        let vc = ListDetailUI()
        vc.detail_id = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListUI: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return (data.count > 0) ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return data.count
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RowList
            cell.setupData(data[indexPath.row])
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_loading") as! RowAnimateLoading
            cell.activity.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let business = data[indexPath.row]
        self.redirectToDetail(business.id)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            if !isRefresh{
                isRefresh = true
                fetchList()
            }
        }
    }
}

extension ListUI: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        keyword = searchBar.text ?? ""
        page = 1
        fetchList()
    }
}

extension ListUI{
    private class RowList: UITableViewCell{
        private let lbl_name = UILabel()
        private let lbl_category = UILabel()
        private let lbl_price = UILabel()
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
            lbl_category.font = UIFont.systemFont(ofSize: 12)
            lbl_price.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            lbl_price.textColor = .orange
            lbl_name.translatesAutoresizingMaskIntoConstraints = false
            lbl_name.numberOfLines = 0
            let view_info = viewInfo()
            contentView.addSubview(lbl_name)
            contentView.addSubview(view_info)
            NSLayoutConstraint.activate([
                lbl_name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                lbl_name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                lbl_name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                view_info.topAnchor.constraint(equalTo: lbl_name.bottomAnchor, constant: 8),
                view_info.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                view_info.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        func setupData(_ data: MDBusiness){
            lbl_name.text = data.name
            lbl_category.text = data.categories.first?.title
            lbl_price.text = data.price
        }
        
        private func viewInfo() -> UIView{
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 8
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(lbl_category)
            stack.addArrangedSubview(lbl_price)
            return stack
        }
    }
    
    private class RowAnimateLoading: UITableViewCell{
        let activity = UIActivityIndicatorView(style: .medium)
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
            activity.startAnimating()
            activity.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(activity)
            NSLayoutConstraint.activate([
                activity.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                activity.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                activity.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
        }
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    }
}

extension ListUI{
    @objc private func refreshHandle(_ sender: UIRefreshControl){
        keyword = ""
        page = 1
        isRefresh = true
        fetchList()
    }
}

extension ListUI{
    
    private func fetchList(){
        if page == 1{
            if !isRefresh{
                activity.startAnimating()
            }
        }
        REPO.getList(page, keyword: keyword) { res, err in
            self.isRefresh = false
            self.refresh_indicator.endRefreshing()
            if let response = res{
                if self.page == 1{
                    self.data = []
                }
                self.data.append(contentsOf: response.businesses)
                self.table.reloadData()
                self.page += 1
                self.lbl_error.text = ""
            }
            else{
                if self.page == 1 && self.data.count == 0{
                    self.data = []
                    self.table.reloadData()
                    self.lbl_error.text = "Data not found"
                }
            }
            self.activity.stopAnimating()
        }
    }
    
}
