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
  DesignTransactionId  INT(10) NOT NULL,
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
  AssignedDate DATETIME,
  DeadlineDate DATETIME,
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
  (1, 'bellakia@gmail.com', 'bella545', '2021-01-12 19:19:49', 0, 1, 1),//designer
  (2, 'annastya@gmail.com', 'ann223', '2021-01-15 06:49:19', 1, 0, 0),
  (3, 'satriabagus11@gmail.com', 'satbagus110', '2021-01-06 13:23:48', 1, 1, 0), //suppllier
  (4, 'bagaskara47@gmail.com', 'bagas09', '2021-01-10 18:40:02', 0, 1, 0), //supplier
  (5, 'rahayuputri15@gmail.com', 'rara05', '2021/01/04 08:44:42', 0, 0, 0),
  (6, 'selaokta02@gmail.com', 'oktasela20', '2021/01/12 01:27:52', 0, 0, 0),
  (7, 'robbybagus@gmail.com', 'robbybgs92', '2021/01/09 15:14:46', 1, 1, 0), //supplier
  (8, 'ahmadsolihin24@gmail.com', 'ahmdsol123', '2021/01/01 22:11:40', 1, 1, 1), //designer
  (9, 'nurkhamidah10@gmail.com', 'khamidh98', '2021/01/11 01:15:24', 1, 1, 0), //supplier
  (10, 'zulfainji33@gmail.com', 'zulfainji27', '04/01/2021 11:54:21', 1, 0, 0),
  (11, 'ahmadqorni84@yahoo.com', 'ahmadqorni99', '10/01/2021 00:32:29', 0, 0, 0),
  (12, 'yutarotanaka48@gmail.com', 'yutyut99', '10/01/2021 00:05:13', 1, 0, 0),
  (13, 'felixfilipi69@gmail.com', 'filipi0000', '02/01/2021 07:07:15', 1, 0, 0),
  (14, 'wildo02@gmail.com', 'wildo914141', '13/01/2021 19:42:32', 1, 0, 0),
  (15, 'rizoct958@yahoo.com', '}:{:">P:}{:', '07/01/2021 02:50:33', 0, 0, 0),
  (16, 'raflijas@gmail.com', 'flii93883', '07/01/2021 02:50:33', 0, 0, 0),
  (17, 'marcus849@gmail.com', 'sammarcus123', '06/01/2021 22:37:20', 0, 1, 1), //designer
  (18, 'jarbud42@gmail.com', 'jarbud827', '08/01/2021 06:20:04', 1, 1, 1), //designer
  (19, 'ericco111@gmail.com', 'rico9182', '14/01/2021 13:15:01', 1, 1, 1),
  (20, 'dillaeka@yahooo.com', 'fadillaeka123', '07/01/2021 09:20:50', 1, 1, 1);
    
