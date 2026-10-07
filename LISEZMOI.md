# DragonsRoblox

Projet Roblox synchronisé avec Rojo. Le brief du prototype est dans `BRIEF.md`.

## Installation (une seule fois)

1. Télécharge Rokit pour Windows sur https://github.com/rojo-rbx/rokit/releases
   (fichier `rokit-...-windows-x86_64.zip`), décompresse-le.
2. Ouvre PowerShell dans le dossier décompressé et tape : `.\rokit.exe self-install`
3. Ferme et rouvre PowerShell, puis va dans ce dossier de projet :
   `cd $HOME\Documents\DragonsRoblox`
4. Installe Rojo : `rokit install`
5. Installe le plugin Rojo dans Roblox Studio : `rojo plugin install`

## À chaque session de travail

1. Dans PowerShell, dans ce dossier : `rojo serve`
2. Dans Roblox Studio, ouvre ton jeu, onglet **Plugins** > **Rojo** > **Connect**.
3. Lance le jeu (Play) : la console doit afficher « Serveur DragonsRoblox démarré »
   et « Client DragonsRoblox démarré ».

Le code se modifie dans le dossier `src` (avec VS Code ou ton IA de code) ;
Rojo l'envoie automatiquement dans Studio.
