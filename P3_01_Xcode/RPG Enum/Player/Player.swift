//
//  Player.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

final class Player {
    
    let name: String
    var characters = [Character]()
    private let maximumNumberOfSelectableCharacters = 3
    
    init(name: String) {
        self.name = name
    }
    
    /// Filter checks each object in the array (characters)  to see if it meets the condition. Check if all of the characters of team are dead. The player lost, else, the game continues.
    var isDefeat: Bool {
        let charactersAreDead = characters.filter { $0.isDead || $0.characterType == .priest }
        return charactersAreDead.count == maximumNumberOfSelectableCharacters ? true : false
    }
    
    func makeYourTeamBySelectingCharacters(_ enemyCharacters: [Character]?) {
        print("""
            ⚠️ The same character cannot be selected more than once. Select your character by entering 1, 2, 3 or 4 and choose a name for him. Maximum of three characters per team. ⚠️
            """)
        while characters.count < maximumNumberOfSelectableCharacters {
            print("""
                \(name), you must choose \(3 - characters.count) character:
                1 - ⚔️ Warrior ⚔️ - Simple, basic but efficient.
                Damage: 20  ||  Lifepoint: 90
                2 - 💪🏼 Colossus 💪🏼 - Thick smelly creature, can't even see his feet.
                Damage: 10  ||  Lifepoint: 110
                3 - 🧙🏼‍♂️ Magus 🧙🏼‍♂️ - Devastating power, but enough sensitive.
                Damage: 25  ||  Lifepoint: 70
                4 - 🙏🏼 Priest 🙏🏼 - Robust ally, incapable of causing harm.
                Healing: 10  ||  Lifepoint: 90
                """)
            
            if let picks = readLine(), !picks.isEmpty {
                switch picks {
                case "1":
                    chooseCharacterIfHasNotBeenAlreadyChosen(.warrior, enemyCharacters)
                case "2":
                    chooseCharacterIfHasNotBeenAlreadyChosen(.colossus, enemyCharacters)
                case "3":
                    chooseCharacterIfHasNotBeenAlreadyChosen(.magus, enemyCharacters)
                case "4":
                    chooseCharacterIfHasNotBeenAlreadyChosen(.priest, enemyCharacters)
                default:
                    print("Please, make your choice.")
                    // if the choice is different of 1,2,3 or 4.
                }
            } else {
                print("You need to choose a character, between 1,2,3 and 4.")
                // if the choice is empty.
            }
        }
    }
    
    private func chooseCharacterIfHasNotBeenAlreadyChosen(_ characterType: CharacterType, _ enemyCharacters: [Character]?) {
        hasBeenAlreadyChosen(characterType) ? print("The \(characterType) is already chosen! Please, make another choice.") : chooseCharacterName(characterType, enemyCharacters)
    }
    
    private func chooseCharacterName(_ characterType: CharacterType, _ enemyCharacters: [Character]?) {
        print("Choose \(characterType) name:")
        if let name = readLine() {
            if isCharacterNameAlreadyChosen(name, enemyCharacters) {
                print("This name has been already choosen!")
                chooseCharacterName(characterType, enemyCharacters)
            } else if name.isEmpty {
                print("😡 Is empty. You need to choose a name for your character! 😡")
                chooseCharacterName(characterType, enemyCharacters)
            } else if name != name.trimmingCharacters(in: .whitespacesAndNewlines) {
                print(" Your character needs a name without spaces.")
                chooseCharacterName(characterType, enemyCharacters)
            } else {
                switch characterType {
                case .warrior:
                    characters.append(Warrior(name: name))
                case .colossus:
                    characters.append(Colossus(name: name))
                case .magus:
                    characters.append(Magus(name: name))
                case .priest:
                    characters.append(Priest(name: name))
                }
                print("Your \(characterType) \(name) has been added to your team.")
            }
        }
    }
    
    private func isCharacterNameAlreadyChosen(_ name: String, _ enemyCharacters: [Character]?) -> Bool {
        for character in characters {
            if character.name == name {
                return true
            }
        }
        
        if let enemyCharacters = enemyCharacters {
            for character in enemyCharacters {
                if character.name == name {
                    return true
                }
            }
        }
        return false
    }
    
    /// When the description of enemy characters is displayed, and when you select a target, if the selection is not correct, it announced an error message and we can try to select a target again.
    private func selectCharacter() -> Character? {
        if let choose = readLine() {
            guard !choose.isEmpty else {
                print("The choice is empty. You need to choose a character.")
                return selectCharacter()
            }
            
            guard let numberChoose = Int(choose) else {
                print("A typo? A space? Impossible choice. Try again.")
                return selectCharacter()
            }
            
            guard numberChoose <= maximumNumberOfSelectableCharacters, numberChoose > 0 else {
                print("You only have \(maximumNumberOfSelectableCharacters) characters.")
                return selectCharacter()
            }
            
            guard isAlive(characters[numberChoose - 1]) else {
                print("This character is dead. You need to choose alive character.")
                return selectCharacter()
            }
            return characters[numberChoose - 1]
        }
        
        print("I can't ask for your choice..")
        return selectCharacter()
    }
    
    /// The player can only choose a character type once. For example, if the choice is warrior, he cannot choose that type a second time.
    private func hasBeenAlreadyChosen(_ characterType: CharacterType) -> Bool {
        for character in characters {
            if character.characterType == characterType {
                return true
            }
        }
        return false
    }
    
    /// For choose the character to inflige damage at the ennemy or heal an ally.
    func selectCharacterForHealingOrFighting() -> Character {
        print("\(name), choose a character to fight or heal:")
        
        diplayCharactersDescription()
        
        if let choose = readLine() {
            guard !choose.isEmpty else {
                print("The choice is empty. You need to choose a character.")
                return selectCharacterForHealingOrFighting()
            }
            
            guard let numberChoose = Int(choose) else {
                print("A typo? A space? Impossible choice. Try again.")
                return selectCharacterForHealingOrFighting()
            }
            
            guard numberChoose <= maximumNumberOfSelectableCharacters, numberChoose > 0 else {
                print("You only have \(maximumNumberOfSelectableCharacters) characters.")
                return selectCharacterForHealingOrFighting()
            }
            
            guard isAlive(characters[numberChoose - 1]) else {
                print("This character is dead. You need to choose an alive character.")
                return selectCharacterForHealingOrFighting()
            }
            return characters[numberChoose - 1]
        }
        
        print("I can't ask for your choice..")
        return selectCharacterForHealingOrFighting()
    }
    
    private func diplayCharactersDescription() {
        for (index, character) in characters.enumerated() {
            print("\(index + 1) \(character.showStatus)")
        }
    }
    
    /// Choice of the target to attack between the three characters enemy.
    func selectAllyToHealOrEnemyToAttack(_ character: Character) -> Character {
        character is Priest ? print("🎯 \(name), which ally needs heal? 🎯") : print("🎯 Who is the target? Chosen from the team of \(name). 🎯")
        diplayCharactersDescription()
        
        if let characterToHealOrAttack = selectCharacter() {
            return characterToHealOrAttack
        }
        return selectAllyToHealOrEnemyToAttack(character)
    }
    
    /// To check if character is dead.
    private func isAlive(_ character: Character) -> Bool {
        if character.isDead {
            print("This character is dead. 💀")
            return false
        }
        return true
    }
}
