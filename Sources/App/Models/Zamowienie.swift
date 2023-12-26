//
//  Zamowienia.swift
//
//
//  Created by Szymon Kluska on 29/12/2023.
//

import Fluent
import Vapor

final class Zamowienie: Model, Content {
    static let schema = "zamowienia"
    
    @ID(custom: "zamowienieid")
    var id: UUID?
    
    @Field(key: "klientid")
    var nazwa: UUID
    
    @Field(key: "produktid")
    var productid: UUID
    
    @Field(key: "cenazakupu")
    var cenazakupu: Decimal
    
    @Field(key: "datazamowienia")
    var datazamowienia: Date
    
    init(){}
    
    init(id: UUID? = nil, nazwa: UUID, productid: UUID, cenazakupu: Decimal, datazamowienia: Date) {
        self.id = id
        self.nazwa = nazwa
        self.productid = productid
        self.cenazakupu = cenazakupu
        self.datazamowienia = datazamowienia
    }
}
