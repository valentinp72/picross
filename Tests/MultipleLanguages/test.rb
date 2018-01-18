# définition du dico anglais
englishDico = Hash.new("Unknow")
englishDico["hello_txt"] = "Hello wolrd!"

# définition du dico français
frenchDico  = Hash.new("Inconnu")
frenchDico["hello_txt"] = "Bonjour le monde !"

spanishDico = Hash.new("Desconocido")
spanishDico["hello_txt"] = "¡Hola mundo!"

# on choisi le langage que l'on souhaite utiliser
#language = englishDico
#language = frenchDico
language = spanishDico

# notre application, on souhaite afficher le bonjour
print language["hello_txt"] + "\n"
