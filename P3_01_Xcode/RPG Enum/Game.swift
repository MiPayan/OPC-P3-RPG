//
//  Game.swift
//  RPG Enum
//
//  Created by Mickael on 19/10/2020.
//

import Foundation

final class Game {
    
    private var players = [Player]()
    private let maximumNumberOfSelectablePlayers = 2
    private var bonusCount = 0
    private let percentageOfHavingBonus = 5
    private var turns = 1
    private var attackingPlayer: Player {
        players[turns % 2]
    }
    private var targetPlayer: Player {
        players[(turns + 1) % 2]
    }
    
    private var exitGame: () {
        print("See you later. 👋🏼")
    }

    
    func start() {
        print("""
            Hi! What do you want to do? (For make your choice, enter 1 or 2)
            1 - 🎮 New Game 🎮 -
            2 - ❌ Quit ❌ -
            """)
        
        if let line = readLine() {
            switch line {
            case "1":
                createPlayers()
            case "2":
                exitGame
            default:
                print("🤞🏼 You must choose between 1 and 2. Try again! 🤞🏼")
                start()
            }
        }
    }
    
    private func createPlayers() {
        while players.count < maximumNumberOfSelectablePlayers {
            print("Choose player name \(players.count + 1):")
            if let name = readLine() {
                if hasPlayerNameAlreadyBeenChosen(name) {
                    print("This name has been already chosen.")
                } else if name.isEmpty {
                    print("😡 You must choose a name! 😡")
                } else if name != name.trimmingCharacters(in: .whitespacesAndNewlines) {
                    print("❌ Sorry, space are not allowed. ❌")
                } else {
                    players.append(Player(name: name))
                }
            }
        }
        selectCharacterForEachPlayer()
    }
    
    private func hasPlayerNameAlreadyBeenChosen(_ name: String) -> Bool {
        for player in players {
            if player.name == name {
                return true
            }
        }
        return false
    }
    
    private func selectCharacterForEachPlayer() {
        for i in 0..<players.count {
            let player = players[i]
            i == 1 ? player.makeYourTeamBySelectingCharacters(players[0].characters) : player.makeYourTeamBySelectingCharacters(nil)
            print("✅ \(player.name) is ready! ✅")
        }
        print("⚠️ How to play? Same as character selection. Select your character to attack or heal, and after, select your target. ⚠️")
        print("Let's go to fight!")
        makeFight()
    }
    
    private func makeFight() {
        let fightingCharacter = attackingPlayer.selectCharacterForHealingOrFighting()
        getsRandomBonus(fightingCharacter: fightingCharacter)
        
        let targetCharacter = chooseTarget(fightingCharacter)
        fightingCharacter.attack(targetCharacter)
        
        if targetPlayer.isDefeat {
            guard let lastCharacterAlive = targetPlayer.characters.last?.characterType else { return }
            if lastCharacterAlive == .priest {
                print("🫥 The priest was the only survivor. He got scared and fled. Sorry, \(targetPlayer.name) you lost. 🫥")
            } else {
                print("⚰️ All of your characters are dead.. Sorry, \(targetPlayer.name) you lost. ⚰️")
            }
            statistics()
        } else {
            turns += 1
            return makeFight()
        }
    }
    
    private func chooseTarget(_ fightingCharacter: Character) -> Character {
        let player = fightingCharacter is Priest ? attackingPlayer : targetPlayer
        return player.selectAllyToHealOrEnemyToAttack(fightingCharacter)
    }
    
    private func getsRandomBonus(fightingCharacter: Character) {
        guard arc4random_uniform(100) < percentageOfHavingBonus else {
            return
        }
        if fightingCharacter is Warrior, hasAlreadyGotBonus(player: attackingPlayer, weapon: DoubleSwords()) {
            return
        } else if fightingCharacter is Colossus, hasAlreadyGotBonus(player: attackingPlayer, weapon: GiantFronde()) {
            return
        } else if fightingCharacter is Magus, hasAlreadyGotBonus(player: attackingPlayer, weapon: VoidStaff()) {
            return
        } else if fightingCharacter is Priest, hasAlreadyGotBonus(player: attackingPlayer, weapon: TibetanBowl()) {
            return
        } else {
            bonusCount += 1
            fightingCharacter.addBonusToWeapon()
        }
    }
    
    private func hasAlreadyGotBonus(player: Player, weapon: Weapon) -> Bool {
        for bonus in player.characters {
            if bonus.weapon.name == weapon.name {
                return true
            }
        }
        return false
    }
    
    private func statistics() {
        guard let winner = players.filter({ !$0.isDefeat }).first else { return }
        
        print("""
            ❌ THE GAME IS OVER ❌
            🥂 The winner is --|  \(winner.name)  |-- 🥂
            ♻️ The game was finished in \(turns)turns. ♻️
            🎁 Bonus number: \(bonusCount) 🎁
            """)
    }
}
