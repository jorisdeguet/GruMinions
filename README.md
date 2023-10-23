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

## fonctionnement:
1. creer un groupe sur A
2. B decouvrir les pairs
3. sur B demande connect vers A
4. sur A Start Socket
5. sur B Connect Socket
6. sur A envoyer un message

Une fois connecté au groupe tu restes connectés,

Par contre repartir le socket à chaque fois

## Prép des tablettes

Pour chaque tablette on veut:
1. activer le mode développeur, Setting > about > taper 10 fois sur le build number
2. dans les options dév avectiver USB debugging et l'option stay awake
3. dans les options display, déselectionner adaptive brightness, mettre luminosité au max et mettre la veille à 30 minutes

## Problèmes déjà rencontrés

Si le minion a lui même un groupe, on dirait qu'il ne peut pas se connecter au socket de Gru

## Execution sur plusieurs appareils

C'est plus rapide de déployer en exécutant "flutter run -d all" depuis le terminal.

Pendant le dev, on peut faire hot reload sur tous en appuyant sur "r" dans le terminal

IL FAUT QUITTER L'APP SUR LES TABLETTES AVANT DE ROULER SINON ON A DES ERREURS DE DESINSTALLATION

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
