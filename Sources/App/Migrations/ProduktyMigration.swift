//
//  ProduktyMigration.swift
//
//
//  Created by Szymon Kluska on 29/12/2023.
//

import Fluent
import Vapor

struct ProduktyMigration : Migration {
    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("produkty")
            .field("produktyid", .uuid, .identifier(auto: true))
            .field("nazwa", .string, .required)
            .field("opis", .string, .required)
            .field("cena", .float, .required)
            .field("wydawcaid", .uuid, .required, .references("wydawcy", "wydawcyid"))
            .field("gatunekid", .uuid, .required, .references("gatunki", "gatunkiid"))
            .field("data_wydania", .date, .required)
            .field("ilosc", .int, .required)
            .create()
    }
    
    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        return database.schema("produkty").delete()
    }
    
    
}
