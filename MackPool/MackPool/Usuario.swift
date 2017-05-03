//
//  Usuario.swift
//  FirebaseTest
//
//  Created by Julio Brazil on 30/04/17.
//  Copyright © 2017 Julio Brazil LTDA. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

public class Usuario {
    var tia: String
    var nome: String
    var email: String
    var dataNascimento: Date
    var foto: String //URL usada para gerar uma UIImage
    var currentLocation: CLLocation
    
    public init() {
        self.tia = ""
        self.nome = ""
        self.email = ""
        self.dataNascimento = Date()
        self.foto = ""
        self.currentLocation = CLLocation()
    }
    
    public init(tia: String, nome: String, email: String, dataNascimento: Date, foto: String, currentLocation: CLLocation) {
        self.tia = tia
        self.nome = nome
        self.email = email
        self.dataNascimento = dataNascimento
        self.foto = foto
        self.currentLocation = currentLocation
    }
    
    public init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.tia = snapshot.key
        self.nome = snapshotValue["nome"] as! String
        self.email = snapshotValue["email"] as! String
        self.dataNascimento = Utils.stringToDate(snapshotValue["dataNascimento"] as! String)
        self.foto = snapshotValue["foto"] as! String
        self.currentLocation = CLLocation()
    }
    
    public func getDictionary() -> [String : Any]{
        let location = "\(currentLocation.coordinate.latitude)/\(currentLocation.coordinate.longitude)"
        let dictionary = ["tia": self.tia,
                          "nome": self.nome,
                          "email": self.email,
                          "dataNascimento": Utils.dateToString(self.dataNascimento),
                          "foto": self.foto,
                          "currentLocation": location] as [String : Any]
        return dictionary
    }
}
