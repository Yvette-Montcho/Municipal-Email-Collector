# Scrapper des mairies du Val-d'Oise

## Présentation du projet

Ce projet a été réalisé en **Ruby** en respectant une logique de **Programmation Orientée Objet (POO)** et une **organisation de dossier propre**, comme demandé dans le rendu.

L'objectif principal est de :

1. **scrapper les e-mails des mairies du Val-d'Oise** depuis un site web ;
2. **stocker les résultats dans une structure de données Ruby** ;
3. **sauvegarder ces données dans trois formats différents** :
   - **JSON** ;
   - **CSV** ;
   - **Google Spreadsheet**.

Ce projet répond donc au double objectif pédagogique suivant :

- apprendre à **structurer un projet Ruby** de manière lisible et maintenable ;
- apprendre à **enregistrer des données** dans plusieurs formats exploitables.

---

## Objectifs pédagogiques couverts

À travers ce projet, plusieurs notions importantes sont mobilisées :

- la **POO en Ruby** ;
- la séparation du code dans des **fichiers ayant chacun une responsabilité claire** ;
- l'utilisation de **Bundler** pour gérer les dépendances ;
- l'utilisation de **Nokogiri** pour analyser du HTML ;
- l'écriture de fichiers **JSON** et **CSV** ;
- la connexion à un **Google Spreadsheet** via une API ;
- la mise en place de **tests RSpec** ;
- une structure de dossier propre permettant à n'importe qui de comprendre rapidement le projet.

---

## Ce que fait concrètement le programme

Lorsque le programme est lancé :

1. il ouvre la page du département du **Val-d'Oise** ;
2. il récupère les liens vers les pages des mairies ;
3. il visite chaque page de mairie ;
4. il extrait l'adresse e-mail trouvée sur la page ;
5. il enregistre le résultat final dans un **hash Ruby** de la forme suivante :

```ruby
{
  "ABLEIGES" => "mairie.ableiges95@wanadoo.fr",
  "AINCOURT" => "mairie.aincourt@wanadoo.fr"
}
```

6. il propose ensuite à l'utilisateur de choisir le format d'enregistrement :
   - JSON ;
   - CSV ;
   - Google Spreadsheet ;
   - ou les trois à la fois.

---

## Structure du projet

Le projet a été organisé de façon à respecter une structure Ruby lisible et cohérente.

```text
mon_projet_ruby_val_doise
├── lib
│   └── app
│       └── scrapper.rb
├── db
│   ├── emails.csv
│   └── emails.json
├── spec
│   ├── spec_helper.rb
│   └── scrapper_spec.rb
├── config
├── app.rb
├── README.md
├── Gemfile
├── .env.example
├── .gitignore
└── .rspec
```

---

## Rôle de chaque fichier et dossier

### `app.rb`
C'est le **point d'entrée** du programme.

Il sert à :

- charger les gems du projet avec Bundler ;
- charger les variables d'environnement ;
- charger la classe `Scrapper` ;
- lancer le scraping ;
- afficher un petit menu dans le terminal ;
- appeler la bonne méthode de sauvegarde selon le choix de l'utilisateur.

### `lib/app/scrapper.rb`
C'est le fichier principal du projet.

Il contient la classe `Scrapper`, qui centralise toute la logique métier du programme.

Cette classe contient plusieurs responsabilités bien identifiées :

- récupérer les URLs des mairies ;
- visiter les pages des mairies ;
- extraire les adresses e-mail ;
- conserver les résultats dans `@emails` ;
- sauvegarder les données en JSON ;
- sauvegarder les données en CSV ;
- sauvegarder les données dans Google Spreadsheet.

### `db/`
Ce dossier contient les **fichiers de sortie générés par le programme**.

On y retrouve :

- `emails.json` ;
- `emails.csv`.

Le dossier joue ici le rôle d'un petit espace de stockage local pour les données exportées.

### `spec/`
Ce dossier contient les **tests automatisés** réalisés avec **RSpec**.

Les tests présents vérifient notamment que :

- la méthode `save_as_json` crée un fichier JSON correct ;
- la méthode `save_as_csv` crée un fichier CSV correct.

### `Gemfile`
Il liste toutes les dépendances du projet, c'est-à-dire les gems nécessaires au fonctionnement.

### `.env.example`
Il fournit un modèle de variables d'environnement à compléter pour la partie Google Spreadsheet.

### `config/`
Ce dossier est prévu pour accueillir le fichier JSON du **service account Google**.

---

## Choix de conception

### 1. Une classe principale

Le projet repose sur une classe `Scrapper`.

Ce choix permet de regrouper dans un seul objet :

- les URLs de départ ;
- les méthodes de scraping ;
- les méthodes d'enregistrement ;
- l'état du programme via la variable `@emails`.

