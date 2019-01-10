require "runapk/version"
require 'tty-prompt'
require 'colorator'
require 'nokogiri'

def cmd(cmd)
    IO.popen("#{cmd}").each do |line|
      puts line.chomp.magenta
    end
end

def phrase(phrase)
  puts
  puts phrase
  puts
end

def phrase_simple(phrase)
  puts phrase
end

def compiler(doc, mode)

  name = doc.at_css("name").content
  version = doc.at_css("widget").attribute('version')
  phrase_simple 'Nome do app: ' + name.blue
  phrase_simple 'Versão do app: ' + version
  phrase_simple ""
  app_name_export = name + '-' + version
  app_name_export = app_name_export.gsub!(/\s/, '')
  end_app_phrase = "O seu apk vai se chamar: ".white + "#{app_name_export}.apk".blue
  phrase_simple end_app_phrase

  case mode
  when 'dev'
    params = ''
    prod = false
  when 'prod'
    params = '--prod --release'
    prod = true
  end

  phrase 'Iniciando processo de build'

  cmd("(ionic cordova build android #{params})")

  phrase 'O seu apk foi buildado, no entanto para continuar você precisa informar o diretório do apk, ele esta acima, basta copia-lo e colar abaixo'.white

  phrase_simple 'É parecido com isso: Built the following apk(s): /Users/apk/path/apk.apk, copie essa linha e cole abaixo'.green
  phrase_simple ""

  prompt = TTY::Prompt.new

  path = prompt.ask("Localização do apk:")

  case mode
  when 'prod'
    phrase 'Agora informe a localização da sua keystore'.white
    keystore_path = prompt.ask("Localização da keystore:")

    phrase "Iniciando processo de assinatura do apk"
    cmd("(jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore #{keystore_path} #{path} alias_name)")
  end

  phrase "Comprimindo app"

  cmd("(zipalign  -v 4 #{path} #{app_name_export}.apk)")
  phrase_simple ""
  phrase_simple "Seu app está pronto!"
  phrase_simple "Basta navegar a pasta raiz do seu projeto ionic"
  phrase_simple ""
  phrase_simple "Obrigado por utilizar o RunApk!".green
end

def compiler_en(doc, mode)

  name = doc.at_css("name").content
  version = doc.at_css("widget").attribute('version')
  phrase_simple 'App name: ' + name.blue
  phrase_simple 'App version: ' + version
  phrase_simple ""
  app_name_export = name + '-' + version
  app_name_export = app_name_export.gsub!(/\s/, '')
  end_app_phrase = "Your apk will be called: ".white + "#{app_name_export}.apk".blue
  phrase_simple end_app_phrase

  case mode
  when 'dev'
    params = ''
    prod = false
  when 'prod'
    params = '--prod --release'
    prod = true
  end

  phrase 'Starting the build process'

  cmd("(ionic cordova build android #{params})")

  phrase 'Your apk has been build, however to continue you need to inform the apk directory, it is above, just copy it and paste it below'.white

  phrase_simple 'It looks like this: Built the following apk (s): /Users/apk/path/apk.apk, copy that line and paste it below'.green
  phrase_simple ""

  prompt = TTY::Prompt.new

  path = prompt.ask("Apk location:")

  case mode
  when 'prod'
    phrase 'Now enter the location of your keystore'.white
    keystore_path = prompt.ask("Keystore location:")

    phrase "Starting the apk signing process"
    cmd("(jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore #{keystore_path} #{path} alias_name)")
  end

  phrase "Compressing app"

  cmd("(zipalign  -v 4 #{path} #{app_name_export}.apk)")
  phrase_simple ""
  phrase_simple "Your app is ready!"
  phrase_simple "Just browse the root folder of your ionic project"
  phrase_simple ""
  phrase_simple "Thanks for using RunApk!".green
end


def setup()
  case ARGV[0]
    when 'skip'
      # phrase_simple 'Hey you want to skip, sure!'
  end

  phrase_simple ""
  phrase_simple "============================================".green + "".blue + "===========================".green + "".blue
  phrase_simple "==                                         ".green + "".blue + "                          ==".green + "".blue
  phrase_simple "==        GabrielLacerda presents:         ".green + "".blue + "          👩‍🚀 Runapk       ==".green + "".blue
  phrase_simple "==                                         ".green + "".blue + "                          ==".green + "".blue
  phrase_simple "============================================".green + "".blue + "===========================".green + "".blue
  phrase "Runapk is open source, if you'd like to help follow:\n".blue + "https://github.com/gabriellacerda/Runapk".green

  prompt = TTY::Prompt.new

  lang = prompt.select("🏳  Welcome Developer! for a better experience select your language:", ['Português Brasil', 'English'])

  case lang
  when 'Português Brasil'
    phrase_simple ""
    phrase_simple '👩‍🚀  Brr Dr, ei onde está o meu comp... 👩‍🚀'.white
    phrase_simple ""
    platform = prompt.select("👩‍🚀 Para qual plataform você deseja exportar?", %w(Android))
    phrase_simple ""
    type = prompt.select("👩‍🚀 Que tipo de apk você deseja?", ['Desenvolvimento (Build rápida, recomendado para testes locais)', 'Produção (Inclui todas as otimizações necessárias para exportar o app para a Play Store ou Apple Store) Se for para android, você vai precisar de uma keystore: https://runapk.page.link/keystore'])
    phrase_simple ""
    load_config = prompt.select("👩‍🚀 Eu não sei o nome e a versão do seu app, deseja que eu carregue eles do seu arquivo de configuração? É o config.xml a propósito...", ['É claro'])
    phrase_simple ""
    case load_config
    when 'É claro'
      @doc = Nokogiri::XML(File.open("config.xml"))
      case type
      when 'Desenvolvimento (Build rápida, recomendado para testes locais)'
        compiler  @doc, 'dev'
      else
        compiler @doc, 'prod'
      end
    end
  else
    phrase_simple ""
    phrase_simple '👩‍🚀  Brr Dr, where is my comp... 👩‍🚀'.white
    phrase_simple ""
    platform = prompt.select("👩‍🚀 For which plataform you want to export?", %w(Android))
    phrase_simple ""
    type = prompt.select("👩‍🚀 What kind of apk do you want?", ["Development (Fast build, recommended for local testing)", "Production (Includes all the optimizations needed to export the app to the Play Store or Apple Store) If it's for android, you'll need a keystore: https://runapk.page.link/keystore"])
    phrase_simple ""
    load_config = prompt.select("👩‍🚀 I don't know the name and version of your app, do you want me to load them from your configuration file? It's the config.xml file by the way ...", ['Sure'])
    phrase_simple ""
    case load_config
    when 'Sure'
      @doc = Nokogiri::XML(File.open("config.xml"))
      case type
      when 'Development (Fast build, recommended for local testing)'
        compiler_en  @doc, 'dev'
      else
        compiler_en @doc, 'prod'
      end
    end
  end
end

module Runapk
  setup()
end
