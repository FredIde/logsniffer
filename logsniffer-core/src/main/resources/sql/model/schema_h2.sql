CREATE TABLE IF NOT EXISTS
	LOG_SOURCES (
		ID BIGINT AUTO_INCREMENT PRIMARY KEY,
		NAME VARCHAR(255) NOT NULL,
		CONFIG VARCHAR
	);
CREATE INDEX IF NOT EXISTS LOG_SOURCES_NAME ON LOG_SOURCES(NAME);


CREATE TABLE IF NOT EXISTS
	SNIFFERS (
		ID BIGINT AUTO_INCREMENT PRIMARY KEY,
		NAME VARCHAR(255) NOT NULL,
		CRON_EXPR VARCHAR(50) NOT NULL,
		SOURCE 	BIGINT NOT NULL,
		SCANNER_CONFIG VARCHAR,
		READER_STRATEGY_CONFIG VARCHAR,
		PUBLISHERS_CONFIG VARCHAR
	);
CREATE INDEX IF NOT EXISTS SNIFFERS_NAME ON SNIFFERS(NAME);
CREATE INDEX IF NOT EXISTS SNIFFERS_SOURCE ON SNIFFERS(SOURCE);


CREATE TABLE IF NOT EXISTS
	SNIFFERS_SCHEDULE_INFO (
		SNIFFER	BIGINT NOT NULL,
		SCHEDULED BOOLEAN NOT NULL,
		LAST_FIRE TIMESTAMP,
		FOREIGN KEY(SNIFFER) REFERENCES SNIFFERS(ID)		
	);


CREATE TABLE IF NOT EXISTS
	SNIFFERS_SCANNER_IDATA (
		SNIFFER	BIGINT NOT NULL,
		SOURCE 	BIGINT NOT NULL,
		LOG		VARCHAR(512) NOT NULL,
		DATA	VARCHAR	NOT NULL,
		NEXT_POINTER VARCHAR NOT NULL,
		PRIMARY KEY (SNIFFER, SOURCE, LOG),
		FOREIGN KEY(SNIFFER) REFERENCES SNIFFERS(ID),
		FOREIGN KEY(SOURCE) REFERENCES LOG_SOURCES(ID)
	);
CREATE INDEX IF NOT EXISTS SNIFFERS_SCANNER_IDATA_LOG ON SNIFFERS_SCANNER_IDATA(LOG);

/** DEPRECATED **/
CREATE TABLE IF NOT EXISTS
	SNIFFERS_EVENTS (
		ID BIGINT AUTO_INCREMENT PRIMARY KEY,
		SNIFFER			BIGINT NOT NULL,
		SOURCE 			BIGINT NOT NULL,
		LOG				VARCHAR(512) NOT NULL,
		DATA			VARCHAR,
		PUBLISHED 		TIMESTAMP NOT NULL,
		/* ENTRIES			VARCHAR, */
		FOREIGN KEY(SNIFFER) REFERENCES SNIFFERS(ID),
		FOREIGN KEY(SOURCE) REFERENCES LOG_SOURCES(ID)
	);
CREATE INDEX IF NOT EXISTS SNIFFERS_EVENTS_LOG ON SNIFFERS_EVENTS(LOG);
CREATE INDEX IF NOT EXISTS SNIFFERS_EVENTS_PUBLISHED ON SNIFFERS_EVENTS(PUBLISHED);	

CREATE TABLE IF NOT EXISTS
	LOG_ENTRIES (
		ID BIGINT AUTO_INCREMENT PRIMARY KEY,
		CTX_ID			BIGINT NOT NULL,
		TMST			TIMESTAMP,
		SEVERITY		SMALLINT,
		SEVERITY_N		VARCHAR(32),
		SEVERITY_C		SMALLINT,
		OFFSET_START	VARCHAR,
		OFFSET_END		VARCHAR,
		RAW_CONTENT		VARCHAR
	);