Cela rend le code plus lisible qu'un script écrit "en vrac" dans un seul fichier.

### 2. Une méthode par responsabilité

Le code a été séparé en plusieurs méthodes courtes :

- `townhall_urls` : récupère les liens des mairies ;
- `fetch_townhall_email` : récupère un e-mail depuis une page mairie ;
- `perform` : orchestre tout le scraping ;
- `save_as_json` : écrit le JSON ;
- `save_as_csv` : écrit le CSV ;
- `save_as_spreadsheet` : met à jour un Google Spreadsheet.

Ce découpage améliore :

- la lisibilité ;
- la réutilisabilité ;
- les tests ;
- la maintenance du projet.

### 3. Une séparation entre logique métier et exécution

La logique principale est placée dans `scrapper.rb`, tandis que `app.rb` s'occupe uniquement de :

- lancer le programme ;
- interagir avec l'utilisateur ;
- appeler les méthodes nécessaires.

Cette séparation est une bonne pratique en Ruby.

---

## Dépendances utilisées

Voici les gems utilisées dans le projet :

### `nokogiri`
Permet d'analyser le code HTML des pages web et d'en extraire des éléments.

### `dotenv`
Permet de charger automatiquement les variables définies dans le fichier `.env`.

### `google_drive`
Permet de se connecter à un Google Spreadsheet et d'y écrire les résultats.

### `rspec`
Permet d'écrire et d'exécuter les tests.

### Bibliothèques standard Ruby utilisées
Le projet utilise aussi des bibliothèques déjà intégrées à Ruby :

- `json` ;
- `csv` ;
- `fileutils` ;
- `open-uri` ;
- `uri`.

---

## Installation du projet

### 1. Cloner ou récupérer le projet

Place le dossier du projet sur ta machine.

### 2. Installer les dépendances

Dans le terminal, place-toi à la racine du projet puis lance :

```bash
bundle install
```

Cette commande installe toutes les gems listées dans le `Gemfile`.

### 3. Préparer le fichier `.env`

Copie le fichier d'exemple :

```bash
cp .env.example .env
```

Ensuite, tu pourras modifier le fichier `.env` si tu veux utiliser Google Spreadsheet.

---

## Lancer le programme

Pour exécuter le projet :

```bash
ruby app.rb
```

Le programme va alors :

1. lancer le scraping ;
2. récupérer les e-mails ;
3. afficher un menu ;
4. demander dans quel format sauvegarder les résultats.

---

## Menu utilisateur

Une fois le scraping terminé, un menu s'affiche dans le terminal :

```text
1 - Sauvegarder en JSON
2 - Sauvegarder en CSV
3 - Sauvegarder en Google Spreadsheet
4 - Sauvegarder dans les trois formats
```

Selon le choix saisi, le programme appellera la bonne méthode.

---

## Sauvegarde en JSON

La méthode `save_as_json` permet d'enregistrer les résultats dans le fichier :

```text
db/emails.json
```

Le fichier JSON est généré dans un format lisible grâce à `JSON.pretty_generate`.

### Exemple de contenu

```json
{
  "ABLEIGES": "mairie.ableiges95@wanadoo.fr",
  "AINCOURT": "mairie.aincourt@wanadoo.fr"
}
```

### Intérêt du format JSON

Le JSON est utile car :

- il est très répandu ;
- il est lisible par un humain ;
- il est facile à relire dans d'autres langages ;
- il représente naturellement un hash Ruby.

---

## Sauvegarde en CSV

La méthode `save_as_csv` permet d'enregistrer les résultats dans le fichier :

```text
db/emails.csv
```

Le fichier contient deux colonnes :

- `Ville` ;
- `Email`.

### Exemple de contenu

```csv
Ville,Email
ABLEIGES,mairie.ableiges95@wanadoo.fr
AINCOURT,mairie.aincourt@wanadoo.fr
```

### Intérêt du format CSV

Le CSV est utile car :

- il est simple ;
- il peut être ouvert dans Excel, LibreOffice ou Google Sheets ;
- il est très pratique pour représenter des tableaux.

---

## Sauvegarde dans Google Spreadsheet

La méthode `save_as_spreadsheet` permet d'envoyer les résultats dans un tableur Google.

Le programme :

1. lit les variables d'environnement ;
2. se connecte à Google via un **service account** ;
3. ouvre le Spreadsheet cible ;
4. vide la première feuille ;
5. écrit les colonnes `Ville` et `Email` ;
6. remplit une ligne par commune.

### Ce qu'il faut configurer

Pour que cette partie fonctionne, il faut :

1. créer un projet sur Google Cloud ;
2. activer l'API Google Sheets ;
3. créer un **service account** ;
4. télécharger le fichier JSON d'authentification ;
5. placer ce fichier dans le dossier `config/` ;
6. partager le Spreadsheet avec l'adresse e-mail du service account ;
7. compléter les variables du fichier `.env`.

