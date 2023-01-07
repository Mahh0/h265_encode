$inputDir = "C:\Users\mahoa\Videos\Euro Truck Simulator 2"
$handbrakeCli = "handbrakecli"
$encoder = "x265"
$rate = "30"
$quality = "21"
$gpu = "0"
$logDir = "C:\Windows\Temp"

# Déplacement dans le dossier "C:\Users\mahoa\Videos\Euro Truck Simulator 2"
Set-Location "C:\Users\mahoa\Videos\Euro Truck Simulator 2"

# Récupération de la date et de l'heure actuelles
$date = Get-Date -Format "yyyy-MM-dd_HHmm"

# Création du nom du fichier de log
$logFile = "log_h265_$date.txt"

# DEBUG - Création du fichier de log pour les commandes HandbrakeCLI exécutées
New-Item -ItemType File -Path "C:\Windows\Temp\commands_$date.txt" -Force

# Initialisation du compteur de fichiers à encoder
$filesToEncode = 0
# Initialisation de la liste des fichiers à encoder
$filesToEncodeList = @()

# Initialisation du compteur de fichiers encodés avec succès
$filesEncoded = 0
# Initialisation de la liste des fichiers encodés avec succès
$filesEncodedList = @()

# Initialisation du compteur de fichiers à ne pas encoder
$filesToSkip = 0
# Initialisation de la liste des fichiers à ne pas encoder
$filesToSkipList = @()

# Récupération de la liste des fichiers vidéo mp4 dans le répertoire
$videoFiles = Get-ChildItem -Path $inputDir -Filter "*.mp4"

# Récupération de la taille du répertoire avant encodage
$originalSize = (Get-ChildItem $inputDir -Recurse | Measure-Object -Property Length -Sum).Sum

# Pour chaque fichier
foreach ($videoFile in $videoFiles) {
  # Si le nom du fichier ne contient pas "h265" ou "H265"
  if (!($videoFile.Name -match "h265") -and !($videoFile.Name -match "H265")) {
    # Incrémentation du compteur de fichiers à encoder
    $filesToEncode++

    # Ajout du fichier à la liste des fichiers à encoder
    $filesToEncodeList += $videoFile.Name

    # Chemin du fichier de sortie généré par HandbrakeCLI
    $outputFile = "$($videoFile.DirectoryName)\$($videoFile.BaseName)_h265.mp4"

    # DEBUG - Enregistrement de la commande HandbrakeCLI à exécuter dans le fichier de log
    "& $handbrakeCli --input '$videoFile' --output '$($videoFile.BaseName)_h265.mp4' -Z 'H.265 NVENC 1080p'" | Out-File -Append -FilePath "C:\Windows\Temp\commands_$date.txt"


    try {
      # Encodage du fichier en H265
      Invoke-Expression "& $handbrakeCli --input '$videoFile' --output '$($videoFile.BaseName)_h265.mp4' -Z 'H.265 NVENC 1080p'"

      if (Test-Path $outputFile) {
      # Incrémentation du compteur de fichiers encodés avec succès
      $filesEncoded++

      # Ajout du fichier encodé à la liste des fichiers encodés avec succès
      $filesEncodedList += $videoFile.Name

      # Suppression du fichier d'origine
      Remove-Item -Path $videoFile.FullName
      }

    } catch {
      # Si une erreur est survenue, incrémentation du compteur de fichiers non encodés.
      $filesNotEncoded++
      # Si une erreur est survenue, ajout du fichier à la liste des fichiers non encodés
      $filesNotEncodedList += $videoFile.Name
      continue
    }
  }
  else {
    # Incrémentation du compteur de fichiers à ne pas encoder
    $filesToSkip++

    # Ajout du fichier à la liste des fichiers à ne pas encoder
    $filesToSkipList += $videoFile.Name
  }
}

# Récupération de la taille du répertoire après encodage
$compressedSize = (Get-ChildItem $inputDir -Recurse | Measure-Object -Property Length -Sum).Sum

# Calcul de l'espace gagné
$savedSpace = $originalSize - $compressedSize

# Ecriture de l'entête de la log
"==============" | Out-File -FilePath "$logDir\$logFile"
"Début d'exécution le $((Get-Date).ToString())" | Out-File -Append -FilePath "$logDir\$logFile"
"==============" | Out-File -Append -FilePath "$logDir\$logFile"
"" | Out-File -Append -FilePath "$logDir\$logFile"

# Ecriture de la taille du répertoire avant encodage, de la taille du répertoire après encodage et de l'espace gagné
"Taille du dossier d'origine : $([math]::Round($originalSize / 1GB, 2)) Go" | Out-File -Append -FilePath "$logDir\$logFile"
"Taille du dossier après compression : $([math]::Round($compressedSize / 1GB, 2)) Go" | Out-File -Append -FilePath "$logDir\$logFile"
"Espace gagné : $([math]::Round($savedSpace / 1GB, 2)) Go" | Out-File -Append -FilePath "$logDir\$logFile"
"" | Out-File -Append -FilePath "$logDir\$logFile"

# Ecriture du nombre de fichiers présents et de la liste des fichiers présents
"Nombre de fichiers présents : $($videoFiles.Count)" | Out-File -Append -FilePath "$logDir\$logFile"
"Liste des fichiers présents :" | Out-File -Append -FilePath "$logDir\$logFile"

# Pour chaque fichier de la liste des fichiers présents
foreach ($videoFile in $videoFiles) {
  "$($videoFile.Name)" | Out-File -Append -FilePath "$logDir\$logFile"
}
"" | Out-File -Append -FilePath "$logDir\$logFile"

# Ecriture du nombre de fichiers à encoder et de la liste des fichiers à encoder
"Nombre de fichiers à encoder en H265 : $filesToEncode" | Out-File -Append -FilePath "$logDir\$logFile"
"Fichiers à encoder en H265 :" | Out-File -Append -FilePath "$logDir\$logFile"

# Pour chaque fichier de la liste des fichiers à encoder
foreach ($videoFile in $filesToEncodeList) {
  "$videoFile" | Out-File -Append -FilePath "$logDir\$logFile"
}
"" | Out-File -Append -FilePath "$logDir\$logFile"

# Ecriture du nombre de fichiers à ne pas encoder et de la liste des fichiers à ne pas encoder
"Nombre de fichiers à ne pas encoder : $filesToSkip" | Out-File -Append -FilePath "$logDir\$logFile"
"Fichiers à ne pas encoder :" | Out-File -Append -FilePath "$logDir\$logFile"

# Pour chaque fichier de la liste des fichiers à ne pas encoder
foreach ($videoFile in $filesToSkipList) {
  "$videoFile" | Out-File -Append -FilePath "$logDir\$logFile"
}
"" | Out-File -Append -FilePath "$logDir\$logFile"

# Ecriture de la fin de la log
"==============" | Out-File -Append -FilePath "$logDir\$logFile"
"Fin d'exécution le $((Get-Date).ToString())" | Out-File -Append -FilePath "$logDir\$logFile"
"==============" | Out-File -Append -FilePath "$logDir\$logFile"