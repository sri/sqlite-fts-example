-- create table note_types (
--   id integer not null primary key,
--   note_type text not null
-- )

-- insert into note_types(note_type) values('code')
-- insert into note_types(note_type) values('text')

CREATE TABLE worklogs (
  id INTEGER NOT NULL PRIMARY KEY,

  note TEXT NOT NULL,
  note_type TEXT NOT NULL,
  workdate TEXT NOT NULL,

  created_at DATETIME NOT NULL DEFAULT current_timestamp,
  updated_at DATETIME NOT NULL DEFAULT current_timestamp,

  parent_id INTEGER,
  FOREIGN KEY(parent_id) REFERENCES worklogs(id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

CREATE UNIQUE INDEX idx_worklogs_workdate ON worklogs(workdate);

CREATE VIRTUAL TABLE fts_worklogs USING FTS5(note, workdate, content='worklogs', content_rowid='id');
CREATE TRIGGER trigger_worklogs_ai AFTER INSERT ON worklogs BEGIN
  INSERT INTO fts_worklogs(rowid, note, workdate) VALUES(new.id, new.note, new.workdate);
end;
CREATE TRIGGER trigger_worklogs_ad AFTER DELETE ON worklogs BEGIN
  INSERT INTO fts_worklogs(fts_worklogs, rowid, note, workdate) VALUES('delete', old.id, old.note, old.workdate);
end;
CREATE TRIGGER trigger_worklogs_au after UPDATE ON worklogs BEGIN
  INSERT INTO fts_worklogs(fts_worklogs, rowid, note, workdate) VALUES('delete', old.id, old.note, old.workdate);
  INSERT INTO fts_worklogs(rowid, note, workdate) VALUES (new.id, new.note, new.workdate);
end;


-- create table todos {
  -- id integer not null primary key,


  -- created_at datetime,
  -- updated_at datetime,
-- }