INSERT INTO UserInfo VALUES
  (1, 'Nabila Askiatus Syifa', 'Halo, saya adalah desainer profesional yang bertempat di daerah Malang', 'InterDesign.co', 'Lowokwaru, Malang', 'Interdesignco.co.id', '089428321458'), //designer
  (2, 'Dhea Annastasya', NULL, NULL, NULL, NULL, '081458928444'),
  (3, 'Satria Bagus', 'Saya mempunyai hobi membuat desain logo. Likes coffee, Lo-fi, and Jessica Veranda', NULL, ''), //supplier
  (4, 'Bagaskara', 'Amateur website designer from Bandung', 'makemakeweb', 'Bandung', NULL, '081992837897'), //supplier
  (5, 'Rahayu Putri Irwanti', NULL, NULL, NULL, NULL, '085827883123'),
  (6, 'Sela Okta Maulina', NULL, NULL, NULL, NULL, '089287773567'),
  (7, 'Robby Bagus', 'Makelar desain furnitur di grosirfurnitur.com', 'grosirFurnitur.inc', 'grosirfurnitur.com', '082834827998'), //supplier
  (8, 'Ahmad Solohin', 'Designer profesional yang berfokus pada DKV dan Desain Website', 'dkvheaven', 'dkvheaven.com', '089857273922'), //designer
  (9, 'Nur Khamidah', 'Mendesain busana adalah side job sayaaa', 'KhamidahBusana', NULL, '081428938848'), //supplier
  (10, 'Zulfa Inji Ilmana', NULL, NULL, NULL, NULL, '081472938472'),
  (11, 'Ahmad Qorni Zulkifli', NULL, NULL, NULL, NULL, '087432839132'),
  (12, 'Yutaro Tanaka', NULL, NULL, NULL, NULL, '081324221112'),
  (13, 'Felix Filipi', NULL, NULL, NULL, NULL, '089483221114'),
  (14, 'William Deovaldo', NULL, NULL, NULL, NULL, '082472832445'),
  (15, 'Rizki Octavian', NULL, NULL, NULL, NULL, '085837829441'),
  (16, 'Rafli Jaskandi', NULL, NULL, NULL, NULL, '081342332148');
  (17, 'Marcus Sitohang', 'Desainer busana profesionnal', 'busanaKuy.co', 'busanakuy.com', '086928321123'),
  (18, 'Fajar Budi', 'Desainer interior. Likes anime, babymetal, and cute', 'bangunRumah.inc', 'bangunrumah.com','089213458928'),
  (19, 'Errico Zaki', 'Desainer apa saja. Aremania', 'aremanialogo.inc', 'aremanialogo.com', '081234918231'),
  (20, 'Fadilla Eka', 'seorang desainer DKV bertempat di Jakarta', 'logomaker.com', 'logomaker.com','081777888332');
  
  
INSERT INTO UserPhoto VALUES
  (1, 1, 'UYZpVt.jpg'),
  (2, 2, 'yMlpSL.png'),
  (3, 3, 'kGfMlA.jpg'),
  (4, 4, 'UDCzQh.jpg'),
  (5, 5, 'Hd5mmC.jpg'),
  (6, 6, 'SNISma.png'),
  (7, 7, 'CbokxV.jpg'),
  (8, 8, 'YsWjl2.png'),
  (9, 9, 'uzarxA.png'),
  (10, 10, 'IGJE9x.png'),
  (11, 11, 'MTX3Bb.png'),
  (12, 12, 'B4Udwh.png'),
  (13, 13, '9LWuac.jpg'),
  (14, 14, 'pwVhOH.png'),
  (15, 15, 'NKHPm6.jpg'),
  (16, 16, 'BNRv3o.jpg'),
  (17, 17, 'lxO7pA.png'),
  (18, 18, 'MHQjer.png'),
  (19, 19, 'A3tUUM.png'),
  (20, 20, 'SLnZJK.jpg');
  
INSERT INTO UserFeedback VALUES
  (1, 15, 'fungsional website dapat lebih baik dan akurat lagi'),
  (2, 3, 'sistem chat mungkin dapat ditambahkan fitur penghapusan chat'),
  (3, 2, 'Website terkadang agak lambat, mungkin dapat dipercepat lagi'),
  (4, 6, 'Proses upload desain agak ribet dan lama, mungkin dapat diatur kembali prosesnya agar lebih efektif'),
  (5, 11, 'Tipe pembayaran mungkin dapat ditambahkan lagi'),
  (6, 3, 'Desain website kurang menarik, mungkin dapat ditingkatkan lagi'),
  (7, 9, 'Dapat ditambahkan report untuk desainer/supplier yang melanggar ketentuan'),
  (8, 16, 'Proses upload agak lambat, mungkin bisa dipercepat lagi'),
  (9, 4, 'ui/ux tidak efektif, mungkin dapat ditambah lagi keefektifannya'),
  (10, 2, 'dapat ditambahkan sistem rekomendasi sehingga publikasi desain mengena');
  
