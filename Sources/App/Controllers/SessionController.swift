//
//  File.swift
//  
//
//  Created by Szymon Kluska on 07/01/2024.
//

import Vapor


struct SessionController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        
        let passwordProtected = routes.grouped(User.authenticator())
        passwordProtected.post("login") { req -> User in
            try req.auth.require(User.self)
            
            
            //return permission, user id
            
            //session user id, permission
        }
        
        passwordProtected.get("test-logowania") { req -> String in
            
            return "udało się"
        }
        
        passwordProtected.get("admin") { req -> String in
            
            return "udało się"
        }
        
        passwordProtected.group("user", "orders") { pass in
            pass.get(use: getOrders)
            pass.post(use: makeOrder)
            
        }
        
        
        
        func getOrders(req: Request) async throws -> [Zamowienie] {
            try await Zamowienie.query(on: req.db).all()
        }
        
        
        func makeOrder(req: Request) async throws -> String {
            return "składanie zamówienia"
//            try await Zamowienie.query(on: req.db).all()
        }
    }
    
    
}
