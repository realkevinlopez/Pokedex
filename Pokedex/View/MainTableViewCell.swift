//
//  MainTableViewCell.swift
//  Pokedex
//
//  Created by Kevin Lopez on 5/7/22.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    static let reuseId = "\(MainTableViewCell.self)"
    
    var imageURL : String?
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name"
        label.numberOfLines = 0
        label.backgroundColor = .systemGray
        label.textColor = .black
        label.font = label.font.withSize(24)
        //        label.textAlignment = .center
        return label
    }()
    
    lazy var typeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Type"
        label.numberOfLines = 0
        label.backgroundColor = .black
        label.textColor = .white
        label.font = label.font.withSize(18)
        //        label.textAlignment = .center
        return label
    }()
    
    lazy var spriteImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.image = UIImage(named: "question-mark")
        return imageView
    }()
    
    var networkManager = NetworkManager()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        self.contentView.backgroundColor = .black
        
        self.contentView.addSubview(self.spriteImageView)
        
        let vStackLeft = UIStackView(frame: .zero)
        vStackLeft.translatesAutoresizingMaskIntoConstraints = false
        vStackLeft.axis = .vertical
        //        vStackLeft.spacing = 8
        
        let topBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        let bottomBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        
        vStackLeft.addArrangedSubview(topBuffer)
        //        vStackLeft.addArrangedSubview(self.nameLabel)
        vStackLeft.addArrangedSubview(self.spriteImageView)
        vStackLeft.addArrangedSubview(bottomBuffer)
        
        let vStackRight = UIStackView(frame: .zero)
        vStackRight.translatesAutoresizingMaskIntoConstraints = false
        vStackRight.axis = .vertical
        vStackRight.spacing = 8
        
        vStackRight.addArrangedSubview(topBuffer)
        vStackRight.addArrangedSubview(self.nameLabel)
        vStackRight.addArrangedSubview(self.typeLabel)
        vStackRight.addArrangedSubview(bottomBuffer)
        
        let hStack = UIStackView(frame: .zero)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.spacing = 8
        
        hStack.addArrangedSubview(vStackLeft)
        hStack.addArrangedSubview(vStackRight)
        
        self.contentView.addSubview(hStack)
        
        hStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        hStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        hStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        hStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
        
        self.spriteImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        self.spriteImageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        topBuffer.heightAnchor.constraint(equalTo: bottomBuffer.heightAnchor).isActive = true
    }
    
    func configure(index: Int, pokemon: BasicData) {
        self.reset()
        self.nameLabel.text = pokemon.name
        
        networkManager.fetchAPokemon(urlPath: pokemon.url) { result in
            switch result {
            case .success(let page):
                DispatchQueue.main.async {
                    for x in 0 ..< page.types.count {
                        self.typeLabel.text?.append(" " + page.types[x].type.name)
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
    
    private func reset() {
        self.nameLabel.text = "Name"
        self.typeLabel.text = "Type: "
        self.spriteImageView.image = UIImage(named: "question-mark")
        self.contentView.backgroundColor = .black
        self.backgroundView = nil
    }
    
}