INSERT INTO ChatSystem VALUES
  (1, 8, 6, 'Hallo'),
  (2, 8, 6, 'Mau bertanya'),
  (3, 8, 6, 'iya, ada yang bisa saya bantu?'),
  (4, 8, 6, 'Apakah desain tipe ini dapat dibuat dengan bahan kayu jati?'),
  (5, 3, 14, 'Hallo, apa kabar?'),
  (6, 3, 14, 'Warna yang tersedia apa saja?'),
  (7, 8, 6, 'Maaf, sepertinya tidak bisa pak'),
  (8, 1, 2, 'Ada yang bisa saya bantu?'),
  (9, 1, 2, 'Pengrjaan berapa lama ya?'),
  (10, 3, 14, 'Untuk warna tersedia warna merah, biru, dan putih pak');
  
INSERT INTO DesignLikeCount VALUES
  (1, 8, 5, 1),
  (2, 4, 8, 1),
  (3, 2, 3, 1),
  (4, 1, 5, 1),
  (5, 9, 2, 1),
  (6, 7, 4, 0),
  (7, 4, 7, 0),
  (8, 3, 1, 1),
  (9, 1, 6, 1),
  (10, 10, 3, 1);
  
INSERT INTO UserInventory VALUES
  (1, 2, 7, 2, '10/01/2021 06:42:45'),
  (2, 13, 1, 3, '01/01/2021 03:02:12'),
  (3, 1, 2, 4, '04/01/2021 12:32:32'),
  (4, 5, 6, 6, '02/01/2021 23:32:11'),
  (5, 7, 3, 7, '06/01/2021 13:54:14'),
  (6, 8, 8, 9, '04/01/2021 13:53:36');
  
INSERT INTO DesignTransactionHeader VALUES
  (1, 5, 7, 0, 0, 'dana'),
  (2, 7, 2, 1, 0, 'linkaja'),
  (3, 1, 13, 1, 0, 'ovo'),
  (4, 2, 1, 1, 0, 'ovo'),
  (5, 10, 10, 0, 1, 'likaja'),
  (6, 6, 5, 1, 0, 'ovo'),
  (7, 3, 7, 1, 0, 'dana'),
  (8, 9, 16, 0, 0, 'dana'),
  (9, 8, 8, 1, 0, 'ovo'),
  (10, 4, 6, 0, 0, 'ovo');

INSERT INTO DesignerTransactionHeader VALUES //1,8,17,18,19,20,21,22,23,24
  (1, 17, 15, 0, 0, 'ovo'),
  (2, 8, 7, 1, 0, 'ovo'),
  (3, 1, 14, 1, 0, 'ovo'),
  (4, 19, 10, 1, 0, 'linkaja'),
  (5, 18, 2, 1, 0, 'dana'),
  (6, 20, 3, 0, 1, 'ovo');
    
INSERT INTO DesignerTransactionDetail VALUES
  (1, '2021-01-02 08:41:53', '2021-01-12 23:59:59', 0),
  (2, '2021-01-05 10:02:21', '2021-01-10 23:59:59', 0),
  (3, '2021-01-16 20:53:52', '2021-01-20 23:59:59', 1),
  (4, '2021-01-02 05:17:15', '2021-01-10 23:59:59', 1),
  (5, '2021-01-15 08:51:06', '2021-01-25 23:59:59', 0),
  (6, '2021-01-17 19:54:10', '2021-01-27 23:59:59', 0);
  
INSERT INTO DesignerInfo VALUES //1,8,17,18,19,20
  (1, '1200000', 4.2),
  (8, '1500000', 4.3),
  (17, '2600000', 4.8),
  (18, '2400000', 3.6),
  (19, '2000000', 4.2),
  (20, '1200000', 4.5); 
  
INSERT INTO DesignerRating VALUES //1,8,17,18,19,20
  (1, 8, 6, 3),
  (2, 17, 1, 5),
  (3, 20, 12, 5),
  (4, 20, 13, 4),
  (5, 1, 6, 5),
  (6, 17, 10, 3),
  (7, 19, 4, 4),
  (8, 19, 3, 3),
  (9, 1, 17, 3),
  (10, 20, 11, 4);
  
