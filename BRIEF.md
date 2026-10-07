# Brief : premier prototype du jeu Roblox de dragons

Ce document s'adresse à une IA de développement. Il décrit le jeu, les décisions déjà prises et le premier prototype à réaliser. Lis-le en entier avant d'écrire du code.

## 1. Ton rôle

Tu développes un jeu Roblox avec moi. Je débute en développement Roblox : explique chaque étape simplement, en français.

- Avance **une étape à la fois** (section 9). À la fin de chaque étape, dis-moi précisément comment la tester dans Roblox Studio, puis attends mon retour avant de passer à la suivante.
- Si une règle de ce document est ambiguë ou si tu dois prendre une décision qui change le gameplay, **pose-moi la question** au lieu de deviner.
- Si une demande de ce document te semble mauvaise (technique ou gameplay), dis-le et propose mieux.
- Quand je te colle une erreur de la console, corrige la cause, pas seulement le symptôme.

## 2. Le jeu en bref

Un jeu de collection de dragons. On vole sur sa monture pour être **le premier à récupérer des œufs**, on les ramène à sa base où ils incubent, et les dragons éclos rapportent de l'argent selon leur rareté. Plus tard, l'argent sert à améliorer ses dragons et à atteindre des zones où se trouvent des œufs plus rares.

Inspirations : Steal An Egg (œufs, éclosion, revenus, base) et Ride A Pet (monture pour aller chercher des œufs plus loin). **Ce qui nous distingue : les dragons volent.** Zones en hauteur, courses aériennes, raccourcis par les airs. Le vol doit être agréable : c'est la priorité du ressenti.

## 3. Décisions déjà prises

Ces règles valent pour tout le projet, pas seulement le prototype.

| Sujet | Décision |
|---|---|
| Vol entre joueurs | **Aucun.** On ne peut pas voler les œufs ou les dragons des autres. La compétition, c'est la vitesse. |
| Œufs communs | **Personnels** : chaque joueur voit les siens, personne ne peut les lui prendre. |
| Œufs rares | **Partagés** : premier arrivé, premier servi. Leur apparition est annoncée à tout le serveur. Ils sont placés dans des endroits difficiles d'accès. |
| Raretés | Commun, Peu commun, Rare, Épique, Légendaire, Mythique, Secret. |
| Revenu | Plus un dragon est rare, plus il rapporte. Mutations et tailles multiplient le revenu. |
| Double rôle | Chaque dragon est à la fois **producteur** (revenu) et **monture** (vitesse, endurance). **La monture ne produit pas d'argent** pendant qu'elle est montée. |
| Accès aux zones | Dépend des **stats de la monture** : l'endurance décide jusqu'où et jusqu'à quelle hauteur on peut voler ; la vitesse décide si on ramène un œuf rare avant qu'il casse. |
| Éléments | Chaque zone donne des dragons de son élément, **pour l'instant purement visuel**. Les hybrides (fusion de deux éléments) viendront en V2. |
| Courses | Mixte, **pilotage d'abord** : les stats comptent, mais anneaux et obstacles décident. Catégories par niveau de monture. |
| Rebirth | Se gagne en réussissant une course solo. **Remet à zéro l'argent et l'arbre d'améliorations**, garde dragons, selles, plantation et Dragon-dex. Donne un multiplicateur d'argent et de vitesse. |
| Raid | Boss PvE : un dragon géant attaque, tout le serveur le combat. |
| Monnaie | Une seule : l'argent. |
| Serveurs | 10 à 16 joueurs. |

Les courses, le rebirth, le raid, l'arbre d'améliorations, les selles et les plantations **ne font pas partie du premier prototype**. Ils sont listés ici pour que ton architecture ne les rende pas difficiles à ajouter.

## 4. Objectif du premier prototype

Rendre jouable la **boucle de base**, dans une seule zone :

1. Je vole sur mon dragon-monture.
2. Je trouve un œuf et je le récupère.
3. Je le ramène à ma base et je le pose dans un incubateur.
4. Il éclot : rareté, mutation, taille.
5. Je pose le dragon sur un perchoir, il me rapporte de l'argent.
6. Je peux choisir un autre dragon comme monture ; il arrête alors de produire.
7. Je quitte le jeu, je reviens : tout est sauvegardé.

Le prototype est réussi si un joueur peut enchaîner cette boucle pendant 15 minutes sans bug bloquant, et si le vol est agréable.

## 5. Hors périmètre du prototype

Ne code pas encore : arbre d'améliorations, selles, plantations, nourriture, fusion, rebirth, courses, boosts x2, boosts de serveur, codes, gamepasses, achats Robux, trade, guildes, raid, familiers, événements météo, Dragon-dex, zones 2 et 3, gains hors ligne.

## 6. Cadre technique

