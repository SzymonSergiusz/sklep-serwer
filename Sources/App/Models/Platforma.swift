//
//  Platforma.swift
//
//
//  Created by Szymon Kluska on 29/12/2023.
//

import Fluent
import Vapor

final class Platforma: Model, Content {
    static let schema = "platformy"
    
    @ID(custom: "platformyid")
    var id: UUID?
    
    @Field(key: "nazwa")
    var nazwa: String
    
}
