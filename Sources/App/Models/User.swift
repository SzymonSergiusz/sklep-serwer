//
//  Uzytkownik.swift
//
//
//  Created by Szymon Kluska on 29/12/2023.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "uzytkownicy"
    
    @ID(custom: "uzytkownicyid")
    var id: UUID?

    @Field(key: "login")
    var login: String
    
    @Field(key: "haslo")
    var haslo: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "klientid")
    var klientId: UUID
    
    @Field(key: "uprawnienia")
    var uprawnienia: String
    
    
    init() {}
    init(id: UUID? = nil, email: String, haslo: String) {
        self.email = email
        self.haslo = haslo

    }
    init(id: UUID? = nil, login: String, haslo: String, email: String, klientId: UUID, uprawnienia: String) {
        self.id = id
        self.login = login
        self.haslo = haslo
        self.email = email
        self.klientId = klientId
        self.uprawnienia = uprawnienia
    }
    
    init(id: UUID? = nil, login: String, haslo: String, email: String) {
        self.id = id
        self.login = login
        self.haslo = haslo
        self.email = email
//        self.klientId = klientId
//        self.uprawnienia = uprawnienia
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$haslo
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.haslo)
    }
}

extension User {
    struct Create: Content {
        var login: String
        var email: String
        var haslo: String
        var potwierdzHaslo: String
    }
}

extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("login", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("haslo", as: String.self, is: .count(3...))
    }
}


