//
//  Pokemon.swift
//  Pokedex
//
//  Created by Huan Cung on 6/13/17.
//  Copyright © 2017 Huan Cung. All rights reserved.
//

import UIKit

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    
    var name: String {
        get{
            return _name
        }
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
}
