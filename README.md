# Rendu de projet BI - Youtube
Maxime Ghermaoui - Christophe Loeur - Vincent Salahkar - Maxence Aïci

## Modèle de données
![Modèle de données](https://github.com/mininao/BI-SQL-Homework/raw/master/DataModel.png)  
* Le modèle de données ci-dessus est disponible ici : [DataModel.png](https://github.com/mininao/BI-SQL-Homework/blob/master/DataModel.png)  
* Le modèle original a été créé avec le logiciel Visual Paradigm, le fichier source est [DataModel.vpp](https://github.com/mininao/BI-SQL-Homework/blob/master/DataModel.vpp)  
* Le script permettant de créer les tables et leur contraintes est [DataModel.sql](https://github.com/mininao/BI-SQL-Homework/blob/master/DataModel.sql)  

## Données de test
* Les données de test on été générées avec [Mockaroo](https://mockaroo.com), Permettant d'en créer autant que souhaité
* Nous avons tenté d'obtenir un maximum de cohérence dans ces données ainsi qu'un volume important pour pouvoir bien tester nos indicateurs.
* Les scripts sql créant chacune des tables sont dans le dossier [FakeData](https://github.com/mininao/BI-SQL-Homework/blob/master/FakeData)
* Un dump complet de la base de données est également disponible dans [dump.sql.gz](https://github.com/mininao/BI-SQL-Homework/blob/master/dump.sql.gz)

Voici la quantité de données ajoutées :

Table       | Lignes
------------|-------
Channel     |500
Comment     |1000
Interaction |10000
Like        |1000
Publicite   |40
Pubview     |3000
Subscription|2000
User        |1000
Video       |100
Videoview   |5000

## Indicateurs

1. [Indicateurs Simples](#indicateurs-simples)
  - [Vidéos les plus vues](#vidéos-les-plus-vues)
  - [Pubs qui poussent à cliquer](#pubs-qui-poussent-à-cliquer)
  - [Chaînes avec le plus d'abonnés](#chaînes-avec-le-plus-dabonnés)
2. [Indicateurs Moyens](#indicateurs-moyens)
  - [Vidéos les plus populaires](#vidéos-les-plus-populaires)
  - [Vidéos qui rapportent le plus d'argent](#vidéos-qui-rapportent-le-plus-dargent)
  - [Genre de vidéos qui poussent à les regarder en entier](#genre-de-vidéos-qui-poussent-à-les-regarder-en-entier)
3. [Indicateurs Difficiles](#indicateurs-difficiles)
  - [Vidéos les plus populaires avec pondération temporelle](#vidéos-les-plus-populaires-avec-pondération-temporelle)
  - [Chaines qui rapportent le plus d'argent](#chaines-qui-rapportent-le-plus-dargent)
  - [Chaines qui poussent à rester sur youtube](#chaines-qui-poussent-à-rester-sur-youtube)

### Indicateurs Simples

#### Vidéos les plus vues

```sql
SELECT Video.video_id, Video.name, COUNT(Videoview.videoview_id) AS Vues
FROM Videoview
INNER JOIN Interaction
INNER JOIN Video
WHERE Videoview.interaction_id = Interaction.interaction_id
AND Interaction.video_id = Video.video_id
AND Interaction.start_date BETWEEN date_sub(now(),INTERVAL 1 WEEK) AND now()
GROUP BY Video.video_id
ORDER BY Vues DESC, Video.name ASC
LIMIT 12;
```

#### Pubs qui poussent à cliquer

```sql
SELECT S1.publicite_id, S1.name, S2.Clics/S1.Vues AS Pourcentage
FROM (SELECT Publicite.name,Publicite.publicite_id, COUNT(Pubview.pubview_id) AS Vues
FROM Pubview
INNER JOIN Publicite
WHERE Pubview.publicite_id = Publicite.publicite_id
GROUP BY Pubview.publicite_id) AS S1
INNER JOIN (SELECT Publicite.name,Publicite.publicite_id, SUM(Pubview.clicked) AS Clics
FROM Pubview
INNER JOIN Publicite
WHERE Pubview.publicite_id = Publicite.publicite_id
GROUP BY Pubview.publicite_id) AS S2
WHERE S1.publicite_id = S2.publicite_id
GROUP BY S1.publicite_id
ORDER BY Pourcentage DESC
LIMIT 12;
```

#### Chaînes avec le plus d'abonnés

```sql
SELECT Channel.channel_id, Channel.channel_name, COUNT(Subscription.subscription_id) AS Subs
FROM Subscription
INNER JOIN Channel
WHERE Subscription.channel_id = Channel.channel_id AND Subscription.end_date IS NULL
GROUP BY Subscription.channel_id
ORDER BY Subs DESC, Channel.channel_name ASC
LIMIT 10;
```

### Indicateurs Moyens

#### Vidéos les plus populaires

```sql
SELECT S1.video_id, S1.name, ((3*S1.Comments + S2.Likes)*100/S3.`Views` + S3.`Views`) AS Popularite, S1.Comments, S2.Likes, S3.`Views`
FROM(SELECT Video.video_id, Video.name, COUNT(Comment.comment_id) AS Comments
FROM Comment
INNER JOIN Interaction
INNER JOIN Video
WHERE Comment.interaction_id = Interaction.interaction_id AND Interaction.video_id = Video.video_id AND Comment.end_date IS NULL
GROUP BY Interaction.video_id) AS S1

INNER JOIN(SELECT Video.video_id, Video.name, COUNT(`Like`.`like_id`) AS `Likes`
FROM `Like`
INNER JOIN Interaction
INNER JOIN Video
WHERE `Like`.interaction_id = Interaction.interaction_id AND Interaction.video_id = Video.video_id AND `Like`.end_date IS NULL
GROUP BY Interaction.video_id) AS S2

INNER JOIN (SELECT Video.video_id, Video.name, COUNT(Videoview.videoview_id) AS `Views`
FROM Videoview
INNER JOIN Interaction
INNER JOIN Video
WHERE Videoview.interaction_id = Interaction.interaction_id AND Interaction.video_id = Video.video_id
GROUP BY Interaction.video_id) AS S3

WHERE S1.video_id = S2.video_id AND S2.video_id = S3.video_id
ORDER BY Popularite DESC
LIMIT 12;
```

#### Vidéos qui rapportent le plus d'argent

```sql
Select Video.video_id,Video.name,
COUNT(S1.interaction_id) AS PubViews,
SUM(S1.clicked) AS PubClics,
AVG(S1.CPC) AS AverageCPC,
AVG(S1.CPV) AS AverageCPV,
SUM(Revenue) AS TotalRevenue
FROM
(Select Pubview.clicked, Publicite.CPV, Publicite.CPC, Pubview.interaction_id, (Publicite.CPV + Pubview.clicked * Publicite.CPC) AS Revenue
FROM Pubview
INNER JOIN Publicite
WHERE Pubview.publicite_id = Publicite.publicite_id) AS S1

INNER JOIN Interaction ON S1.interaction_id = Interaction.interaction_id
INNER JOIN Video ON Interaction.video_id = Video.video_id
GROUP BY Interaction.video_id
ORDER BY TotalRevenue DESC, Video.name ASC
LIMIT 10;
```

#### Genre de vidéos qui poussent à les regarder en entier

```sql
SELECT Video.genre,
AVG(Videoview.duration / Video.duration) AS AverageViewRatio,
AVG(Video.duration) AS AverageVideoDuration,
AVG(Videoview.duration) AS AverageViewDuration
FROM Videoview
INNER JOIN Interaction ON Videoview.interaction_id = Interaction.interaction_id
INNER JOIN Video ON Interaction.video_id = Video.video_id
GROUP BY Video.genre
ORDER BY AverageViewRatio DESC, Video.Genre ASC
LIMIT 10;
```

### Indicateurs Difficiles

#### Vidéos les plus populaires avec pondération temporelle

```sql
SELECT S1.video_id, S1.name, ((3*S1.FreshComments + S2.FreshLikes)*100/S3.FreshViews + S3.FreshViews) AS FreshPopularite, S1.FreshComments, S2.FreshLikes, S3.FreshViews
FROM(SELECT Video.video_id, Video.name, COUNT(Comment.comment_id) AS Comments,
SUM(GREATEST(
  TIMESTAMPDIFF(SECOND,Interaction.start_date,date_sub(now(),INTERVAL 1 MONTH))
/ TIMESTAMPDIFF(SECOND,now()                 ,date_sub(now(),INTERVAL 1 MONTH))
,0)) AS FreshComments
FROM Comment
INNER JOIN Interaction
INNER JOIN Video
WHERE Comment.interaction_id = Interaction.interaction_id AND Interaction.video_id = Video.video_id AND Comment.end_date IS NULL
GROUP BY Interaction.video_id) AS S1

INNER JOIN(SELECT Video.video_id, Video.name, COUNT(`Like`.like_id) AS Likes,
SUM(GREATEST(
  TIMESTAMPDIFF(SECOND,Interaction.start_date,date_sub(now(),INTERVAL 1 MONTH))
/ TIMESTAMPDIFF(SECOND,now()                 ,date_sub(now(),INTERVAL 1 MONTH))
,0)) AS FreshLikes
FROM `Like`
INNER JOIN Interaction
INNER JOIN Video
WHERE `Like`.interaction_id = Interaction.interaction_id AND Interaction.video_id = Video.video_id AND `Like`.end_date IS NULL
GROUP BY Interaction.video_id) AS S2

INNER JOIN (SELECT Video.video_id, Video.name, COUNT(Videoview.videoview_id) AS `Views`,
SUM(GREATEST(
  TIMESTAMPDIFF(SECOND,Interaction.start_date,date_sub(now(),INTERVAL 1 MONTH))
/ TIMESTAMPDIFF(SECOND,now()                 ,date_sub(now(),INTERVAL 1 MONTH))
,0)) AS FreshViews
FROM Videoview
INNER JOIN Interaction
INNER JOIN Video
WHERE Videoview.interaction_id = Interaction.interaction_id AND Interaction.video_id = Video.video_id
GROUP BY Interaction.video_id) AS S3

WHERE S1.video_id = S2.video_id AND S2.video_id = S3.video_id
ORDER BY FreshPopularite DESC
LIMIT 12;
```

#### Chaines qui rapportent le plus d'argent

```sql
Select Channel.channel_id, Channel.channel_name,
COUNT(S1.interaction_id) AS PubViews,
SUM(S1.sponsored) AS SponsoredPubViews,
SUM(S1.clicked) AS PubClics,
AVG(S1.CPC) AS AverageCPC,
AVG(S1.CPV) AS AverageCPV,
COUNT(DISTINCT Video.video_id) AS Videos,
SUM(Revenue) AS TotalRevenue
FROM
(Select Pubview.clicked,Publicite.sponsored, Publicite.CPV, Publicite.CPC, Pubview.interaction_id, (Publicite.CPV + Pubview.clicked * Publicite.CPC) AS Revenue
FROM Pubview
INNER JOIN Publicite
WHERE Pubview.publicite_id = Publicite.publicite_id) AS S1

INNER JOIN Interaction ON S1.interaction_id = Interaction.interaction_id
INNER JOIN Video ON Interaction.video_id = Video.video_id
INNER JOIN Channel ON Video.channel_id = Channel.channel_id
GROUP BY Channel.channel_id
ORDER BY TotalRevenue DESC, Video.name ASC
LIMIT 10;
```

#### Chaines qui poussent à rester sur youtube

```sql
SELECT Channel.channel_id, Channel.channel_name,
ViewCounter.Views,
COUNT(Videoview.videoview_id) AS CreatedViews,
GREATEST(1-(COUNT(Videoview.videoview_id)/ViewCounter.Views),0) AS BounceRate
FROM Videoview
INNER JOIN Video ON Videoview.previous_video_id = Video.video_id
INNER JOIN Channel ON Video.channel_id = Channel.channel_id

INNER JOIN
(SELECT Channel.channel_name, Channel.channel_id, COUNT(Videoview.videoview_id) AS `Views`
FROM Videoview
INNER JOIN Interaction ON Videoview.interaction_id = Interaction.interaction_id
INNER JOIN Video ON Interaction.video_id = Video.video_id
INNER JOIN Channel ON Video.channel_id = Channel.channel_id
GROUP BY Video.channel_id)
AS ViewCounter ON ViewCounter.channel_id = Channel.channel_id

GROUP BY Channel.channel_id
ORDER BY BounceRate ASC, Channel.channel_name ASC
LIMIT 10;
```
