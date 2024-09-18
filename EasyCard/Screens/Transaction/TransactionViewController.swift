//
//  TransactionViewController.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 18.09.24.
//

import UIKit

final class TransactionViewController: BaseViewController<TransactionViewModel> {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(LeftImageTitleSubtitleCell.self, forCellReuseIdentifier: LeftImageTitleSubtitleCell.identifier)
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        return tableView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "transactions".localized()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = titleLabel
        view.backgroundColor = UIColor(named: "backgroundColor")
        vm.fetchAllCards()
        vm.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        setupUI()
    }
    
    private func  setupUI() {
        tableView.dataSource = vm
        tableView.delegate   = vm
        view.addSubview(tableView)
        setupConstraints()
        
        vm.selectedCard = { [weak self] card in
            let vc = self?.router.transferVC() as! TransferViewController
            vc.selectedCard = card
            self?.navigationController?.pushViewController(vc , animated: true)
        }
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
