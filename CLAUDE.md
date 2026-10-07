# DragonsRoblox

Jeu Roblox de collection de dragons. Le joueur vole sur son dragon-monture pour être le premier à récupérer des œufs, les fait éclore à sa base, et ses dragons rapportent de l'argent selon leur rareté.

## Documents de référence

- `BRIEF.md` : le brief complet du premier prototype (décisions de game design, spécifications, valeurs de départ, étapes). **C'est la source de vérité : lis-le avant toute tâche de développement.**
- Le document de conception général du jeu est un Google Doc tenu par l'utilisateur. En cas de contradiction entre une demande et `BRIEF.md`, demande à l'utilisateur.

## L'utilisateur

- Il débute en développement Roblox. Explique simplement, en français, ce que tu fais et pourquoi.
- Il teste dans Roblox Studio et te renvoie les erreurs de la console. Corrige la cause, pas le symptôme.
- Avance une étape du brief à la fois. À la fin de chaque étape : dis ce qui a changé, comment tester dans Studio, puis attends son retour.
- Pose la question plutôt que de deviner quand une décision change le gameplay.

## Environnement

- Windows, PowerShell. Roblox Studio et VS Code sont installés.
- Synchronisation du code avec **Rojo 7.7.0**, installé via **Rokit** (`rokit.toml` à la racine).
- Projet Rojo : `default.project.json`.
  - `src/shared` → `ReplicatedStorage.Shared`
  - `src/server` → `ServerScriptService.Server`
  - `src/client` → `StarterPlayer.StarterPlayerScripts.Client`
- Fichiers en `.luau` : `*.server.luau` pour les scripts serveur, `*.client.luau` pour les scripts joueur, sinon ModuleScript.

## Installation restant à faire (première session)

Rien n'est encore installé côté outils. Si `rojo --version` échoue :

1. Installer Rokit (https://github.com/rojo-rbx/rokit). Sur Windows : télécharger la dernière release `windows-x86_64.zip`, la décompresser, puis `.\rokit.exe self-install`. Un nouveau terminal est nécessaire ensuite pour que `rokit` soit dans le PATH.
2. Dans ce dossier : `rokit install` (installe Rojo d'après `rokit.toml`).
3. `rojo plugin install` (plugin Rojo dans Roblox Studio ; Studio doit être redémarré s'il était ouvert).
4. Vérifier avec `rojo --version`, puis expliquer à l'utilisateur comment lancer `rojo serve` et cliquer sur **Plugins > Rojo > Connect** dans Studio.

Demande à l'utilisateur avant de télécharger ou d'installer quoi que ce soit.

## Règles de code

- Luau, `--!strict` quand c'est raisonnable.
- Variables et fonctions en anglais, commentaires en français.
- Le serveur décide de tout ce qui touche à l'argent, aux œufs et aux dragons ; le client affiche et demande, le serveur vérifie.
- Tous les réglages chiffrés dans `src/shared/Config.luau`.
- API modernes (`LinearVelocity`, `AlignOrientation`), pas d'API dépréciées.
- Pas de modèles payants ni d'assets externes pour le prototype : formes simples remplaçables plus tard.

## État actuel

- Projet Rojo créé, avec des scripts de démarrage vides (`Main.server.luau`, `Main.client.luau`, `Config.luau`).
- Aucune étape du brief n'est encore réalisée. Prochaine étape : installation des outils, puis étape 1 du brief.
