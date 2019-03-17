//
//  set.swift
//  Sets
//
//  Created by Samad Khan on 2/24/19.
//  Copyright © 2019 Kesign. All rights reserved.
//

import Foundation

class Sets {
    private let d_initialVisbleCardCount : Int
    private let d_maxVisbleCardCount: Int
    private(set) var cards : Dictionary<Int,Card> = Dictionary<Int,Card>();
    private(set) var d_matchedSetsCount: Int = 0
    var selectedCards : Array<Card> {
        get {
            return Array(cards.filter({$0.value.state == .Selected}).values)
        }
    }
    var visbleCards : Array<Card> {
        get {
            return Array(cards.filter({$0.value.state == .Active || $0.value.state == .Selected}).values)
        }
    }
    var hiddenCards : Array<Card> {
        get {
            return Array(cards.filter({$0.value.state == .Hidden}).values)
        }
    }
    init(initialActiveCardCount:Int, maxActiveCardCount:Int)
    {
        d_initialVisbleCardCount = initialActiveCardCount
        d_maxVisbleCardCount = maxActiveCardCount
        // Creating 81 cards and pushing them in cards array
        for shape in Shape.allCases {
            for color in Color.allCases {
                for shading in Shading.allCases {
                    for count in Count.allCases {
                        let card = Card(shape:shape,shading:shading, color:color,count:count)
                        cards[card.id] = card;
                    }
                }
            }
        }
        self.showNewCards(number:d_initialVisbleCardCount)
    }
    func reset() {
        for card in cards.values
        {
            card.state = .Hidden
        }
        d_matchedSetsCount = 0
    }
    
    func chooseCard(id:Int)
    {
        assert(selectedCards.count < 3, "There where more than 3 cards selected!")
        let card = cards[id]!;
        // If card is already selected, matched or no visable then exit
        if card.state != .Active
        {
            return
        }
        card.state = .Selected
        // There are only 2 cards selected
        if selectedCards.count <= 2
        {
            return
        }
        // There are three cards selected
        if isValidSet(cardsIn: selectedCards) {
            for c in selectedCards {
                c.state = .Matched
            }
        }
        else {
            for c in selectedCards {
                c.state = .Active
            }
        }
        
    }
    func isValidSet(cardsIn: Array<Card>) -> Bool
    {
        assert(cardsIn.count == 3, "Cards passed to the isSet function were not 3")
        let shapeSeen = Set<Shape>(cardsIn.map{$0.shape});
        let shadingSeen = Set<Shading>(cardsIn.map{$0.shading});
        let colorSeen = Set<Color>(cardsIn.map{$0.color});
        let countSeen = Set<Count>(cardsIn.map{$0.count});
        return shapeSeen.countIsOneOrThree() && shadingSeen.countIsOneOrThree() && colorSeen.countIsOneOrThree() && countSeen.countIsOneOrThree()
    }
    func getAValidSet() -> Array<Card>?
    {
        let visible = self.visbleCards
        for i in 0..<visible.count {
            for j in i..<visible.count {
                for k in i..<visible.count {
                    let cards = [visible[i], visible[j], visible[k]]
                    if isValidSet(cardsIn: cards) {
                        return cards
                    }
                }
            }
        }
        return nil
    }
    func showNewCards(number: Int)
    {
        var  number  = number
        if visbleCards.count + number > d_maxVisbleCardCount {
            number = max(d_maxVisbleCardCount - visbleCards.count,0)
        }
        for _ in 0..<number {
            if let hiddenCard = self.hiddenCards.randomElement() {
                hiddenCard.state = .Active
            }
            else {
                print("No hidden cards remain. Cannot activate a card.")
            }
        }
    }
}

extension Set {
    func countIsOneOrThree() -> Bool
    {
        return self.count == 1 || self.count == 3
    }
}
