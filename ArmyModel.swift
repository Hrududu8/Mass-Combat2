//
//  ArmyModel.swift
//  MassCombat
//
//  Created by rukesh on 11/7/15.
//  Copyright © 2015 Rukesh. All rights reserved.
//

import Cocoa

class Army: NSObject {
    var units = [ArmyUnit]()
    
    
    init(numOfUnits: Int) {
        for _ in 1...numOfUnits {
            self.units.append(ArmyUnit(unitType: "Bowmen", equipmentQuality: .Fine, troopQuality: .Average, specialClasses: ["Archer"], unitName: "Guys"))
            self.units.append(ArmyUnit(type: "Heavy Infantry"))
            
        }
        self.units[0].equipmentQuality = .VeryFine
        self.units[1].troopQuality = .Elite
        self.units[0].specialClasses.insert("Recon")
        
        
    }
    func numberOfUnits()->Int{
        return self.units.count
    }
    func getStrength(strengthCategory: String) throws ->Double {
        var troopStr : Double = 0
        if strengthCategory == "troop strength" {
            for eachUnit in units {
                troopStr += eachUnit.TS()
            }
            return troopStr
        }
        if ArmyUnit.ArmyUnitConstants.availableClasses.contains(strengthCategory) {
            for eachUnit in units {
                if eachUnit.specialClasses.contains(strengthCategory) {
                    troopStr += eachUnit.TS()
                }
            }
        } else {
            throw ArmyUnitErrors.UndefinedError
        }
        return troopStr
    }
            
}


