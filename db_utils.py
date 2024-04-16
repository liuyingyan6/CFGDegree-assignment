import mysql.connector
from config import HOST, USER, PASSWORD, DATABASE

class DBConnectionError(Exception):
    pass

def _connect_to_db():
    try:
        connection = mysql.connector.connect(
            host=HOST,
            user=USER,
            password=PASSWORD,
            database=DATABASE,
            auth_plugin='mysql_native_password'  # 指定使用 mysql_native_password 认证插件
        )
        return connection
    except Exception as e:
        raise DBConnectionError("Failed to connect to database") from e

def execute_query(query, values=None):
    try:
        connection = _connect_to_db()
        cursor = connection.cursor()
        if values:
            cursor.execute(query, values)
        else:
            cursor.execute(query)
        connection.commit()
        cursor.close()
        return True
    except Exception as e:
        connection.rollback()
        raise DBConnectionError("Failed to execute query") from e
    finally:
        if connection:
            connection.close()

def fetch_query(query, values=None):
    try:
        connection = _connect_to_db()
        cursor = connection.cursor(dictionary=True)
        if values:
            cursor.execute(query, values)
        else:
            cursor.execute(query)
        result = cursor.fetchall()
        cursor.close()
        return result
    except Exception as e:
        raise DBConnectionError("Failed to fetch data from database") from e
    finally:
        if connection:
            connection.close()
