import Vapor
//import FluentMySQL
import FluentPostgreSQL

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
//    try services.register(FluentMySQLProvider())
    try services.register(FluentPostgreSQLProvider())
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    
//    let dbConfig = MySQLDatabaseConfig(hostname: "localhost",
//                                port: 3306,
//                                username: "vapor",
//                                password: "password",
//                                database: "vapor",
//                                capabilities: .default,
//                                characterSet: .utf8mb4_unicode_ci,
//                                transport: .cleartext)
//    let db = MySQLDatabase(config: dbConfig)
//    databases.add(database: db, as: .mysql)
//    services.register(databases)
    
//Local
//    let databaseConfig = PostgreSQLDatabaseConfig(hostname: "localhost",
//                                                  port: 5432,
//                                                  username: "vapor",
//                                                  database: "vapor",
//                                                  password: "password",
//                                                  transport: .cleartext)
//    let db = PostgreSQLDatabase(config: databaseConfig)
//    databases.add(database: db, as: .psql)
//    services.register(databases)
    
    //Cloud
    let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
    let username = Environment.get("DATABASE_USER") ?? "vapor"
    let databaseName = Environment.get("DATABSE_DB") ?? "vapor"
    let password = Environment.get("DATABSE_PASSWORD") ?? "password"
    
    let databaseConfig = PostgreSQLDatabaseConfig(hostname: hostname,
                                                username: username,
                                                database: databaseName,
                                                password: password)
    let db = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: db, as: .psql)
    services.register(databases)
    

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Acronym.self, database: .psql)
    services.register(migrations)
    
    var commandConfig = CommandConfig.default()
    commandConfig.useFluentCommands()
    services.register(commandConfig)
    

}
