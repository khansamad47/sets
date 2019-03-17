//
//  ViewController.swift
//  Sets
//
//  Created by Samad Khan on 2/24/19.
//  Copyright © 2019 Kesign. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var game : Sets = Sets(initialActiveCardCount: 3, maxActiveCardCount: buttons.count)
    
    var buttonToCard = Dictionary<UIButton,Card>()
    
    @IBOutlet weak var matchedCount: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBAction func touchHint(_ sender: UIButton) {
        if let c = game.getAValidSet() {
            let cards = Set(c)
            for k in buttonToCard {
                if cards.contains(k.value) {
                    k.key.layer.borderColor = UIColor.darkGray.cgColor
                }
            }
        }
    }
    
    
    @IBAction func touchReset(_ sender: UIButton) {
        game.reset()
        buttonToCard.removeAll(keepingCapacity: true)
        refreshButtonCardMap()
        paintScreen()
    }
    
    @IBAction func touchAddThreeMore(_ sender: UIButton) {
        game.showNewCards(number: 3)
        refreshButtonCardMap()
        paintScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewController viewWillAppear function called.")
        buttons.sortInPlaceByTag()
        refreshButtonCardMap()
        paintScreen()
    }
    
    @IBAction func touchButtonHandler(_ sender: UIButton) {
        print("ViewController touchButtonHandler function called.")
        if let card = buttonToCard[sender] {
            game.chooseCard(id: card.id)
            refreshButtonCardMap()
            paintScreen()
        }
    }
    
    func paintScreen()
    {
        print("ViewController paintScreen function called.")
        for buttonIn in buttons {
            buttonIn.setAttributedTitle(NSAttributedString(), for: UIControl.State.normal)
            buttonIn.backgroundColor = UIColor.blue
            if let cardIn = buttonToCard[buttonIn]
            {
                paintButton(button: buttonIn, card: cardIn)
            }
        }
        
        // Paint Statistics
        matchedCount.text = "Matches = \(game.matchedSetsCount)"
    }
    
    func paintButton(button: UIButton, card : Card)
    {
        // Defaults
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 8.0
        button.backgroundColor = UIColor.white
        button.layer.borderColor = UIColor.blue.cgColor
        switch card.state {
        case .Selected:
            button.layer.borderColor = UIColor.yellow.cgColor
        case .Active:
            button.layer.borderColor = UIColor.blue.cgColor
        default:
            button.backgroundColor = UIColor.blue
        }
        button.setAttributedTitle(
            NSMutableAttributedString(
                string: getString(card: card),
                attributes: [
                    NSAttributedString.Key.foregroundColor : getForegroundColor(card: card),
                    NSAttributedString.Key.strokeColor : getForegroundColor(card: card),
                    NSAttributedString.Key.strokeWidth : getStrokeWidth(card: card),
                    
                ]
            ),
            for: UIControl.State.normal)
    }
    
    func refreshButtonCardMap() {
        print("ViewController refreshButtonCardMap function called.")
        var visbleCardsSet :Set<Card> = Set<Card>(game.visbleCards)
        for button in buttons {
            if let card = buttonToCard[button] {
                if visbleCardsSet.contains(card)
                {
                    print("Button \(button.tag) is in visble set")
                    visbleCardsSet.remove(card)
                }
                else {
                    print("Button \(button.tag) is not visble set. Removing from buttonToCard.")
                    // This card is no longer in the visble set
                    buttonToCard.removeValue(forKey: button)
                }
            }
        }
        for button in buttons {
            if buttonToCard[button] == nil {
                
                if let card = visbleCardsSet.randomElement() {
                    print("Button \(button.tag) is available. Setting a card on it.")
                    buttonToCard[button] = card
                    visbleCardsSet.remove(card)
                }
            }
        }
        
    }
}

func getForegroundColor(card: Card) -> UIColor
{
    var color : UIColor;
    switch card.color {
    case .Green:
        color = UIColor.green
    case .Purple:
        color = UIColor.purple
    case.Red:
        color = UIColor.red
    }
    if card.shading == .Striped {
        color=color.withAlphaComponent(0.25)
    }
    return color
}


func getStrokeWidth(card: Card) -> Int
{
    switch card.shading {
    case .Open:
        return 5
    case .Solid:
        return -1
    case .Striped:
        return 0
    }
}

func getString(card: Card) -> String
{
    var str = "";
    switch card.shape {
    case .Diamond:
        str = "▲"
    case .Oval:
        str = "●"
    case.Squiggle:
        str = "■"
    }
    str = String(repeating: str, count: card.count.toInt())
    return str
}

extension Count {
    func toInt() -> Int {
        switch self {
        case .One:
            return 1
        case .Two:
            return 2
        case .Three:
            return 3
        }
    }
}

extension Array where Element: UIButton {
    mutating func sortInPlaceByTag() {
        self.sort{$0.tag < $1.tag}
    }
}

