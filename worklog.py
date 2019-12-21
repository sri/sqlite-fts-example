import sqlite3

def _quote(param):
    quoted = param.replace('"', '""')
    return f'"{quoted}"'




def search(cursor, user_input):
    safe_input = _quote(user_input)
    sql = """
      SELECT rowid, * FROM fts_worklogs
      WHERE fts_worklogs MATCH ?
    """
    cursor.execute(sql, (safe_input,))
    return cursor.fetchall()


conn = sqlite3.connect('test.db')
conn.row_factory = sqlite3.Row
cur = conn.cursor()
user_input = input('search> ')
for result in search(cur, user_input):
    print(result)
    for key in sorted(result.keys()):
        print(f"{key}={result[key]}")
