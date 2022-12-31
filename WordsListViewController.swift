//
//  WordsListViewController.swift
//  MySpellBee
//
//  Created by Ravi Theja Karnatakam on 12/28/22.
//

import Foundation
import UIKit
import AVFoundation

class WordsListViewController: UIViewController, AVSpeechSynthesizerDelegate {
    let tableView = UITableView(frame: .zero)
    let synthesizer = AVSpeechSynthesizer()
    var words = [String]()
    var category = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setup(with category: String) {
        self.category = category
        if let allWords = UserDefaults.standard.array(forKey: category) as? [String] {
            words = allWords
        }
        
        synthesizer.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WordsTableViewCell.self, forCellReuseIdentifier: "WordsTableViewCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
        
        self.title = "\(words.count) words in \(category)"
    }
}

extension WordsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordsTableViewCell",
                                                for: indexPath) as! WordsTableViewCell
        
        let word = words[indexPath.row]
        cell.setup(word: "\(indexPath.row). \(word)")
        cell.accessoryType = .none
        cell.selectionStyle = .gray
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word = words[indexPath.row]

        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        utterance.volume = 1
        
        synthesizer.speak(utterance)
    }
}

class WordsTableViewCell: UITableViewCell {
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

extension WordsListViewController {
    func allWords() -> [String] {
        return ["gradual",
     "ferocious",
     "frequently",
     "permission",
     "towel",
     "sundae",
     "ornament",
     "rooster",
     "scold",
     "organza",
     "fragile",
     "galaxy",
     "complaint",
     "curries",
     "tennis",
     "grumbling",
     "garlic",
     "hula",
     "reactionary",
     "muscular",
     "drizzle",
     "accurate",
     "studio",
     "illusionist",
     "genetic",
     "levity",
     "moisture",
     "toughness",
     "tasteless",
     "astute",
     "turtle",
     "Pinkerton",
     "fortune",
     "sluggard",
     "bedlam",
     "shortfall",
     "cowlick",
     "opinionated",
     "slogan",
     "triumphant",
     "parenthetic",
     "listener",
     "guardian",
     "dwindled",
     "fraught",
     "sturdy",
     "treadmill",
     "originate",
     "**forfend",
     "OR forefend",
     "eavesdrop",
     "January",
     "scruple",
     "moxie",
     "winnow",
     "incentive",
     "admirer",
     "emotional",
     "chia",
     "raspberry",
     "bogus",
     "recoup",
     "bookworm",
     "veteran",
     "erase",
     "downcast",
     "spinal",
     "demolition",
     "gargantuan",
     "salsa",
     "chaotic",
     "shrimp",
     "mandate",
     "turret",
     "pigeon",
     "satellite",
     "parasite",
     "favorite",
     "OR *favourite",
     "cascade",
     "dandelion",
     "famous",
     "pristine",
     "golden",
     "modesty",
     "amphibian",
     "jealousy",
     "remedial",
     "vouch",
     "trivia",
     "shoulder",
     "zebra",
     "butterscotch",
     "apron",
     "beagle",
     "kidney",
     "wistful",
     "raven",
     "fructose",
     "Amazon",
     "companion",
     "panorama",
     "gimmick",
     "flannel",
     "cucumber",
     "McMansion",
     "janitor",
     "lionize",
     "headdress",
     "ludicrous",
     "pear",
     "system",
     "pedigree",
     "empty",
     "amulet",
     "guess",
     "magician",
     "carrot",
     "meteor",
     "distraught",
     "freight",
     "honeybee",
     "blemish",
     "crumpet",
     "blizzard",
     "squirm",
     "harmonious",
     "lawyer",
     "valiant",
     "purse",
     "raisin",
     "trumpet",
     "bias",
     "lettuce",
     "shamrock",
     "Americana",
     "monopolize",
     "water",
     "marathon",
     "omission",
     "newbie",
     "spreadsheet",
     "badger",
     "fortification",
     "hydra",
     "grouse",
     "manta",
     "astonish",
     "fashionista",
     "stubble",
     "genius",
     "nuance",
     "stencil",
     "penguin",
     "freckle",
     "blooper",
     "misconception",
     "lambkin",
     "chowder",
     "sunflower",
     "lambasted",
     "volumetric",
     "flattery",
     "simmer",
     "whisk",
     "bathtub",
     "fantastically",
     "failure",
     "tolerable",
     "mosquito",
     "target",
     "angora",
     "snippet",
     "ascribe",
     "hodgepodge",
     "verbiage",
     "nephew",
     "imbibe",
     "savvy",
     "reckon",
     "boorish",
     "tarmac",
     "iteration",
     "nurture",
     "volcano",
     "forensics",
     "miraculous",
     "trendy",
     "permafrost",
     "iceberg",
     "cactus",
     "nationalism",
     "leeway",
     "pilferer",
     "rollicking",
     "quart",
     "lactose",
     "domineering",
     "onion",
     "abandon",
     "vault",
     "junior",
     "hamlet",
     "jubilant"]
    }
}
