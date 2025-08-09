-- Core content tables
CREATE TABLE IF NOT EXISTS factions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    key TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS suffixes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    key TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    power INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS lore (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    key TEXT UNIQUE NOT NULL,
    text TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS ascii_art (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    key TEXT UNIQUE NOT NULL,
    art TEXT NOT NULL
);

-- Seeds (idempotent)
INSERT OR IGNORE INTO factions (key, name) VALUES
    ('imps', 'Imps'),
    ('angels', 'Angels');

INSERT OR IGNORE INTO suffixes (key, name, power) VALUES
    ('brave', 'Brave', 1),
    ('cursed', 'Cursed', -1);

INSERT OR IGNORE INTO lore (key, text) VALUES
    ('intro', 'Waking in a narrow bed in New Babylon, the city hums below.');

INSERT OR IGNORE INTO ascii_art (key, art) VALUES
    ('title', 'BD:NB');
