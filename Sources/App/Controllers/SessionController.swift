//
//  SessionController.swift
//
//
//  Created by Szymon Kluska on 07/01/2024.
//

import Vapor
import Fluent

struct SessionController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        
        let passwordProtected = routes.grouped(User.authenticator())
        passwordProtected.post("login") { req -> [String:String] in
            let user = try req.auth.require(User.self)
            
            req.session.data["userId"] = user.id?.uuidString
            req.session.data["clientId"] = user.klientId.uuidString
            req.session.data["uprawnienia"] = user.uprawnienia
            let responseData: [String:String] = [
                "id": user.id?.uuidString ?? "",
                "uprawnienia": user.uprawnienia
            ]
            return responseData
        }
        
        passwordProtected.post("logout") { req -> HTTPStatus in
            req.session.data["userId"] = ""
            req.session.data["clientId"] = ""
            req.session.data["uprawnienia"] = ""
            return .ok
        }
        
        passwordProtected.group("user", "orders") { pass in
            pass.get(use: getOrders)
            pass.post(use: makeOrder)
            
        }
        
        passwordProtected.post("addProduct") { req -> HTTPStatus in
            
            if (req.session.data["uprawnienia"] == "pracownik") {
                let produkt = try req.content.decode(Produkt.self)
                try await produkt.save(on: req.db)
                return .ok
            } else {
                return .badGateway
            }
        }
        
        func getOrders(req: Request) async throws -> [Zamowienie] {
            guard let clientIdString = req.session.data["clientId"],
                  let clientId = UUID(clientIdString) else {
                throw Abort(.unauthorized)
            }
            let orders = try await Zamowienie.query(on: req.db)
                .filter(\.$klientId == clientId)
                .all()
            return orders
        }

        
        func makeOrder(req: Request) async throws -> HTTPStatus {
            guard let clientIdString = req.session.data["clientId"],
                  let clientId = UUID(clientIdString) else {
                throw Abort(.unauthorized)
            }

            struct ProductIdOnly: Content {
                let id: String
            }

            let productIdOnly = try req.content.decode(ProductIdOnly.self)
            guard let productId = UUID(productIdOnly.id) else {
                throw Abort(.badRequest)
            }

            guard let product = try await Produkt.query(on: req.db)
                    .filter(\.$id == productId)
                    .first() else {
                throw Abort(.notFound)
            }

            let cena = product.cena

            let newOrder = Zamowienie(klientId: clientId,
                                      productid: productId,
                                      cenazakupu: cena,
                                      datazamowienia: Date())

            do {
                try await newOrder.save(on: req.db)
                return .ok
            } catch {
                throw Abort(.internalServerError, reason: "Błąd: \(error)")
            }
        }
        
        
    }
}
