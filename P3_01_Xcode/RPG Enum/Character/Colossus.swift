//
//  Colossus.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

final class Colossus: Character {
    init(name: String) {
        super.init(
            name: name,
            characterType: .colossus,
            lifePoint: 120,
            maxHealt: 120,
            weapon: TreeTrunk()
        )
    }
}
