# SQLite Quick Reference

## Basic Commands
- List tables: `.tables`
- Show table schema: `.schema table_name`
- Exit SQLite: `.quit`

## Query Data
- Select data: `SELECT * FROM table_name LIMIT 5;`
- Count rows: `SELECT COUNT(*) FROM table_name;`

## Modify Data
- Insert row: `INSERT INTO table_name (column1, column2) VALUES (value1, value2);`
- Update row: `UPDATE table_name SET column1 = value1 WHERE condition;`
- Delete row: `DELETE FROM table_name WHERE condition;`

## Table Operations
- Create table: `CREATE TABLE table_name (column1 datatype, column2 datatype);`
- Drop table: `DROP TABLE IF EXISTS table_name;`

## Display Options
- Show headers: `.headers on`
- Column mode: `.mode column`

## File Operations
- Open database: `sqlite3 database_file.db`
- Run SQL file: `.read filename.sql`

## Practice Session

1. Open SQLite with a new database:
   ```
   sqlite3 practice.db
   ```

2. Create a sample table:
   ```sql
   CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, age INTEGER);
   ```

3. Insert some data:
   ```sql
   INSERT INTO users (name, age) VALUES ('Alice', 30);
   INSERT INTO users (name, age) VALUES ('Bob', 25);
   INSERT INTO users (name, age) VALUES ('Charlie', 35);
   ```

4. Query the data:
   ```sql
   SELECT * FROM users;
   ```

5. Update a record:
   ```sql
   UPDATE users SET age = 31 WHERE name = 'Alice';
   ```

6. Delete a record:
   ```sql
   DELETE FROM users WHERE name = 'Bob';
   ```

7. Count the remaining records:
   ```sql
   SELECT COUNT(*) FROM users;
   ```

8. Drop the table:
   ```sql
   DROP TABLE users;
   ```

9. Exit SQLite:
   ```
   .quit
   ```
