//
//  Character.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

class Character {
    let name: String
    let characterType: CharacterType
    let maxHealth: Int
    var weapon: Weapon
    var lifePoint: Int {
        willSet {
            newValue > lifePoint ? print("\(name) is about to get heal") : print("\(name) is about to get attack")
        }
        
        didSet {
            oldValue > lifePoint ? print("\(name) lose \(oldValue - lifePoint)HP.") : print("\(name) has been healed.. +\(lifePoint - oldValue)HP.")
        }
    }
    
    var showStatus: String {
        isDead ? "\(characterType) \(name) is dead in the fight." : "\(characterType) \(name) -- \(lifePoint)/\(maxHealth)HP -- \(weapon.damage)Damages."
    }
    
    var isDead: Bool {
        lifePoint <= 0 ? true : false
    }
    
    init(name: String,
         characterType: CharacterType,
         lifePoint: Int,
         maxHealt: Int,
         weapon: Weapon
    ) {
        self.name = name
        self.characterType = characterType
        self.lifePoint = lifePoint
        self.maxHealth = maxHealt
        self.weapon = weapon
    }
    
    
    func attack(_ target: Character) {
        target.lifePoint -= weapon.damage
    }
        
    func addBonusToWeapon() {
        switch characterType {
        case .warrior:
            weapon = DoubleSwords()
            print("Good, your \(CharacterType.warrior)(\(name)) has unlocked a weapon: \(weapon.name), + 10 damage. Check out your new stats 😊.")
        case .colossus:
            weapon = GiantFronde()
            print("Good, your \(CharacterType.colossus)(\(name)) has unlocked a weapon: \(weapon.name), + 10 damage. Check out your new stats 😊.")
        case .magus:
            weapon = VoidStaff()
            print("Good, your \(CharacterType.magus)(\(name)) has unlocked a weapon: \(weapon.name), + 10 damage. Check out your new stats 😊.")
        case .priest:
            weapon = TibetanBowl()
            print("Good, your \(CharacterType.priest)(\(name)) has unlocked a weapon: \(weapon.name), + 10 of healling. Check out your new stats 😊.")
        }
    }
}

