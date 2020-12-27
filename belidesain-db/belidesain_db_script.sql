CREATE TABLE User(
  UserId INT(10) NOT NULL AUTO_INCREMENT,
  Email VARCHAR(30),
  Password VARCHAR(15),
  LastActivity VARCHAR(10),
  IsOnline BOOLEAN,
  IsSupplier BOOLEAN,

  PRIMARY KEY (UserId)
);

CREATE TABLE UserId(
  UserId INT(10) NOT NULL AUTO_INCREMENT,
  Name VARCHAR(100),
  Email VARCHAR(30),
  Company  VARCHAR(50),
  Location VARCHAR(50),
  Website VARCHAR(30),
  PhoneNumber INT(13),

  FOREIGN KEY (UserId) REFERENCES User (UserId)
);

CREATE TABLE UserPhoto(
  PhotoId  INT(10) NOT NULL AUTO_INCREMENT,
  UserId  INT(10) NOT NULL AUTO_INCREMENT,
  PhotoName VARCHAR(30),

  PRIMARY KEY (PhotoId),
  FOREIGN KEY (UserId) REFERENCES User (UserId)
);

CREATE TABLE ChatSystem(
  ChatSystemId  INT(10) NOT NULL AUTO_INCREMENT,
  toUserId  INT(10) NOT NULL AUTO_INCREMENT,
  fromUserId  INT(10) NOT NULL AUTO_INCREMENT,
  Message VARCHAR(100),
  Timestamp  DATE,
  StatusMessage VARCHAR(15),

  PRIMARY KEY (ChatSystemId),
  FOREIGN KEY (toUserId) REFERENCES User (UserId),
  FOREIGN KEY (fromUserId) REFERENCES User (UserId)
);

CREATE TABLE DesignCategories(
  CategoryId  INT(10) NOT NULL AUTO_INCREMENT,
  CategoryName VARCHAR(20),
  CategoryDesc VARCHAR(50),
  CategoryPhoto VARCHAR(20),
  
  PRIMARY KEY (CategoryId)
);

CREATE TABLE DesginTheme(
  ThemeId INT(10) NOT NULL AUTO_INCREMENT,
	ThemeName VARCHAR(20),
  ThemeDesc VARCHAR(50),
  
  PRIMARY KEY (ThemeId)
);

CREATE TABLE DesignHeader(
  DesignId  INT(10) NOT NULL AUTO_INCREMENT,
  CategoryId  INT(10) NOT NULL AUTO_INCREMENT,
  ThemeId  INT(10) NOT NULL AUTO_INCREMENT,
  SupplierUserId  INT(10) NOT NULL AUTO_INCREMENT,
  isSold BOOLEAN,

  PRIMARY KEY (DesignId),
  FOREIGN KEY (CategoryId) REFERENCES DesignCategory (CategoryId),
  FOREIGN KEY (ThemeId) REFERENCES DesignTheme (ThemeId),
  FOREIGN KEY (SupplierUserId) REFERENCES User (UserId)
);

CREATE TABLE DesignRating(
  RatingId INT(10) NOT NULL AUTO_INCREMENT,
	DesignId INT(10) NOT NULL AUTO_INCREMENT,
	UserId INT(10) NOT NULL AUTO_INCREMENT,
	Rating INT(5),
  
  PRIMARY KEY (RatingId),
  FOREIGN KEY (DesignId) REFERENCES DesignHeader (DesignId),
	FOREIGN KEY (UserId) REFERENCES User (UserId)
);

CREATE TABLE DesignComments(
  CommentId  INT(10) NOT NULL AUTO_INCREMENT,
  DesignId  INT(10) NOT NULL AUTO_INCREMENT,
  Comment VARCHAR(1000),
  UserId  INT(10) NOT NULL AUTO_INCREMENT,
  DateSent DATE,

  PRIMARY KEY (CommentId),
  FOREIGN KEY (DesignId) REFERENCES DesignHeader (DesignId)
);

CREATE TABLE UserInventory(
  InventoryId  INT(10) NOT NULL AUTO_INCREMENT,
  UserId  INT(10) NOT NULL AUTO_INCREMENT,
  DesignId  INT(10) NOT NULL AUTO_INCREMENT,
  DatePurchased DATE,

  PRIMARY KEY (InventoryId),
  FOREIGN KEY (UserId) REFERENCES User (UserId),
  FOREIGN KEY (DesignId) REFERENCES DesignHeader (DesignId)
);

CREATE TABLE TransactionHeader(
  TransactionId  INT(10) NOT NULL AUTO_INCREMENT,
  DesignId INT(10) NOT NULL AUTO_INCREMENT,
  BuyerUserId INT(10) NOT NULL AUTO_INCREMENT,
  SupplierUserId INT(10) NOT NULL AUTO_INCREMENT,
  IsSucces BOOLEAN,
  IsExpired BOOLEAN,
  TransactionType VARCHAR(10),

  PRIMARY KEY (TransactionId),
  FOREIGN KEY (DesignId) REFERENCES DesignHeader (DesignId),
  FOREIGN KEY (BuyerUserId) REFERENCES User (UserId),
  FOREIGN KEY (SupplierUserId) REFERENCES User (UserId)
);

CREATE TABLE TrabsactionDetails(
  TransactionId  INT(10) NOT NULL AUTO_INCREMENT,
  TransactionAmount INT(11),
  TransactionDate DATE,
  ExpirationDate DATE,
  DateCreated DATE,

  FOREIGN KEY (TransactionId) REFERENCES TransactionHeader (TransactionId)
);

CREATE TABLE DesignPhotos(
  DesignPhotoId INT(10) NOT NULL AUTO_INCREMENT,
  DesignId INT(10) NOT NULL AUTO_INCREMENT,
  DesignPhotoName VARCHAR(20),

  PRIMARY KEY (DesignPhotoId),
  FOREIGN KEY (DesignId) REFERENCES DesignDetails (DesignId)
);

CREATE TABLE DesignFile(
  DesignFileId INT(10) NOT NULL AUTO_INCREMENT,
  DesignId INT(10) NOT NULL AUTO_INCREMENT,
  DesignFileName VARCHAR(20),
  DesignFileType VARCHAR(20),

  PRIMARY KEY (DesignFileId),
  FOREIGN KEY (DesignId) REFERENCES DesignDetails (DesignId)
);