import Fluent
import Vapor

func routes(_ app: Application) throws {
    

    app.get("gatunki") { req -> EventLoopFuture<[Gatunek]> in
        return Gatunek.query(on: req.db).all()
    }
    
    app.get("platformy") { req -> EventLoopFuture<[Platforma]> in
        return Platforma.query(on: req.db).all()
    }
    
    app.get("images", ":imageName") { req -> EventLoopFuture<Response> in
        guard var imageName = req.parameters.get("imageName") else {
            throw Abort(.badRequest)
        }

        imageName = imageName.replacingOccurrences(of: ":", with: "-")
        let imagePath = app.directory.publicDirectory + "images/\(imageName).png"
        
        guard let imageData = FileManager.default.contents(atPath: imagePath) else {
            throw Abort(.notFound)
        }
        
        let response = Response()
        response.headers.contentType = .png
        response.body = .init(data: imageData)
        
        return req.eventLoop.makeSucceededFuture(response)
    }
    
    try app.register(collection: ProduktyController())
    try app.register(collection: UserController())
    try app.register(collection: ZamowieniaController())
    try app.register(collection: SessionController())
}
             
