CREATE TABLE `User` (user_id int(10) NOT NULL AUTO_INCREMENT, registration_date timestamp NULL, pseudo varchar(255), start_date timestamp NOT NULL, PRIMARY KEY (user_id));
CREATE TABLE Channel (channel_id int(10) NOT NULL AUTO_INCREMENT, channel_name varchar(255) NOT NULL, channel_desc text, channel_approved tinyint(1) DEFAULT false NOT NULL, creation_date timestamp NOT NULL, PRIMARY KEY (channel_id));
CREATE TABLE Video (video_id int(10) NOT NULL AUTO_INCREMENT, name text NOT NULL, description text NOT NULL, maxquality varchar(255) NOT NULL, genre varchar(255) NOT NULL, duration int(10) NOT NULL, publishing_date timestamp NOT NULL, channel_id int(10) NOT NULL, PRIMARY KEY (video_id));
CREATE TABLE Videoview (videoview_id int(10) NOT NULL AUTO_INCREMENT, duration int(10) NOT NULL, interaction_id int(10) NOT NULL, previous_video_id int(10), PRIMARY KEY (videoview_id));
CREATE TABLE `Like` (like_id int(10) NOT NULL AUTO_INCREMENT, end_date timestamp NULL, interaction_id int(10) NOT NULL, PRIMARY KEY (like_id));
CREATE TABLE Comment (comment_id int(10) NOT NULL AUTO_INCREMENT, end_date timestamp NULL, content text NOT NULL, interaction_id int(10) NOT NULL, PRIMARY KEY (comment_id));
CREATE TABLE Subscription (subscription_id int(10) NOT NULL AUTO_INCREMENT, start_date timestamp NOT NULL, end_date timestamp NULL, channel_id int(10) NOT NULL, user_id int(10) NOT NULL, PRIMARY KEY (subscription_id));
CREATE TABLE Interaction (interaction_id int(10) NOT NULL AUTO_INCREMENT, start_date timestamp NOT NULL, user_id int(10) NOT NULL, video_id int(10) NOT NULL, PRIMARY KEY (interaction_id));
CREATE TABLE Pubview (pubview_id int(10) NOT NULL AUTO_INCREMENT, clicked tinyint(1) NOT NULL, interaction_id int(10) NOT NULL, publicite_id int(10) NOT NULL, platform text NOT NULL, PRIMARY KEY (pubview_id));
CREATE TABLE Publicite (publicite_id int(10) NOT NULL AUTO_INCREMENT, sponsored tinyint(1) NOT NULL, CPV float NOT NULL, CPC float NOT NULL, name text NOT NULL, brand text NOT NULL, PRIMARY KEY (publicite_id));
CREATE TABLE TopTenVideos (video_id int(10) NOT NULL, views int(10) NOT NULL, likes int(10) NOT NULL, comments int(10) NOT NULL);
CREATE TABLE DailyRevenue (revenue_date date NOT NULL, revenue_amount int(11) NOT NULL, PRIMARY KEY (revenue_date));
CREATE TABLE DailyDurationWatched (duration_date date NOT NULL, duration_amount int(11) NOT NULL, PRIMARY KEY (duration_date));
ALTER TABLE Video ADD INDEX FKVideo365235 (channel_id), ADD CONSTRAINT FKVideo365235 FOREIGN KEY (channel_id) REFERENCES Channel (channel_id);
ALTER TABLE Subscription ADD INDEX FKSubscripti491498 (channel_id), ADD CONSTRAINT FKSubscripti491498 FOREIGN KEY (channel_id) REFERENCES Channel (channel_id);
ALTER TABLE `Like` ADD INDEX FKLike744550 (interaction_id), ADD CONSTRAINT FKLike744550 FOREIGN KEY (interaction_id) REFERENCES Interaction (interaction_id);
ALTER TABLE Comment ADD INDEX FKComment541027 (interaction_id), ADD CONSTRAINT FKComment541027 FOREIGN KEY (interaction_id) REFERENCES Interaction (interaction_id);
ALTER TABLE Videoview ADD INDEX FKVideoview665103 (interaction_id), ADD CONSTRAINT FKVideoview665103 FOREIGN KEY (interaction_id) REFERENCES Interaction (interaction_id);
ALTER TABLE Interaction ADD INDEX FKInteractio614839 (user_id), ADD CONSTRAINT FKInteractio614839 FOREIGN KEY (user_id) REFERENCES `User` (user_id);
ALTER TABLE Interaction ADD INDEX FKInteractio432845 (video_id), ADD CONSTRAINT FKInteractio432845 FOREIGN KEY (video_id) REFERENCES Video (video_id);
ALTER TABLE Subscription ADD INDEX FKSubscripti903899 (user_id), ADD CONSTRAINT FKSubscripti903899 FOREIGN KEY (user_id) REFERENCES `User` (user_id);
ALTER TABLE Pubview ADD INDEX FKPubview961696 (publicite_id), ADD CONSTRAINT FKPubview961696 FOREIGN KEY (publicite_id) REFERENCES Publicite (publicite_id);
ALTER TABLE Videoview ADD INDEX FKVideoview447935 (previous_video_id), ADD CONSTRAINT FKVideoview447935 FOREIGN KEY (previous_video_id) REFERENCES Video (video_id);
ALTER TABLE Pubview ADD INDEX FKPubview8386 (interaction_id), ADD CONSTRAINT FKPubview8386 FOREIGN KEY (interaction_id) REFERENCES Interaction (interaction_id);
ALTER TABLE TopTenVideos ADD INDEX FKTopTenVide838386 (video_id), ADD CONSTRAINT FKTopTenVide838386 FOREIGN KEY (video_id) REFERENCES Video (video_id);