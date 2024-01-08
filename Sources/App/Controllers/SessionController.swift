//
//  File.swift
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
        
        passwordProtected.get("test-logowania") { req -> String in
            
            return "udało się"
        }
        
        passwordProtected.get("admin") { req -> String in
            
            if (req.session.data["uprawnienia"] == "pracownik") {
                return "witam admina"
            } else {
                return "brak uprawnień"

            }
}
        
        passwordProtected.group("user", "orders") { pass in
            pass.get(use: getOrders)
            pass.post(use: makeOrder)
            
        }
        
        
        
        func getOrders(req: Request) async throws -> [Zamowienie] {
            guard let clientIdString = req.session.data["clientId"],
                  let clientId = UUID(clientIdString) else {
                throw Abort(.unauthorized)
            }
            print(clientIdString)


            let orders = try await Zamowienie.query(on: req.db)
                .filter(\.$klientId == clientId)
                .all()

            return orders
        }

        
        func makeOrder(req: Request) async throws -> HTTPStatus {
            // Retrieve clientId from the session
            guard let clientIdString = req.session.data["clientId"],
                  let clientId = UUID(clientIdString) else {
                throw Abort(.unauthorized)
            }

            // Decode the request body to get productId
            struct ProductIdOnly: Content {
                let id: String
            }

            let productIdOnly = try req.content.decode(ProductIdOnly.self)
            guard let productId = UUID(productIdOnly.id) else {
                throw Abort(.badRequest)
            }

            // Fetch the product details
            guard let product = try await Produkt.query(on: req.db)
                    .filter(\.$id == productId)
                    .first() else {
                throw Abort(.notFound)
            }

            // Extract the price (cena) from the product
            let cena = product.cena

            // Create a new order instance
            let newOrder = Zamowienie(klientId: clientId,
                                      productid: productId,
                                      cenazakupu: cena,
                                      datazamowienia: Date()) // Use Date() for the current date

            // Save the new order to the database
            do {
                try await newOrder.save(on: req.db)
                return .ok // Return success status if order saved successfully
            } catch {
                throw Abort(.internalServerError, reason: "Failed to save the order: \(error)")
            }
        }

        
        
        
    }
    
    
}
