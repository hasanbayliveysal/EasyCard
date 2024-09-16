//
//  ViewController.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 16.09.24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "hello".localized()
        label.textColor = .black
        label.font = .systemFont(ofSize: 44, weight: .bold)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide.snp.center)
        }
    }

}

