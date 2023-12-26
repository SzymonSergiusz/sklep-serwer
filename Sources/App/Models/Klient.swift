//
//  Klient.swift
//
//
//  Created by Szymon Kluska on 29/12/2023.
//

import Fluent
import Vapor

final class Klient: Model, Content {
    static let schema = "klienci"
    
    @ID(custom: "klienciid")
    var id: UUID?

    @Field(key: "imie")
    var imie: String
    
    @Field(key: "nazwisko")
    var nazwisko: String
    
    
    init(){}
    init(id: UUID? = nil, imie: String, nazwisko: String) {
        self.id = id
        self.imie = imie
        self.nazwisko = nazwisko
    }
    
    
}
