CREATE TABLE dbresprod.dbo.SEL_UNITS(
	unitGUID UNIQUEIDENTIFIER NOT NULL,
	unitID INT NOT NULL,
	unitName NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_SEL_UNITS PRIMARY KEY (unitGUID)
);

CREATE TABLE dbresprod.dbo.SEL_MODES(
	modeGUID UNIQUEIDENTIFIER NOT NULL,
	modeID INT NOT NULL,
	modeName NVARCHAR(20) NULL,
	CONSTRAINT PK_SEL_MODES PRIMARY KEY (modeGUID)
);

CREATE TABLE dbresprod.dbo.SEL_STATUSES(
	statusGUID UNIQUEIDENTIFIER NOT NULL,
	statusID INT NOT NULL,
	statusName NVARCHAR(20) NULL,
	CONSTRAINT PK_SEL_STATUSES PRIMARY KEY (statusGUID)
);

CREATE TABLE dbresprod.dbo.SEL_TYPES(
	typeGUID UNIQUEIDENTIFIER NOT NULL,
	typeID INT NOT NULL,
	typeName NVARCHAR(20) NULL,
	CONSTRAINT PK_SEL_TYPES PRIMARY KEY (typeGUID)
);

CREATE TABLE dbresprod.dbo.SEL_MEASURE_UNITS(
	mUnitGUID UNIQUEIDENTIFIER NOT NULL,
	mUnitName NVARCHAR(20) NOT NULL,
	CONSTRAINT PK_SEL_MEASURE_UNITS PRIMARY KEY (mUnitGUID)
);

CREATE TABLE dbresprod.dbo.SEL_SENSORS(
	sensorGUID UNIQUEIDENTIFIER NOT NULL,
	sensorName NVARCHAR(20) NOT NULL,
	CONSTRAINT PK_SEL_SENSORS PRIMARY KEY (sensorGUID)
);

