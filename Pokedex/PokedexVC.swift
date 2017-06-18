//
//  PokedexVC.swift
//  Pokedex
//
//  Created by Huan Cung on 6/13/17.
//  Copyright © 2017 Huan Cung. All rights reserved.
//

import UIKit
import AVFoundation

class PokedexVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var notFoundLbl: UILabel!
    
    var pokemonList = [Pokemon]()
    var filteredPokemonList = [Pokemon]()
    var inSearchMode: Bool = false
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text  == ""{
            inSearchMode = false
            notFoundLbl.isHidden = true
            collectionView.reloadData()
        } else {
            inSearchMode = true
            
            let searchText = searchBar.text!.lowercased()
            filteredPokemonList = pokemonList.filter({$0.name.range(of: searchText) != nil})
            
            if filteredPokemonList.isEmpty {
                notFoundLbl.isHidden = false
            } else {
                notFoundLbl.isHidden = true
            }
            
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokeCells", for: indexPath) as? PokemonCell {
            
            let pokemon: Pokemon!
            
            if inSearchMode {
                pokemon = filteredPokemonList[indexPath.row]
            } else {
                pokemon = pokemonList[indexPath.row]
            }
            
            cell.updateCell(pokemon: pokemon)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemonList.count
        } else {
            return pokemonList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if inSearchMode {
            performSegue(withIdentifier: "PokemonDetailSegue", sender: filteredPokemonList[indexPath.row])
        } else {
            performSegue(withIdentifier: "PokemonDetailSegue", sender: pokemonList[indexPath.row])
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.volume = 0.1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        do {
            let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let pokemon = Pokemon(name: name, pokedexId: pokeID)
                pokemonList.append(pokemon)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PokemonDetailsVC {
            if let pokemon = sender as? Pokemon {
                destination.pokemon = pokemon
            }
        }
    }
    
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
}

