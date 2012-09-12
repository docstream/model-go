-- LESMEG:
-- Dette er en SQL SCHEMA FIL SOM
-- bruker spesial-kommentater for å 
-- i tillegg generere .go kode
--
-- IKKE ROT I KOMMENTARFELTENE ! ! ! ! !
--
--
--
--
-- ok ?





-- PRAGMA stmt below should be set on 'open' in sqlite3

PRAGMA foreign_keys=ON;


-- AUTHZ-stuff not needed since route.id field is a 
-- jolly fine FK for external systems


-- allowed-ops: GET PUT 
CREATE TABLE routes (

    -- Main struct
    -- DELETE not allowed
    -- UPDATE allowed (but never id!)

    id TEXT,                            -- xml:",attr" PK. The path appended to server-uri
                                        -- Must start w slash (/), cannot end in one,
                                        -- unless it is the same as starting slash ^o^
	sort_index INTEGER DEFAULT 0,		-- xml:",attr" 
    --impl_repo INTEGER DEFAULT 0,   When multiple 'impl' dirs is to be joined. NO THX!
    src TEXT DEFAULT NULL,              -- Rel-path to ebook git-repo, 
                                        -- NULL here is the same as type 'collection'

    disabled TINYINT DEFAULT FALSE,     -- Disabled = 1/0
    http_code INTEGER DEFAULT NULL,     -- If disabled=1, set a code here. 301/307/404/410
    redir_to_id TEXT DEFAULT NULL,       -- Optional. If route is disabled we should use redirect
    partial_redir TINYINT DEFAULT NULL,  -- Optional. If 1 'full-chunk-path' must be appended


	-- Always use tblname in "has_many-comment"s
	-- has_many :names
	-- has_many :meta_values

	PRIMARY KEY(id) ASC
);
 

-- allowed-ops: GET PUT DELETE
CREATE TABLE names (

    -- Multi lang support. i18n 
    -- routes >one2many> names

    route_id TEXT NOT NULL,            -- {FK} , will not be exported (LCase'd firstletter)
    lang TEXT NOT NULL,                -- xml:",attr" aka code, FK
    name TEXT NOT NULL,                -- Name
    tooltip TEXT,                      -- Tooltip optional

    PRIMARY KEY(route_id,lang),
    FOREIGN KEY(route_id) REFERENCES routes(id),
    FOREIGN KEY(lang) REFERENCES lang_codes(code)

	-- no need to bother w has_many: here 
);


-- allowed-ops: GET PUT DELETE
CREATE TABLE lang_codes (

    -- Iso stuff, static 

    code TEXT PRIMARY KEY,         -- no/sv/da/en/es etc.
    desc TEXT DEFAULT NULL         -- Description
);


-- allowed-ops: GET PUT DELETE 
CREATE TABLE meta_values ( 
    
    -- Store all sort of crazy 'impl' logic here
    -- Eg. adv-search & pub_date
    -- routes >one2many> metadata

    route_id TEXT NOT NULL,    -- {FK}
    key TEXT NOT NULL,         -- xml:",attr" KEY
    value TEXT,                -- VALUE

    PRIMARY KEY(route_id,key),
    FOREIGN KEY(route_id) REFERENCES routes(id)
);

-- allowed-ops: GET POST
CREATE TABLE pub_setups (

    -- Publications_setup for each route+dest
    -- Works also as log
    -- INSERT ony
    -- Both UPDATE and DELETE is denied
    -- routes >one2many> pub_setups


    route_id TEXT NOT NULL,             -- {FK}
    dest INTEGER NOT NULL,              -- Corresponds to a 'dest' used in '(globals)_d3g.conf' 
    tag TEXT DEFAULT 'HEAD',            -- git tag.  BLANK = DEAKTIVERING
    branch TEXT DEFAULT 'master',       -- git branch. BLANK = DEAKTIVERING

    created DATETIME NOT NULL,          -- XML syntax datetime. TODO: autogen, expr
    user TEXT NOT NULL,                 -- LDAP user. Not same as in git-log
    comment TEXT,                       -- Info from user.
   
    -- PRIMARY KEY(route_id,dest,tag,branch,created),
    FOREIGN KEY(route_id) REFERENCES routes(id)
);
