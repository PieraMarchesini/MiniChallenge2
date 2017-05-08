//
//  Group.swift
//  FirebaseTest
//
//  Created by Julio Brazil on 28/04/17.
//  Copyright © 2017 Julio Brazil LTDA. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

public class Group {
    var id: String
    var lider: String
    var maxUsuarios: Int
    var privacidade: Bool
    var horario: String
    var local: CLLocation
    var meioTransporte: MeioTransporte
    var rotaMack: Rota
    var toMack: Bool
    
    public init() {
        self.id = ""
        self.lider = ""
        self.maxUsuarios = 0
        self.privacidade = false
        self.horario = ""
        self.local = CLLocation()
        self.meioTransporte = MeioTransporte(rawValue: 0)!
        self.rotaMack = Rota()
        self.toMack = false
    }
    
    public init(id: String, lider: String, maxUsuarios: Int, privacidade: Bool, horario: String, local: CLLocation, meioTransporte: Int, rotaMack: Rota, toMack: Bool) {
        self.id = id
        self.lider = lider
        self.maxUsuarios = maxUsuarios
        self.privacidade = privacidade
        self.horario = horario
        self.local = local
        self.meioTransporte = MeioTransporte(rawValue: meioTransporte)!
        self.rotaMack = rotaMack
        self.toMack = toMack
    }
    
    public init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        self.id = snapshot.key
        self.lider = snapshotValue["lider"] as! String
        self.maxUsuarios = snapshotValue["maxUsuarios"] as! Int
        self.privacidade = snapshotValue["privacidade"] as! Bool
        self.horario = snapshotValue["horario"] as! String
        self.local = Utils.stringToCLLocation(snapshotValue["local"] as! String)
        self.meioTransporte = MeioTransporte(rawValue: snapshotValue["meioTransporte"] as! Int)!
        self.rotaMack = Rota(snapshotValue["rotaMack"] as! Dictionary)
        self.toMack = snapshotValue["toMack"] as! Bool
    }
    
    public func getDictionary() -> [String : Any]{
        let dictionary = ["id": self.id,
                          "lider": self.lider,
                          "maxUsuarios": self.maxUsuarios,
                          "privacidade": self.privacidade,
                          "horario": self.horario,
                          "local": self.local,
                          "meioTransporte": self.meioTransporte.rawValue,
                          "rotaMack": self.rotaMack.getDictionary(),
                          "toMack": self.toMack] as [String : Any]
        return dictionary
    }
}
