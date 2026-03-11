# frozen_string_literal: true

# Cette ligne charge Bundler pour gérer automatiquement les gems du Gemfile.
require "bundler"

# Cette ligne demande à Bundler de charger toutes les gems du Gemfile.
Bundler.require

# Cette ligne charge automatiquement les variables d'environnement du fichier .env.
Dotenv.load

# Cette ligne ajoute le dossier lib au chemin de recherche des fichiers Ruby.
$LOAD_PATH.unshift(File.expand_path("lib", __dir__))

# Cette ligne charge la classe Scrapper située dans lib/app/scrapper.rb.
require "app/scrapper"

# Cette ligne crée une nouvelle instance de la classe Scrapper.
scrapper = Scrapper.new

# Cette ligne lance le scraping et récupère les e-mails des mairies.
scrapper.perform

# Cette ligne affiche un titre dans le terminal.
puts "\n=== SCRAPPER DES MAIRIES DU VAL-D'OISE ==="

# Cette ligne affiche le nombre d'e-mails récupérés.
puts "#{scrapper.emails.count} e-mails ont été récupérés."

# Cette ligne affiche un menu pour laisser l'utilisateur choisir le format de sauvegarde.
puts "\nChoisis le format d'enregistrement :"

# Cette ligne propose l'option JSON.
puts "1 - Sauvegarder en JSON"

# Cette ligne propose l'option CSV.
puts "2 - Sauvegarder en CSV"

# Cette ligne propose l'option Google Spreadsheet.
puts "3 - Sauvegarder en Google Spreadsheet"

# Cette ligne propose l'option d'enregistrer dans tous les formats.
puts "4 - Sauvegarder dans les trois formats"

# Cette ligne demande le choix de l'utilisateur.
print "> "

# Cette ligne lit ce que l'utilisateur tape dans le terminal.
choice = gets.chomp

# Cette structure choisit l'action à exécuter selon la réponse de l'utilisateur.
case choice
# Ce cas enregistre uniquement au format JSON.
when "1"
  # Cette ligne appelle la méthode qui enregistre les données en JSON.
  scrapper.save_as_json
  
  # Cette ligne confirme la sauvegarde dans le terminal.
  puts "Le fichier JSON a bien été créé dans db/emails.json"
# Ce cas enregistre uniquement au format CSV.
when "2"
  # Cette ligne appelle la méthode qui enregistre les données en CSV.
  scrapper.save_as_csv
  
  # Cette ligne confirme la sauvegarde dans le terminal.
  puts "Le fichier CSV a bien été créé dans db/emails.csv"
# Ce cas enregistre uniquement dans Google Spreadsheet.
when "3"
  # Cette ligne appelle la méthode qui enregistre les données dans Google Spreadsheet.
  scrapper.save_as_spreadsheet
  
  # Cette ligne confirme la sauvegarde dans le terminal.
  puts "Le Google Spreadsheet a bien été mis à jour."
# Ce cas enregistre dans les trois formats.
when "4"
  # Cette ligne enregistre les données en JSON.
  scrapper.save_as_json
  
  # Cette ligne enregistre les données en CSV.
  scrapper.save_as_csv
  
  # Cette ligne enregistre les données dans Google Spreadsheet.
  scrapper.save_as_spreadsheet
  
  # Cette ligne confirme la sauvegarde complète.
  puts "Les sauvegardes JSON, CSV et Spreadsheet ont bien été effectuées."
# Ce cas gère les choix non prévus.
else
  # Cette ligne affiche un message d'erreur si le choix est invalide.
  puts "Choix invalide : relance le programme et tape 1, 2, 3 ou 4."
end
