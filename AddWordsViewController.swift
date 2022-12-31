//
//  AddWordsViewController.swift
//  MySpellBee
//
//  Created by Ravi Theja Karnatakam on 12/29/22.
//

import Foundation
import UIKit

class AddWordsViewController: UIViewController {
    let tableView = UITableView(frame: .zero)
    var words = [String]()
    var category = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddWordsTableViewCell.self, forCellReuseIdentifier: "AddWordsTableViewCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
    
    func setupWords(with string: String, to category: String) {
        self.category = category
        let splitWords = string.components(separatedBy: "\n")
        words = splitWords
        
        self.title = "\(words.count) words found"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addWords))
    }
    
    @objc private func addWords() {
        var totalWords = [String]()
        if let existingCategoryWords = UserDefaults.standard.array(forKey: category) as? [String] {
            totalWords.append(contentsOf: existingCategoryWords)
            totalWords.append(contentsOf: words)
        } else {
            totalWords.append(contentsOf: words)
        }
        
        let finalList = Array(NSOrderedSet(array: totalWords))
        UserDefaults.standard.setValue(finalList, forKey: category)
        
        let alert = UIAlertController(title: "\(words.count) words added",
                                      message: "\(finalList.count) words exist in \(category) category",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension AddWordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddWordsTableViewCell",
                                                for: indexPath) as! AddWordsTableViewCell
        
        let word = words[indexPath.row]
        cell.setup(word: word)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}

class AddWordsTableViewCell: UITableViewCell {
    private var nameLabel: UILabel!
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpInterface() {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
        nameLabel = label
    }
    
    func setup(word: String) {
        nameLabel.text = word
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
    }
}
