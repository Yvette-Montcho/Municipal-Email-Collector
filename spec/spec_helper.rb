# frozen_string_literal: true

# Cette ligne charge Bundler pour gérer les gems du projet pendant les tests.
require "bundler"

# Cette ligne charge toutes les gems du Gemfile.
Bundler.require

# Cette ligne ajoute le dossier lib au chemin de recherche Ruby.
$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

# Cette ligne charge la classe Scrapper que l'on veut tester.
require "app/scrapper"
