//
//  Rota.swift
//  FirebaseTest
//
//  Created by Julio Brazil on 28/04/17.
//  Copyright © 2017 Julio Brazil LTDA. All rights reserved.
//

import Foundation
import CoreLocation

public class Rota {
    var partida: CLLocation
    var destino: CLLocation
    var tempoPercurso: Int
    
    init() {
        self.partida = CLLocation()
        self.destino = CLLocation()
        self.tempoPercurso = 0
    }
    
    init(_ dictionary: Dictionary<String, Any>) {
        self.partida = Utils.stringToCLLocation(dictionary["partida"] as! String)
        self.destino = Utils.stringToCLLocation(dictionary["destino"] as! String)
        self.tempoPercurso = 0
    }
    
    public func getDictionary() -> [String: Any] {
        let dictionary = ["partida": "\(self.partida.coordinate.latitude)/\(self.partida.coordinate.longitude)",
                          "destino": "\(self.destino.coordinate.latitude)/\(self.destino.coordinate.longitude)"]
        return dictionary
    }
}
