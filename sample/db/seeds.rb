# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


ActiveRecord::Base.connection.execute('
CREATE TABLE `Post` (
  `id` mediumint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `body` varchar(255) DEFAULT NULL,
  `img` MEDIUMBLOB DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) 
')

ActiveRecord::Base.connection.execute('
CREATE TABLE `category` (
  `id` mediumint NOT NULL AUTO_INCREMENT,
  `postid` mediumint NOT NULL,
  `category` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) 
')

ActiveRecord::Base.connection.execute('
CREATE TABLE `admin` (
  `id` mediumint NOT NULL AUTO_INCREMENT,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) 
')


ActiveRecord::Base.connection.execute("
insert into admin
(password)
values
('password')
")

