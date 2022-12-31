//
//  ViewController.swift
//  MySpellBee
//
//  Created by Ravi Theja Karnatakam on 12/28/22.
//

import CoreGraphics
import UIKit
import MLKitTextRecognition
import MLKitVision

class ViewController: UIViewController {
    let detectVC = WordsDetectViewController(nibName: nil, bundle: nil)
    
    var segments = ["Learn words", "Practice", "Add words"]
    var selectedSegment = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        title = "Spelling Bee"
        setUp()
    }
    
    func setUp() {
        let segment = UISegmentedControl(items: segments)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = selectedSegment
        segment.backgroundColor = .gray
        segment.tintColor = .blue
        segment.addTarget(self, action: #selector(didSelectSegment(_:)), for: .valueChanged)
        view.addSubview(segment)
        
        let low = setupView("LOW")
        low.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLow(_:))))
        view.addSubview(low)
        
        let medium = setupView("MEDIUM")
        medium.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMedium(_:))))
        view.addSubview(medium)
        
        let high = setupView("HIGH")
        high.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHigh(_:))))
        view.addSubview(high)
        
        NSLayoutConstraint.activate([
            segment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segment.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            low.widthAnchor.constraint(equalToConstant: 240),
            low.heightAnchor.constraint(equalToConstant: 100),
            low.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            low.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            medium.widthAnchor.constraint(equalTo: low.widthAnchor),
            medium.heightAnchor.constraint(equalTo: low.heightAnchor),
            medium.centerXAnchor.constraint(equalTo: low.centerXAnchor),
            medium.topAnchor.constraint(equalTo: low.bottomAnchor, constant: 50),
            high.widthAnchor.constraint(equalTo: low.widthAnchor),
            high.heightAnchor.constraint(equalTo: low.heightAnchor),
            high.centerXAnchor.constraint(equalTo: low.centerXAnchor),
            high.topAnchor.constraint(equalTo: medium.bottomAnchor, constant: 50),
        ])
    }
    
    func setupView(_ complexity: String) -> UIView {
        let backgroundView = UIView(frame: .zero)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .lightGray
        backgroundView.layer.cornerRadius = 5.0
        backgroundView.layer.borderColor = UIColor.gray.cgColor
        backgroundView.layer.borderWidth = 2.0
        
        let textLabel = UILabel(frame: .zero)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = complexity
        textLabel.textColor = .white
        textLabel.font = UIFont.boldSystemFont(ofSize: 20)
        backgroundView.addSubview(textLabel)
        
        let countLabel = UILabel(frame: .zero)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.textColor = .black
        countLabel.font = UIFont.systemFont(ofSize: 16)
        backgroundView.addSubview(countLabel)
        
        if let array = UserDefaults.standard.array(forKey: complexity) as? [String] {
            countLabel.text = "\(array.count) words"
        } else {
            countLabel.text = "No words yet"
        }

        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -15),
            countLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            countLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 15)
        ])
        
        return backgroundView
    }
    
    @objc func didSelectSegment(_ sender: UISegmentedControl) {
        selectedSegment = sender.selectedSegmentIndex
    }
    
    @objc func didTapLow(_ sender: Any) {
        navigate(with: "LOW")
    }

    @objc func didTapHigh(_ sender: Any) {
        navigate(with: "HIGH")
    }

    @objc func didTapMedium(_ sender: Any) {
        navigate(with: "MEDIUM")
    }
    
    func navigate(with category: String) {
        switch selectedSegment {
        case 0:
            let listVC = WordsListViewController(nibName: nil, bundle: nil)
            listVC.setup(with: category)
            navigationController?.pushViewController(listVC, animated: true)
        case 1:
            let practiceVC = PracticeWordsViewController(nibName: nil, bundle: nil)
            practiceVC.setup(with: category)
            navigationController?.pushViewController(practiceVC, animated: true)
        case 2:
            detectVC.category = category
            navigationController?.pushViewController(detectVC, animated: true)
        default:
            detectVC.category = category
            navigationController?.pushViewController(detectVC, animated: true)
        }
    }
}
