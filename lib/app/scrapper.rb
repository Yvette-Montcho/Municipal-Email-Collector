# frozen_string_literal: true

# Cette ligne charge la bibliothèque standard pour lire et écrire du JSON.
require "json"

# Cette ligne charge la bibliothèque standard pour lire et écrire du CSV.
require "csv"

# Cette ligne charge la bibliothèque standard pour créer des dossiers si besoin.
require "fileutils"

# Cette ligne charge la bibliothèque standard pour ouvrir des URLs.
require "open-uri"

# Cette ligne charge la classe URI pour construire correctement des URLs absolues.
require "uri"

# Cette classe a pour rôle de scrapper les mairies du Val-d'Oise et de sauvegarder les résultats.
class Scrapper
  # Cette ligne crée un lecteur pour accéder à la variable @emails depuis l'extérieur de la classe.
  attr_reader :emails

  # Cette méthode est appelée automatiquement quand on fait Scrapper.new.
  def initialize
    # Cette ligne stocke l'URL de base du site des mairies.
    @base_url = "https://annuaire-des-mairies.com/"

    # Cette ligne stocke l'URL de la page listant les communes du Val-d'Oise.
    @department_url = "https://annuaire-des-mairies.com/val-d-oise.html"

    # Cette ligne initialise un hash vide qui contiendra le résultat final du scraping.
    @emails = {}
  end

  # Cette méthode récupère la liste des villes et l'URL de leur page mairie.
  def townhall_urls
    # Cette ligne ouvre la page du département et récupère son code HTML.
    html = URI.open(@department_url)

    # Cette ligne transforme le HTML brut en document analysable par Nokogiri.
    page = Nokogiri::HTML.parse(html)

    # Cette ligne sélectionne tous les liens qui possèdent un attribut href.
    all_links = page.css("a[href]")

    # Cette ligne garde uniquement les liens qui pointent vers une page de mairie du département 95.
    town_links = all_links.select { |link| link["href"].match?(%r{\A\.?/95/.+\.html\z}) }

    # Cette ligne prépare un hash vide pour associer chaque ville à son URL.
    results = {}

    # Cette boucle parcourt chaque lien de mairie trouvé sur la page du département.
    town_links.each do |link|
      # Cette ligne récupère le nom de la ville affiché dans le lien.
      city_name = link.text.strip

      # Cette ligne récupère l'URL relative présente dans le lien.
      relative_url = link["href"]

      # Cette ligne transforme l'URL relative en URL absolue complète.
      absolute_url = URI.join(@base_url, relative_url).to_s

      # Cette ligne ajoute dans le hash la ville comme clé et son URL comme valeur.
      results[city_name] = absolute_url
    end

    # Cette ligne renvoie le hash contenant les villes et leurs URLs.
    results
  end

  # Cette méthode récupère l'e-mail d'une mairie à partir de l'URL de sa page.
  def fetch_townhall_email(townhall_url)
    # Cette ligne ouvre la page de la mairie et récupère son HTML.
    html = URI.open(townhall_url)

    # Cette ligne transforme le HTML brut en document Nokogiri.
    page = Nokogiri::HTML.parse(html)

    # Cette ligne convertit toute la page en texte simple.
    page_text = page.text

    # Cette ligne cherche la première adresse e-mail présente dans le texte de la page.
    email_match = page_text.match(/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}/i)

    # Cette condition vérifie si un e-mail a bien été trouvé.
    if email_match
      # Cette ligne renvoie l'e-mail trouvé.
      email_match[0]
    else
      # Cette ligne renvoie nil si aucun e-mail n'a été trouvé.
      nil
    end
  end

  # Cette méthode principale lance le scraping complet du département.
  def perform
    # Cette ligne récupère la liste des villes et de leurs URLs.
    urls = townhall_urls

    # Cette boucle parcourt chaque couple ville / URL.
    urls.each do |city_name, townhall_url|
      # Cette ligne récupère l'e-mail de la mairie courante.
      email = fetch_townhall_email(townhall_url)

      # Cette ligne enregistre le résultat dans le hash final.
      @emails[city_name] = email
    end

    # Cette ligne renvoie le hash final pour permettre une réutilisation immédiate.
    @emails
  end

  # Cette méthode enregistre le résultat du scraping dans un fichier JSON.
  def save_as_json(file_path = "db/emails.json")
    # Cette ligne crée le dossier parent du fichier si ce dossier n'existe pas encore.
    FileUtils.mkdir_p(File.dirname(file_path))

    # Cette ligne convertit le hash @emails en JSON lisible et l'écrit dans le fichier.
    File.write(file_path, JSON.pretty_generate(@emails))
  end

  # Cette méthode enregistre le résultat du scraping dans un fichier CSV.
  def save_as_csv(file_path = "db/emails.csv")
    # Cette ligne crée le dossier parent du fichier si ce dossier n'existe pas encore.
    FileUtils.mkdir_p(File.dirname(file_path))

    # Cette ligne ouvre le fichier CSV en écriture et écrit aussi une ligne d'en-tête.
    CSV.open(file_path, "w", write_headers: true, headers: ["Ville", "Email"]) do |csv|
      # Cette boucle parcourt chaque couple ville / e-mail du hash.
      @emails.each do |city_name, email|
        # Cette ligne écrit une ligne dans le CSV avec la ville et l'e-mail correspondant.
        csv << [city_name, email]
      end
    end
  end

  # Cette méthode enregistre le résultat du scraping dans un Google Spreadsheet existant.
  def save_as_spreadsheet
    # Cette ligne récupère depuis le .env le chemin du fichier JSON du compte de service Google.
    service_account_path = ENV.fetch("GOOGLE_SERVICE_ACCOUNT_JSON")

    # Cette ligne récupère depuis le .env la clé du Google Spreadsheet cible.
    spreadsheet_key = ENV.fetch("GOOGLE_SPREADSHEET_KEY")

    # Cette ligne ouvre une session Google Drive à partir du fichier JSON du compte de service.
    session = GoogleDrive::Session.from_service_account_key(service_account_path)

    # Cette ligne ouvre le Google Spreadsheet à partir de sa clé.
    spreadsheet = session.spreadsheet_by_key(spreadsheet_key)

    # Cette ligne récupère la première feuille du Google Spreadsheet.
    worksheet = spreadsheet.worksheets.first

    # Cette ligne supprime le contenu actuel de la feuille pour repartir proprement.
    worksheet.clear

    # Cette ligne écrit l'en-tête de la première colonne.
    worksheet[1, 1] = "Ville"

    # Cette ligne écrit l'en-tête de la deuxième colonne.
    worksheet[1, 2] = "Email"

    # Cette ligne initialise un compteur de ligne à 2 pour commencer sous l'en-tête.
    row_index = 2

    # Cette boucle parcourt chaque couple ville / e-mail du hash.
    @emails.each do |city_name, email|
      # Cette ligne écrit le nom de la ville dans la colonne A.
      worksheet[row_index, 1] = city_name

      # Cette ligne écrit l'e-mail dans la colonne B.
      worksheet[row_index, 2] = email

      # Cette ligne passe à la ligne suivante dans le tableur.
      row_index += 1
    end

    # Cette ligne envoie réellement toutes les modifications au serveur Google.
    worksheet.save
  end
end
