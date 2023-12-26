//
//  Gatunek.swift
//
//
//  Created by Szymon Kluska on 29/12/2023.
//

import Fluent
import Vapor

final class Gatunek: Model, Content {
    static let schema = "gatunki"
    
    @ID(custom: "gatunkiid")
    var id: UUID?
    
    @Field(key: "nazwa")
    var nazwa: String
    
    init() {}
    
    init(id: UUID? = nil, nazwa: String, panstwo: String) {
        self.id = id
        self.nazwa = nazwa
    }
    
}
