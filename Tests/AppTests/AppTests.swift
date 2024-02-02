@testable import App
import XCTVapor
import Fluent

final class AppTests: XCTestCase {
    
    func testGetRandomFive() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try await configure(app)
        
        let numberOfRandomElements = 5
        try app.test(.GET, "products/random") { response in
            XCTAssertEqual(response.status, .ok)
            let randomProducts = try response.content.decode([Produkt].self)
            XCTAssertEqual(randomProducts.count, numberOfRandomElements)
        }
    }


    
     func testAddProduct() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try await configure(app)
        let ile = try await Produkt.query(on: app.db).count()

        let produkt = Produkt(nazwa: "Test", opis: "opis testu", cena: 10, wydawcaid: UUID("48ACAAC0-9F76-45E2-8A83-FCE3F442D54F")!, gatunekid: UUID("B09746DF-132E-4DBE-901A-94E90A246D73")!, platformaid: UUID("51E25813-0CCE-4705-8D3D-DD5FFB8874D3")!, datawydania: Date.now, ilosc: 1)
        try await produkt.save(on: app.db)
        
        let ilePlusJeden = try await Produkt.query(on: app.db).count()
        XCTAssertEqual(ile+1, ilePlusJeden)
    }
    
     func testDeleteProduct() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try await configure(app)
        let ile = try await Produkt.query(on: app.db).count()
        let produkt = Produkt(nazwa: "Test", opis: "opis testu", cena: 10, wydawcaid: UUID("48ACAAC0-9F76-45E2-8A83-FCE3F442D54F")!, gatunekid: UUID("B09746DF-132E-4DBE-901A-94E90A246D73")!, platformaid: UUID("51E25813-0CCE-4705-8D3D-DD5FFB8874D3")!, datawydania: Date.now, ilosc: 1)
      
        try await Produkt.query(on: app.db)
            .filter(\.$nazwa == produkt.nazwa)
                .delete()
        
        let ileMinusJeden = try await Produkt.query(on: app.db).count()
        XCTAssertEqual(ile, ileMinusJeden+1)
    }
}
