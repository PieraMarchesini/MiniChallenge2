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
    var origem: CLLocation
    var destino: CLLocation
    var tempoPercurso: Int
    
    init() {
        self.origem = CLLocation()
        self.destino = CLLocation()
        self.tempoPercurso = 0
    }
    
    init(_: Dictionary<String, Any>) {
        self.origem = CLLocation()
        self.destino = CLLocation()
        self.tempoPercurso = 0
    }
}
