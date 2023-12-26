import Fluent
import Vapor

final class Produkt: Model, Content {

    static let schema = "produkty"
    
    @ID(custom: "produktyid")
    var id: UUID?

    @Field(key: "nazwa")
    var nazwa: String
    
    @Field(key: "opis")
    var opis: String
    
    @Field(key: "cena")
    var cena: Decimal
    
    @Field(key: "wydawcaid")
    var wydawcaid: UUID
    
    @Field(key: "gatunekid")
    var gatunekid: UUID
    
    @Field(key: "platformaid")
    var platformaid: UUID
    
    @Field(key: "data_wydania")
    var datawydania: Date
    
    @Field(key: "ilosc")
    var ilosc: Int
    

    init() { }
    
    init(id: UUID? = nil, nazwa: String, opis: String, cena: Decimal, wydawcaid: UUID, gatunekid: UUID, platformaid: UUID, datawydania: Date, ilosc: Int) {
        self.id = id
        self.nazwa = nazwa
        self.opis = opis
        self.cena = cena
        self.wydawcaid = wydawcaid
        self.gatunekid = gatunekid
        self.platformaid = platformaid
        self.datawydania = datawydania
        self.ilosc = ilosc
    }
    
}
