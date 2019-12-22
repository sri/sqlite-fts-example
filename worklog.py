from flask import Flask, escape, request, render_template

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

def getall(cursor):
    sql = """
      select * from worklogs
      order by workdate desc
    """
    cursor.execute(sql)
    return cursor.fetchall()

conn = sqlite3.connect('test.db', check_same_thread=False)
conn.row_factory = sqlite3.Row
cur = conn.cursor()



# user_input = input('search> ')
# for result in search(cur, user_input):
#     print(result)
#     for key in sorted(result.keys()):
#         print(f"{key}={result[key]}")


app = Flask(
    __name__,
    template_folder="app/templates",
)

@app.route('/')
def hello():
    all = getall(cur)
    return render_template('index.html', worklogs=all)
