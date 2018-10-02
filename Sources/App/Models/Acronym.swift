
import Vapor
//import FluentMySQL
import FluentPostgreSQL

final class Acronym: Codable {
    
    var id: Int?
    var short: String
    var long: String
    
    var userID: User.ID
    
    init(short: String, long: String, userID: User.ID) {
        self.short = short
        self.long = long
        self.userID = userID
    }
}

//extension Acronym: MySQLModel {}
extension Acronym: PostgreSQLModel {}

extension Acronym: Migration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.reference(from: \.userID, to: \User.id)
        }
    }
}

extension Acronym: Content {}

extension Acronym: Parameter {}

extension Acronym {
    // 1
    var user: Parent<Acronym, User> {
        // 2
        return parent(\.userID)
    }
}
