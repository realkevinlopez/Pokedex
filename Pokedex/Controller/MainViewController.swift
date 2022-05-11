//
//  MainViewController.swift
//  Pokedex
//
//  Created by Kevin Lopez on 5/7/22.
//

import UIKit

class MainViewController: UIViewController {
    
    let networkManager = NetworkManager()
    
    lazy var pokemonTableView: UITableView = {
        let tableview = UITableView(frame: .zero)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.dataSource = self
        tableview.delegate = self
        tableview.prefetchDataSource = self
        tableview.backgroundColor = .black
        tableview.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseId)
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchPokemonData()
    }

    private func setupUI() {
        self.view.backgroundColor = .black
        self.view.addSubview(self.pokemonTableView)
        
        self.pokemonTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.pokemonTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.pokemonTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        self.pokemonTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
    }
    
    var nextPokemon = 0
    
    var pokemon: [BasicData] = []
    
    func fetchPokemonData() {
        self.networkManager.fetchPokemonData(nextPokemon: self.nextPokemon) { [self] result in
            switch result {
            case .success(let fetchedPokemon):
                if (self.nextPokemon < 150){
                    self.pokemon.append(contentsOf: fetchedPokemon.results)
                }

                if (self.nextPokemon >= 150){
                    self.pokemon.append(contentsOf: fetchedPokemon.results)
                    self.pokemon.removeSubrange(151...self.pokemon.count - 1)
                }
                DispatchQueue.main.async {
                    self.pokemonTableView.reloadData()
                }
            case .failure(let err):
                self.presentErrorAlert(title: "NetworkError", message: err.localizedDescription)
            }
        }
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDataSourcePrefetching, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseId, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        tableViewCell.configure(index: indexPath.row, pokemon: self.pokemon[indexPath.row])
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        let lastIndexPath = IndexPath(row: self.pokemon.count - 1, section: 0)
        guard indexPaths.contains(lastIndexPath) else { return }
        
        if (self.nextPokemon < 150){
            self.nextPokemon += 30
            self.fetchPokemonData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailView = DetailViewController()
        detailView.pokemonData = pokemon
        detailView.indexInt = pokemonTableView.indexPathForSelectedRow?.row
        self.present(detailView, animated: true, completion: nil)
    }
    
}
