//
//  MainPageViewController.swift
//  Crypto_App
//
//  Created by Dmitriy Mkrtumyan on 18.08.23.
//

import UIKit

final class MainPageViewController: UIViewController {
    
    // MARK: - Data
    private var datasource = [Coins]()
    private let network = CoinsViewModel()
    private var coinsIcons = [URL: UIImage]()
    
    // MARK: - UI elements
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    private let indicator = UIActivityIndicatorView()
    private let refreshControl = UIRefreshControl()
    
    // MARK: - UI setup methods
    private func setupSubviews() {
        view.addSubview(tableView)
        view.addSubview(indicator)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.addCustomConstraints(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leadingAnchor, right: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.bounds.size.width)
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Page is updating")
        refreshControl.addTarget(self, action: #selector(refreshTapped), for: .valueChanged)
    }
    
    @objc
    private func refreshTapped() {
        setupRequest()
    }
    
    private func setupActivityIndicator() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            indicator.widthAnchor.constraint(equalToConstant: 100),
            indicator.heightAnchor.constraint(equalToConstant: 100)
        ])
        indicator.startAnimating()
    }
    
    private func setupRequest() {
        network.getRequest { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let coins):
                self.datasource = coins
                print(self.datasource)
            case .failure(let error):
                let alertController = UIAlertController(title: "Cant fetch data", message: "\(error)", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Retry", style: .default)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            }
            
            DispatchQueue.main.async {
                if self.indicator.isAnimating {
                    self.indicator.stopAnimating()
                }
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    // MARK: - Overrided methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupActivityIndicator()
        setupTableView()
        setupRefreshControl()
        setupRequest()
    }
    
}

// MARK: - Extensions
extension MainPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CoinTableViewCell {
            cell.setupCellData(coins: self.datasource[indexPath.row])
            cell.selectionStyle = .none
            if let icons = coinsIcons[datasource[indexPath.row].icon] {
                cell.setupCellIcon(icon: icons)
            } else {
                DispatchQueue.main.async {
                    URLSession.shared.dataTask(with: self.datasource[indexPath.row].icon) { [ weak self ] data, _, _ in
                        guard let self = self else { return }
                        guard let data else { return }
                        self.coinsIcons[datasource[indexPath.row].icon] = UIImage(data: data)
                        cell.setupCellIcon(icon: self.coinsIcons[datasource[indexPath.row].icon]!)
                    }.resume()
                }
            }

            return cell
        }
        
        return UITableViewCell()
    }
}

extension MainPageViewController: UITableViewDelegate {
}
