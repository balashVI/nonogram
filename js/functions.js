function dbCreatingTables(db) {
    db = LocalStorage.openDatabaseSync("nonograDB", "1.0", "Nonogram Data Base", 10000000)
    if(!db) {
        console.error("Can not open DB!")
        Qt.quit()
    }

    db.transaction(
                function(tx){
                    tx.executeSql("CREATE TABLE IF NOT EXISTS settings(property TEXT, value TEXT)")
                    var res = tx.executeSql("SELECT * FROM settings")
                    if(!res.rows.length){
                        tx.executeSql("INSERT INTO settings VALUES (\"language\", \"uk\")")
                        tx.executeSql("INSERT INTO settings VALUES (\"db_version\", \"0\")")
                    }
                    tx.executeSql("CREATE TABLE IF NOT EXISTS crosswords(crossword_id INT NOT NULL PRIMARY KEY, "+
                                  "width INT, height INT, crossword TEXT, user_crossword TEXT, progress FLOAT, "+
                                  "time INT, status INT)")
                }
                )
}
