//
//  CoinTableViewCell.swift
//  Crypto_App
//
//  Created by Dmitriy Mkrtumyan on 18.08.23.
//

import UIKit

class CoinTableViewCell: UITableViewCell {
    
    // MARK: - UI elements
    lazy var numberInQueue: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var coinIconView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var coinName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    lazy var coinPrice: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()

    // MARK: - Overrided methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        setup()
    }
    
    // MARK: - UI setup methods
    private func setupSubviews() {
        addSubview(numberInQueue)
        addSubview(coinIconView)
        addSubview(coinName)
        addSubview(coinPrice)
    }
    
    private func setup() {
        numberInQueue.translatesAutoresizingMaskIntoConstraints = false
        coinIconView.translatesAutoresizingMaskIntoConstraints = false
        coinName.translatesAutoresizingMaskIntoConstraints = false
        coinPrice.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberInQueue.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberInQueue.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            numberInQueue.widthAnchor.constraint(equalToConstant: 20),
            numberInQueue.heightAnchor.constraint(equalToConstant: bounds.height),
            
            coinIconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            coinIconView.leadingAnchor.constraint(equalTo: numberInQueue.trailingAnchor, constant: 10),
            coinIconView.widthAnchor.constraint(equalToConstant: bounds.size.height / 1.5),
            coinIconView.heightAnchor.constraint(equalToConstant: bounds.size.height / 1.5),
            
            coinName.centerYAnchor.constraint(equalTo: centerYAnchor),
            coinName.leadingAnchor.constraint(equalTo: coinIconView.trailingAnchor, constant: 10),
            coinName.widthAnchor.constraint(equalToConstant: bounds.size.width / 2),
            coinName.heightAnchor.constraint(equalToConstant: bounds.size.height),
            
            coinPrice.centerYAnchor.constraint(equalTo: centerYAnchor),
            coinPrice.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            coinPrice.widthAnchor.constraint(equalToConstant: 70),
            coinPrice.heightAnchor.constraint(equalToConstant: bounds.size.height)
        ])
    }
    
    func setupCellData(coins: Coins) {
        self.numberInQueue.text = "\(coins.rank)"
        self.coinPrice.text = "\(round(100 * coins.price) / 100)"
        self.coinName.text = coins.name
    }
    
    func setupCellIcon(icon: UIImage) {
        DispatchQueue.main.async {
            self.coinIconView.image = icon
        }
    }

}
