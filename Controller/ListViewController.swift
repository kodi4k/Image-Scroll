//
//  ListViewController.swift
//  RandomPicture
//
//  Created by Ivan Alexeevich on 28.04.2025.
//

import UIKit

class ListViewController: UIViewController {
    
    private let tableView = UITableView()
    private var photos: [Photo] = []
    private var isLoading = false
    private var currentPage = 1
    private let loadingFooterView = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadPhotos() 
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Photo List"
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        loadingFooterView.color = .gray
        loadingFooterView.hidesWhenStopped = true
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        tableView.tableFooterView?.addSubview(loadingFooterView)
        loadingFooterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingFooterView.centerXAnchor.constraint(equalTo: tableView.tableFooterView!.centerXAnchor),
            loadingFooterView.centerYAnchor.constraint(equalTo: tableView.tableFooterView!.centerYAnchor)
        ])
    }
    
    private func loadPhotos() {
        guard !isLoading else { return }
        isLoading = true
        loadingFooterView.startAnimating()
        
        var newPhotos: [Photo] = []
        for _ in 1...5 {
            let url = "https://picsum.photos/300/360?random=\(Int.random(in: 1...1000))"
            let photo = Photo(imageUrl: url)
            newPhotos.append(photo)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.photos.append(contentsOf: newPhotos)
            self.currentPage += 1
            self.isLoading = false
            self.loadingFooterView.stopAnimating()
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as! PhotoTableViewCell
        let photo = photos[indexPath.row]
        cell.configure(with: photo)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return 260
        let width = tableView.frame.width - 16 // Учитываем отступы 8 + 8
        return width * 1.2 + 8 + 44 + 8  // 44-размер кнопки
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            loadPhotos()
        }
    }
}
