# Vapor SQLcipher Demo

This is the Vapor ToDo demo that uses SQLcipher for transparent encryption of SQLite databases.

## Action

Build and run. Then add data:

```bash
% curl -H "Content-Type: application/json" \
    --request POST \
    --data '{"title": "Integrate SQLite-NIO and SQLcipher"}' \
    http://localhost:8080/todos
{"id":"24873A58-2634-41E6-A2B5-D3C65F3DD74E","title":"Integrate SQLite-NIO and SQLcipher"}
```

Vapor app's logging:

```
[ DEBUG ] Server starting on http://127.0.0.1:8080 (Vapor/HTTPServer.swift:386)
[ NOTICE ] Server started on http://127.0.0.1:8080 (Vapor/HTTPServer.swift:413)
[ INFO ] POST /todos [request-id: 6E717499-16BB-4C4E-9191-51BB7C99B799] (Vapor/RouteLoggingMiddleware.swift:14)
[ DEBUG ] Running query [action: create, database-id: sqlite, input: [[id: 24873A58-2634-41E6-A2B5-D3C65F3DD74E, title: "Integrate SQLite-NIO and SQLcipher"]], request-id: 6E717499-16BB-4C4E-9191-51BB7C99B799, schema: todos] (FluentKit/QueryBuilder.swift:335)
[ DEBUG ] Executing query [binds: [24873A58-2634-41E6-A2B5-D3C65F3DD74E, Integrate SQLite-NIO and SQLcipher], database-id: sqlite, request-id: 6E717499-16BB-4C4E-9191-51BB7C99B799, sql: INSERT INTO "todos" ("id", "title") VALUES (?1, ?2) RETURNING "id"] (SQLiteKit/SQLiteConnection+SQLKit.swift:221)
```

Check the database:

```bash
% sqlite3 db.sqlcipher
SQLite version 3.43.2 2023-10-10 13:08:14
Enter ".help" for usage hints.
sqlite> .tables
Error: file is not a database
sqlite> ^D

% sqlcipher db.sqlcipher
SQLite version 3.45.3 2024-04-15 13:34:05 (SQLCipher 4.6.0 community)
Enter ".help" for usage hints.
sqlite> .tables
Error: file is not a database
sqlite> pragma key = 'seKret123';
ok
sqlite> .tables
_fluent_migrations  todos             
sqlite> .mode box
sqlite> select * from todos;
┌──────────────────────────────────────┬────────────────────────────────────┐
│                  id                  │               title                │
├──────────────────────────────────────┼────────────────────────────────────┤
│ 24873A58-2634-41E6-A2B5-D3C65F3DD74E │ Integrate SQLite-NIO and SQLcipher │
└──────────────────────────────────────┴────────────────────────────────────┘
sqlite> 
```

