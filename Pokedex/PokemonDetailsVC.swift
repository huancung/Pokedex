//
//  PokemonDetailsVC.swift
//  Pokedex
//
//  Created by Huan Cung on 6/14/17.
//  Copyright © 2017 Huan Cung. All rights reserved.
//

import UIKit

class PokemonDetailsVC: UIViewController {

    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexIDLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var evoLbl: UILabel!
    
    private var _pokemon: Pokemon!
    
    var pokemon: Pokemon {
        get{
            return _pokemon
        } set {
            _pokemon = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = _pokemon.name.capitalized
        image.image = UIImage(named: "\(_pokemon.pokedexId)")
        currentEvoImg.image = UIImage(named: "\(_pokemon.pokedexId)")
        
        _pokemon.downloadPokemonDetails {
            self.updateUI()
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateUI() {
        baseAttackLbl.text = _pokemon.attack
        defenseLbl.text = _pokemon.defense
        weightLbl.text = _pokemon.weight
        heightLbl.text = _pokemon.height
        pokedexIDLbl.text = "\(_pokemon.pokedexId)"
        typeLbl.text = _pokemon.type
        descriptionLbl.text = _pokemon.description
        nextEvoImage.image = UIImage(named: _pokemon.nextEvolutionId)
        evoLbl.text = _pokemon.nextEvolutionText
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
