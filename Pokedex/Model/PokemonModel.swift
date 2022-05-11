//
//  Pokemon.swift
//  Pokedex
//
//  Created by Kevin Lopez on 5/7/22.
//

import Foundation

struct PokeAPI: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [BasicData]
}

struct Pokemon: Decodable {
    var abilities: [Ability]
    var base_experience: Int
    var forms: [BasicData]
    var game_indices: [GameIndex]
    var height: Int
    var id: Int
    var is_default: Bool
    var location_area_encounters: String
    var moves: [Move]
    var name: String
    var order: Int
    var species: BasicData
    var sprites: Sprites
    var stats: [Stat]
    var types: [PokemonType]
    var weight: Int
}

struct Ability: Decodable {
    var ability: BasicData
    var is_hidden: Bool
    var slot: Int
}

struct GameIndex: Decodable {
    var game_index: Int
    var version: BasicData
}

struct Move: Decodable {
    var move: BasicData
    var version_group_details: [VersionGroup]
}

struct VersionGroup: Decodable {
    var level_learned_at: Int
    var move_learn_method: BasicData
    var version_group: BasicData
}

struct Sprites: Decodable {
    var back_default: String?
    var back_female: String?
    var back_shiny: String?
    var back_shiny_female: String?
    var front_default: String?
    var front_female: String?
    var front_shiny: String?
    var front_shiny_female: String?
}

struct Stat: Decodable {
    var base_stat: Int
    var effort: Int
    var stat: BasicData
}

struct PokemonType: Decodable {
    var slot: Int
    var type: BasicData
}

struct BasicData: Decodable {
    var name: String
    var url: String
}
