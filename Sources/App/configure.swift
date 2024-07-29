import NIOSSL
import Fluent
import FluentSQLiteDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.views.use(.leaf)

    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlcipher")), as: .sqlite)
    // Source: https://discord.com/channels/431917998102675485/684159753189982218/1240372868336975973
    for eventLoop in app.eventLoopGroup.makeIterator() {
        try await app.databases.database(logger: app.logger, on: eventLoop)?.withConnection { conn in
            try await (conn as! SQLDatabase).raw("PRAGMA key = 'seKret123'").run()
        }
    }

    app.migrations.add(CreateTodo())
    try await app.autoMigrate().get()

    try routes(app)
}
