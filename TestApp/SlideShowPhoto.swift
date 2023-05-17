//
//  SlideShowPhoto.swift
//  TestApp
//
//  Created by Icon+ Gaenael on 17/05/23.
//

import UIKit

class SlideShowPhoto: UIViewController {

    //UiKit
    private let scroll  = UIScrollView()
    private let stack = UIStackView()
    private let lbl_photo = UILabel()
    //Data
    var photos = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupUI(){
        view.backgroundColor = .black
        title = "Slideshow"
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.contentInsetAdjustmentBehavior = .never
        scroll.isPagingEnabled = true
        scroll.clipsToBounds = true
        scroll.delegate = self
        stack.axis = .horizontal
        stack.distribution = .fill
        scroll.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        scroll.addSubview(stack)
        let view_photo = viewPhotoCount()
        setIndexPhoto(1)
        view.addSubview(view_photo)
        NSLayoutConstraint.activate([
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            stack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 0),
            stack.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 0),
            stack.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: 0),
            stack.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: 0),
            stack.heightAnchor.constraint(equalTo: scroll.heightAnchor),
            view_photo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view_photo.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
        ])
    }
    
    private func setupData(){
        photos.forEach { str in
            if let url = URL(string: str){
                let image = UIImageView()
                image.load(url: url)
                image.translatesAutoresizingMaskIntoConstraints = false
                image.contentMode = .scaleAspectFit
                stack.addArrangedSubview(image)
                image.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            }
        }
    }
    
    private func viewPhotoCount() -> UIView{
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
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
    
    private func setIndexPhoto(_ index: Int){
        lbl_photo.text = "\(index) from \(photos.count) photos"
    }
}

extension SlideShowPhoto: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setScrollIndex()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setScrollIndex()
    }
    private func setScrollIndex(){
        let x = scroll.contentOffset.x
        let page = x / scroll.frame.width
        let pageInt = Int(page) + 1
        setIndexPhoto(pageInt)
    }
}