- **Outils** : Roblox Studio + VS Code avec **Rojo**. Fournis le `default.project.json` et explique-moi comment installer et lancer Rojo la première fois.
- **Langage** : Luau, avec `--!strict` quand c'est raisonnable.
- **Noms** : variables et fonctions en anglais, **commentaires en français**.
- **Le serveur décide de tout** ce qui touche à l'argent, aux œufs et aux dragons. Le client affiche et envoie des demandes ; le serveur vérifie chaque demande (distance, possession, cooldown) avant d'agir.
- **Tous les réglages chiffrés dans un seul module de configuration** partagé, pour que je puisse équilibrer sans toucher au code.
- **Sauvegarde** avec DataStoreService : chargement à l'arrivée, sauvegarde à intervalles réguliers, au départ et à la fermeture du serveur (`BindToClose`), avec nouvelles tentatives en cas d'échec. Si tu préfères une bibliothèque reconnue (ProfileStore par exemple), propose-la et explique pourquoi.
- **API modernes** : `LinearVelocity` et `AlignOrientation`, pas `BodyVelocity` ni `BodyGyro`.
- **Pas de modèles payants** ni de dépendance à des assets externes : tout le visuel du prototype est construit en parties simples.
- **Commandes de test** actives uniquement dans Studio : me donner de l'argent, faire apparaître un œuf d'une rareté choisie, finir une incubation tout de suite.

Structure de dossiers suggérée (adapte si tu as mieux) :

```
src/
  shared/      -- configuration, types, fonctions utilitaires
  server/      -- services : données, œufs, base, dragons, monture
  client/      -- contrôles de vol, interface, affichage des œufs personnels
```

## 7. Spécifications du prototype

Les valeurs ci-dessous sont des **valeurs de départ** : mets-les toutes dans la configuration.

### 7.1 La zone 1 : forêt, montagne, lac

- Environ 512 × 512 studs, générée par script (terrain Roblox) ou construite une fois puis enregistrée dans le projet : propose la méthode la plus pratique avec Rojo.
- Une **forêt** autour du point d'apparition, une **montagne** haute (sommet enneigé vers 200 studs) dans un coin, un **lac** avec une rive en sable.
- Des endroits **difficiles d'accès** pour les œufs rares : sommet de la montagne, petites îles flottantes, corniches.
- Des murs invisibles aux limites et un plafond de vol.
- Élément de la zone : **Nature** (couleurs vertes et brunes pour les dragons de cette zone).

### 7.2 Le vol et la monture

- Touche **F** (et un bouton à l'écran pour mobile) pour monter sur son dragon et décoller, ou atterrir.
- Direction selon la caméra et les touches de déplacement ; **Espace** pour monter, **C** ou **Ctrl** pour descendre ; boutons ▲ ▼ sur mobile. Manette prise en charge si simple à faire.
- Le personnage est assis sur le modèle de son dragon-monture (forme simple, à la taille du dragon).
- **Endurance** : une barre à l'écran. Elle baisse en vol, remonte au sol. À zéro, le dragon se pose (descente planée, pas une chute brutale).
- Stats de monture selon la rareté du dragon (multipliées par la taille) :

| Rareté | Vitesse (studs/s) | Endurance max |
|---|---|---|
| Commun | 40 | 60 |
| Peu commun | 48 | 75 |
| Rare | 56 | 95 |
| Épique | 66 | 120 |
| Légendaire | 78 | 150 |
| Mythique | 90 | 185 |
| Secret | 100 | 230 |

- Consommation : 5 points d'endurance par seconde de vol, 8 en montée. Récupération au sol : 20 par seconde.
- Le sommet de la montagne doit être **inaccessible avec la monture de départ** et accessible avec une monture Rare ou mieux. Ajuste la consommation en montée pour que ce soit vrai.
- La vérification de base se fait côté client pour la fluidité, mais le serveur doit rejeter une vitesse ou une altitude manifestement impossibles.

### 7.3 Les œufs

**Œufs personnels**
- Chaque joueur a **3 œufs personnels** dans la zone en même temps, visibles par lui seul (affichés par son client, positions tirées et suivies par le serveur).
- Raretés possibles : Commun à Rare, avec les poids 60 / 28 / 12.
- Quand il en ramasse un, un autre apparaît ailleurs, à au moins 120 studs.

**Œufs rares partagés**
- Toutes les **3 minutes**, un œuf partagé apparaît à un endroit difficile d'accès, visible par tous.
- Raretés possibles : Épique à Secret, poids 70 / 22 / 6.5 / 1.5.
- Annonce à tout le serveur : « Un œuf Légendaire est apparu au sommet de la montagne ! »
- Le premier joueur qui le touche le prend. Un seul œuf partagé à la fois.

**Transporter un œuf**
- On porte **un seul œuf à la fois**, visible dans les mains ou sur le dragon.
- Les œufs **Épique et plus** ont un **minuteur** une fois ramassés : 75 secondes pour les ramener à la base, sinon ils cassent (et sont perdus). C'est ce qui donne de la valeur à la vitesse de la monture.
- Option « un obstacle percuté fait lâcher l'œuf » : code-la, mais **désactivée par défaut** dans la configuration.
- Chaque œuf est repérable de loin : faisceau lumineux de la couleur de sa rareté et nom affiché au-dessus.

### 7.4 La base

- Chaque joueur reçoit une **parcelle** au début de la partie (prévois autant de parcelles que de joueurs max), avec son nom affiché.
- Une parcelle contient **2 incubateurs** et **6 perchoirs**.
- Déposer l'œuf porté : s'approcher d'un incubateur libre et valider (ProximityPrompt).

### 7.5 Incubation et éclosion

- Durées (courtes pour le prototype) : Commun 10 s, Peu commun 20 s, Rare 40 s, Épique 60 s, Légendaire 90 s, Mythique 120 s, Secret 180 s.
- L'incubation continue même si le joueur se déconnecte (stocke l'heure de fin).
- À l'éclosion, le serveur tire :
  - **Mutation** : aucune 94 %, Or 4 % (revenu ×2), Diamant 1,5 % (×3), Arc-en-ciel 0,5 % (×5).
  - **Taille** : Petit 30 % (×0,8), Normal 55 % (×1), Grand 12 % (×1,5), Géant 3 % (×2,5). La taille multiplie le revenu, les stats de monture et la taille du modèle.
