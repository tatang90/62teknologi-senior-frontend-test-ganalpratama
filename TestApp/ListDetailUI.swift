//
//  ListDetailUI.swift
//  TestApp
//
//  Created by Icon+ Gaenael on 17/05/23.
//

import UIKit

class ListDetailUI: UIViewController {

    //UiKit
    private let table = UITableView()
    private let activity = UIActivityIndicatorView(style: .large)
    private let refresh_indicator = UIRefreshControl()
    private let lbl_error = UILabel()
    //Param
    var detail_id = ""
    //Repo
    private let REPO = RepoDetail()
    //Data
    private var data : [ResDetail] = []
    private var reviews : [MDReview] = []
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
        title = "Detail Business"
        table.delegate = self
        table.dataSource = self
        table.register(RowDetail.self, forCellReuseIdentifier: "cell")
        table.register(RowReview.self, forCellReuseIdentifier: "cell_review")
        table.separatorStyle = .none
        refresh_indicator.addTarget(self, action: #selector(refreshHandle(_:)), for: .valueChanged)
        table.refreshControl = refresh_indicator
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        lbl_error.translatesAutoresizingMaskIntoConstraints = false
        activity.translatesAutoresizingMaskIntoConstraints = false
        table.translatesAutoresizingMaskIntoConstraints = false
        activity.startAnimating()
        view.addSubview(table)
        view.addSubview(activity)
        view.addSubview(lbl_error)
        NSLayoutConstraint.activate([
            activity.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lbl_error.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lbl_error.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let rightButtonItem = UIBarButtonItem(
              title: "Map",
              style: .done,
              target: self,
              action: #selector(openMap)
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
}

extension ListDetailUI: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return data.count
        }
        else{
            return reviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RowDetail
            cell.setupData(data[indexPath.row])
            cell.actionPhoto = {
                self.popSlideshowPhoto()
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_review") as! RowReview
            cell.setupData(reviews[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return "Review"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            return 24
        }
        return 0
    }
}

extension ListDetailUI{
    @objc private func refreshHandle(_ sender: UIRefreshControl){
    }
    
    @objc private func openMap(_ sender: UIBarButtonItem){
        if let detail = data.first{
            let url = URL(string: "maps://?q=\(detail.name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&ll=\(detail.coordinates.latitude),\(detail.coordinates.longitude)")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    private func popSlideshowPhoto(){
        if let detail = data.first{
            let vc = SlideShowPhoto()
            vc.photos = detail.photos
            self.present(vc, animated: true)
        }
    }
}

extension ListDetailUI{
    private class RowDetail: UITableViewCell{
        private let img_view = UIImageView()
        private let lbl_name = UILabel()
        private let lbl_photo = UILabel()
        private let lbl_category = UILabel()
        private let lbl_price = UILabel()
        private let lbl_rate = UILabel()
        private let lbl_review = UILabel()
        var actionPhoto : () -> () = {}
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
            img_view.contentMode = .scaleAspectFill
            img_view.clipsToBounds = true
            lbl_name.translatesAutoresizingMaskIntoConstraints = false
            img_view.translatesAutoresizingMaskIntoConstraints = false
            lbl_category.font = UIFont.systemFont(ofSize: 12)
            lbl_price.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            lbl_price.textColor = .orange
            
            lbl_rate.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            lbl_review.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            lbl_rate.textColor = .yellow
            
            let view_photo = viewPhotoCount()
            contentView.addSubview(img_view)
            contentView.addSubview(lbl_name)
            contentView.addSubview(view_photo)
            let view_info = viewInfo()
            contentView.addSubview(view_info)
            let view_rate = viewRate()
            contentView.addSubview(view_rate)
            NSLayoutConstraint.activate([
                img_view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
                img_view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
                img_view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
                img_view.heightAnchor.constraint(equalToConstant: 320),
                lbl_name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                lbl_name.topAnchor.constraint(equalTo: img_view.bottomAnchor, constant: 16),
                lbl_name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                view_photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                view_photo.bottomAnchor.constraint(equalTo: img_view.bottomAnchor, constant: -12),
                view_info.topAnchor.constraint(equalTo: lbl_name.bottomAnchor, constant: 8),
                view_info.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                view_rate.topAnchor.constraint(equalTo: view_info.bottomAnchor, constant: 8),
                view_rate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                view_rate.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        func setupData(_ data: ResDetail){
            if let url = URL(string: data.image_url){
                img_view.load(url: url)
            }
            lbl_name.text = data.name
            lbl_photo.text = "\(data.photos.count) Photos"
            lbl_category.text = data.categories.first?.title
            lbl_price.text = data.price
            lbl_rate.text = "Rating \(data.rating)"
            lbl_review.text = "\(data.review_count)"
        }
        
        private func viewPhotoCount() -> UIView{
            let blurEffect = UIBlurEffect(style: .dark)
            let blurView = UIVisualEffectView(effect: blurEffect)
            let tap = UITapGestureRecognizer(target: self, action: #selector(addTapPhoto))
            blurView.addGestureRecognizer(tap)
            lbl_photo.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            blurView.contentView.addSubview(lbl_photo)
            blurView.translatesAutoresizingMaskIntoConstraints = false
            blurView.setRadius(6)
            lbl_photo.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                lbl_photo.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 8),
                lbl_photo.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 4),
                lbl_photo.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -8),
                lbl_photo.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -4)
            ])
            return blurView
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
        
        private func viewRate() -> UIView{
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 4
            stack.translatesAutoresizingMaskIntoConstraints = false
            let lbl_from = UILabel()
            lbl_from.font = UIFont.systemFont(ofSize: 12)
            lbl_from.text = "From"
            let lbl_reviews = UILabel()
            lbl_reviews.font = UIFont.systemFont(ofSize: 12)
            lbl_reviews.text = "Reviews"
            stack.addArrangedSubview(lbl_rate)
            stack.addArrangedSubview(lbl_from)
            stack.addArrangedSubview(lbl_review)
            stack.addArrangedSubview(lbl_reviews)
            return stack
        }
        
        @objc private func addTapPhoto(){
            actionPhoto()
        }
    }
    
    private class RowReview: UITableViewCell{
        private let lbl_comment = UILabel()
        private let lbl_date = UILabel()
        private let lbl_rate = UILabel()
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
            lbl_rate.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            lbl_rate.textColor = .yellow
            lbl_comment.translatesAutoresizingMaskIntoConstraints = false
            lbl_comment.numberOfLines = 0
            lbl_comment.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            lbl_date.font = UIFont.systemFont(ofSize: 12)
            let view_info = viewInfo()
            contentView.addSubview(lbl_comment)
            contentView.addSubview(view_info)
            NSLayoutConstraint.activate([
                lbl_comment.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                lbl_comment.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                lbl_comment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                view_info.topAnchor.constraint(equalTo: lbl_comment.bottomAnchor, constant: 8),
                view_info.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                view_info.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        func setupData(_ data: MDReview){
            lbl_comment.text = data.text
            lbl_rate.text = "Rating \(data.rating)"
            lbl_date.text = data.time_created
        }
        
        private func viewInfo() -> UIView{
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 8
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(lbl_rate)
            stack.addArrangedSubview(lbl_date)
            return stack
        }
    }
}

extension ListDetailUI{
    
    private func fetchList(){
        if !isRefresh{
            activity.startAnimating()
        }
        REPO.getDetail(detail_id) { res, err in
            self.isRefresh = false
            self.refresh_indicator.endRefreshing()
            self.activity.stopAnimating()
            
            self.data = []
            if let response = res{
                self.data.append(response)
                self.lbl_error.text = ""
            }
            else{
                self.lbl_error.text = "Data not found"
            }
            self.table.reloadData()
            self.fetchReviews()
        }
    }
    
    private func fetchReviews(){
        REPO.getReview(detail_id) { res, err in
            if let response = res{
                self.reviews = response.reviews
                self.table.reloadData()
            }
        }
    }
    
}
