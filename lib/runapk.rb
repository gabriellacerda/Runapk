require "runapk/version"
require 'tty-prompt'
require 'colorator'
require 'nokogiri'
require 'securerandom'
require "google_drive"

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

def publish_to_drive(session, file, name)
  file = session.upload_from_file("#{file}", "#{file}", convert: false)
  folder = session.collection_by_title("runapk")
  if folder.nil?
    session
      .root_collection.create_subcollection("runapk")
        .create_subcollection("deploy")
          .create_subcollection(name)
            .add(file)
    session.root_collection.remove(file)
    # Add folder permissions
    session.collection_by_title("runapk")
      .acl.push({type: "anyone", role: "reader", allow_file_discovery: true})
  else
    folder.delete(permanent = true)
    session
      .root_collection.create_subcollection("runapk")
        .create_subcollection("deploy")
          .create_subcollection(name)
            .add(file)
    session.root_collection.remove(file)
    # Add folder permissions
    session.collection_by_title("runapk")
      .acl.push({type: "anyone", role: "reader", allow_file_discovery: true})
  end

  share_url = session
                .collection_by_title("runapk")
                  .subcollection_by_title("deploy")
                    .subcollection_by_title(name)
                      .human_url()
  return share_url
end

def compiler(doc, mode, session)

  name = doc.at_css("name").content
  version = doc.at_css("widget").attribute('version')
  phrase_simple 'Nome do app: ' + name.blue
  phrase_simple 'Versão do app: ' + version
  phrase_simple ""
  app_name_export = "#{name}-#{version}-#{SecureRandom.hex(10)}"
  end_app_phrase = "O seu apk vai se chamar: ".white + "#{app_name_export}.apk, lembre-se ele vai ser enviado para o seu google drive...".blue
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

    phrase "Comprimindo app"
    cmd("(zipalign  -v 4 #{path} #{app_name_export}.apk)")
  else
    cmd("(mv #{path} #{app_name_export}.apk)")
  end

  share_url = publish_to_drive(session, "#{app_name_export}.apk", name)

  phrase_simple ""
  phrase_simple "Seu app está pronto!"
  phrase_simple "O nome do seu app é: #{app_name_export}.apk".green
  phrase_simple "Link compartilhável do Google Drive: #{share_url}".blue
  phrase_simple "Basta navegar a pasta raiz do seu projeto ionic"
  phrase_simple ""
  phrase_simple "Obrigado por utilizar o RunApk!".green
end

def compiler_en(doc, mode, session)

  name = doc.at_css("name").content
  version = doc.at_css("widget").attribute('version')
  phrase_simple 'App name: ' + name.blue
  phrase_simple 'App version: ' + version
  phrase_simple ""
  app_name_export = "#{name}-#{version}-#{SecureRandom.hex(10)}"
  end_app_phrase = "Your apk will be called: ".white + "#{app_name_export}.apk, note: your apk will be uploaded to your google drive".blue
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

    phrase "Compressing app"
    cmd("(zipalign  -v 4 #{path} #{app_name_export}.apk)")
  else
    cmd("(mv #{path} #{app_name_export}.apk)")
  end

  share_url = publish_to_drive(session, "#{app_name_export}.apk", name)

  phrase_simple ""
  phrase_simple "Your app is ready!"
  phrase_simple "Your app name is: #{app_name_export}.apk".green
  phrase_simple "Your app is stored here on google drive: /runapk/#{name}/#{app_name_export}.apk"
  phrase_simple "🍪 Google Drive share link: #{share_url}".blue
  phrase_simple ""
  phrase_simple ""
  phrase_simple "🍟 Thanks for using Runapk!".green
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
    phrase_simple '☁️  O suporte ao Google Drive chegou! Esperamos que você adore! ☁️'.cyan
    phrase_simple ""
    phrase_simple "Saudações! Agora o seu apk gerado é enviado automaticamente a sua conta do Google Drive, sem clicks adicionais, direto ao ponto!".blue
    phrase_simple ""
    phrase_simple "para tirar proveito deste novo recurso você precisa permitir que o Runapk tenha acesso a sua conta, isso só acontece uma vez...".blue
    phrase_simple ""
    phrase_simple "🍿🤩  E... Ao final do processo de compilação do seu apk você vai receber o link de compartilhamento dele para utilizar como quiser... É só isso, um grande abraço da equipe do Runapk!".blue
    phrase_simple ""
    phrase_simple "Caso você já tenha autorizado o runapk, ignore".magenta

    session = GoogleDrive::Session.from_config("config.json")

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
        compiler  @doc, 'dev', session
      else
        compiler @doc, 'prod', session
      end
    end
  else

    phrase_simple ""
    phrase_simple '☁️ Google Drive support has arrived! We hope you love it! ☁️'.cyan
    phrase_simple ""
    phrase_simple "Greetings! Now your generated apk is automatically sent to your Google Drive account, without additional clicks, to the point!".blue
    phrase_simple ""
    phrase_simple "to take advantage of this new feature you need to allow Runapk to access your account, this only happens once ...". blue
    phrase_simple ""
    phrase_simple "🍿🤩 And ... At the end of the process of compiling your apk you will receive the sharing link of it to use as you wish ... That's it, a big hug from the Runapk team!". blue
    phrase_simple ""
    phrase_simple "If you have already authorized runapk, ignore" .magenta

    session = GoogleDrive::Session.from_config("config.json")

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
