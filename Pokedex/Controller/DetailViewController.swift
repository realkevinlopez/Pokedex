//
//  DetailViewController.swift
//  Pokedex
//
//  Created by Kevin Lopez on 5/7/22.
//

import UIKit

class DetailViewController: UIViewController {

    var indexInt: Int?
    var pokemonData: [BasicData] = []
    var networkManager = NetworkManager()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name: "
        label.numberOfLines = 0
//        label.backgroundColor = .white
        label.textAlignment = .center
        label.font = label.font.withSize(36)
        return label
    }()
    
    lazy var typeLabel: UILabel = { // // //
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Type: " + "\n"
        label.numberOfLines = 0
        label.backgroundColor = .black
        label.textColor = .white
        label.font = label.font.withSize(24)
//        label.textAlignment = .center
        return label
    }()
    
    lazy var spriteImageView: UIImageView = { // // //
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.image = UIImage(named: "question-mark")
        return imageView
    }()
    
    lazy var abilitiesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Abilities: " + "\n"
        label.numberOfLines = 0
//        label.backgroundColor = .white
        label.font = label.font.withSize(24)
        return label
    }()
    
    lazy var movesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Moves: " + "\n"
        label.numberOfLines = 0
//        label.backgroundColor = .white
        label.font = label.font.withSize(24)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        fetchMorePokemonData()
        }
    
    private func setUpUI() {
        self.nameLabel.text = pokemonData[indexInt ?? 0].name
        self.view.addSubview(self.spriteImageView) // // //
        
        let vStack = UIStackView(frame: .zero)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.backgroundColor = .black
        
        let topBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        let midBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        let bottomBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)

        vStack.addArrangedSubview(topBuffer)
        vStack.addArrangedSubview(self.nameLabel)
        vStack.addArrangedSubview(self.spriteImageView) // // //
        vStack.addArrangedSubview(self.typeLabel)
        vStack.addArrangedSubview(midBuffer)
        vStack.addArrangedSubview(self.abilitiesLabel)
        vStack.addArrangedSubview(self.movesLabel)
        vStack.addArrangedSubview(bottomBuffer)
        
        self.view.addSubview(vStack)
       
        vStack.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
        vStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        vStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
        vStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
        
        self.spriteImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        self.spriteImageView.widthAnchor.constraint(equalToConstant: 140).isActive = true

        topBuffer.heightAnchor.constraint(equalTo: bottomBuffer.heightAnchor).isActive = true
    }
    
    var imageURL : String?
    
    func fetchMorePokemonData() {
        networkManager.fetchAPokemon(urlPath: pokemonData[indexInt ?? 0].url) { result in
            switch result {
                case .success(let page):
                    DispatchQueue.main.async {
                        
                        for x in 0 ..< page.types.count {
                            self.typeLabel.text?.append(" " + page.types[x].type.name + "\n")
                        }
                        
                        for x in 0 ..< page.abilities.count{
                            self.abilitiesLabel.text?.append(" " + page.abilities[x].ability.name + "\n")
                        }
                        
                        for x in 0 ..< page.moves.count{
                            self.movesLabel.text?.append(" " + page.moves[x].move.name + "\n")
                        }
                        
                        self.imageURL = page.sprites.front_default
                        
                        if let imageData = ImageCache.shared.getImageData(key: self.imageURL ?? "") {
                            print("Image Cache")
                            self.spriteImageView.image = UIImage(data: imageData)
                            return
                        }
                        
                        self.networkManager.fetchImageData(imagePath: page.sprites.front_default ?? " ", completion: { result in
                            switch result {
                            case .success(let imageData):
                                
                                ImageCache.shared.setImageData(key: page.sprites.front_default ?? "", data: imageData)
                                
                                DispatchQueue.main.async {
                                    self.spriteImageView.image = UIImage(data: imageData)
                                }
                            case .failure(let err):
                                print(err)
                            }
                        })
                    }
                case .failure(let err):
                    print("Error: \(err.localizedDescription)")
            }
        }
    }
    
}
