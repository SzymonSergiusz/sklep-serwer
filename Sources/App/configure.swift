import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "postgres",
        password: Environment.get("DATABASE_PASSWORD") ?? "bazydanych",
        database: Environment.get("DATABASE_NAME") ?? "postgres",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    app.migrations.add(ProduktyMigration())

    // register routes
    try routes(app)
    
    
    let corsConfiguration = CORSMiddleware.Configuration(
         allowedOrigin: .custom("http://localhost:5173"), // Replace with your frontend origin
         allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
         allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin],
         allowCredentials: true // Allow credentials (session cookies)
     )
     let cors = CORSMiddleware(configuration: corsConfiguration)
     app.middleware.use(cors, at: .beginning)
    
    
    app.middleware.use(app.sessions.middleware)
    
    app.sessions.use(.memory)
    

}