INSERT INTO UserExpo VALUES
  (19, 10, '17/01/2021 14:32:11'),
  (12, 9, '13/01/2021 08:14:45'),
  (13, 2, '20/01/2021 09:08:54'),
  (6, 9, '16/01/2021 04:45:13'),
  (17, 10, '15/01/2021 11:43:58'),
  (9, 6, '26/01/2021 07:10:06'),
  (6, 7, '09/01/2021 12:35:23'),
  (11, 1, '05/01/2021 23:44:08'),
  (11, 10, '17/01/2021 17:55:45'),
  (4, 1, '04/01/2021 15:12:34');
  
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
  (1, 1, 'Lightning'),
  (2, 1, 'Colorful'),
  (3, 2, 'Dark'),
  (4, 2, 'Valuable'),
  (5, 2, 'Japan'),
  (6, 3, 'White'),
  (7, 3, 'Oriental'),
  (8, 4, 'Dark'),
  (9, 4, 'Colouful'),
  (10, 5, 'Aqua'),
  (11, 5, 'Bronze'),
  (12, 5, 'Dark'),
  (13, 5, 'Colourful'),
  (14, 6, 'Cold'),
  (15, 7, 'Blue'),
  (16, 7, 'Green'),
  (17, 8, 'Cyberpunk'),
  (18, 9, 'Modern'),
  (19, 9, 'Country'),
  (20, 10, 'Modern'),
  (21, 10, 'Cyberpunk'),
  (22, 11, 'Wood'),
  (23, 12, 'Organic'),
  (24, 12, 'Vintage'),
  (25, 13, 'Country'),
  (26, 13, 'Javanese'),
  (27, 13, 'Eastern Indonesian'),
  (28, 14, 'Cool'),
  (29, 14, 'Charismatic'),
  (30, 14, 'Simple'),
  (31, 15, 'Professional'),
  (32, 16, 'Colourful'),
  (33, 17, 'Charming'),
  (34, 17, 'Winter'),
  (35, 17, 'Lightning'),
  (36, 18, 'Spring'),
  (37, 19, 'Snow'),
  (38, 20, 'Solarized'),
  (39, 20, 'Green'),
  (40, 20, 'Bootstrap'),
  (41, 21, 'Awesome'),
  (42, 21, 'Simple'),
  (43, 21, 'No Borders'),
  (44, 22, 'Elegant');
	
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
  (1, 1, 'Ukuran panjang dimensi', '140cm'),
  (2, 1, 'Ukuran lebar dimensi', '124cm'),
  (3, 1, 'Ukuran tinggi dimensi', '450cm'),
  (4, 2, 'Versi HTML', '5'),
  (5, 2, 'CSS framework', 'Bootstrap'),
  (6, 3, 'Ukuran brosur', '80x45 cm'),
  (7, 4, 'CSS framework', 'Materialize'),
  (8, 4, 'Font framework', 'FontAwesome'),
  (9, 4, 'Versi HTML', '5'),
  (10, 5, 'CSS framework', 'Bootstrap'),
  (11, 6, 'Ukuran panjang poster', '80cm'),
  (12, 6, 'Ukuran lebar poster', '50cm'),
  (13, 6, 'Bahan ideal poster', 'kertas'),
  (14, 7, 'Ukuran panjang lantai', '8m'),
  (15, 7, 'Ukuran lebar lantai', '7m'),
  (16, 8, 'Ukuran panjang x lebar x tinggi dimensi', '80cm x 80cm x 100cm'),
  (17, 8, 'Bahan dasar desain', 'kayu mahoni, sutera'),
  (18, 9, 'Frontend Framework', 'VueJS'),
  (19, 10, 'Ukuran panjang kartu', '12cm'),
  (20, 10, 'Ukuran lebar kartu', '8cm');

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
