#################### Lister les derniers fichiers maj dans une arborescence de dossiers

# Indiquer le lecteur à analyser
lecteur <- NULL

while (is_empty(lecteur))
{
  lecteur <- dlg_dir(default = getwd(), title = "Choisir le dossier à analyser")$res
}

# Récupérer la liste des fichiers
list_dossier <- list.files(path = lecteur,
                           full.names = TRUE,
                           recursive = TRUE) %>%
                           # Récupérer la date de modification
                           file.info() %>%
                           select(mtime)

# Modification du format de la date
list_dossier$mtime <- as_date(list_dossier$mtime)
  
# Création d'un dataframe avec le nom du chemin, le nom du fichier
list_dossier <- list_dossier %>%
                mutate(Chemin = dirname(row.names(list_dossier))) %>%
                mutate(Fichier = basename(row.names(list_dossier)))
  
# Suppression des noms de ligne
row.names(list_dossier) <- NULL
  
# Modification du nom des colonnes
colnames(list_dossier) <- c("Modif_F", "Chemin", "Fichier")

# Détection du dernier fichier maj par dossiers 
list_fichier <- list_dossier %>%
                group_by(Chemin) %>%
                summarize(Modif_F = max(Modif_F)) %>%
                filter(!is.na(mtime))
 
# Ajout du nom de fichier
list_fichier <- left_join(list_fichier, list_dossier) %>%
                # Regroupement par chemin et date de modification
                group_by(Chemin, Modif_F) %>%
                # Conservation de la première valeur identique
                slice(1) %>%
                ungroup()

# Séparation du chemin en morceaux (Lecteur, Dossier1, Dossier2...)
morceaux_chemin <- strsplit(list_fichier$Chemin, "/")

# Nombre maximum de morceaux (= nombre de colonnes)
nb_col <- max(sapply(morceaux_chemin, length))

# Création d'une matrice pour stocker les morceaux  
mat_morceaux <- matrix("",
                       nrow = length(morceaux_chemin),
                       ncol = nb_col)

# Remplissage de la matrice avec les morceaux
for (i in 1:length(morceaux_chemin))
{
  mat_morceaux[i, 1:length(morceaux_chemin[[i]])] <- morceaux_chemin[[i]]
}

# Conversion de la matrice en dataframe
mat_morceaux <- as.data.frame(mat_morceaux)

# Renommage des colonnes
colnames(mat_morceaux) <- c("Lecteur", paste("Dossier", seq_len(nb_col - 1), sep = "_"))

# Rassemblement des informations
list_fichier <- cbind(mat_morceaux,list_fichier)

# Export des données
write.table(list_fichier,
            file = "result/dernier_fichier_maj.csv",
            fileEncoding = "UTF-8",
            sep =";",
            row.names = FALSE)
