import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    // 1
    let acronymsController = AcronymController()
    // 2
    try router.register(collection: acronymsController)
    
    // 1
    let usersController = UserController()
    // 2
    try router.register(collection: usersController)
}
















