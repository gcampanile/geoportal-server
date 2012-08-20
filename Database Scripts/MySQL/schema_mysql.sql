-- See the NOTICE file distributed with
-- this work for additional information regarding copyright ownership.
-- Esri Inc. licenses this file to You under the Apache License, Version 2.0
-- (the "License"); you may not use this file except in compliance with
-- the License.  You may obtain a copy of the License at
-- 
--      http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

CREATE TABLE GPT_USER ( 
  USERID INT(32) NOT NULL AUTO_INCREMENT,
  DN VARCHAR(900),
  USERNAME VARCHAR(64),
  CONSTRAINT GPT_USER_PK PRIMARY KEY (USERID)
);

CREATE INDEX GPT_USER_IDX1 ON GPT_USER(DN);
CREATE INDEX GPT_USER_IDX2 ON GPT_USER(USERNAME);

CREATE TABLE GPT_SEARCH (
  UUID VARCHAR(38) NOT NULL,
  NAME VARCHAR (255),
  USERID INT(32),
  CRITERIA LONGTEXT,
  CONSTRAINT GPT_SEARCH_PK PRIMARY KEY (UUID)
);

CREATE INDEX GPT_SEARCH_IDX1 ON GPT_SEARCH(USERID);


CREATE TABLE GPT_HARVESTING_JOBS_PENDING (
  UUID VARCHAR (38) NOT NULL,
  HARVEST_ID VARCHAR (38) NOT NULL,
  INPUT_DATE DATETIME, 
  HARVEST_DATE DATETIME,  
  JOB_STATUS VARCHAR (10),
  JOB_TYPE VARCHAR (10),
  CRITERIA VARCHAR(1024) NULL,
  SERVICE_ID VARCHAR (128),
  CONSTRAINT GPT_HARVJOBSPNDG_PK PRIMARY KEY (HARVEST_ID)
);

DELIMITER $
CREATE TRIGGER `GPT_HARVESTING_JOBS_PENDING_INSERT` BEFORE INSERT ON `GPT_HARVESTING_JOBS_PENDING`
FOR EACH ROW 
BEGIN 
  SET NEW.INPUT_DATE = NOW();
  SET NEW.HARVEST_DATE = NOW();
END $
DELIMITER ;

CREATE TRIGGER `GPT_HARVESTING_JOBS_PENDING_UPDATE` BEFORE UPDATE ON `GPT_HARVESTING_JOBS_PENDING`
FOR EACH ROW SET NEW.HARVEST_DATE = NOW() ;

CREATE INDEX GPT_HJOBSPNDG_IDX1 ON GPT_HARVESTING_JOBS_PENDING(UUID);
CREATE INDEX GPT_HJOBSPNDG_IDX2 ON GPT_HARVESTING_JOBS_PENDING(HARVEST_DATE);
CREATE INDEX GPT_HJOBSPNDG_IDX3 ON GPT_HARVESTING_JOBS_PENDING(INPUT_DATE);
CREATE INDEX GPT_HJOBSPNDG_IDX4 ON GPT_HARVESTING_JOBS_PENDING(JOB_STATUS);


CREATE TABLE GPT_HARVESTING_JOBS_COMPLETED (
  UUID VARCHAR (38) NOT NULL,
  HARVEST_ID VARCHAR (38) NOT NULL,
  INPUT_DATE DATETIME, 
  HARVEST_DATE DATETIME, 
  JOB_TYPE VARCHAR (10),
  SERVICE_ID VARCHAR (128),
  CONSTRAINT GPT_HARVJOBSCMPLTD_PK PRIMARY KEY (UUID)
);

DELIMITER $
CREATE TRIGGER `GPT_HARVESTING_JOBS_COMPLETED_INSERT` BEFORE INSERT ON `GPT_HARVESTING_JOBS_COMPLETED`
FOR EACH ROW 
BEGIN
  SET NEW.INPUT_DATE = NOW();
  SET NEW.HARVEST_DATE = NOW();
END $
DELIMITER ;

CREATE TRIGGER `GPT_HARVESTING_JOBS_COMPLETED_UPDATE` BEFORE UPDATE ON `GPT_HARVESTING_JOBS_COMPLETED`
FOR EACH ROW SET NEW.HARVEST_DATE = NOW() ;

CREATE INDEX GPT_HJOBSCMPLTD_IDX1 ON GPT_HARVESTING_JOBS_COMPLETED(HARVEST_ID);


