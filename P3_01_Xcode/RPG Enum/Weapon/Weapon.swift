//
//  Weapon.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

class Weapon {
    
    let damage: Int
    let name: String
    
    init(
        damage: Int,
        nameWeapon: String
    ) {
        self.damage = damage
        self.name = nameWeapon
    }
}
