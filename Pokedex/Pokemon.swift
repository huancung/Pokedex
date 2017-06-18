//
//  Pokemon.swift
//  Pokedex
//
//  Created by Huan Cung on 6/13/17.
//  Copyright © 2017 Huan Cung. All rights reserved.
//

import UIKit
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: String!
    private var _description: String!
    private var _height: String!
    private var _weight: String!
    private var _type: String!
    private var _defense: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _pokemonURL: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    
    var name: String {
        get{
            return _name
        }
    }
    
    var pokedexId: String {
        return _pokedexId
    }
    
    var description: String {
        get{
            if _description == nil {
                _description = ""
            }
            return _description
        }
    }
    
    var height: String {
        get{
            if _height == nil {
                _height = ""
            }
            return _height
        }
    }
    
    var weight: String {
        get{
            if _weight == nil {
                _weight = ""
            }
            return _weight
        }
    }
    
    var type: String {
        get{
            if _type == nil {
                _type = ""
            }
            return _type
        }
    }
    
    var defense: String {
        get{
            if _defense == nil {
                _defense = ""
            }
            return _defense
        }
    }
    
    var attack: String {
        get{
            if _attack == nil {
                _attack = ""
            }
            return _attack
        }
    }
    
    var nextEvolutionText: String {
        get{
            if _nextEvolutionText == nil || nextEvolutionId == "" {
                _nextEvolutionText = "Highest Evolution"
            }
            return _nextEvolutionText
        }
    }
    
    var nextEvolutionId: String {
        get{
            if _nextEvolutionId == nil {
                _nextEvolutionId = ""
            }
            return _nextEvolutionId
        }
    }
    
    var nextEvolutionName: String {
        get{
            if _nextEvolutionName == nil {
                _nextEvolutionName = ""
            }
            return _nextEvolutionName
        }
    }
    
    var nextEvolutionLevel: String {
        get{
            if _nextEvolutionLevel == nil {
                _nextEvolutionLevel = ""
            }
            return _nextEvolutionLevel
        }
    }
    
    var pokemonURL: String {
        get{
            return _pokemonURL
        }
    }
    
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = "\(pokedexId)"
        self._pokemonURL = "\(BASE_URL)\(POKEMON_URL)\(_pokedexId!)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        // Alamofire download
        let url = URL(string: _pokemonURL)!
        
        Alamofire.request(url).responseJSON { response in
            // Handle response
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                // height
                if let pokeHeight = dict["height"] as? String {
                    self._height = pokeHeight
                }
                // weight
                if let pokeWeight = dict["weight"] as? String {
                    self._weight = pokeWeight
                }
                // attack
                if let pokeAttack = dict["attack"] as? Int {
                    self._attack = "\(pokeAttack)"
                }
                // defense
                if let pokeDefense = dict["defense"] as? Int {
                    self._defense = "\(pokeDefense)"
                }
                
                // types
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    // additional types
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self._type = "\(self._type!)/\(name.capitalized)"
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }
                
                // descriptions
                if let descArray = dict["descriptions"] as? [Dictionary<String, String>], descArray.count > 0 {
                    if let urlString = descArray[0]["resource_uri"] {
                        let url = URL(string: "\(BASE_URL)\(urlString)")!
                        Alamofire.request(url).responseJSON { response in
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let desc = descDict["description"] as? String {
                                    let newDescription = desc.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDescription
                                } else {
                                    self._description = "missing"
                                }
                            }
                            completed()
                        }
                    } else {
                        self._description = ""
                    }
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                    
                    if let nextEvo = evolutions[0]["to"] as? String {
                        
                        if nextEvo.range(of: "mega") == nil {
                            
                            self._nextEvolutionName = nextEvo
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = nextEvoId
                                
                                if let lvlExist = evolutions[0]["level"] {
                                    
                                    if let lvl = lvlExist as? Int {
                                        
                                        self._nextEvolutionLevel = "\(lvl)"
                                    }
                                    
                                } else {
                                    
                                    self._nextEvolutionLevel = ""
                                }
                                
                            }
                            
                        }
                        
                    }
                    self._nextEvolutionText = "Next Evolution: \(self.nextEvolutionName) LVL \(self.nextEvolutionLevel)"
                    print(self._nextEvolutionLevel)
                    print(self._nextEvolutionName)
                    print(self._nextEvolutionId)
                }

                
            }
            completed()
        }
    }
}
