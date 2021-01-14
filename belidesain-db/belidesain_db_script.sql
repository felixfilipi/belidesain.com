CREATE TABLE User(
  UserId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  Email VARCHAR(20),
  Password VARCHAR(16),
  LastActivity DATETIME,
  IsOnline BOOL,
  IsSupplier BOOL,
  IsAdmin BOOL,
  CONSTRAINT chk_email CHECK (Email like '%@%.%')
);

CREATE TABLE UserInfo(
  UserId INT(10) NOT NULL,
  Name VARCHAR(50),
  Description TEXT,
  Company VARCHAR(48),
  Location VARCHAR(48),
  Website VARCHAR(48),
  PhoneNumber VARCHAR(16),
  FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT chk_phone CHECK (PhoneNumber <= 13 AND PhoneNumber like '08[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
  CONSTRAINT chk_website CHECK (Website like '%.%')
);

CREATE TABLE UserPhoto(
  PhotoId  INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  UserId  INT(10) NOT NULL,
  PhotoName VARCHAR(48) NOT NULL,
  FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE UserFeedback(
  FeedbackId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  UserId INT(10) NOT NULL,
  FeedbackMessage TEXT,
  FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ChatSystem(
  ChatSystemId  INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  toUserId  INT(10) NOT NULL,
  fromUserId  INT(10) NOT NULL,
  Message VARCHAR(100) NOT NULL,
  Timestamp DATETIME NOT NULL,
  StatusMessage ENUM ('Pending', 'Delivered', 'Success') NOT NULL,
  FOREIGN KEY (toUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (fromUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignCategories(
  CategoryId  INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  CategoryName VARCHAR(20) NOT NULL,
  CategoryDesc TEXT NOT NULL
);

CREATE TABLE DesignSubCategories(
  SubCategoryId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  CategoryId INT(10) NOT NULL,
  SubCategoryName VARCHAR(64) NOT NULL,
  SubCategoryDesc TEXT,
  FOREIGN KEY (CategoryId) REFERENCES DesignCategories (CategoryId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignTheme(
  ThemeId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  SubCategoryId INT(10) NOT NULL,
  ThemeName VARCHAR(20),
  FOREIGN KEY (SubCategoryId) REFERENCES DesignSubCategories (SubCategoryId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignHeader(
  DesignId  INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  CategoryId  INT(10) NOT NULL,
  SubCategoryId INT(10) NOT NULL,
  ThemeId  INT(10) NOT NULL,
  SupplierUserId INT(10) NOT NULL,
  isSold BOOLEAN NOT NULL,
  FOREIGN KEY (CategoryId) REFERENCES DesignCategories (CategoryId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (SubCategoryId) REFERENCES DesignSubCategories (SubCategoryId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (ThemeId) REFERENCES DesignTheme (ThemeId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (SupplierUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignLikeCount(
  LikeCountId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignId INT(10) NOT NULL,
  UserId INT(10) NOT NULL,
  Likes INT(10) NOT NULL,
  FOREIGN KEY (DesignId) REFERENCES DesignHeader (DesignId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE UserInventory(
  InventoryId  INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  UserId  INT(10) NOT NULL,
  DesignId  INT(10) NOT NULL,
  DesignTransactionId INT(10) NOT NULL,
  DatePurchased DATETIME NOT NULL,
  FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (DesignId) REFERENCES DesignHeader (DesignId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (DesignTransactionId) REFERENCES DesignTransactionHeader (DesignTransactionId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignTransactionHeader(
  DesignTransactionId  INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignId INT(10) NOT NULL,
  BuyerUserId INT(10) NOT NULL,
  IsSuccess BOOLEAN,
  IsExpired BOOLEAN,
  TransactionType ENUM('ovo', 'linkaja', 'dana'),
  FOREIGN KEY (DesignId) REFERENCES DesignHeader (DesignId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (BuyerUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignTransactionDetails(
  TransactionId  INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  TransactionDate DATETIME NOT NULL,
  ExpirationDate DATETIME NOT NULL,
  DateCreated DATETIME NOT NULL,
  FOREIGN KEY (DesignTransactionId) REFERENCES DesignTransactionHeader (DesignTransactionId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignDetails(
  DesignId INT(10) NOT NULL,
  DesignName VARCHAR(64),
  DesignDesc TEXT,
  DesignPrice INT(10),
  DesignDateCreated DATETIME NOT NULL,
  FOREIGN KEY (DesignId) REFERENCES DesignHeader (DesignId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignPhotos(
  DesignPhotoId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignId INT(10) NOT NULL,
  DesignPhotoName VARCHAR(64) NOT NULL,
  FOREIGN KEY (DesignId) REFERENCES DesignDetails (DesignId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignSpesification(
  SpesificationId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignId INT(10) NOT NULL,
  SpesificationName VARCHAR(32),
  SpesificationDesc VARCHAR(32),
  FOREIGN KEY (DesignId) REFERENCES DesignDetails (DesignId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignFile(
  DesignFileId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignId INT(10) NOT NULL,
  DesignFileName VARCHAR(20) NOT NULL,
  DesignFileType VARCHAR(20) NOT NULL,
  FOREIGN KEY (DesignId) REFERENCES DesignDetails (DesignId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ExpoEvent(
  ExpoEventId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  OrganizerUserId INT(10) NOT NULL,
  CategoryId INT(10) NOT NULL,
  DateHeld DATETIME NOT NULL,
  IsOnline BOOL NOT NULL,
  FOREIGN KEY (OrganizerUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (CategoryId) REFERENCES DesignCategories (CategoryId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ExpoTransactionHeader(
  ExpoTransactionId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  ExpoEventId INT(10) NOT NULL,   
  BuyerUserId INT(10) NOT NULL,
  IsSuccess BOOL NOT NULL,
  IsExpired BOOL NOT NULL,
  TransactionType ENUM('ovo','linkaja','dana') NOT NULL,
  TicketQty INT(10) NOT NULL,
  FOREIGN KEY (ExpoEventId) REFERENCES ExpoEvent (ExpoEventId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (BuyerUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT chk_ticketQty CHECK (TicketQty <= 10)
);

CREATE TABLE UserExpo(
  UserId INT(10) NOT NULL,
  ExpoEventId INT(10) NOT NULL,
  ExpoTransactionId INT(10) NOT NULL,
  DatePurchased DATETIME NOT NULL,
  FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (ExpoEventId) REFERENCES ExpoEvent (ExpoEventId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (ExpoTransactionId) REFERENCES ExpoTransactionHeader(ExpoTransactionId) ON DELETE CASCADE ON UPDATE CASCADE
); 
  
CREATE TABLE ExpoTransactionDetails(
  ExpoTransactionId INT(10) NOT NULL,
  ExpoTransactionDate DATETIME NOT NULL,
  ExpoExpirationDate DATETIME NOT NULL,
  DateCreated DATETIME NOT NULL,
  FOREIGN KEY (ExpoTransactionId) REFERENCES ExpoTransactionHeader (ExpoTransactionId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ExpoEventDetails(
  ExpoEventId INT(10) NOT NULL,
  ExpoEventTitle VARCHAR(32)NOT NULL,
  ExpoEventPlace VARCHAR(32),
  ExpoEventLink VARCHAR(32),
  ExpoEventDesc TEXT NOT NULL,
  TicketQuota INT(10) NOT NULL,
  TicketPrice INT(10) NOT NULL,
  FOREIGN KEY (ExpoEventId) REFERENCES ExpoEvent (ExpoEventId) ON DELETE CASCADE ON UPDATE CASCADE,
);
  
CREATE TABLE ExpoEventPhoto(
  PhotoId INT(10) NOT NULL,
  ExpoEventId INT(10) NOT NULL,
  PhotoName VARCHAR(32) NOT NULL,
  FOREIGN KEY (ExpoEventId) REFERENCES ExpoEvent (ExpoEventId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignerTransactionHeader(
  DesignerTransactionId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignerId INT(10) NOT NULL,
  BuyerUserId INT(10) NOT NULL,
  IsSuccess BOOL,
  IsExpired BOOL,
  TransactionType ENUM('ovo', 'linkaja', 'dana'),
  FOREIGN KEY (DesignerId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (BuyerUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignerTransactionDetail(
  DesignerTransactionId INT(10) NOT NULL,
  AssignedDate DATE,
  DeadlineDate DATE,
  Confirmed BOOL,
  FOREIGN KEY (DesignerTransactionId) REFERENCES DesignerTransactionHeader (DesignerTransactionId) ON DELETE CASCADE ON UPDATE CASCADE
);  

CREATE TABLE DesignerInfo(
  DesignerId INT(10) NOT NULL,
  DesignerPrice INT(10) NOT NULL,
  Rating INT(10) NOT NULL,
  FOREIGN KEY (DesignerId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT chk_rating CHECK (Rating <= 5 AND Rating > 0)
);

CREATE TABLE DesignerRating(
  RatingId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignerId INT(10) NOT NULL,
  UserId INT(10) NOT NULL,
  Rating INT(10) NOT NULL,
  FOREIGN KEY (DesignerId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT chk_rating CHECK (Rating <= 5 AND Rating > 0)
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

INSERT INTO User VALUES
  ('1230000001', 'bellakia@gmail.com', 'bella545', '30-01-2021 07:38:53', '0', '1', '0'),
  ('1230000002', 'annastya@gmail.com', 'ann223', '25-01-2021 14:48:27', '1', '0', '1'),
  ('1230000003', 'satriabagus11@gmail.com', 'satbagus110', '20-01-2021 21:40:57', '1', '1', '0'),
  ('1230000004', 'bagaskara47@gmail.com', 'bagas09', '22-01-2021 05:19:25', '0', '1', '0'),
  ('1230000005', 'rahayuputri15@gmail.com', 'rara05', '23-01-2021 02:42:43', '0', '1', '1'),
  ('1230000006', 'selaokta02@gmail.com', 'oktasela20', '23-01-2021 17:09:24', '0', '0', '1'),
  ('1230000007', 'robbybagus@gmail.com', 'robbybgs92', '23-01-2021 19:42:46', '1', '0', '1'),
  ('1230000008', 'ahmadsolihin24@gmail.com', 'ahmdsol123', '19-01-2021 04:05:38', '1', '1', '1'),
  ('1230000009', 'nurkhamidah10@gmail.com', 'khamidh98', '18-01-2021 05:21:36', '1', '0', '0'),
  ('1230000010', 'zulfainji33@gmail.com', 'zulfainji27', '24-01-2021 02:37:42', '0', '1', '0');
    
INSERT INTO UserInfo VALUES
  ('1230000001', 'Nabila Askiatus Syifa', '',),
  ('1230000002', 'Dhea Annastasya', '',),
  ('1230000003', 'Satria Bagus', '',),
  ('1230000004', 'Bagaskara', '',),
  ('1230000005', 'Rahayu Putri Irwanti', '',),
  ('1230000006', 'Sela Okta Maulina', '', ),
  ('1230000007', 'Robby Bagus', '',),
  ('1230000008', 'Ahmad Solohin', '', ),
  ('1230000009', 'Nur Khamidah', '', ),
  ('1230000010', 'Zulfa Inji Ilmana', '', );
  
INSERT INTO UserPhoto VALUES
  ('3210000001', '1230000001', 'Kursi kayu single'),
  ('3210000002', '1230000002', 'Kamar 3x3 gaya retro'),
  ('3210000003', '1230000003', 'Lemari kayu 2 pintu'),
  ('3210000004', '1230000004', 'Lemari kayu 2 pintu dan kaya sebadan'),
  ('3210000005', '1230000005', 'Batik coklat motif bunga'),
  ('3210000006', '1230000006', 'Kemeja resmi kantor'),
  ('3210000007', '1230000007', 'Dapur modern'),
  ('3210000008', '1230000008', 'Kemeja kerja putih'),
  ('3210000009', '1230000009', 'Poster acara lomba'),
  ('3210000010', '1230000010', 'Kartu nama');
  
INSERT INTO UserFeedback VALUES
  ('1110000001', '1230000001', ''),
  ('1110000002', '1230000002', ''),
  ('1110000003', '1230000003', ''),
  ('1110000004', '1230000004', ''),
  ('1110000005', '1230000005', ''),
  ('1110000006', '1230000006', ''),
  ('1110000007', '1230000007', ''),
  ('1110000008', '1230000008', ''),
  ('1110000009', '1230000009', ''),
  ('1110000010', '1230000010', '');
  
INSERT INTO ChatSystem VALUES
  ('2220000001', '1230000007', '1230000009', 'Hallo'),
  ('2220000002', '1230000008', '1230000010', 'Mau bertanya'),
  ('2220000003', '1230000009', '1230000007', 'Ada yang bisa saya bantu?'),
  ('2220000004', '1230000006', '1230000002', 'Pengerjaan berapa lama?'),
  ('2220000005', '1230000008', '1230000003', 'Hallo, apa kabar?'),
  ('2220000006', '1230000007', '1230000001', 'Warna yang tersedia apa saja?'),
  ('2220000007', '1230000001', '1230000005', 'Silahkan konsultasi desain sesuai keinginan'),
  ('2220000008', '1230000003', '1230000004', 'Ada yang bisa saya bantu?'),
  ('2220000009', '1230000005', '1230000006', 'Pengrjaan berapa lama ya?'),
  ('2220000010', '1230000002', '1230000007', 'Baik, terima kasih');
  
INSERT INTO DesignLikeCount VALUES
  ('3330000001', '1210000001', '1230000001', '5'),
  ('3330000002', '1210000002', '1230000002', '7'),
  ('3330000003', '1210000003', '1230000003', '4'),
  ('3330000004', '1210000004', '1230000004', '11'),
  ('3330000005', '1210000005', '1230000005', '7'),
  ('3330000006', '1210000006', '1230000006', '18'),
  ('3330000007', '1210000007', '1230000007', '10'),
  ('3330000008', '1210000008', '1230000008', '20'),
  ('3330000009', '1210000009', '1230000009', '3'),
  ('3330000010', '1210000010', '1230000010', '11');
  
INSERT INTO UserInventory VALUES
  ('4440000001', '1230000001', '1210000001', '5550000001', '24-01-2021 09:02:30'),
  ('4440000002', '1230000002', '1210000002', '5550000002', '21-02-2021 17:16:29'),
  ('4440000003', '1230000003', '1210000003', '5550000003', '10-03-2021 01:19:35'),
  ('4440000004', '1230000004', '1210000004', '5550000004', '07-04-2021 11:10:05'),
  ('4440000005', '1230000005', '1210000005', '5550000005', '22-05-2021 16:41:13'),
  ('4440000006', '1230000006', '1210000006', '5550000006', '15-09-2021 05:55:22'),
  ('4440000007', '1230000007', '1210000007', '5550000007', '05-10-2021 18:11:37'),
  ('4440000008', '1230000008', '1210000008', '5550000008', '17-11-2021 06:29:05'),
  ('4440000009', '1230000009', '1210000009', '5550000009', '23-11-2021 12:41:51'),
  ('4440000010', '1230000010', '1210000010', '5550000010', '29-12-2021 23:08:05');
  
INSERT INTO DesignTransactionHeader VALUES
  ('5550000001', '1210000001', '1230000001', '0', '1', 'Credit'),
  ('5550000002', '1210000002', '1230000002', '1', '0', 'Deposit'),
  ('5550000003', '1210000003', '1230000003', '1', '0', 'Credit'),
  ('5550000004', '1210000004', '1230000004', '1', '1', 'Debit'),
  ('5550000005', '1210000005', '1230000005', '0', '1', 'Credit'),
  ('5550000006', '1210000006', '1230000006', '1', '1', 'Credit'),
  ('5550000007', '1210000007', '1230000007', '1', '0', 'Debit'),
  ('5550000008', '1210000008', '1230000008', '0', '1', 'Credit'),
  ('5550000009', '1210000009', '1230000009', '1', '0', 'Debit'),
  ('5550000010', '1210000010', '1230000010', '0', '1', 'Deposit');

INSERT INTO DesignerTransactionHeader VALUES
  ('6660000001', '1210000001', '1230000001', '0', '1', 'Credit'),
  ('6660000002', '1210000002', '1230000002', '1', '1', 'Deposit'),
  ('6660000003', '1210000003', '1230000003', '1', '0', 'Credit'),
  ('6660000004', '1210000004', '1230000004', '1', '0', 'Debit'),
  ('6660000005', '1210000005', '1230000005', '1', '1', 'Credit'),
  ('6660000006', '1210000006', '1230000006', '1', '0', 'Credit'),
  ('6660000007', '1210000007', '1230000007', '1', '1', 'Debit'),
  ('6660000008', '1210000008', '1230000008', '1', '0', 'Credit'),
  ('6660000009', '1210000009', '1230000009', '0', '0', 'Debit'),
  ('6660000010', '1210000010', '1230000010', '1', '1', 'Deposit');
    
INSERT INTO DesignerTransactionDetail VALUES
  ('6660000001', '23/01/2021', '06/03/2021', '0'),
  ('6660000002', '27/05/2021', '04/06/2021', '0'),
  ('6660000003', '08/06/2021', '20/07/2021', '1'),
  ('6660000004', '11/06/2021', '01/08/2021', '1'),
  ('6660000005', '16/08/2021', '23/09/2021', '1'),
  ('6660000006', '22/08/2021', '27/09/2021', '1'),
  ('6660000007', '15/10/2021', '02/11/2021', '0'),
  ('6660000008', '22/10/2021', '18/12/2021', '1'),
  ('6660000009', '11/11/2021', '28/12/2021', '1'),
  ('6660000010', '05/02/2021', '17/04/2021', '0');
  
INSERT INTO DesignerInfo VALUES
  ('1230000001', '1200000', '9'),
  ('1230000002', '1500000', '7'),
  ('1230000003', '2600000', '7'),
  ('1230000004', '2400000', '4'),
  ('1230000005', '2000000', '10'),
  ('1230000006', '1200000', '6'),
  ('1230000007', '2000000', '10'),
  ('1230000008', '1800000', '9'),
  ('1230000009', '800000', '4'),
  ('1230000010', '3000000', '8');
  
INSERT INTO DesignerRating VALUES
  ('7770000001', '1230000007', '1230000009', '9'),
  ('7770000002', '1230000008', '1230000010', '7'),
  ('7770000003', '1230000009', '1230000007', '7'),
  ('7770000004', '1230000006', '1230000002', '4'),
  ('7770000005', '1230000008', '1230000003', '10'),
  ('7770000006', '1230000007', '1230000001', '6'),
  ('7770000007', '1230000001', '1230000005', '10'),
  ('7770000008', '1230000003', '1230000004', '9'),
  ('7770000009', '1230000005', '1230000006', '4'),
  ('7770000010', '1230000002', '1230000007', '8');
  
INSERT INTO UserExpo VALUES
  ('1230000007', '8880000009', '17/01/2021'),
  ('1230000008', '8880000010', '24/02/2021'),
  ('1230000009', '8880000007', '08/05/2021'),
  ('1230000006', '8880000002', '25/05/2021'),
  ('1230000005', '8880000003', '24/06/2021'),
  ('1230000004', '8880000001', '28/06/2021'),
  ('1230000001', '8880000005', '14/07/2021'),
  ('1230000003', '8880000004', '05/09/2021'),
  ('1230000010', '8880000006', '22/10/2021'),
  ('1230000002', '8880000008', '04/11/2021');
  
 INSERT INTO DesignTransactionDetails VALUES
	(1, 250000, 06/01/2021 07:39:10 , 10/01/2021 11:39:10, 05/01/2021 11:39:10),
	(2, 12000, 10/01/2021 06:42:45, 15/01/2021 06:41:45, 10/01/2021 06:41:45),
	(3, 121000, 01/01/2021 03:02:12, 05/01/2021 02:35:20, 01/01/2021 02:35:20),
	(4, 200000, 04/01/2021 12:32:32, 07/01/2021 07:52:59, 02/01/2021 07:52:59),
	(5, 16000, 04/01/2021 15:04:04, 09/01/2021 10:38:36, 04/01/2021 10:38:36),
	(6, 140000, 02/01/2021 23:32:11, 07/01/2021 21:42:29, 02/01/2021 21:42:29),
	(7, 190000, 06/01/2021 13:54:14, 11/01/2021 13:00:13, 06/01/2021 13:00:13),
	(8, 10000, 09/01/2021 07:23:43, 13/01/2021 06:29:43, 01/08/2021 06:29:43),
	(9, 25000, 04/01/2021 13:53:36, 07/01/2021 01:29:36, 02/01/2021 01:29:36),
	(10, 42000, 12/01/2021 01:00:43, 16/01/2021 18:19:19, 11/01/2021 18:19:19);
	
INSERT INTO DesignTheme VALUES
	()
	
INSERT INTO DesignHeader VALUES
	(1, 3, 11, 3, 6, 0),
	(2, 5, 22, 6, 1, 1),
	(3, 2, 8, 1, 5, 1),
	(4, 5, 21, 5, 9, 1),
	(5, 5, 21, 6, 8, 0),
	(6, 2, 5, 3, 10, 0),
	(7, 1, 2, 10, 4, 0),
	(8, 3, 10, 9, 7, 0),
	(9, 5, 22, 2, 1, 1),
	(10, 2, 7, 2, 5, 0);
	
INSERT INTO ExpoTransactionHeader VALUES
	(1, 7, 4, 1, 0, 'ovo', 1),
	(2, 4, 6, 0, 0, 'dana', 3),
	(3, 4, 5, 1, 0, 'ovo', 3),
	(4, 10, 2, 0, 0, 'linkaja', 1),
	(5, 6, 1, 1, 0, 'linkaja', 5),
	(6, 8, 9, 1, 0, 'linkaja', 5),
	(7, 9, 3, 1, 0, 'linkaja', 2),
	(8, 10, 1, 1, 0, 'ovo', 5),
	(9, 8, 5, 0, 0, 'dana', 3),
	(10, 3, 4, 0, 1, 'ovo', 2);
	
INSERT INTO DesignDetails VALUES
	(1, 'Kursi Antik warna hitam', 'Desain kursi yang mempunyai estetika antik dengan warna utama hitam. Kursi ini nyaman untuk diduduki dan tidak membuat orang capai.', 76999, '2021-01-02 16:41:07'),
	(2, 'Website EventMaker', 'Desain frontend website untuk pembuatan dan publikasi event', 80000, '2021-01-01 05:44:58'),
	(3, 'Desain eatery', 'Desain brosur untuk promosi makanan dan restoran', 75000, '2021-01-01 13:50:38'),
	(4, 'RestoSite', 'Desain website untuk promosi makanan dan restoran', 150000, '2021-01-01 17:07:58'),
	(5, 'MakanYuk', 'Desain website untuk pemesanan online kuliner', 50000, '2021-01-03 01:52:53'),
	(6, 'DarkPoster', 'Desain poster berestetika hitam/dark cocok untuk konser bertema halloween', 75000, '2021-01-05 10:44:24'),
	(7, 'DapurForest', 'Desain interior dapur bertema greeny dan organik, cocok untuk konsep alam liar', 250000, '2021-01-05 17:21:32'),
	(8, 'KursiForest', 'Desain kursi bertema greeny dan organik, cocok untuk konsep alam liar', 78000, '2021-01-06 23:14:29'),
	(9, 'LombaWeb', 'Desain website untuk mempromosikan event terutama lomba - lomba', 170000, '2021-01-08 18:36:39'),
	(10, 'ChristmasCard', 'Desain kartu untuk merayakan natal dan tahun-baru', 50000, '2021-01-05 15:23:08');

INSERT INTO DesignPhotos VALUES
	(1, 1, 'PWEuCI.jpg'),
	(2, 2, 'YU6HTc.jpg'),
	(3, 2, 'jb3vgc.jpg'),
	(4, 2, 'C0jtr0.jpg'),
	(5, 3, 'BmUDXe.png'),
	(6, 3, 'mUZNpl.jpg'),
	(7, 4, 'BajtOu.png'),
	(8, 5, '4npiUb.png'),
	(9, 5, 'mSd0NP.png'),
	(10, 5, 'L9p8QS.jpg'),
	(11, 6, 'GFB2AN,png'),
	(12, 7, 'RVkJL4.jpg'),
	(13, 7, 'MRqlqg.png'),
	(14, 7, 'odlVWY.jpg'),
	(15, 8, 'ZvnfHv.png'),
	(16, 8, 'IjuoqO.png'),
	(17, 9, '0i9kIY.png'),
	(18, 9, 'Fi1NOz.png'),
	(19, 10, 'qG0jGJ.png'),
	(20, 10, 'XtpRAJ.jpg'),
	(21, 10, '4tHJG9.jpg');
	

INSERT INTO ExpoTransactionDetails VALUES
	(1, '10/01/2021 07:21:32', '14/01/2021 15:54:03', '09/01/2021 15:54:03'),
	(2, NULL, '15/01/2021 13:40:03', '10/01/2021 13:40:03'),
	(3, '07/01/2021 09:45:51', '13/01/2021 08:03:51', '07/01/2021 08:03:51'),
	(4, NULL, '02/01/2021 23:01:57', '02/01/2021 23:01:57'),
	(5, '06/01/2021 09:00:45', '08/01/2021 11:39:20', '03/01/2021 11:39:20'),
	(6, '05/01/2021 19:12:01', '10/01/2021 15:47:07', '05/01/2021 15:47:07'),
	(7, '08/01/2021 21:07:41', '12/01/2021 23:42:24', '07/01/2021 23:42:24'),
	(8, '11/01/2021 11:05:07', '13/01/2021 13:13:58', '08/01/2021 13:13:58'),
	(9, NULL, '17/01/2021 07:52:42', '12/01/2021 07:52:42'),
	(10, NULL, '09/01/2021 15:54:03', '04/01/2021 15:54:03');

INSERT INTO ExpoEvent VALUES
	(1, 11, 5, '16/01/2021 02:34:00', 0, 0),
	(2, 12, 2, '27/01/2021 03:30:16', 1, 0),
	(3, 13, 4, '15/01/2021 08:18:16',1, 1),
	(4, 14, 5, '25/01/2021 14:03:22', 0, 0),
	(5, 15, 3, '24/01/2021 07:15:22', 0, 1),
	(6, 16, 5, '27/01/2021 15:40:07', 0, 0),
	(7, 17, 3, '14/01/2021 07:53:37', 1, 1),
	(8, 18, 2, '16/01/2021 05:02:07', 1, 1),
	(9, 19, 4, '16/01/2021 22:00:47', 1, 0),
	(10, 20, 3, '18/01/2021 21:38:28', 1, 1);

INSERT INTO ExpoEventPhoto VALUES
	(1, 1, 'apDSPF.jpg'),
	(2, 2, 'eSFtG9.jpg'),
	(3, 3, 'UGPdOI.jpg'),
	(4, 4, 'nYE4bQ.jpg'),
	(5, 5, 'zo7xjv.jpg'),
	(6, 6, 'EClJeC.jpg'),
	(7, 7, 'ePENx9.jpg'),
	(8, 8, 'viXcGF.jpg'),
	(9, 9, 'wsfZBP.jpg'),
	(10, 10, '2yPWHD.jpg');
	

INSERT INTO ExpoEventDetails VALUES
	(1, 'GoE-Commerce', 'Jalan Shah Amanat Market 12/A', NULL, 'Pameran desain website bertema e-commerce', 100, 12000),
	(2, 'DKVExpo', NULL, 'http://example.com/aunt/alarm#act', 'Pameran desain yang bertajuk komunikasi visual dan promosi', 300, 6000),
	(3, 'JizCloth', NULL, 'http://example.com/?alarm=alarm&bell=believe#bells', 'Pameran clothing dengan tema milenial', NULL, NULL),
	(4, 'FrontendMake', 'Jl. Dr Muwardi no.7, Bali', NULL, 'Pameran dan seminar tentang pembuatan frontend pada website', 500, 5000),
	(5, 'FurnitureCADExpo', 'Gang Nuri 4-6, Jawa Tengah' NULL, 'Pemeran dan seminar pembuatan desain furnitur memakai CAD', NULL, NULL),
	(6, 'MockUpMaking', 'Jalan Kwitang Raya 36 RT 001/07', NULL, 'Pameran pembuatan tampilan mockup sebuah website', 100, 7000),
	(7, 'FurniterStarter', NULL, 'http://example.com/bedroom/ants', 'Pameran untuk mengajak mahasiswa - mahasiswa desain interior melakukan startup desain', NULL, NULL),
	(8, 'MillenialLogo', NULL, 'https://boot.example.edu/acoustics', 'Expo yang mempamerkan logo yang diminati orang milenial masa kini', NULL, NULL),
	(9, 'PartyClothing', NULL, 'http://amount.example.com/?argument=apparel', 'Expo untuk desain baju santai dan cocok untuk pesta', 50, 15000),
	(10, 'BedStyles', NULL, 'https://www.example.com/boot.html#badge', 'Pameran desain yang ideal untuk pembuatan ranjang/tempat tidur', NULL, NULL);

INSERT INTO DesignSpesification VALUES
	(1, 1,),
	(2, 1,),
	(3, 1,),
	(4, 2,),
	(5, 2,),
	(6, 3,),
	(7, 4,),
	(8, 4,),
	(9, 4,),
	(10, 5,),
	(11, 6,),
	(12, 6,),
	(13, 6,),
	(14, 7,),
	(15, 7,),
	(16, 8,),
	(17, 8,),
	(18, 9,),
	(19, 10,),
	(20, 10,);

INSERT INTO DesignFile VALUES 
	(1, 1, 'bMV20SKq1YEmvEJ72S2p', '.svg'),
	(2, 2, 'isfh4PGq1W0ACB0xRdIT', '.zip'),
	(3, 3, 'Fx2S9DV0ocsEN5dZwygu', '.tar.xz'),
	(4, 4, '6WZqB38KjsQtOWW20YlR', '.rar'),
	(5, 5, 'MbHqAu3jRbEFgbFnlmym', '.svg'),
	(6, 6, 'GPTZXL4kLmpQGiWG0rnd', '.zip'),
	(7, 7, 'S81uvbeMRXVWNTzEnKAb', '.obj'),
	(8, 8, '4lOZ7Gy16RQCtN2fu277', '.svg'),
	(9, 9, 'lebzJReOnR2SKtGTjD7k', '.zip'),
	(10, 10, 'QFQbVDhjHtWMu3XMmE7k', '.tar.xz');
	
