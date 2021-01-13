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
  CONSTRAINT chk_phone CHECK (PhoneNumber <= 12 AND PhoneNumber like '08[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
  CONSTRAINT chk_website CHECK (Website like '%.%')
);

CREATE TABLE UserPhoto(
  PhotoId  INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  UserId  INT(10) NOT NULL,
  PhotoName VARCHAR(48),
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
  Message VARCHAR(100),
  Timestamp DATETIME,
  StatusMessage ENUM ('Pending', 'Delivered', 'Success'),
  FOREIGN KEY (toUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (fromUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignCategories(
  CategoryId  INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  CategoryName VARCHAR(20),
  CategoryDesc TEXT
);

CREATE TABLE DesignSubCategories(
  SubCategoryId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  CategoryId INT(10) NOT NULL,
  SubCategoryName VARCHAR(64),
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
  isSold BOOLEAN,
  FOREIGN KEY (CategoryId) REFERENCES DesignCategories (CategoryId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (SubCategoryId) REFERENCES DesignSubCategories (SubCategoryId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (ThemeId) REFERENCES DesignTheme (ThemeId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (SupplierUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignLikeCount(
  LikeCountId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignId INT(10) NOT NULL,
  UserId INT(10) NOT NULL,
  Likes INT(10),
  FOREIGN KEY (DesignId) REFERENCES DesignHeader (DesignId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE UserInventory(
  InventoryId  INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  UserId  INT(10) NOT NULL,
  DesignId  INT(10) NOT NULL,
  DesignTransactionId INT(10) NOT NULL,
  DatePurchased DATETIME,
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
  TransactionDate DATETIME,
  ExpirationDate DATETIME,
  DateCreated DATETIME,
  FOREIGN KEY (DesignTransactionId) REFERENCES DesignTransactionHeader (DesignTransactionId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignDetails(
  DesignId INT(10) NOT NULL PRIMARY KEY,
  DesignName VARCHAR(64),
  DesignDesc TEXT,
  DesignPrice INT(10),
  DesignDateCreated DATETIME,
  FOREIGN KEY (DesignId) REFERENCES DesignHeader (DesignId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DesignPhotos(
  DesignPhotoId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignId INT(10) NOT NULL,
  DesignPhotoName VARCHAR(64),
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
  DesignFileName VARCHAR(20),
  DesignFileType VARCHAR(20),
  FOREIGN KEY (DesignId) REFERENCES DesignDetails (DesignId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ExpoEvent(
  ExpoEventId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  OrganizerUserId INT(10) NOT NULL,
  CategoryId INT(10) NOT NULL,
  DateHeld DATETIME,
  IsOnline BOOL,
  FOREIGN KEY (OrganizerUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (CategoryId) REFERENCES DesignCategories (CategoryId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ExpoTransactionHeader(
  ExpoTransactionId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  ExpoEventId INT(10) NOT NULL,   
  BuyerUserId INT(10) NOT NULL,
  IsSuccess BOOL,
  IsExpired BOOL,
  TransactionType ENUM('ovo','linkaja','dana'),
  TicketQty INT(10),
  FOREIGN KEY (ExpoEventId) REFERENCES ExpoEvent (ExpoEventId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (BuyerUserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT chk_ticketQty CHECK (TicketQty <= 10)
);

CREATE TABLE UserExpo(
  UserId INT(10) NOT NULL,
  ExpoEventId INT(10) NOT NULL,
  ExpoTransactionId INT(10) NOT NULL,
  DatePurchased DATETIME,
  FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (ExpoEventId) REFERENCES ExpoEvent (ExpoEventId) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (ExpoTransactionId) REFERENCES ExpoTransactionHeader(ExpoTransactionId) ON DELETE CASCADE ON UPDATE CASCADE
); 
  
CREATE TABLE ExpoTransactionDetails(
  ExpoTransactionId INT(10) NOT NULL,
  ExpoTransactionDate DATETIME,
  ExpoExpirationDate DATETIME,
  DateCreated DATETIME,
  FOREIGN KEY (ExpoTransactionId) REFERENCES ExpoTransactionHeader (ExpoTransactionId) ON DELETE CASCADE ON UPDATE CASCADE
);

 CREATE TABLE ExpoEventDetails(
   ExpoEventId INT(10) NOT NULL,
   ExpoEventTitle VARCHAR(32),
   ExpoEventPlace VARCHAR(32),
   ExpoEventLink VARCHAR(32),
   ExpoEventDesc TEXT,
   TicketQuota INT(10) Not NULL,
   TicketPrice INT(10) Not NULL,
   FOREIGN KEY (ExpoEventId) REFERENCES ExpoEvent (ExpoEventId) ON DELETE CASCADE ON UPDATE CASCADE,
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
  DesignerPrice INT(10),
  Rating INT(10),
  FOREIGN KEY (DesignerId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT chk_rating CHECK (Rating <= 5 AND Rating > 0)
);

CREATE TABLE DesignerRating(
  RatingId INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  DesignerId INT(10) NOT NULL,
  UserId INT(10) NOT NULL,
  Rating INT(10),
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
