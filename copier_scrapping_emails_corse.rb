	require 'google_drive'
	require 'rubygems'
	require 'open-uri'
	require 'nokogiri'
	require 'gmail'

#ouvrir session Google drive
=begin

session = GoogleDrive::Session.from_config("config.json")

#spécifier l'emplacement de la worksheet

$worksheet = session.spreadsheet_by_key("1ui3ErASlIMI2PFF8qH0ASCqy2fxrJ47zslI4lGbW_b4").worksheets[0]

#créer une colonne "adresse email" dans la worksheet

def set_worksheet
    $worksheet[1, 1] = "Adresse email"
    $worksheet.save
end

set_worksheet



# Récupérer les URL des sites internets de toutes les mairies du Val d'Oise et les mettre dans un tableau
def get_all_the_urls_of_haute_corse_townhalls()
		tableau = []
		page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/haute-corse.html"))
		links = page.css("a.lientxt")
		liste = links.each{|departement| tableau << 'http://annuaire-des-mairies.com/' + departement['href']}

		return tableau

end


#Récupérer l'email de la mairie dans une page donnée


def  get_the_email_of_a_townhall_from_its_webpage(page_url)
	page2 = Nokogiri::HTML(open(page_url))
	page2.css('p:contains("@")').each do |email|
	return email.text
	end

end

#assembler les 2
def get_all_emails()
	liste_emails = []
	tableau = get_all_the_urls_of_haute_corse_townhalls
 	liste_emails << tableau.each do |url|
	get_the_email_of_a_townhall_from_its_webpage(url) 
	end
	return liste_emails
end
liste_emails = []
tableau = get_all_the_urls_of_haute_corse_townhalls
tableau.each do |url|
liste_emails << get_the_email_of_a_townhall_from_its_webpage(url)
end



#mettre le tout dans la worksheet
	    counter = 2
    	liste_emails.each do |value|
        $worksheet[counter, 1] = value
        counter = counter + 1
        $worksheet.save
    end
=end
Gmail.connect('natacha.jurgensen', 'TheHackingProject') do |gmail|


gmail.deliver do
  to "nataliaagafonova@gmail.com"
  subject "J'envoie un email depuis mon terminal de commande"
  text_part do
    body "Bonjour,
Je m'appelle Natacha, je suis élève à une formation de code gratuite, ouverte à tous, sans restriction géographique, ni restriction de niveau. La formation s'appelle The Hacking Project (http://thehackingproject.org/). Nous apprenons l'informatique via la méthode du peer-learning : nous faisons des projets concrets qui nous sont assignés tous les jours, sur lesquel nous planchons en petites équipes autonomes. Le projet du jour est d'envoyer des emails à nos élus locaux pour qu'ils nous aident à faire de The Hacking Project un nouveau format d'éducation gratuite.

Nous vous contactons pour vous parler du projet, et vous dire que vous pouvez ouvrir une cellule localement, où vous pouvez former gratuitement 6 personnes (ou plus), qu'elles soient débutantes, ou confirmées. Le modèle d'éducation de The Hacking Project n'a pas de limite en terme de nombre de moussaillons (c'est comme cela que l'on appelle les élèves), donc nous serions ravis de travailler avec vous !

Charles, co-fondateur de The Hacking Project pourra répondre à toutes vos questions : 06.95.46.60.80"
  end
end


end