CREATE TABLE GPT_HARVESTING_HISTORY (
  UUID VARCHAR (38) NOT NULL,
  HARVEST_ID VARCHAR (38) NOT NULL,
  HARVEST_DATE DATETIME, 
  HARVESTED_COUNT INT DEFAULT 0,
  VALIDATED_COUNT INT DEFAULT 0,
  PUBLISHED_COUNT INT DEFAULT 0,
  HARVEST_REPORT LONGTEXT,
  CONSTRAINT GPT_HARVHIST_PK PRIMARY KEY (UUID)
);

CREATE TRIGGER `GPT_HARVESTING_HISTORY_INSERT` BEFORE INSERT ON `GPT_HARVESTING_HISTORY`
FOR EACH ROW SET NEW.HARVEST_DATE = NOW() ;


CREATE TABLE GPT_RESOURCE (  
  DOCUUID VARCHAR(38) NOT NULL,
  TITLE VARCHAR(4000),
  OWNER INT NOT NULL,
  INPUTDATE DATETIME,
  UPDATEDATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ID INT(32) UNIQUE NOT NULL AUTO_INCREMENT,
  APPROVALSTATUS VARCHAR(64),
  PUBMETHOD VARCHAR(64),
  SITEUUID VARCHAR(38),
  SOURCEURI VARCHAR(4000),
  FILEIDENTIFIER VARCHAR(4000),
  ACL VARCHAR(4000),
  HOST_URL VARCHAR(255), 
  PROTOCOL_TYPE VARCHAR(20), 
  PROTOCOL VARCHAR(1000),
  FREQUENCY VARCHAR(10),
  SEND_NOTIFICATION   VARCHAR(10),
  FINDABLE            VARCHAR(6),
  SEARCHABLE          VARCHAR(6),
  SYNCHRONIZABLE      VARCHAR(6),
  LASTSYNCDATE        DATETIME,
  CONSTRAINT GPT_RESOURCE_PK PRIMARY KEY (DOCUUID)
);

DELIMITER $
CREATE TRIGGER `GPT_RESOURCE_INSERT` BEFORE INSERT ON `GPT_RESOURCE`
FOR EACH ROW 
BEGIN
  SET NEW.INPUTDATE = NOW();
END $
DELIMITER ;

CREATE INDEX GPT_RESOURCE_IDX1  ON GPT_RESOURCE(SITEUUID);
CREATE INDEX GPT_RESOURCE_IDX2  ON GPT_RESOURCE(FILEIDENTIFIER);
CREATE INDEX GPT_RESOURCE_IDX3  ON GPT_RESOURCE(SOURCEURI);
CREATE INDEX GPT_RESOURCE_IDX4  ON GPT_RESOURCE(UPDATEDATE);
CREATE INDEX GPT_RESOURCE_IDX5  ON GPT_RESOURCE(TITLE);
CREATE INDEX GPT_RESOURCE_IDX6  ON GPT_RESOURCE(OWNER);
CREATE INDEX GPT_RESOURCE_IDX8  ON GPT_RESOURCE(APPROVALSTATUS);
CREATE INDEX GPT_RESOURCE_IDX9  ON GPT_RESOURCE(PUBMETHOD);
CREATE INDEX GPT_RESOURCE_IDX11 ON GPT_RESOURCE(ACL);
CREATE INDEX GPT_RESOURCE_IDX12 ON GPT_RESOURCE(PROTOCOL_TYPE);
CREATE INDEX GPT_RESOURCE_IDX13 ON GPT_RESOURCE(LASTSYNCDATE);


CREATE TABLE GPT_RESOURCE_DATA (
  DOCUUID    VARCHAR(38) NOT NULL,
  ID         INT(32) UNIQUE NOT NULL,
  XML        LONGTEXT,
  THUMBNAIL  LONGBLOB,
  CONSTRAINT GPT_RESOURCE_DATA_PK PRIMARY KEY (DOCUUID)
);

CREATE INDEX GPT_RESOURCE_DATA_IDX1  ON GPT_RESOURCE_DATA(ID);

CREATE TABLE GPT_COLLECTION (
  COLUUID    VARCHAR(38) NOT NULL,
  SHORTNAME  VARCHAR(128) UNIQUE NOT NULL,
  CONSTRAINT GPT_COLLECTION_PK PRIMARY KEY (COLUUID)
);
CREATE INDEX GPT_COLLECTION_IDX1 ON GPT_COLLECTION(SHORTNAME);

CREATE TABLE GPT_COLLECTION_MEMBER (
    DOCUUID VARCHAR(38) NOT NULL,
    COLUUID VARCHAR(38) NOT NULL
);
CREATE INDEX GPT_COLL_MEMBER_IDX1 ON GPT_COLLECTION_MEMBER(DOCUUID);
CREATE INDEX GPT_COLL_MEMBER_IDX2 ON GPT_COLLECTION_MEMBER(COLUUID);
    
