//
//  File.swift
//  
//
//  Created by Szymon Kluska on 29/12/2023.
//

import Fluent
import Vapor

final class Wydawca: Model, Content {
    static let schema = "wydawcy"
    
    @ID(custom: "wydawcyid")
    var id: UUID?
    
    @Field(key: "nazwa")
    var nazwa: String
    
    @Field(key: "panstwo")
    var panstwo: String
    
    init() {}
    
    init(id: UUID? = nil, nazwa: String, panstwo: String) {
        self.id = id
        self.nazwa = nazwa
        self.panstwo = panstwo
    }
    
}
