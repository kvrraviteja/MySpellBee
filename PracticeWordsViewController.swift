//
//  PracticeWordsViewController.swift
//  MySpellBee
//
//  Created by Ravi Theja Karnatakam on 12/29/22.
//

import Foundation
import UIKit
import AVFoundation

class PracticeWordsViewController: UIViewController, AVSpeechSynthesizerDelegate {
    let tableView = UITableView(frame: .zero)
    let synthesizer = AVSpeechSynthesizer()
    var words = [String]()
    var category = ""
    var currentIndex = 0
    var finishedWords = [String]()
    var skippedCount = 0
    
    let utterWordButton = UIButton(frame: .zero)
    let nextButton = UIButton(frame: .zero)
    let resultTextField = UITextField(frame: .zero)
    let result = UILabel(frame: .zero)
    let status = UILabel(frame: .zero)
    let revealButton = UIButton(frame: .zero)
    let revealedWord = UILabel(frame: .zero)

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setup(with category: String) {
        self.category = category
        if let allWords = UserDefaults.standard.array(forKey: category) as? [String] {
            words = allWords
        }
        
        if let index = UserDefaults.standard.value(forKey: "\(category)_Completed") as? Int {
            currentIndex = index
        }
        
        finishedWords = Array(words[0..<currentIndex])
        
        synthesizer.delegate = self
        
        utterWordButton.translatesAutoresizingMaskIntoConstraints = false
        utterWordButton.backgroundColor = UIColor.blue
        utterWordButton.setTitle("Utter word", for: .normal)
        utterWordButton.addTarget(self, action: #selector(utterCurrentWord), for: .touchUpInside)
        utterWordButton.layer.cornerRadius = 8.0
        utterWordButton.layer.borderColor = UIColor.blue.cgColor
        utterWordButton.layer.borderWidth = 1.0
        view.addSubview(utterWordButton)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.backgroundColor = UIColor.blue
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(pickNextWord), for: .touchUpInside)
        nextButton.layer.cornerRadius = 8.0
        nextButton.layer.borderColor = UIColor.blue.cgColor
        nextButton.layer.borderWidth = 1.0
        nextButton.isEnabled = false
        view.addSubview(nextButton)
        
        revealButton.translatesAutoresizingMaskIntoConstraints = false
        revealButton.backgroundColor = UIColor.blue
        revealButton.setTitle("Reveal", for: .normal)
        revealButton.addTarget(self, action: #selector(revealCurrentWord), for: .touchUpInside)
        revealButton.layer.cornerRadius = 8.0
        revealButton.layer.borderColor = UIColor.blue.cgColor
        revealButton.layer.borderWidth = 1.0
        view.addSubview(revealButton)

        resultTextField.translatesAutoresizingMaskIntoConstraints = false
        resultTextField.textColor = .white
        resultTextField.backgroundColor = .gray
        resultTextField.clearButtonMode = .whileEditing
        resultTextField.addTarget(self, action: #selector(didChangeText(_:)), for: .editingChanged)
        view.addSubview(resultTextField)
        
        result.translatesAutoresizingMaskIntoConstraints = false
        result.textAlignment = .center
        result.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(result)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WordsTableViewCell.self, forCellReuseIdentifier: "WordsTableViewCell")
        view.addSubview(tableView)
        
        status.translatesAutoresizingMaskIntoConstraints = false
        status.textAlignment = .left
        status.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(status)

        revealedWord.translatesAutoresizingMaskIntoConstraints = false
        revealedWord.textAlignment = .right
        revealedWord.font = UIFont.systemFont(ofSize: 15)
        revealedWord.textColor = .green
        view.addSubview(revealedWord)
        
        
        NSLayoutConstraint.activate([
            status.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            status.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            status.heightAnchor.constraint(equalToConstant: 30),
            revealedWord.leadingAnchor.constraint(equalTo: status.trailingAnchor, constant: 20),
            revealedWord.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            revealedWord.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            revealedWord.heightAnchor.constraint(equalToConstant: 30),
            utterWordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            utterWordButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            utterWordButton.heightAnchor.constraint(equalToConstant: 45),
            nextButton.leadingAnchor.constraint(equalTo: utterWordButton.trailingAnchor, constant: 10),
            nextButton.bottomAnchor.constraint(equalTo: utterWordButton.bottomAnchor, constant: 0),
            nextButton.heightAnchor.constraint(equalTo: utterWordButton.heightAnchor),
            nextButton.widthAnchor.constraint(equalTo: utterWordButton.widthAnchor),
            revealButton.leadingAnchor.constraint(equalTo: nextButton.trailingAnchor, constant: 10),
            revealButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            revealButton.bottomAnchor.constraint(equalTo: utterWordButton.bottomAnchor, constant: 0),
            revealButton.heightAnchor.constraint(equalTo: utterWordButton.heightAnchor),
            revealButton.widthAnchor.constraint(equalTo: utterWordButton.widthAnchor),
            resultTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            resultTextField.topAnchor.constraint(equalTo: utterWordButton.bottomAnchor, constant: 20),
            resultTextField.heightAnchor.constraint(equalToConstant: 45),
            result.leadingAnchor.constraint(equalTo: resultTextField.trailingAnchor, constant: 20),
            result.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            result.topAnchor.constraint(equalTo: resultTextField.topAnchor),
            result.heightAnchor.constraint(equalToConstant: 45),
            result.widthAnchor.constraint(equalToConstant: 120),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
        
        self.title = "Practice words - \(category)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetPractice))
        status.text = "\(finishedWords.count) words completed"
    }
    
    @objc func resetPractice(_ sender: Any) {
        currentIndex = 0
        UserDefaults.standard.set(currentIndex, forKey: "\(category)_Completed")
        finishedWords = Array(words[0..<currentIndex])
        tableView.reloadData()
        resultTextField.text = ""
        utterCurrentWord(utterWordButton)
    }

    @objc func revealCurrentWord(_ sender: UIButton) {
        if revealButton.titleLabel?.text == "Reveal" {
            let word = words[currentIndex]
            revealedWord.text = word
            revealButton.setTitle("Skip", for: .normal)
        } else {
            revealedWord.text = ""
            revealButton.setTitle("Reveal", for: .normal)
            pickNextWord()
        }
    }

    @objc func utterCurrentWord(_ sender: Any) {
        let word = words[currentIndex]

        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        utterance.volume = 1
        
        synthesizer.speak(utterance)
    }

    func canSkipWord() {
        let word = words[currentIndex].lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if word.contains("or ") {
            finishedWords.append(word)
            currentIndex += 1
            UserDefaults.standard.set(currentIndex, forKey: "\(category)_Completed")
        }
    }
    
    @objc func pickNextWord() {
        let word = words[currentIndex]
        finishedWords.append(word)
        UserDefaults.standard.set(currentIndex, forKey: "\(category)_Completed")
        currentIndex += 1
        
        canSkipWord()

        tableView.reloadData()
        resultTextField.text = ""
        utterCurrentWord(utterWordButton)
        nextButton.isEnabled = false
        status.text = "\(finishedWords.count) words completed"
    }
    
    @objc func didChangeText(_ sender: UITextField) {
        let word = words[currentIndex].lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let textFieldEntry = sender.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        if textFieldEntry == word {
            result.text = "Correct"
            result.textColor = .green
            nextButton.isEnabled = true
        } else {
            result.text = "Incorrect"
            result.textColor = .red
            nextButton.isEnabled = false
        }
    }
}

extension PracticeWordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordsTableViewCell",
                                                for: indexPath) as! WordsTableViewCell
        
        let word = finishedWords[indexPath.row]
        cell.setup(word: word)
        cell.accessoryType = .none
        cell.selectionStyle = .blue
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finishedWords.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word = finishedWords[indexPath.row]

        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        utterance.volume = 1
        
        synthesizer.speak(utterance)
    }
}
