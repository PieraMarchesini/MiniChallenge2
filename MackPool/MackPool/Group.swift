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
    var maxUsuarios: Int
    var privacidade: Bool
    var horario: Double
    var local: CLLocation
    var meioTransporte: MeioTransporte
    var rotaMack: Rota
    
    public init() {
        self.id = ""
        self.maxUsuarios = 0
        self.privacidade = false
        self.horario = 0
        self.local = CLLocation()
        self.meioTransporte = MeioTransporte(rawValue: 0)!
        self.rotaMack = Rota()
    }
    
    public init(id: String, maxUsuarios: Int, privacidade: Bool, horario: Double, local: CLLocation, meioTransporte: Int, rotaMack: Rota) {
        self.id = id
        self.maxUsuarios = maxUsuarios
        self.privacidade = privacidade
        self.horario = horario
        self.local = local
        self.meioTransporte = MeioTransporte(rawValue: meioTransporte)!
        self.rotaMack = rotaMack
    }
    
    public init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.id = snapshot.key
        self.maxUsuarios = snapshotValue["maxUsuarios"] as! Int
        self.privacidade = snapshotValue["privacidade"] as! Bool
        self.horario = snapshotValue["horario"] as! Double
        self.local = snapshotValue["local"] as! CLLocation
        self.meioTransporte = MeioTransporte(rawValue: (snapshotValue["meioTransporte"] as! Int))!
        self.rotaMack = snapshotValue["rotaMack"] as! Rota
    }
    
    public func getDictionary() -> [String : Any]{
        let dictionary = ["id": self.id,
                          "maxUsuarios": self.maxUsuarios,
                          "privacidade": self.privacidade,
                          "horario": self.horario,
                          "local": self.local,
                          "meioTransporte": self.meioTransporte.rawValue,
                          "rotaMack": self.rotaMack] as [String : Any]
        return dictionary
    }
}
