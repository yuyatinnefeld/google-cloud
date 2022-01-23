import psycopg2
from psycopg2 import Error

try:
    # Connect to an existing database
    connection = psycopg2.connect(user="xxxx",
                                  password="xxxx",
                                  host="10.197.0.3",
                                  port="5432",
                                  database="private-instance-db")

    # Create a cursor to perform database operations
    cursor = connection.cursor()
    # Print PostgreSQL details
    print("PostgreSQL server information")
    print(connection.get_dsn_parameters(), "\n")
    # Executing a SQL query
    cursor.execute("SELECT version();")
    # Fetch result
    record = cursor.fetchone()
    print("You are connected to - ", record, "\n")


    create_table_query = '''SELECT table_name, column_name, data_type FROM information_schema.columns;); '''
    # Execute a command: this creates a new table
    result = cursor.execute(create_table_query)
    print(result)
    print("Table created successfully in PostgreSQL ")



except (Exception, Error) as error:
    print("Error while connecting to PostgreSQL", error)
finally:
    if (connection):
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")
