# Questions-réponses cahier des charges

-----

### A - Relation client

1. **Comment souhaitez-vous accéder et obtenir notre logiciel ? Par mail ? Souhaitez-vous un accès à notre dépôt Github ?**
> On doit avoir les infos pour lancer su la machine (mode d'emploi)

1. **Doit-on vous présenter une ou plusieurs versions "Beta" de l'application ?**
> Pas de version intermédiaire, mais maquettes possibles

1. **Avez-vous des tests d'acceptation pour la version finale de l'application ou devons-nous les définir nous-mêmes ?**
> Non (pas de pièges)

1. **Doit-on utiliser rdoc pour la documentation du code ? Si oui doit-on vous fournir la rdoc en tant que livrable ?**
> 

1. **Quel est le public cible de l'application ?**
> Tout public

1. **Quel nom voulez-vous donner au logiciel ?**
> ???

1. **Dans quelles langues le logiciel devra-t-il être disponible ?**
> Internationalisation possible (prévu pour)

-----

### B - Règles et didacticiel

1. **Doit-on expliquer les règles dans l'application ou seulement en dehors avec le manuel utilisateur ?**
> Dans l'application

1. **Doit-il y avoir un niveau didacticiel pour les joueurs ne connaissant pas le jeu ? Si oui quelle serait la meilleure façon d'expliquer les règles ? (surligner des chiffres, masquer les autres, ...)**
> Oui

-----

### C - Génération des cartes

1. **Devra-t-il avoir des cartes par défaut dans le jeu, ou alors les cartes sont-elles générées aléatoirement ? Ou les deux ?**
> Il faut que ça représente quelque chose (satifsaction)
> Calcul difficulté ou grilles déjà classées

1. **Doit-on permettre la possibilité d'avoir plusieurs solutions pour une grille de Picross ?**
> Exlusion des grilles avec plusieurs solutions

1. **La grille une fois remplie doit-elle représenter quelque chose ?**
> Oui

-----

### D - Aide à la résolution du Picross

1. **Devra-t-il avoir plusieurs types d'aides ? Une aide précise qui indique la case à remplir, ou plutôt une indication sur la ligne ou une zone ?**
> 

1. **Le jeu devra-t-il indiquer les erreurs du joueur avant la fin ? Sinon, arrivé à la fin, le jeu proposera-t-il une aide pour trouver les erreurs ?**
> En fonction du mode de jeu (débutant oui, pas expert)
> A partir d'une erreur, le système le sait, pour ramennner le joueur à un endroit sans erreurs

1.  **Doit-il y avoir une limitation pour les aides ou l'utilisateur peut-il en utiliser autant qu'il le souhaite ?**
> Gagner des aides en obtenant des étoiles
> 
> Coefficient en fonction du mode d'aide
> Classement mode facile, classement moyen, difficile

-----

### E - IHM

1. **Avez-vous des préférences pour la couleur et la forme utilisée pour remplir les cases ? (croix, cercle, case pleine)**
> Carré
> Croix
> Interface claire, pas trop de choses à nous embeter
> Noircir une série de cases à la suite
> Cases grises d'Emeric, hypothèses imbriquées (changement de couleur des cases durant l'hypothèse), avec annulation d'une hypothèse
> Validation d'un hypothèse
> Affichage taille trait qu'on est en train de faire (numéros) et la taille globale du trait 

1. **Doit-on modifier l'affichage d'une ligne ou colonne si elle possède le bon nombre de cases validées ?**
> Of course, a voir en fonction de la solution ?
> Si plusieurs solutions, ne pas rayer

1. **Avez-vous des préférences pour la ou les tailles de grille ?**
> 

-----

### F - Partie

1. **Les parties doivent-elles être chronométrées ?**
> Oui

1. **Doit-on prévoir une pause en jeu (afin que le chrono ne défile pas) ?**
> Oui

1. **Voulez-vous qu'il soit possible de jouer uniquement au clavier, uniquement à la souris ou les deux ?**
> Oui, les deux, souris et clavier (intégralement l'une et l'autre), avec shift

1. **Le jeu devra-t-il comporter plusieurs niveaux de difficulté ?**
> Oui

-----

### G - Sauvegarde et partage


1. **Le joueur pourra-t-il poser des checkpoints pour revenir en arrière ? Il y aura-t-il des limitations (nombres, fréquences, ...) ?**
> 

1. **Voulez-vous un système qui sauvegarde la partie lorsque l'on clique sur un bouton ou une sauvegarde automatique qui sauvegarde après chaque action du joueur ?**
> Sauvegarde a chaque action

1. **Souhaitez-vous une méthode de sauvegarde des parties en particulier ? (l'utilisateur sauvegarde sa partie où il le souhaite, dans un dossier de l'application, dans une base de données, en ligne, ... ?)**
> Dans l'application

1. **Le joueur pourra-t-il partager une partie à d'autres joueurs (seed, fichier, ...) ?**
> /

-----

### H - Statistiques

1. **Voulez-vous qu'il y ait des statistiques propres à chaque partie (nombre de click, nombre de fautes, chrono, ...) ?**
> Nombre de changements sur une case
> 

1. **Voulez-vous qu'il y ait des statistiques propres à chaque utilisateur (tableau des scores, meilleurs temps, ...) ?**
> Niveaux de l'utilisateurs, étapes, 

Choix de la carte : aléatoire ou les unes à la suite des autres
Classés par ordre de difficulté, ou par taille, dans des packs de grilles
A la place d'un score : des étoiles en fonction du temps, réduit en fonction du nombre d'aides utilisées.
Pack possible avec un nombre d'étoiles atteint.

-----

### I - Fonctionnalité supplémentaire

1. **Le logiciel doit-il comporter un éditeur de cartes pour le joueur ? Si oui, comment peut-il créer des niveaux ? À partir d'une image, pixel par pixel, ou les deux ?**
> Bof / 20, secondaire
> Laisser la possibilité d'importer une grille, à voir pour faire le générateur après

1. **Peut-on réaliser un mode de jeu où la grille s'agrandit au fur et à mesure que le joueur la remplit ?**
> Oui, sur une mode spécial 