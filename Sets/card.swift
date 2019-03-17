//
//  card.swift
//  Sets
//
//  Created by Samad Khan on 2/24/19.
//  Copyright © 2019 Kesign. All rights reserved.
//

import Foundation

enum Shape : Int, CaseIterable {
    case Diamond
    case Squiggle
    case Oval
}

enum Shading : Int, CaseIterable {
    case Solid
    case Striped
    case Open
}

enum Color : Int, CaseIterable {
    case Red
    case Green
    case Purple
}

enum Count : Int, CaseIterable{
    case One
    case Two
    case Three
}

enum CardState {
    case Hidden
    case Active
    case Selected
    case Matched
}

class Card : Equatable, Hashable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    var id : Int {
        get {
            return self.shape.rawValue + self.shading.rawValue*10 + self.color.rawValue*100 + self.count.rawValue*1000
        }
    }
    let shape : Shape
    let shading: Shading
    let color : Color
    let count : Count
    var isSelected : Bool = false
    var state : CardState = .Hidden
    
    init(shape: Shape, shading: Shading, color: Color, count:Count)
    {
        self.shape = shape;
        self.shading = shading;
        self.color = color;
        self.count = count;
        print("Creating new card with (id=\(self.id)) (shape=\(self.shape) (shading=(\(self.shading)) (color=\(self.color)) (count=\(self.count))")
        
    }
    
}
