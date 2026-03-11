# frozen_string_literal: true

# Cette ligne charge la configuration commune à tous les tests.
require "spec_helper"

# Cette ligne charge la bibliothèque standard permettant de créer un dossier temporaire.
require "tmpdir"

# Cette ligne charge la bibliothèque standard JSON afin de relire le fichier de test généré.
require "json"

# Cette ligne charge la bibliothèque standard CSV afin de relire le fichier de test généré.
require "csv"

# Ce bloc décrit la classe Scrapper que l'on souhaite tester.
RSpec.describe Scrapper do
  # Cette ligne crée une instance de Scrapper pour les tests.
  let(:scrapper) { described_class.new }

  # Cette ligne prépare un faux hash d'e-mails pour éviter de lancer un vrai scraping dans les tests.
  let(:fake_emails) do
    # Cette ligne renvoie un hash de test simple.
    {
      "ABLEIGES" => "mairie.ableiges95@wanadoo.fr",
      "AINCOURT" => "mairie.aincourt@wanadoo.fr"
    }
  end

  # Ce bloc s'exécute avant chaque test.
  before do
    # Cette ligne injecte nos fausses données dans l'instance testée.
    scrapper.instance_variable_set(:@emails, fake_emails)
  end

  # Ce test vérifie la sauvegarde JSON.
  it "sauvegarde les données dans un fichier JSON" do
    # Cette ligne crée un dossier temporaire pour le fichier de test.
    Dir.mktmpdir do |dir|
      # Cette ligne construit le chemin du fichier JSON temporaire.
      file_path = File.join(dir, "emails.json")

      # Cette ligne appelle la méthode à tester.
      scrapper.save_as_json(file_path)

      # Cette ligne relit le contenu du fichier JSON créé.
      parsed_json = JSON.parse(File.read(file_path))

      # Cette ligne vérifie que le contenu du fichier correspond à nos données de test.
      expect(parsed_json).to eq(fake_emails)
    end
  end

  # Ce test vérifie la sauvegarde CSV.
  it "sauvegarde les données dans un fichier CSV" do
    # Cette ligne crée un dossier temporaire pour le fichier de test.
    Dir.mktmpdir do |dir|
      # Cette ligne construit le chemin du fichier CSV temporaire.
      file_path = File.join(dir, "emails.csv")

      # Cette ligne appelle la méthode à tester.
      scrapper.save_as_csv(file_path)

      # Cette ligne relit tout le contenu du fichier CSV créé.
      rows = CSV.read(file_path, headers: true)

      # Cette ligne vérifie que la première ligne contient bien la première ville.
      expect(rows[0]["Ville"]).to eq("ABLEIGES")

      # Cette ligne vérifie que la première ligne contient bien le premier e-mail.
      expect(rows[0]["Email"]).to eq("mairie.ableiges95@wanadoo.fr")
    end
  end
end
