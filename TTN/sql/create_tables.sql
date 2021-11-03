CREATE TABLE dbresprod.dbo.TTN_APPLICATIONS(
	application_guid UNIQUEIDENTIFIER NOT NULL,
	application_name NVARCHAR(35) NOT NULL,
	CONSTRAINT PK_TTN_APPLICATIONS PRIMARY KEY (application_guid)
);

CREATE TABLE dbresprod.dbo.TTN_WARNINGS(
	warning_guid UNIQUEIDENTIFIER NOT NULL,
	decoded_payload_warning NVARCHAR(MAX) NULL,
	CONSTRAINT PK_TTN_WARNINGS PRIMARY KEY (warning_guid)
);

CREATE TABLE dbresprod.dbo.TTN_LOCATIONS(
	location_guid UNIQUEIDENTIFIER NOT NULL, 
	latitude FLOAT NOT NULL,
	longitude FLOAT NOT NULL,
	source NVARCHAR(100) NULL,
	CONSTRAINT PK_TTN_LOCATIONS PRIMARY KEY (location_guid)
);

CREATE TABLE dbresprod.dbo.TTN_GATEWAYS(
	gateway_guid UNIQUEIDENTIFIER NOT NULL,
	location_guid UNIQUEIDENTIFIER NOT NULL,
	gateway_name NVARCHAR(30) NOT NULL,
	CONSTRAINT PK_TTN_GATEWAYS PRIMARY KEY (gateway_guid),
	CONSTRAINT FK_TTN_GATEWAYS_TTN_LOCATIONS FOREIGN KEY (location_guid)
		REFERENCES dbresprod.dbo.TTN_LOCATIONS (location_guid)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE dbresprod.dbo.TTN_SENSORS(
	sensor_guid UNIQUEIDENTIFIER NOT NULL,
	sensor_name NVARCHAR(30) NULL,
	sensor_type NVARCHAR(15) NULL,
	sensor_location NVARCHAR(30) NULL,
	measurement_unit NVARCHAR(5) NULL,
	CONSTRAINT PK_TTN_SENSORS PRIMARY KEY (sensor_guid)
);

CREATE TABLE dbresprod.dbo.TTN_DEVICES(
	device_guid UNIQUEIDENTIFIER NOT NULL,
	application_guid UNIQUEIDENTIFIER NOT NULL,
	device_name NVARCHAR(100) NOT NULL,
	device_location NVARCHAR(30) NULL,
	dev_eui NVARCHAR(30) NULL,
	join_eui NVARCHAR(30) NULL,
	dev_addr NVARCHAR(15) NULL,
	CONSTRAINT PK_TTN_DEVICES PRIMARY KEY (device_guid),
	CONSTRAINT FK_TTN_DEVICES_TTN_APPLICATIONS FOREIGN KEY (application_guid)
		REFERENCES dbresprod.dbo.TTN_APPLICATIONS (application_guid)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE dbresprod.dbo.TTN_UPLINKS(
	uplink_guid UNIQUEIDENTIFIER NOT NULL,
	device_guid UNIQUEIDENTIFIER NOT NULL,
	warning_guid UNIQUEIDENTIFIER NULL,
	session_key_id NVARCHAR(40) NOT NULL,
	f_port INT NOT NULL,
	f_cnt INT NOT NULL,
	frm_payload NVARCHAR(50) NOT NULL,
	raw_bytes NVARCHAR(50) NOT NULL,
	consumed_airtime FLOAT NOT NULL,
	CONSTRAINT PK_TTN_UPLINKS PRIMARY KEY (uplink_guid),
	CONSTRAINT FK_TTN_UPLINKS_TTN_DEVICES FOREIGN KEY (device_guid)
		REFERENCES dbresprod.dbo.TTN_DEVICES (device_guid)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT FK_TTN_UPLINKS_TTN_WARNINGS FOREIGN KEY (warning_guid)
		REFERENCES dbresprod.dbo.TTN_WARNINGS (warning_guid)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE dbresprod.dbo.TTN_RX(
	rx_guid UNIQUEIDENTIFIER NOT NULL, 
	gateway_guid UNIQUEIDENTIFIER NOT NULL,
	uplink_guid UNIQUEIDENTIFIER NOT NULL,
	rx_time DATETIME NOT NULL,
	rx_timestamp INT NOT NULL,
	rssi INT NOT NULL,
	channel_rssi INT NOT NULL,
	snr FLOAT NOT NULL,
	message_id NVARCHAR(30) NULL,
	forwarder_net_id INT NULL, 
	forwarder_tenant_id NVARCHAR(8) NULL,
	forwarder_cluster_id NVARCHAR(15) NULL,
	home_network_net_id INT NULL,
	home_network_tenant_id NVARCHAR(8) NULL,
	home_network_cluster_id NVARCHAR(12) NULL,
	CONSTRAINT PK_TTN_RX PRIMARY KEY (rx_guid),
	CONSTRAINT FK_TTN_RX_TTN_GATEWAY FOREIGN KEY (gateway_guid)
		REFERENCES dbresprod.dbo.TTN_GATEWAYS (gateway_guid)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT FK_TTN_RX_TTN_UPLINKS FOREIGN KEY (uplink_guid)
		REFERENCES dbresprod.dbo.TTN_UPLINKS (uplink_guid)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE dbresprod.dbo.TTN_HOPS(
	hop_guid UNIQUEIDENTIFIER NOT NULL,
	rx_guid UNIQUEIDENTIFIER NOT NULL,
	sender_address NVARCHAR(15) NOT NULL,
	receiver_name NVARCHAR(40) NOT NULL,
	receiver_agent NVARCHAR(40) NOT NULL,
	CONSTRAINT PK_TTN_HOPS PRIMARY KEY (hop_guid),
	CONSTRAINT FK_TTN_HOPS_TTN_RX FOREIGN KEY (rx_guid)
		REFERENCES dbresprod.dbo.TTN_RX (rx_guid)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE dbresprod.dbo.TTN_DATETIMES(
	rx_guid UNIQUEIDENTIFIER NULL,
	hop_guid UNIQUEIDENTIFIER NULL,
	uplink_guid UNIQUEIDENTIFIER NULL,
	received_at DATETIME NOT NULL,
	CONSTRAINT PFK_TTN_DATETIMES_RX FOREIGN KEY (rx_guid)
		REFERENCES dbresprod.dbo.TTN_RX (rx_guid)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT PFK_TTN_DATETIMES_HOP FOREIGN KEY (hop_guid)
		REFERENCES dbresprod.dbo.TTN_HOPS (hop_guid)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT PFK_TTN_DATETIMES_UPLINK FOREIGN KEY (uplink_guid)
		REFERENCES dbresprod.dbo.TTN_UPLINKS (uplink_guid)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
);

CREATE TABLE dbresprod.dbo.TTN_CORRELATION_IDS(
	correlation_guid UNIQUEIDENTIFIER NOT NULL,
	rx_guid UNIQUEIDENTIFIER NOT NULL,
	correlation_id NVARCHAR(MAX) NOT NULL,
	CONSTRAINT PK_TTN_CORRELATION_IDS PRIMARY KEY (correlation_guid),
	CONSTRAINT FK_TTN_CORRELATION_IDS_TTN_RX FOREIGN KEY (rx_guid)
		REFERENCES dbresprod.dbo.TTN_RX (rx_guid)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE dbresprod.dbo.TTN_UPLINK_TOKENS(
	rx_guid UNIQUEIDENTIFIER NOT NULL,
	gateway_guid UNIQUEIDENTIFIER NOT NULL,
	uplink_token NVARCHAR(MAX) NOT NULL,
	CONSTRAINT FK_TTN_UPLINK_TOKENS_TTN_RX FOREIGN KEY (rx_guid)
		REFERENCES dbresprod.dbo.TTN_RX
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT FK_TTN_UPLINK_TOKENS_TTN_GATEWAYS FOREIGN KEY (gateway_guid)
		REFERENCES dbresprod.dbo.TTN_GATEWAYS (gateway_guid)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
);

CREATE TABLE dbresprod.dbo.TTN_READINGS(
	uplink_guid UNIQUEIDENTIFIER NOT NULL,
	sensor_guid UNIQUEIDENTIFIER NOT NULL,
	sensor_value NVARCHAR(MAX) NOT NULL,
	CONSTRAINT FK_TTN_READINGS_TTN_UPLINKS FOREIGN KEY (uplink_guid)
		REFERENCES dbresprod.dbo.TTN_UPLINKS (uplink_guid)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT FK_TTN_READINGS_TTN_SENSORS FOREIGN KEY (sensor_guid)
		REFERENCES dbresprod.dbo.TTN_SENSORS (sensor_guid)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE dbresprod.dbo.TTN_UPLINK_SETTINGS(
	uplink_setting_guid UNIQUEIDENTIFIER NOT NULL,
	uplink_guid UNIQUEIDENTIFIER NOT NULL,
	bandwidth INT NOT NULL,
	spreading_factor INT NOT NULL,
	data_rate_index INT NOT NULL,
	coding_rate NVARCHAR(5) NOT NULL,
	frequency INT NOT NULL,
	setting_timestamp INT NOT NULL,
	CONSTRAINT PK_TTN_UPLINK_SETTINGS PRIMARY KEY (uplink_setting_guid),
	CONSTRAINT FK_TTN_UPLINK_SETTINGS_TTN_UPLINKS FOREIGN KEY (uplink_guid)
		REFERENCES dbresprod.dbo.TTN_UPLINKS (uplink_guid)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);
