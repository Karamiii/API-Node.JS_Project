const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const bodyParser = require('body-parser');
const res = require("express/lib/response");

// Initialize Express app and SQLite3 database connection
const app = express();
const db = new sqlite3.Database('./database.db', sqlite3.OPEN_READWRITE, (err) => {
    if (err) return console.error(err);
});

app.use(bodyParser.json());


 // Dynamic route handler for posting data to table
 // TODO add more error handling and stuff
app.post('/post/:table', (req, res) => {
    const table = req.params.table;
    const { values } = req.body;
    const columns = Object.keys(values).join(', ');
    const placeholders = Object.keys(values).map(() => '?').join(', ');
    const query = `INSERT INTO ${table} (${columns}) VALUES (${placeholders})`;
    const data = Object.values(values);

    db.run(query, data, (err) => {
      if (err) {
        console.error(err.message);
        return res.status(500).json({
          status: 500,
          message: 'Internal Server Error',
        });
      }
      return res.status(200).json({ message: 'Data inserted successfully' });
    });
  });

/*
  // Dynamic route handler for retrieving data from a table
  // TODO add more error handling and stuff
app.get('/:table', (req, res) => {
    const table = req.params.table;
    const query = `SELECT * FROM ${table}`;
    db.all(query, [], (err, rows) => {
      if (err) {
        console.error(err.message);
        return res.status(500).json({
          status: 500,
          message: 'Internal Server Error',
        });
      }
      return res.status(200).json(rows);
    });
});
*/
// Dynamic route handler for retrieving data from a table

app.get('/get/:table', (req, res) => {
    const table = req.params.table;
    let query = `SELECT * FROM ${table}`;
    const params = Object.keys(req.query);

    if (params.length) {
      query += ' WHERE ';
      for (let i = 0; i < params.length; i++) {
        const key = params[i];
        const value = req.query[key];
        query += `${key} = "${value}"`;
        if (i < params.length - 1) {
          query += ' AND ';
        }
      }
    }

    db.all(query, [], (err, rows) => {
      if (err) {
        console.error(err.message);
        return res.status(500).json({
          status: 500,
          message: 'Internal Server Error',
        });
      }
      return res.status(200).json(rows);
    });
});


app.get('/get/:table1/:table2', (req, res) => {
    const table1 = req.params.table1;
    const table2 = req.params.table2;

    // Build query using table and column names
    let query = `SELECT * FROM ${table1} JOIN ${table2} ON ${table1}.deptno = ${table2}.deptno`;

    const params = Object.keys(req.query);
    if (params.length) {
      query += ' WHERE ';
      for (let i = 0; i < params.length; i++) {
        const key = params[i];
        const value = req.query[key];
        query += `${table2}.${key} = "${value}"`;
        if (i < params.length - 1) {
          query += ' AND ';
        }
      }
    }

    db.all(query, [], (err, rows) => {
      if (err) {
        console.error(err.message);
        return res.status(500).json({
          status: 500,
          message: 'Internal Server Error',
        });
      }
      return res.status(200).json(rows);
    });
  });


// Dynamic route handler for deleting data from a table
app.delete('/delete/:table', (req, res) => {
    const table = req.params.table;
    const { column, value } = req.body;
    const query = `DELETE FROM ${table} WHERE ${column} = ?`;
    const data = [value];

    db.run(query, data, (err) => {
      if (err) {
        console.error(err.message);
        return res.status(500).json({
          status: 500,
          message: 'Internal Server Error',
        });
      }
      return res.status(200).json({ message: 'Data deleted successfully' });
    });
  });


// Dynamic route handler for updating data in a table
app.put('/update/:table', (req, res) => {
    const table = req.params.table;
    const { column, value, update } = req.body;
    if (!column || !value || !update || Object.keys(update).length === 0) {
        return res.status(400).json({
            status: 400,
            message: 'Bad Request',
        });
    }
    const setClause = Object.keys(update).map(key => `${key} = ?`).join(', ');
    const query = `UPDATE ${table} SET ${setClause} WHERE ${column} = ?`;
    const data = [...Object.values(update), value];

    db.run(query, data, (err) => {
        if (err) {
            console.error(err.message);
            return res.status(500).json({
                status: 500,
                message: 'Internal Server Error',
            });
        }
        return res.status(200).json({ message: 'Data updated successfully' });
    });
});



// Start the server on port 8000
app.listen(8000, () => {
  console.log('Server started on port 8000');

});

