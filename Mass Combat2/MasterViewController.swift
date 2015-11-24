//
//  MasterViewController.swift
//  Mass Combat2
//
//  Created by rukesh on 11/14/15.
//  Copyright © 2015 Rukesh. All rights reserved.
//

import Cocoa

class MasterViewController: NSViewController {
    
    var battleModel = BattleModel()
    
    @IBOutlet weak var unitNameView: NSTextFieldCell!
    @IBOutlet weak var unitsTableView: NSTableView!
    @IBOutlet weak var unitTroopStrenghtView: NSTextField!
    @IBOutlet weak var unitEquipmentQualityView: NSPopUpButtonCell!
    @IBOutlet weak var unitTroopQualityView: NSPopUpButton!
    @IBOutlet weak var unitSpecialClassTableView: NSTableView!
    @IBOutlet weak var unitSpecialClassLabel: NSTextField!
    @IBOutlet weak var unitTypeButton: NSPopUpButtonCell!
    
    @IBOutlet weak var totalTroopStrengthLabel: NSTextField!
    
    @IBOutlet weak var totalArcherStrength: NSTextField!
    @IBOutlet weak var totalCavalryStrength: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    override func awakeFromNib() {
        //MARK: Set up popup buttons
        let unitEquipQualities = ["Poor", "Basic", "Good", "Fine", "Very Fine"]
        unitEquipmentQualityView.removeAllItems()
        unitEquipmentQualityView.addItemsWithTitles(unitEquipQualities)
        unitEquipmentQualityView.selectItemAtIndex(1)
        
        let unitTropQualities = ["Inferior", "Average","Good", "Elite"]
        unitTroopQualityView.removeAllItems()
        unitTroopQualityView.addItemsWithTitles(unitTropQualities)
        unitTroopQualityView.selectItemAtIndex(1)
        
        let unitTypes = ArmyUnit.allUnitTypes()
        unitTypeButton.removeAllItems()
        unitTypeButton.addItemsWithTitles(unitTypes)
        unitTypeButton.selectItemAtIndex(1)
        
        //Mark: set up Army Level values
        displayArmyLevelInfo()
        
        
    }
    //MARK: Troop Unit Table Related Functions
    func numberOfRowsInTableView(aTableView: NSTableView)->Int {
        if aTableView == self.unitsTableView {
            return battleModel.attacker.numberOfUnits()
        }
        if aTableView == self.unitSpecialClassTableView {
            if let unitSelectedForSpecialClassTableView = selectedUnit() {
                return  unitSelectedForSpecialClassTableView.specialClasses.count
            }
        }
        return 0
    }
    func populateUnitTableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int)-> NSView? {
        let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        let unit = self.battleModel.attacker.units[row]
        if tableColumn?.identifier == "UnitNameColumn" {
            cellView.textField!.stringValue = unit.unitName
        }
        if tableColumn?.identifier == "TroopStrengthColumn" {
            cellView.textField!.stringValue = String(unit.TS())
        }
        return cellView
    }
    
    func populateUnitSpecialClassTableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int)-> NSView? {
        print("hi")
        let viewID = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self)
        let cellView = viewID as! NSTableCellView
        //To do: the problem is that you are calling it without a unit
        if tableColumn?.identifier == "SpecialClassColumn" {
                cellView.textField!.stringValue = "hi"
        }
        return cellView
    }

    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int)-> NSView? {
        if tableView == self.unitsTableView {
            let theView : NSView? = populateUnitTableView(tableView, viewForTableColumn: tableColumn!, row: row)
            return theView
        }
        //To do: make the special class Table view work
        /*
        if tableView == self.unitSpecialClassTableView {
            let theView: NSView? = populateUnitSpecialClassTableView(tableView, viewForTableColumn: tableColumn!, row: row)
            return theView
        }
        */
        
        return nil
    }
   
        
    
    
    func selectedUnit()->ArmyUnit?{
        let selectedRow = self.unitsTableView.selectedRow
        if selectedRow >= 0 && selectedRow < self.battleModel.attacker.units.count {
            return self.battleModel.attacker.units[selectedRow]
        }
        return nil
    }
    func updateDetailInfo(unit: ArmyUnit?){  
        //TODO: I think you have update the tableView here
        var unitName = ""
        var unitType = "Heavy Infantry"
        var unitTS = 0.0
        var unitEquipment : UnitEquipmentQuality = .Basic
        var unitQuality : UnitTroopQuality = .Average
        var unitSpecialClasses = Set<String>()
        if let aUnit = unit {
            unitName = aUnit.unitName
            unitType = aUnit.unitType 
            unitTS = aUnit.TS()
            unitEquipment = aUnit.equipmentQuality
            unitQuality = aUnit.troopQuality
            unitSpecialClasses = aUnit.specialClasses
        }
        self.unitNameView.stringValue = unitName
        self.unitTroopStrenghtView.stringValue = String(unitTS)
        self.unitEquipmentQualityView.selectItemAtIndex(unitEquipment.getIndex())
        self.unitTroopQualityView.selectItemAtIndex(unitQuality.getIndex())
        self.unitTypeButton.selectItemAtIndex(ArmyUnit.allUnitTypes().indexOf(unitType)!)
        var listOfClasses = "Special Classes"
        if unitSpecialClasses.count > 0 {
            for eachClass in unitSpecialClasses {
                listOfClasses = listOfClasses + "\n" + eachClass
            }
        } else {
            listOfClasses = "Special Classes\nNone"
        }
        self.unitSpecialClassLabel.stringValue = listOfClasses
        displayArmyLevelInfo()  
    }
    
    
