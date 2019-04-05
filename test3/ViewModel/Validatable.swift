//
//  Validatable.swift
//  test3
//
//  Created by Alexander Batalov on 4/5/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

struct BrokenRule {
    
    var propertyName :String
    var message :String
}

protocol Validatable {
    
    var brokenRules :[BrokenRule] { get set}
    var isValid :Bool { mutating get }
}

