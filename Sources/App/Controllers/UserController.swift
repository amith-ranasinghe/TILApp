import Vapor

// 1
struct UserController: RouteCollection {
    // 2
    func boot(router: Router) throws {
        // 3
        let usersRoute = router.grouped("api", "users")
        // 4
        usersRoute.post(User.self, use: createHandler)
        
        usersRoute.get(use: getAllHandler)
        
        usersRoute.get(User.parameter, use: getHandler)
        
        usersRoute.get(User.parameter, "acronyms", use: getAcronymsHandler)
    }
    
    // 5
    func createHandler(_ req: Request, user: User) throws -> Future<User> {
        // 6
        return user.save(on: req)
    }
    
    
    // 1
    func getAllHandler(_ req: Request) throws -> Future<[User]> {
        // 2
        return User.query(on: req).all()
    }
    
    func getHandler(_ req: Request) throws -> Future<User> {
        // 4
        return try req.parameters.next(User.self)
    }
    
    func getAcronymsHandler(_ req: Request) throws -> Future<[Acronym]> {
        return try req
            .parameters.next(User.self)
            .flatMap(to: [Acronym].self) { user in
                try user.acronyms.query(on: req).all()
        }
    }
}