//MARK: - Army Level Functions
    func displayArmyLevelInfo()->(){
        try! totalTroopStrengthLabel.stringValue = "Troop Strength     " + String(battleModel.attacker.getStrength("troop strength"))
        try! totalCavalryStrength.stringValue = "Cavalry Strength    " + String(battleModel.attacker.getStrength("Cavalry"))
        try! totalArcherStrength.stringValue = "Archer Strength    " + String(battleModel.attacker.getStrength("Archer"))
        
    }
    
}

//MARK: - IBActions

extension MasterViewController {
    
    @IBAction func unitNameDidEndEdit(sender: AnyObject) {
        if let theSelectedUnit = selectedUnit() {
            theSelectedUnit.unitName = self.unitNameView.stringValue
            updateDetailInfo(theSelectedUnit)
            let indexSet = NSIndexSet(index: self.unitsTableView.selectedRow)
            let columnSet = NSIndexSet(index: 0)
            self.unitsTableView.reloadDataForRowIndexes(indexSet, columnIndexes: columnSet)
        }
    }
    
    @IBAction func unitTypeDidEndEdit(sender: AnyObject) {
        if let theSelectedUnit = selectedUnit() {
            theSelectedUnit.unitType = self.unitTypeButton.titleOfSelectedItem!
            battleModel.attacker.units[self.unitsTableView.selectedRow].unitType = theSelectedUnit.unitType
            updateDetailInfo(theSelectedUnit)
            let indexSet = NSIndexSet(index: self.unitsTableView.selectedRow)
            let columnSet = NSIndexSet(index: 0)
            self.unitsTableView.reloadDataForRowIndexes(indexSet, columnIndexes: columnSet)
            
        }
    }
    @IBAction func unitEquipmtnTypeDidEndEdit(sender: AnyObject) {
        if let theSelectedUnit = selectedUnit() {
            //TO DO: fix me
            //theSelectedUnit.equipmentQuality = self.unitEquipmentQualityView.titleOfSelectedItem!
            
        }
    }
    
    
    @IBAction func addUnitButton(sender: AnyObject) {
        let newUnit = ArmyUnit(type: "heavy infantry")
        self.battleModel.attacker.units.append(newUnit)
        let newRowIndex = self.battleModel.attacker.units.count - 1
        self.unitsTableView.insertRowsAtIndexes(NSIndexSet(index: newRowIndex), withAnimation: NSTableViewAnimationOptions.EffectGap)
        self.unitsTableView.selectRowIndexes((NSIndexSet(index: newRowIndex)), byExtendingSelection: false)
        self.unitsTableView.scrollRowToVisible(newRowIndex)
        
    }
    
    
    @IBAction func deleteUnitButton(sender: AnyObject) {
        if let _ = selectedUnit() {
            self.battleModel.attacker.units.removeAtIndex(self.unitsTableView.selectedRow)
            self.unitsTableView.removeRowsAtIndexes(NSIndexSet(index:self.unitsTableView.selectedRow), withAnimation: NSTableViewAnimationOptions.SlideRight)
            updateDetailInfo(nil)
        }
    }
}

//MARK: NSTableViewDelegate
extension MasterViewController : NSTableViewDelegate {
    func tableViewSelectionDidChange(notification: NSNotification) {
        let selectedDoc = selectedUnit()
        updateDetailInfo(selectedDoc)
    }
}




















