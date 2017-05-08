//
//  Functions.swift
//  MackPool
//
//  Created by Piera Marchesini on 07/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import Foundation

public class Functions {
    public static func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let string = dateFormatter.string(from: date)
        return string
    }
    
    public static func stringToDate(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        let dateObject = dateFormatter.date(from: string)
        return dateObject!
    }
}
