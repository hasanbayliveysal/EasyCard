//
//  HomeViewController.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 16.09.24.
//

import UIKit

final class HomeViewController: BaseViewController<HomeViewModel> {
    
    private var isShowingBack = false
    
    private let leftTitleView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "MR. Veysal"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var rightBarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rightBarButton"), for: .normal)
        button.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let cardFrontView: CardFrontView = {
        let view = CardFrontView()
        return view
    }()
    
    private let cardBackView: CardBackView = {
        let view = CardBackView()
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLeftAndRightBarButton()
        view.backgroundColor = UIColor(named: "backgroundColor")
        containerView.addSubview(cardFrontView)
        containerView.addSubview(cardBackView)
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(view.bounds.height/4)
        }
        cardFrontView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cardBackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        Task {
            do {
                let data = try await vm.generateCard(with: .MASTERCARD)
                cardFrontView.configure(with: Card(id: "", type: data.type, ownerID: "", code: data.cardNumber, cvv: data.cvv, balance: "10.0", date: data.date))
                
                cardBackView.configure(with: Card(id: "", type: data.type, ownerID: "", code: data.cardNumber, cvv: data.cvv, balance: "10.0", date: data.date))
            }
        }
        
        let longPressGestureForBack = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        let longPressGestureForFront = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        cardFrontView.addGestureRecognizer(longPressGestureForFront)
        cardBackView.addGestureRecognizer(longPressGestureForBack)
        cardFrontView.isUserInteractionEnabled = true
        cardBackView.isUserInteractionEnabled = true
    }
    
    @objc
    private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            flipCard()
        }
    }
    
    func flipCard() {
        let fromView = isShowingBack ? cardBackView : cardFrontView
        let toView = isShowingBack ? cardFrontView : cardBackView
        
        UIView.transition(from: fromView, to: toView, duration: 0.8, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        
        // Toggle the state
        isShowingBack.toggle()
    }
    
    private func createLeftAndRightBarButton() {
        let leftBarButtonItem = UIBarButtonItem(customView: leftTitleView)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
    }
    
    @objc
    private func didTapMoreButton() {
        let alert = UIAlertController(title: "logout".localized(), message: "doyouwantlogout".localized(), preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.vm.setUserLoggedOut()
            let vc = UINavigationController(rootViewController: self?.router.welcomeVC() ?? UIViewController())
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
        }
        alert.addAction(okButton)
        alert.addAction(UIAlertAction(title: "cancel".localized(), style: .destructive))
        self.present(alert, animated: true)
    }
}
