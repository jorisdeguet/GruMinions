# vieux_pixels

## Principe

Le but est d'utiliser des vieilles tablettes pour faire un genre de mur interactif.

Le mode de communication est WiFi Direct. 

Une tablette principale agit comme contrôleur, on l'a appelé Gru.

Les autres tablettes sont en mode travailleurs, pour nous les minions.

Les tablettes peuvent s'identifier entre elles avec leurs adresses MAC.

Le but est de faire des jeux / expériences avec les primitives suivantes:
- les tablettes peuvent réagir au touché
- les tablettes peuvent afficher le miroir de leur camera
- prendre une photo
- émettre un son
- enregistrer un son

## Fonctionnement:

Le plus compliqué c'est de rouler l'application pour la première fois avec un nouveau Gru
1. s'assurer que toutes tablettes ont oublié tous les Wifi (A VERIFIER)
2. installer l'appli sur toutes les tablettes
3. appuyer sur le bouton Ask permission sur toutes les tablettes, 
  - verifier que Wifi on puis faire back
  - verifier que location on puis faire back
  - on devrait être sur l'appli, avec un dialogue ouvert approuver
4. lancer la tablette Gru en mode gru
5. un par un, prendre un minion et le lancer en mode minion
  - il devrait apparaitre un dialogue sur Gru pour accepter la connection 
  - si le minion ne se connecte pas au socket, revenir a accueil et repartir mode minion
  - jusqu'à connecté

## Prép des tablettes

Pour chaque tablette on veut:
1. activer le mode développeur, Setting > about > taper 10 fois sur le build number
2. dans les options dév avectiver USB debugging et l'option stay awake
3. dans les options display, déselectionner adaptive brightness, mettre luminosité au max et mettre la veille à 30 minutes

## Problèmes déjà rencontrés

Si le minion a lui même un groupe, on dirait qu'il ne peut pas se connecter au socket de Gru

### Une tablette ne voit pas Gru
1. fermer l'appli
2. désactiver le Wifi
3. activer le Wifi
4. repartir l'appli

Il semble que désactiver le wifi supprime complètement un éventuel groupe.

### Ne trouve pas la librairie quand on repointe vers le repo git

Il faut vider la cache de pub dans 
- \AppData\Local\Pub\Cache
- pubspeck.lock
- build
- .dart_tool

### si plein d'erreurs quand flutter run -d all
- ca peut être qu'un processus bloque la suppression du build
  - essayer de supprimer le dossier build
  - si ça marche pas, tuer toutes les taches java dans le task manager
  - repartir Android Studio et réessayer
- 

## Execution sur plusieurs appareils

C'est plus rapide de déployer en exécutant "flutter run -d all" depuis le terminal.

Pendant le dev, on peut faire hot reload sur tous en appuyant sur "r" dans le terminal

IL FAUT QUITTER L'APP SUR LES TABLETTES AVANT DE ROULER SINON ON A DES ERREURS DE DESINSTALLATION

