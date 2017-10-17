	require 'google_drive'
	require 'rubygems'
	require 'open-uri'
	require 'nokogiri'

#ouvrir session Google drive

session = GoogleDrive::Session.from_config("config.json")

#spécifier l'emplacement de la worksheet

$worksheet = session.spreadsheet_by_key("1cr2XsaPffaUiq3v8DZ2gWtuu2bDJ5dVDqJQQ9CC_aDg").worksheets[0]

#créer une colonne "adresse email" dans la worksheet

def set_worksheet
    $worksheet[1, 1] = "Adresse email"
    $worksheet.save
end

set_worksheet



# Récupérer les URL des sites internets de toutes les mairies du Val d'Oise et les mettre dans un tableau
def get_all_the_urls_of_val_doise_townhalls()
		tableau = []
		page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
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
	tableau = get_all_the_urls_of_val_doise_townhalls
 	liste_emails << tableau.each do |url|
	get_the_email_of_a_townhall_from_its_webpage(url) 
	end
	return liste_emails
end
liste_emails = []
tableau = get_all_the_urls_of_val_doise_townhalls
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