### Exemple de `.env`

```env
GOOGLE_SERVICE_ACCOUNT_JSON=config/google_service_account.json
GOOGLE_SPREADSHEET_KEY=ta_cle_google_spreadsheet_ici
```

### Important

Les exports **JSON** et **CSV** fonctionnent sans configuration Google.

Seule la partie **Google Spreadsheet** nécessite une configuration externe.

---

## Fonctionnement interne du scraping

Le scraping suit les étapes suivantes :

### Étape 1 : récupération de la page du département
Le programme ouvre la page principale du Val-d'Oise.

### Étape 2 : extraction des liens vers les mairies
Avec Nokogiri, il sélectionne les balises HTML contenant des liens, puis il garde seulement celles qui correspondent aux pages des communes.

### Étape 3 : création d'un hash `ville => url`
Chaque ville est associée à l'URL de sa page mairie.

### Étape 4 : visite de chaque page mairie
Le programme ouvre ensuite chaque page individuellement.

### Étape 5 : extraction de l'e-mail
Le contenu texte de la page est analysé avec une expression régulière afin de repérer une adresse e-mail.

### Étape 6 : stockage des résultats
Les résultats sont enregistrés dans le hash d'instance `@emails`.

---

## Exemple de résultat en mémoire

Après exécution de `perform`, la variable `@emails` contient une structure de ce type :

```ruby
{
  "VILLE_1" => "email_1@exemple.fr",
  "VILLE_2" => "email_2@exemple.fr"
}
```

Cette structure sert ensuite de base aux trois méthodes d'export.

---

## Tests réalisés

Le projet contient des tests automatisés avec **RSpec**.

### Ce qui est testé

Les tests actuels vérifient :

- que le fichier JSON est bien créé avec le bon contenu ;
- que le fichier CSV est bien créé avec les bonnes colonnes et les bonnes valeurs.

### Lancer les tests

Dans le terminal :

```bash
bundle exec rspec
```

### Pourquoi ces tests sont utiles

Ils permettent de vérifier rapidement que les méthodes d'enregistrement fonctionnent correctement, sans relancer tout le scraping réel.

---

## Pourquoi le code est commenté ligne par ligne

Dans ce rendu, le choix a été fait de **commenter pratiquement chaque ligne importante du code**.

L'objectif est double :

- rendre le projet compréhensible pour une personne qui découvre Ruby ou la POO ;
- montrer précisément le rôle de chaque instruction dans le programme.

Cela permet à n'importe quel lecteur de suivre le cheminement du code sans difficulté.

---

## Points forts du projet

Ce projet présente plusieurs points positifs :

- une structure de dossier claire ;
- une logique orientée objet ;
- une séparation nette des responsabilités ;
- plusieurs formats d'export ;
- un menu simple pour l'utilisateur ;
- la présence de tests ;
- un code abondamment commenté pour faciliter la compréhension.

---

## Limites actuelles du projet

Comme tout projet pédagogique, celui-ci possède aussi quelques limites :

1. le scraping dépend de la structure HTML du site cible ;
2. si le site change, certaines méthodes devront être adaptées ;
3. la récupération de l'e-mail repose sur une expression régulière simple ;
4. il n'y a pas encore de gestion avancée des erreurs réseau ;
5. le Google Spreadsheet doit déjà exister avant l'exécution.

Ces limites sont normales pour un projet d'apprentissage.

---

## Améliorations possibles

Voici quelques pistes d'amélioration :

- ajouter une meilleure gestion des exceptions réseau ;
- afficher une barre de progression pendant le scraping ;
- créer plusieurs classes séparées (`Scrapper`, `Exporter`, `Menu`) ;
- ajouter davantage de tests (par exemple sur `perform`) ;
- permettre de choisir dynamiquement le département ;
- éviter de rescanner le site si les données sont déjà disponibles localement.

---

## Conclusion

Ce projet montre comment construire une **application Ruby simple mais propre**, en respectant les conventions de rangement vues en cours.

Il permet de mettre en pratique :

- la **POO** ;
- la structuration d'un projet Ruby ;
- le **web scraping** ;
- l'écriture de données dans plusieurs formats ;
- l'utilisation d'un **Google Spreadsheet** ;
- les bases des **tests automatisés**.

Le résultat final est un projet lisible, commenté, structuré et suffisamment détaillé pour qu'une autre personne puisse comprendre rapidement ce qui a été fait, comment cela fonctionne, et comment l'exécuter.

---

## Auteur

Projet réalisé dans le cadre d'un exercice de Ruby / POO / manipulation de fichiers de données.

Tu peux compléter cette section avec :

- ton nom ;
- la formation ;
- la date ;
- le nom exact du rendu demandé.
