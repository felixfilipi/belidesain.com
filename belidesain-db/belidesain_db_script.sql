CREATE TABLE User(
  UserId INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Email VARCHAR(50),
  Password VARCHAR(255),
  LastActivity DATETIME,
  IsOnline BOOL,
  IsSupplier BOOL,
  IsAdmin BOOL
);

CREATE TABLE UserInfo(
  UserId INT(32) NOT NULL,
  Name VARCHAR(100),
  Description TEXT,
  Company VARCHAR(48),
  Location VARCHAR(48),
  Website VARCHAR(64),
  PhoneNumber VARCHAR(16),
  FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE UserPhoto(
  PhotoId  INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  UserId  INT(32) NOT NULL,
  PhotoName VARCHAR(48),
  FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE UserFeedback(
  FeedbackId INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  UserId INT(32) NOT NULL,
  FeedbackMessage TEXT,
  FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ChatSystem(
  ChatSystemId  INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  toUserId  INT(32) NOT NULL,
  fromUserId  INT(32) NOT NULL,
  Message VARCHAR(100),
  Timestamp DATETIME,
  StatusMessage VARCHAR(15),
  FOREIGN KEY (toUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (fromUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignTheme(
  ThemeId INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  ThemeName VARCHAR(20),
  ThemeDesc TEXT
);

CREATE TABLE DesignCategories(
  CategoryId  INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  CategoryName VARCHAR(20),
  CategoryDesc TEXT,
  CategoryPhoto VARCHAR(20)
);

CREATE TABLE DesignSubCategories(
  SubCategoryId INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  CategoryId INT(32) NOT NULL,
  SubCategoryName VARCHAR(64),
  SubCategoryDesc TEXT,
  FOREIGN KEY (CategoryId) REFERENCES DesignCategories (CategoryId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignHeader(
  DesignId  INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  CategoryId  INT(32) NOT NULL,
  SubCategoryId INT(32) NOT NULL,
  ThemeId  INT(32) NOT NULL,
  SupplierUserId INT(32) NOT NULL,
  isSold BOOLEAN,
  FOREIGN KEY (CategoryId) REFERENCES DesignCategories (CategoryId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (SubCategoryId) REFERENCES DesignSubCategories (SubCategoryId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (ThemeId) REFERENCES DesignTheme (ThemeId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (SupplierUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignLikeCount(
  LikeCountId INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignId INT(32) NOT NULL,
  UserId INT(32) NOT NULL,
  Likes INT(11),
  FOREIGN KEY (DesignId) REFERENCES DesignHeader (DesignId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE UserInventory(
  InventoryId  INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  UserId  INT(32) NOT NULL,
  DesignId  INT(32) NOT NULL,
  DesignTransactionId INT(32) NOT NULL,
  DatePurchased DATETIME,
  FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (DesignId) REFERENCES DesignHeader (DesignId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (DesignTransactionId) REFERENCES DesignTransactionHeader (DesignTransactionId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignTransactionHeader(
  DesignTransactionId  INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignId INT(32) NOT NULL,
  BuyerUserId INT(32) NOT NULL,
  IsSuccess BOOLEAN,
  IsExpired BOOLEAN,
  TransactionType VARCHAR(32),
  FOREIGN KEY (DesignId) REFERENCES DesignHeader (DesignId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (BuyerUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignTransactionDetails(
  DesignTransactionId  INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignTransactionAmount INT(32),
  DesignTransactionDate DATETIME,
  ExpirationDate DATETIME,
  DateCreated DATETIME,
  FOREIGN KEY (DesignTransactionId) REFERENCES DesignTransactionHeader (DesignTransactionId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignDetails(
  DesignId INT(32) NOT NULL PRIMARY KEY,
  DesignName VARCHAR(64),
  DesignDesc TEXT,
  DesignPrice INT(32),
  DesignDateCreated DATETIME,
  FOREIGN KEY (DesignId) REFERENCES DesignHeader (DesignId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignPhotos(
  DesignPhotoId INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignId INT(32) NOT NULL,
  DesignPhotoName VARCHAR(64),
  FOREIGN KEY (DesignId) REFERENCES DesignDetails (DesignId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignSpesification(
  SpesificationId INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignId INT(32) NOT NULL,
  SpesificationName VARCHAR(32),
  SpesificationDesc VARCHAR(32),
  FOREIGN KEY (DesignId) REFERENCES DesignDetails (DesignId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignFile(
  DesignFileId INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignId INT(32) NOT NULL,
  DesignFileName VARCHAR(20),
  DesignFileType VARCHAR(20),
  FOREIGN KEY (DesignId) REFERENCES DesignDetails (DesignId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ExpoEvent(
  ExpoEventId INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  OrganizerUserId INT(32) NOT NULL,
  CategoryId INT(32) NOT NULL,
  DateHeld DATETIME,
  IsOnline BOOL,
  FOREIGN KEY (OrganizerUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (CategoryId) REFERENCES DesignCategories (CategoryId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ExpoTransactionHeader(
  ExpoTransactionId INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  ExpoEventId INT(32) NOT NULL,   
  BuyerUserId INT(32) NOT NULL,
  IsSuccess BOOL,
  IsExpired BOOL,
  TransactionType VARCHAR(32),
  FOREIGN KEY (ExpoEventId) REFERENCES ExpoEvent (ExpoEventId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (BuyerUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE UserExpo(
  UserId INT(32) NOT NULL,
  ExpoEventId INT(32) NOT NULL,
  ExpoTransactionId INT(32) NOT NULL,
  DatePurchased DATETIME,
  FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (ExpoEventId) REFERENCES ExpoEvent (ExpoEventId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (ExpoTransactionId) REFERENCES ExpoTransactionHeader(ExpoTransactionId) ON DELETE CASCADE ON UPDATE CASCADE
); 
  
CREATE TABLE ExpoTransactionDetails(
  ExpoTransactionId INT(32) NOT NULL,
  ExpoTransactionAmount INT(32),
  ExpoTransactionDate DATETIME,
  ExpoExpirationDate DATETIME,
  DateCreated DATETIME,
  FOREIGN KEY (ExpoTransactionId) REFERENCES ExpoTransactionHeader (ExpoTransactionId) ON DELETE CASCADE ON UPDATE CASCADE
);

 CREATE TABLE ExpoEventDetails(
   ExpoEventId INT(32) NOT NULL,
   ExpoEventTitle VARCHAR(32),
   ExpoEventPlace VARCHAR(32),
   ExpoEventLink TEXT,
   FOREIGN KEY (ExpoEventId) REFERENCES ExpoEvent (ExpoEventId) ON DELETE CASCADE ON UPDATE CASCADE
);
  
CREATE TABLE DesignerTransactionHeader(
  DesignerTransactionId INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignerId INT(32) NOT NULL,
  BuyerUserId INT(32) NOT NULL,
  IsSuccess BOOL,
  IsExpired BOOL,
  TransactionType VARCHAR(32),
  FOREIGN KEY (DesignerId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (BuyerUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignerTransactionDetail(
  DesignerTransactionId INT(32) NOT NULL,
  AssignedDate DATE,
  DeadlineDate DATE,
  Confirmed BOOL,
  FOREIGN KEY (DesignerTransactionId) REFERENCES DesignerTransactionHeader (DesignerTransactionId) ON DELETE CASCADE ON UPDATE CASCADE
);  

CREATE TABLE DesignerInfo(
  DesignerId INT(32) NOT NULL,
  DesignerPrice INT(32),
  Rating INT(32),
  FOREIGN KEY (DesignerId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignerRating(
  RatingId INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignerId INT(32) NOT NULL,
  UserId INT(32) NOT NULL,
  Rating INT(32),
  FOREIGN KEY (DesignerId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);  

/*
Categories : Desain Interior, DKV, Desain Busana, Desain Furnitur, Desain Website
SubCategories : 
----Desain Interior
   |--- Ruang Tamu
   |--- Dapur
   |--- Kamar Tidur
   |--- Ruang Bersantai
----Desain Busana
   |--- Batik
   |--- Kasual
   |--- Resmi
   |--- Pesta
----Desain Furnitur
   |--- Kursi
   |--- Meja
   |--- Lemari
----Desain Komunikasi Visual
   |--- Poster
   |--- Flyer
   |--- Card
   |--- Brochure
----Desain Website
   |--- Online Shop
   |--- Portofolio
   |--- Photography
   |--- Entertainment
   |--- Food
   |--- Event
*/

INSERT INTO DesignCategories VALUES
  (NULL, 'Desain Interior', 'Salah satu jenis desain rumah yang berfokus pada interior atau ruangan sebuah rumah. Disini terdapat beberapa desain berdasarkan jenis ruangan, seperti desain ruang tamu, desain kamar tidur, desain dapur, dll'),
  (NULL, 'Desain Komunikasi Visual', 'Salah satu jenis desain yang bertujuan menyampaikan pesan ditambah dengan aspek visual yang bagus.'),
  (NULL, 'Desain Furnitur', 'Kategori Desain ini lebih berfokus pada isi dari interior rumah, misalnya Kursi, Meja, Lemari, dll'),
  (NULL, 'Desain Busana', 'Desain ini berfokus pada pakaian dan sejenisnya. Contoh kategori pada desain ini antara lain: pakaian batik, pakaian pesta, pakaian resmi, dll'),
  (NULL, 'Desain Website', 'Ditunjukkan pada desainer UI/UX, desain ini lebih berfokus pada bagaiman penyajian konten pada website dibuat lebih bagus. Pada website ini terdapat banyak tema yang disajikan, misalnya online shop, entertainment, event, dll');

INSERT INTO DesignSubCategories VALUES
  (NULL, '1', 'Ruang Tamu'),
  (NULL, '1', 'Dapur'),
  (NULL, '1', 'Kamar Tidur'),
  (NULL, '1', 'Ruang Bersantai'),
  (NULL, '2', 'Poster'),
  (NULL, '2', 'Flyer'),
  (NULL, '2', 'Card'),
  (NULL, '2', 'Brochure'),
  (NULL, '2', 'Logo'),
  (NULL, '3', 'Kursi'),
  (NULL, '3', 'Meja'),
  (NULL, '3', 'Lemari'),
  (NULL, '4', 'Batik'),
  (NULL, '4', 'Kasual'),
  (NULL, '4', 'Resmi'),
  (NULL, '4', 'Pesta'),
  (NULL, '5', 'Online Shop'),
  (NULL, '5', 'Portofolio'),
  (NULL, '5', 'Photography'),
  (NULL, '5', 'Entertainment'),
  (NULL, '5', 'Food'),
  (NULL, '5', 'Event');
