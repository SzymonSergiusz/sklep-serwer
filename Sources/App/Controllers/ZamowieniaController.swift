import Fluent
import Vapor

struct ZamowieniaController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let orders = routes.grouped("orders")
        orders.get(use: index)
//        produkty.post(use: create)
//        produkty.put(use: update)
//        
//        produkty.group(":id") { produkty in
//            produkty.get(use: show)
//            produkty.put(use: update)
//            produkty.delete(use: delete)
//        }

    }

    func index(req: Request) async throws -> [Zamowienie] {
        try await Zamowienie.query(on: req.db).all()
    }

//    func create(req: Request) async throws -> Produkt {
//        let produkt = try req.content.decode(Produkt.self)
//        try await produkt.save(on: req.db)
//        return produkt
//    }
//    
//    func show(req: Request) async throws -> Produkt {
//        guard let produkt = try await Produkt.find(req.parameters.get("id"), on: req.db) else {
//               throw Abort(.notFound)
//           }
//           return produkt
//        
//    }
//    
//    func update(req: Request) async throws -> Produkt {
//        guard let produkt = try await Produkt.find(req.parameters.get("id"), on: req.db) else {
//            throw Abort(.notFound)
//        }
//        
//        let updatedProdukt = try req.content.decode(Produkt.self)
//        //zmiana tylko ceny nazwy opisu TODO?
//        produkt.nazwa = updatedProdukt.nazwa
//        produkt.opis = updatedProdukt.opis
//        produkt.cena = updatedProdukt.cena
//        
//        try await produkt.save(on: req.db)
//        return produkt
//    }
//    
//    func delete(req: Request) async throws -> HTTPStatus {
//        guard let produkt = try await Produkt.find(req.parameters.get("id"), on: req.db) else {
//              throw Abort(.notFound)
//          }
//          try await produkt.delete(on: req.db)
//          return .ok
//    }
}
