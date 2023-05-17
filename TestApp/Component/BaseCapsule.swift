//
//  BaseCapsule.swift
//  TestApp
//
//  Created by Icon+ Gaenael on 17/05/23.
//

import UIKit

class BaseCapsule: UIView {
    init(_ vw: UIView, _ padding: CGFloat = 16){
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(vw)
        NSLayoutConstraint.activate([
            vw.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            vw.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            vw.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            vw.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
