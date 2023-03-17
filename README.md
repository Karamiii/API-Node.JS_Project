# Node.js/SQL API Project

This project is a Node.js/SQL API that allows users to perform CRUD (Create, Read, Update, Delete) operations on a database. It provides endpoints for querying, adding, updating, and deleting data from the database. It's built using Node.js and SQL, and utilizes the Express.js framework for handling HTTP requests and responses.

## Who dis dude

- Karam Chafqane

## Date

- 2023-03-18

## Setup

1. Clone the repository:
`git clone git@github.com:Karamiii/API-Node.JS_Project.git` (ssh)

`git clone https://github.com/Karamiii/API-Node.JS_Project.git` (http)

2. Install the required dependencies by running
`npm install`
in the project directory.

3. Create the database file with example data in the tables:

`sqlite3 database.db < sql/create.sql`

This will add example data to the tables.

If you only want empty tables with no data in them, you can use:

`sqlite3 database.db < sql/delete.sql`
after creating the database to empty the tables.

4. Start the server with:

`node app.js` or `npm start`

The server will start and use port 8000 as the deafult port.


## Usage

You can make queries to the API using for example Postman or the terminal. Here are the methods that you can use:

GET: Use this method to retrieve data from the API.
POST: Use this method to add data to the API.
PUT: Use this method to update existing data in the API.
DELETE: Use this method to delete data from the API.

To make a query using Postman, open the app and enter the API endpoint URL in the address bar. Select the method that you want to use from the dropdown menu next to the address bar, and then click the "Send" button to make the query.

To make a query using the terminal, use a tool such as cURL or HTTPie. For example, to make a GET request using cURL, enter the following command:

`curl http://localhost:8000/get/emp`

This will retrieve all of the employee data from the API. You can replace "emp" with the name of another table to retrieve data from a different table.

Note: The specific commands and steps for making queries may vary depending on your setup and tools used.

## Checking tables and contents with sqlite3

Open your terminal or command prompt and navigate to the directory where your database file is located.
Type the following command to start sqlite3:

`sqlite3 database.db`

Once you have started sqlite3, you can view a list of all the tables in your database with:

`.tables`

This will display a list of all the tables in your database.

To view the contents of a table, you can use:
`SELECT * FROM table_name;`

where table_name is the name of the table you want to view. This will display all the data in the table.

To exit sqlite3:

`.exit`


