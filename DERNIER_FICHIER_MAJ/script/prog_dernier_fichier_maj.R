###########################################################################
# Ce script permet de lister les derniers fichiers  mis à jour pour       #
# chaque dossiers et sous dossiers d'une  arborescence                    #
###########################################################################
# Fonctionnement :                                                        #
#     Lancer le script intitulé "prog_dernier_fichier_maj" qui se         #
#     trouve dans le dossier "script"                                     #
#                                                                         #
# Résultat :                                                              #
# Le tableau contenant la liste des derniers fichiers mis à jour se       #
# trouve dans le dossier "result" et se nomme "dernier_fichier_maj.csv".  #
###########################################################################


#################### Chargement des librairies

source("./script/librairie.R")

#################### Suppression des fichiers gitkeep

source("script/suppression_gitkeep.R")

########## Lister le contenu de l'arborescence

source("./script/dernier_fichier_maj.R")
