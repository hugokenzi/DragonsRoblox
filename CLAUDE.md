# DragonsRoblox

Jeu Roblox de collection de dragons. Le joueur vole sur son dragon-monture pour être le premier à récupérer des œufs, les fait éclore à sa base, et ses dragons rapportent de l'argent selon leur rareté.

## Documents de référence

- `BRIEF.md` : le brief complet du premier prototype (décisions de game design, spécifications, valeurs de départ, étapes). **C'est la source de vérité : lis-le avant toute tâche de développement.**
- Le document de conception général du jeu est un Google Doc tenu par l'utilisateur. En cas de contradiction entre une demande et `BRIEF.md`, demande à l'utilisateur.

## L'utilisateur

- Il débute en développement Roblox. Explique simplement, en français, ce que tu fais et pourquoi.
- Il teste dans Roblox Studio et te renvoie les erreurs de la console. Corrige la cause, pas le symptôme.
- Pose la question plutôt que de deviner quand une décision change le gameplay.
- Le jeu lui-même (interface, textes, annonces) est en **anglais**. Le code (variables, fonctions) est en anglais, les commentaires en français, et le chat avec lui reste en français.
- Après chaque modification, committe et pousse sur GitHub (https://github.com/hugokenzi/DragonsRoblox).

## Environnement

- Windows, PowerShell. Roblox Studio et VS Code sont installés.
- **Pas d'outil de synchronisation.** Le code source de référence vit dans `src/` (ce dépôt Git) ; l'utilisateur le copie-colle à la main dans Roblox Studio. Rojo a été essayé puis retiré (désinstallé le 7/10/2026) au profit de cette approche.
- Correspondance entre `src/` et l'explorateur Studio (dossiers à recréer une fois dans Studio, avec des `Folder`) :
  - `src/shared/*` → des `ModuleScript` dans un `Folder` nommé `Shared` sous `ReplicatedStorage`
  - `src/server/*` → sous un `Folder` nommé `Server` dans `ServerScriptService` (les sous-dossiers comme `Services/` sont aussi des `Folder`)
  - `src/client/*` → sous un `Folder` nommé `Client` dans `StarterPlayer.StarterPlayerScripts`
- Type d'instance et nom : `*.server.luau` → `Script` ; `*.client.luau` → `LocalScript` ; sinon → `ModuleScript`. Le nom de l'instance Studio = nom du fichier sans l'extension (`DataService.luau` → `DataService`).
- Quand un fichier est créé ou modifié, le dire clairement avec son chemin complet, pour que l'utilisateur sache où le coller dans Studio.

## Règles de code

- Luau, `--!strict` quand c'est raisonnable.
- Variables et fonctions en anglais, commentaires en français.
- Le serveur décide de tout ce qui touche à l'argent, aux œufs et aux dragons ; le client affiche et demande, le serveur vérifie.
- Tous les réglages chiffrés dans `src/shared/Config.luau`.
- API modernes (`LinearVelocity`, `AlignOrientation`), pas d'API dépréciées.
- Pas de modèles payants ni d'assets externes pour le prototype : formes simples remplaçables plus tard.

## État actuel

Voir `CHANGELOG.md` pour le détail à jour de ce qui est fait.
