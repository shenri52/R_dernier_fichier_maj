# Script R : dernier_fichier_maj

Ce script permet de lister les derniers fichiers mis à jour pour chaque dossiers et sous-dossiers d'une arborescence définie.

## Descriptif du contenu

* Racine : emplacement du projet R --> "DERNIER_FICHIER_MAJ.Rproj"
* Un dossier "result" pour le stockage du résultat
* Un dosssier script qui contient :
  * prog_dernier_fichier_maj.R --> script principal
  * librairie.R --> script contenant les librairies utiles au programme
  * dernier_fichier_maj.R --> script listant les fichiers
  * suppression_gitkeep.R --> script de suppression des .gitkeep

## Fonctionnement

Lancer le script intitulé "prog_dernier_fichier_maj" qui se trouve dans le dossier "script"

## Résultat

Le tableau contenant la liste des derniers fichiers mis à jour se trouve dans le dossier "result" et se nomme "dernier_fichier_maj.csv".
