# -*- encoding: utf-8 -*-
require File.expand_path('../lib/runapk/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors = 'GabrielLacerda'
  gem.email = ['gabriellacerdadesign@gmail.com']
  gem.description = %q{RunApk comes to help when the problem is to export ionic apks}
  gem.summary = %q{RunApk export apks of ionic v1 & v3 apps!}
  gem.homepage = "https://gabriellacerda.github.io/Runapk"


  gem.files = `git ls-files`.split($\)
  gem.executables = ["runapk"]
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.name = "Runapk"
  gem.require_paths = ["lib"]
  gem.version = Runapk::VERSION
end
