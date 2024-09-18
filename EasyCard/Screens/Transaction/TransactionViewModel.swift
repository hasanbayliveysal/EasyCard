//
//  TransactionViewModel.swift
//  EasyCard
//
//  Created by Veysal Hasanbayli on 18.09.24.
//

import UIKit

final class TransactionViewModel: NSObject {
    var reloadTableView: emptyClosure?
    var cards: [Card] = [] {
        didSet {
            reloadTableView?()
        }
    }
    
    
    func fetchAllCards() {
        Task {
            do {
                let cards = try await CardGenerator.shared.fetchAllCards()
                self.cards = cards
            } catch {
                print(error)
            }
        }
    }
    
    func sendMoney(with selectedCard: Card) {
        Task {
            do {
                try await TransactionService.shared.sendBalance(with: selectedCard, and: 5.0)
            } catch {
                print("here" , error)
            }
        }
    }
}

extension TransactionViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeftImageTitleSubtitleCell.identifier, for: indexPath) as! LeftImageTitleSubtitleCell
        cell.configure(with: cards[indexPath.row])
        cell.backgroundColor = UIColor(named: "backgroundColor")
        return cell
    }
}

extension TransactionViewModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendMoney(with: cards[indexPath.row])
    }
    
}
