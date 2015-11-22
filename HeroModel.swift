//
//  HeroModel.swift
//  MassCombat
//
//  Created by rukesh on 11/8/15.
//  Copyright © 2015 Rukesh. All rights reserved.
//

import Cocoa


class hero : NSObject  {
    var name = ""
    var hitPoint = 10
    var heroSkills = ["strategy": 4, "leadership": 5, "tactics": 4, "intelligenceAnalysis": 4, "specialSkill": 0, "combat": 10]
    var riskModifier = 0
    var specialAdvantage = false
    
    init(name: String, hitPoints: Int, riskModifier: Int, skills: [String: Int]?) {
        self.name = name
        self.riskModifier = riskModifier
        self.hitPoint = hitPoints
        if skills != nil {
            for (skill, value) in heroSkills {
                if skills![skill] != nil {
                    heroSkills[skill] = skills![skill]
                } else {
                    heroSkills[skill] = value
                }
            }
        }
    }
    convenience init(name: String) {
        self.init(name: name)
    }
}