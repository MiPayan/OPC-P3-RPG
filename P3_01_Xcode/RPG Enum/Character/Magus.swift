//
//  Magus.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

final class Magus: Character {
    init(name: String) {
        super.init(
            name: name,
            characterType: .magus,
            lifePoint: 70,
            maxHealt: 70,
            weapon: IncantationBook()
        )
    }
}