- Petite animation d'éclosion et message au joueur. Annonce au serveur pour Légendaire et plus, ou pour toute mutation Arc-en-ciel.

### 7.6 Les dragons et l'argent

- Revenu de base par seconde : Commun 1, Peu commun 3, Rare 8, Épique 20, Légendaire 50, Mythique 120, Secret 300.
- **Revenu = base × mutation × taille**, versé chaque seconde, uniquement pour les dragons posés sur un perchoir.
- Le dragon choisi comme monture **ne produit pas**, même s'il était sur un perchoir.
- Un **inventaire** simple : liste des dragons avec rareté, mutation, taille, revenu, stats de monture. Actions : poser sur un perchoir, retirer, choisir comme monture.
- Au premier lancement, le joueur reçoit un **dragon Commun de départ** déjà choisi comme monture.
- Affichage de l'argent en haut de l'écran, et revenu par seconde total.

**Modèles provisoires** : un dragon en parties simples (corps, tête, ailes, queue) coloré selon la rareté. Or = couleur dorée brillante, Diamant = matière vitrée, Arc-en-ciel = couleur qui change en boucle. Prévois un dossier où je pourrai plus tard déposer de vrais modèles par rareté, qui remplaceront automatiquement les formes provisoires.

### 7.7 Interface

Toute l'interface en français, lisible sur ordinateur et sur mobile :
- argent et revenu par seconde ;
- barre d'endurance ;
- bouton Voler / Atterrir ;
- œuf porté et minuteur restant ;
- notifications (œuf trouvé, éclosion, annonces du serveur) ;
- inventaire des dragons.

## 8. Données sauvegardées

Schéma de départ (propose des améliorations si besoin) :

```lua
{
  version = 1,
  money = 0,
  dragons = {
    -- [id] = { rarity = "Rare", mutation = "Or", size = "Grand", element = "Nature", createdAt = 0 }
  },
  perches = { nil, nil, nil, nil, nil, nil }, -- id du dragon posé sur chaque perchoir
  mountId = nil,                              -- id du dragon-monture
  incubators = {
    -- { rarity = "Épique", endsAt = 0 } ou nil
  },
}
```

Un champ `version` permet de migrer les sauvegardes quand on ajoutera des systèmes.

## 9. Étapes de réalisation

À chaque étape : liste des fichiers créés, où ils vont dans Studio via Rojo, et comment tester.

1. **Mise en place** : projet Rojo, module de configuration, sauvegarde des données, argent affiché.
2. **La zone 1** : terrain, forêt, montagne, lac, endroits difficiles d'accès, limites.
3. **Le vol** : monture provisoire, commandes, endurance, atterrissage plané.
4. **Les œufs** : œufs personnels, œuf partagé avec annonce, transport, minuteur des œufs rares.
5. **La base** : parcelles, incubateurs, dépôt de l'œuf, incubation qui continue hors ligne.
6. **L'éclosion et les dragons** : tirage mutation et taille, inventaire, perchoirs, revenu.
7. **Le double rôle** : choisir sa monture, stats selon le dragon, la monture ne produit plus.
8. **Finitions** : commandes de test, messages, vérifications côté serveur, test complet de la boucle.

## 10. Plus tard (pour ne pas bloquer l'architecture)

Après le prototype viendront, dans cet ordre probable : zones 2 et 3, arbre d'améliorations, selles, plantations, fusion d'étoiles, rebirth par course solo, courses toutes les 30 minutes, boosts x2 et boosts de serveur, codes, Dragon-dex, puis trade, raid boss, guildes, familiers et hybrides. Garde le code découpé en services indépendants pour que chacun de ces systèmes s'ajoute sans tout réécrire.
