//
//  DateFormater.swift
//  alura-ponto
//
//  Created by c94289a on 22/02/22.
//

import Foundation

enum TypesOfDate {
    case time, dateAndTime
}

struct DateAndTimeFormatter {
    func getDate(_ data: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT-3")
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        return formatter.string(from: data)
    }
    
    func getTime(_ data: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT-3")
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: data)
    }
}
