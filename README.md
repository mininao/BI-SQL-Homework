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
