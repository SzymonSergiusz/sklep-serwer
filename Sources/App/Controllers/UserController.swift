import Fluent
import Vapor
import FluentPostgresDriver

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let uzytkownicy = routes.grouped("users")
        uzytkownicy.get(use: index)
        uzytkownicy.post(use: create)
    }

    func index(req: Request) async throws -> [User] {
        try await User.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> HTTPStatus {
       
        let klient = try req.content.decode(Klient.self)

        try User.Create.validate(content: req)
        let create = try req.content.decode(User.Create.self)
        guard create.haslo == create.potwierdzHaslo else {
            throw Abort(.badRequest, reason: "Podane hasła się nie zgadzają")
        }
        
        let user = try User(
                login: create.login,
                haslo: Bcrypt.hash(create.haslo),
                email: create.email
            )
        
        
        if let postgres = req.db as? PostgresDatabase {
            _ = postgres
                .simpleQuery("SELECT dodajklienta('\(klient.imie)', '\(klient.nazwisko)', '\(user.login)', '\(user.haslo)', '\(user.email)')")
        } else {
            return .badRequest
        }
        return .ok
    }

}