CREATE INDEX IF NOT EXISTS LOG_ENTRIES_CTX_ID ON LOG_ENTRIES(CTX_ID);
CREATE INDEX IF NOT EXISTS LOG_ENTRIES_TMST ON LOG_ENTRIES(TMST);
CREATE INDEX IF NOT EXISTS LOG_ENTRIES_SEVERITY ON LOG_ENTRIES(SEVERITY);

	
CREATE TABLE IF NOT EXISTS
	LOG_ENTRIES_FIELDS (
		SUBJ			BIGINT NOT NULL,
		NAME			VARCHAR(32) NOT NULL,
		SEQ_NR			SMALLINT NOT NULL,
		TYPE			SMALLINT NOT NULL,
		V_STR			VARCHAR,
		V_DATE			TIMESTAMP,
		V_INT			BIGINT,
		V_FLOAT			DOUBLE,
		V_JSON			VARCHAR,
		FOREIGN KEY(SUBJ) REFERENCES LOG_ENTRIES(ID)
	);
CREATE INDEX IF NOT EXISTS LOG_ENTRIES_FIELDS_NAME ON LOG_ENTRIES_FIELDS(NAME);
CREATE INDEX IF NOT EXISTS LOG_ENTRIES_FIELDS_STR ON LOG_ENTRIES_FIELDS(V_STR);
CREATE INDEX IF NOT EXISTS LOG_ENTRIES_FIELDS_DATE ON LOG_ENTRIES_FIELDS(V_DATE);
CREATE INDEX IF NOT EXISTS LOG_ENTRIES_FIELDS_INT ON LOG_ENTRIES_FIELDS(V_INT);
CREATE INDEX IF NOT EXISTS LOG_ENTRIES_FIELDS_FLOAT ON LOG_ENTRIES_FIELDS(V_FLOAT);


-- VOS-0.5.1__AddTableUserProfileSettings.sql

CREATE TABLE IF NOT EXISTS
	USER_PROFILE_SETTINGS (
		TOKEN VARCHAR(255) NOT NULL,
		PATH VARCHAR(255) NOT NULL,
		DATA VARCHAR
	);
CREATE UNIQUE INDEX IF NOT EXISTS USER_PROFILE_SETTINGS_UNIQUE ON USER_PROFILE_SETTINGS(TOKEN, PATH);
CREATE INDEX IF NOT EXISTS USER_PROFILE_SETTINGS_TOKEN ON USER_PROFILE_SETTINGS(TOKEN);
CREATE INDEX IF NOT EXISTS USER_PROFILE_SETTINGS_PATH ON USER_PROFILE_SETTINGS(PATH);

-- VOS-0.5.4_AddSystemNotifications.sql

CREATE TABLE IF NOT EXISTS
	SYSTEM_NOTIFICATIONS (
		ID VARCHAR(255) NOT NULL PRIMARY KEY,
		NTYPE SMALLINT NOT NULL,
		TITLE VARCHAR NOT NULL,
		MESSAGE VARCHAR,
		LEVEL SMALLINT NOT NULL,
		EXPIRATION TIMESTAMP,
		CREATION TIMESTAMP NOT NULL
	);
CREATE INDEX IF NOT EXISTS SYSTEM_NOTIFICATIONS_NTYPE ON SYSTEM_NOTIFICATIONS(NTYPE);
CREATE INDEX IF NOT EXISTS SYSTEM_NOTIFICATIONS_LEVEL ON SYSTEM_NOTIFICATIONS(LEVEL);
CREATE INDEX IF NOT EXISTS SYSTEM_NOTIFICATIONS_EXPIRATION ON SYSTEM_NOTIFICATIONS(EXPIRATION);
CREATE INDEX IF NOT EXISTS SYSTEM_NOTIFICATIONS_CREATION ON SYSTEM_NOTIFICATIONS(CREATION);

CREATE TABLE IF NOT EXISTS
	SYSTEM_NOTIFICATIONS_ACKS (
		ID VARCHAR(255) NOT NULL,
		USER VARCHAR(255) NOT NULL,
		FOREIGN KEY(ID) REFERENCES SYSTEM_NOTIFICATIONS(ID)
	);
CREATE INDEX IF NOT EXISTS SYSTEM_NOTIFICATIONS_ACKS_USER ON SYSTEM_NOTIFICATIONS_ACKS(USER);