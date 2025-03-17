#################### Lister les derniers fichiers maj dans une arborescence de dossiers

# Choisir le lecteur à analyser
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

# Mettre en forme la liste des fichiers
list_dossier <- list_dossier %>%
                # Ajouter le chemin, le nom du fichier et la date de modification formatée
                mutate(Chemin = dirname(row.names(list_dossier)),
                       Fichier = basename(row.names(list_dossier)),
                       Modif_F = as_date(list_dossier$mtime)) %>%
                select(-mtime) %>%
                # Regrouper les données par chemin
                group_by(Chemin) %>%
                # Récupérer les fichiers ayant la date de modification la plus récente par chemin
                slice_max(Modif_F, n = 1, with_ties = FALSE) %>%
                ungroup()
  
# Séparer le chemin en morceaux (Lecteur, Dossier1, Dossier2...)
morceaux_chemin <- strsplit(list_dossier$Chemin, "/")

# Détecter le nombre de colonnes max à créer
nb_col <- max(lengths(morceaux_chemin))

# Créer une matrice pour stocker les morceaux  
mat_morceaux <- matrix("",
                       nrow = length(morceaux_chemin),
                       ncol = nb_col)

# Remplir la matrice avec les morceaux
for (i in 1:length(morceaux_chemin))
{
  mat_morceaux[i, 1:length(morceaux_chemin[[i]])] <- morceaux_chemin[[i]]
}

# Convertir la matrice en dataframe
mat_morceaux <- as.data.frame(mat_morceaux)

# Renommer les colonnes
colnames(mat_morceaux) <- c("Lecteur", paste("Dossier", seq_len(nb_col - 1), sep = "_"))

# Rassembler des informations
list_dossier <- cbind(mat_morceaux, list_dossier)

# Export des données
write.table(list_dossier,
            file = "result/dernier_fichier_maj.csv",
            fileEncoding = "UTF-8",
            sep =";",
            row.names = FALSE)
