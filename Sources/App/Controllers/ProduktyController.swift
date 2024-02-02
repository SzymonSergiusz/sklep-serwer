import Fluent
import Vapor

struct ProduktyController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let produkty = routes.grouped("products")
        produkty.get(use: index)
        produkty.post(use: create)
        produkty.put(use: update)
        
        produkty.group(":id") { produkty in
            produkty.get(use: show)
            produkty.put(use: update)
            produkty.delete(use: delete)
        }
        let randomProdukty = routes.grouped("products", "random")
        randomProdukty.get(use: getRandomFive)
    }

    func index(req: Request) async throws -> [Produkt] {
        do {
            if let search: String = try req.query.get(at: "szukane") {
                print(search)
                let produkty = try await Produkt.query(on: req.db)
                    .filter(\.$nazwa, .custom("ILIKE"), "%\(search)%")
                    .all()
                return produkty
            } else {
                return try await Produkt.query(on: req.db).all()
            }
        } catch {
            throw Abort(.badRequest, reason: "Error: \(error)")
        }
    }

        

    }

    func getRandomFive(req: Request) async throws -> [Produkt] {
        try await Produkt.query(on: req.db).all().randomSample(count: 5)
    }
    
    func create(req: Request) async throws -> Produkt {
        let produkt = try req.content.decode(Produkt.self)
        try await produkt.save(on: req.db)
        return produkt
    }
    
    func show(req: Request) async throws -> Produkt {
        guard let produkt = try await Produkt.find(req.parameters.get("id"), on: req.db) else {
               throw Abort(.notFound)
           }
           return produkt
        
    }
    
    func update(req: Request) async throws -> Produkt {
        guard let produkt = try await Produkt.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedProdukt = try req.content.decode(Produkt.self)
        //zmiana tylko ceny nazwy opisu TODO?
        produkt.nazwa = updatedProdukt.nazwa
        produkt.opis = updatedProdukt.opis
        produkt.cena = updatedProdukt.cena
        
        try await produkt.save(on: req.db)
        return produkt
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let produkt = try await Produkt.find(req.parameters.get("id"), on: req.db) else {
              throw Abort(.notFound)
          }
          try await produkt.delete(on: req.db)
          return .ok
    }