CREATE TABLE dbresprod.dbo.SEL_OUTPUTS(
	outputGUID UNIQUEIDENTIFIER NOT NULL,
	unitGUID UNIQUEIDENTIFIER NOT NULL,
	modeGUID UNIQUEIDENTIFIER NOT NULL,
	statusGUID UNIQUEIDENTIFIER NOT NULL,
	outputID INT NOT NULL,
	outputName NVARCHAR(50) NOT NULL,
	highState NVARCHAR(5) NOT NULL,
	lowState NVARCHAR(5) NOT NULL,
	CONSTRAINT PK_SEL_OUTPUTS PRIMARY KEY (outputGUID),
	CONSTRAINT FK_SEL_OUTPUTS_SEL_UNITS FOREIGN KEY (unitGUID)
	REFERENCES dbresprod.dbo.SEL_UNITS (unitGUID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_SEL_OUTPUTS_SEL_MODES FOREIGN KEY (modeGUID)
	REFERENCES dbresprod.dbo.SEL_MODES (modeGUID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_SEL_OUTPUTS_SEL_STATUSES FOREIGN KEY (statusGUID)
	REFERENCES dbresprod.dbo.SEL_STATUSES (statusGUID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE dbresprod.dbo.SEL_REQUESTS(
	requestGUID UNIQUEIDENTIFIER NOT NULL,
	unitGUID UNIQUEIDENTIFIER NOT NULL,
	modeGUID UNIQUEIDENTIFIER NOT NULL,
	success BIT NOT NULL,
	requestMessage NVARCHAR(35) NOT NULL,
	requestNow DATETIME NOT NULL,
	requestName NVARCHAR(50) NOT NULL,
	tz NVARCHAR(25) NOT NULL,
	updateCycle INT NOT NULL,
	CONSTRAINT PK_SEL_REQUESTS PRIMARY KEY (requestGUID),
	CONSTRAINT FK_SEL_REQUESTS_SEL_UNITS FOREIGN KEY (unitGUID)
	REFERENCES dbresprod.dbo.SEL_UNITS (unitGUID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_SEL_REQUESTS_SEL_MODES FOREIGN KEY (modeGUID)
	REFERENCES dbresprod.dbo.SEL_MODES (modeGUID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE dbresprod.dbo.SEL_ALARMS(
	alarmGUID UNIQUEIDENTIFIER NOT NULL,
	unitGUID UNIQUEIDENTIFIER NOT NULL,
	typeGUID UNIQUEIDENTIFIER NOT NULL,
	statusGUID UNIQUEIDENTIFIER NOT NULL,
	mUnitGUID UNIQUEIDENTIFIER NOT NULL,
	alarmID INT NOT NULL,
	alarmName NVARCHAR(50) NOT NULL,
	healthyName NVARCHAR(10) NULL,
	faultyName NVARCHAR(10) NULL,
	pulseTotal FLOAT NOT NULL,
	CONSTRAINT PK_SEL_ALARMS PRIMARY KEY (alarmGUID),
	CONSTRAINT FK_SEL_ALARMS_SEL_UNITS FOREIGN KEY (unitGUID)
	REFERENCES dbresprod.dbo.SEL_UNITS (unitGUID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_SEL_ALARMS_SEL_TYPES FOREIGN KEY (typeGUID)
	REFERENCES dbresprod.dbo.SEL_TYPES (typeGUID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_SEL_ALARMS_SEL_STATUSES FOREIGN KEY (statusGUID)
	REFERENCES dbresprod.dbo.SEL_STATUSES (statusGUID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_SEL_ALARMS_SEL_MEASURE_UNITS FOREIGN KEY (mUnitGUID)
	REFERENCES dbresprod.dbo.SEL_MEASURE_UNITS (mUnitGUID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE dbresprod.dbo.SEL_READINGS(
	readingGUID UNIQUEIDENTIFIER NOT NULL,
	unitGUID UNIQUEIDENTIFIER NOT NULL,
	mUnitGUID UNIQUEIDENTIFIER NOT NULL,
	sensorGUID UNIQUEIDENTIFIER NOT NULL,
	analogID INT NOT NULL, 
	readingValue NVARCHAR(10) NOT NULL,
	recharge INT NOT NULL,
	cyclePulses FLOAT NOT NULL,
	readingStart FLOAT NOT NULL, 
	readingStop FLOAT,
	dp INT NOT NULL,
	CONSTRAINT PK_SEL_READINGS PRIMARY KEY (readingGUID),
	CONSTRAINT FK_SEL_READINGS_SEL_UNITS FOREIGN KEY (unitGUID)
	REFERENCES dbresprod.dbo.SEL_UNITS (unitGUID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_SEL_READINGS_SEL_MEASURE_UNITS FOREIGN KEY (mUnitGUID)
	REFERENCES dbresprod.dbo.SEL_MEASURE_UNITS (mUnitGUID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FK_SEL_READINGS_SEL_SENSORS FOREIGN KEY (sensorGUID)
	REFERENCES dbresprod.dbo.SEL_SENSORS (sensorGUID)
	ON DELETE CASCADE
	ON UPDATE CASCADE	
);

CREATE TABLE dbresprod.dbo.SEL_UPDATES(
	requestGUID UNIQUEIDENTIFIER NULL,
	alarmGUID UNIQUEIDENTIFIER NULL,
	readingGUID UNIQUEIDENTIFIER NULL,
	outputGUID UNIQUEIDENTIFIER NULL,
	lastUpdate DATETIME NOT NULL,
	CONSTRAINT PFK_SEL_UPDATES_REQUEST FOREIGN KEY (requestGUID)
		REFERENCES dbresprod.dbo.SEL_REQUESTS (requestGUID)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT PFK_SEL_UPDATES_ALARM FOREIGN KEY (alarmGUID)
		REFERENCES dbresprod.dbo.SEL_ALARMS (alarmGUID)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT PFK_SEL_UPDATES_READING FOREIGN KEY (readingGUID)
		REFERENCES dbresprod.dbo.SEL_READINGS (readingGUID)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT PFK_SEL_UPDATES_OUTPUT FOREIGN KEY (outputGUID)
		REFERENCES dbresprod.dbo.SEL_OUTPUTS (outputGUID)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
);

GO