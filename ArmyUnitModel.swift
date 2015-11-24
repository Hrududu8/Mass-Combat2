//
//  ArmyUnitModel.swift
//  MassCombat
//
//  Created by rukesh on 11/8/15.
//  Copyright © 2015 Rukesh. All rights reserved.
//

import Cocoa

//MARK: - enum UnitTroopQuality
enum UnitTroopQuality {
    case Inferior, Average, Good, Elite
    func getMultiplier()->Double {
        switch self {
        case .Inferior:
            return -0.5
        case .Good:
            return 0.5
        case .Elite:
            return 1.0
        default:
            //average is the default and return value if nothing else matches
            return 0
        }
    }
    func getIndex()->Int {
        switch self {
        case .Inferior:
            return 0
        case .Average:
            return 1
        case .Good:
            return 2
        case .Elite:
            return 3
        }
    }
}

//MARK: - enum UnitEquipmentQuality
enum UnitEquipmentQuality {
    case Poor, Basic, Good, Fine, VeryFine
    func getMultiplier()->Double {
        switch self {
        case .Poor:
            return -0.25
        case .Good:
            return 0.5
        case .Fine:
            return 1.0
        case .VeryFine:
            return 1.5
        default:
            //basic is the default and return value if nothing else matches
            return 0
        }
    }
    func getIndex()->Int {
        switch self {
        case .Poor:
            return 0
        case .Basic:
            return 1
        case .Good:
            return 2
        case .Fine:
            return 3
        case .VeryFine:
            return 4
        }
    }
    
}

//MARK: -ArmyUnitErrorTypes
enum ArmyUnitErrors: ErrorType {
    case SpecialClassTypeError
    case InvalidArmyUnitType
    case UndefinedError
    
}



//MARK: -ArmyUnit
class ArmyUnit : NSObject {
    var basicTS = 0.0
    var unitType : String = "" {
        didSet {
            self.basicTS = try! troopStrLookupTable(self.unitType)
            //TO DO: automatically change special classes
        }
    }
    var specialClasses = Set<String>()
    var unitName = ""
    //TODO:  create didSet for equipment and troopquality to change TS when they change
    var equipmentQuality : UnitEquipmentQuality = .Basic
    var troopQuality : UnitTroopQuality = .Average
    
    
    
    struct ArmyUnitConstants {
        static let availableClasses : Set<String> = ["Cavalry","Fire","Recon", "Archer"]
    }
    
    init(unitType: String, equipmentQuality: UnitEquipmentQuality, troopQuality: UnitTroopQuality, specialClasses: [String]?, unitName: String?){
        super.init()
        self.unitType = unitType
        //the next line will crash it can't find a unit type
        self.basicTS = try! troopStrLookupTable(self.unitType)
        //self.TS = self.basicTS
        self.equipmentQuality = equipmentQuality
        self.troopQuality = troopQuality
        if let listOfClasses = specialClasses {
             //the next line will cause program to crash if the special class is not permitted
            try! checkSpecialClasses(listOfClasses)
            for unitClass in listOfClasses {
                self.specialClasses.insert(unitClass)
            }
        }
        if self.unitType.rangeOfString("Cavalry") != nil {
            self.specialClasses.insert("Cavalry")
        }
        if self.unitType.rangeOfString("Bowmen") != nil {
            self.specialClasses.insert("Archer")
        }
        if unitName != nil {
            self.unitName = unitName!
        } else {
            self.unitName = self.unitType
        }
    }
    convenience init(type: String){
        self.init(unitType: type, equipmentQuality: .Basic, troopQuality: .Average, specialClasses: nil, unitName: nil)
    }
    
    func debugQuickLookObject()->AnyObject  {
        var myString = "Unit: \(self.unitType)"
        myString += "\nTS = \(self.TS())"
        myString += "\nSpecial Classes: \(self.specialClasses)"
        myString += "\nEquip: \(self.equipmentQuality); troop quality: \(self.troopQuality)"
        return myString
    }
    
    func checkSpecialClasses(listOfClasses: [String]) throws {
        for unitClass in listOfClasses {
            guard ArmyUnitConstants.availableClasses.contains(unitClass) else {
                throw ArmyUnitErrors.SpecialClassTypeError
            }
        }
    }
    
    func TS()->Double {
        var TS : Double 
            let equipModifier = 1.0 + self.equipmentQuality.getMultiplier()
            let troopQualityModifier = 1.0 + self.troopQuality.getMultiplier()
            TS = self.basicTS * equipModifier * troopQualityModifier
            return TS
    }
    
    
    class func allUnitTypes()->[String] {
        let unitTypes = [
            "Hero",
            "Bowmen",
            "Heavy Cavalry",
            "Heavy Chariots",
            "Heavy Infantry",
            "Horse Archers",
            "Light Cavalry",
            "Light Chariots",
            "Light Infantry",
            "Medium Cavalry",
            "Medium Infantry",
            "Miners",
            "Pikemen",
            "Beasts",
            "War Beasts",
            "General Beasts",
            "Flying Beasts",
            "Flying Cavalry",
            "Flying Infantry",
            "Flying Leviathan",
            "Giant Flying monster",
            "Giant Monster",
            "Giants",
            "Leviathan",
            "Ogres",
            "Titan"
        ]
        return unitTypes
    }
    
    func troopStrLookupTable(type: String) throws ->Double{
        //TODO: move the data to a file
        let troopStr = [
            "Hero": 0.25,
            "Bowmen": 2,
            "Heavy Cavalry": 5,
            "Heavy Chariots": 4,
            "Heavy Infantry": 4,
            "Horse Archers": 2,
            "Light Cavalry": 2,
            "Light Chariots": 2,
            "Light Infantry": 2,
            "Medium Cavalry": 3,
            "Medium Infantry": 3,
            "Miners": 1, //assumes TL3
            "Pikemen": 4,
            "Beasts": 1,
            "War Beasts": 20,
            "General Beasts": 1,
            "Flying Beasts": 1,
            "Flying Cavalry": 2,
            "Flying Infantry": 2,
            "Flying Leviathan": 150,
            "Giant Flying monster": 15,
            "Giant Monster": 40,
            "Giants": 20,
            "Leviathan": 250,
            "Ogres": 8,
            "Titan": 400
        ]
        guard let str = troopStr[type] else {
            throw ArmyUnitErrors.InvalidArmyUnitType
        }
        return str
    }
}
