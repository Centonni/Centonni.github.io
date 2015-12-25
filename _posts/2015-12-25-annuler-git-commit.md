---
layout: post
title: Git annuler un commit poussé vers une branche distante
date: "2015-12-25 20:25:02"
categories: [tutoriel]
tags: [git]
---
Il arrive parfois qu'après avoir poussé une branche locale sur un dépôt distant, on réalise qu'un des commits envoyés ne devrait pas être inclut ou que ce commit contient des erreurs.
Pas de panique, git offre la possibilité de rémédier à cela, mais il vaut mieux le faire le plus vite possible avant qu'un de vos collaborateurs ne récupère vos ajouts, sinon vous risquez de passer de très bonnes heures au sein de votre équipe ;)

Il existe plusieurs solutions pour résoudre ce problème, certaines permettant de garder l'historique de votre dépôt intact et d'autres permettant de le réécrire.

### Corriger l'erreur via un nouveau commit

Il s'agit là d'enlever ou modifier le fichier en question dans un nouveau commit et le pousser vers le dépôt distant. C'est le moyen le plus simple, le plus sûr et le plus intuitif pour résoudre ce genre d'erreurs sans risques. Le commit défectueux est toujours présent, mais cela ne devrait pas causer de soucis à moins que les fichiers inclus contiennent des informations sensibles.

### Annuler toutes les modifications du commit

Parfois, on peut vouloir annuler toutes les modifications effectuées dans un commit. Plutôt que de modifier chaque fichier (si on a plus de 100 fichier..la galère), on peut simplement annuler le commit. Cela se traduit en fait par la création d'un nouveau commit qui annule les changements qui ont été faits dans le commit dont on ne veut plus.
Comme dans le point précédent, le mauvais commit est toujours présent dans l'historique du dépôt mais il n'affecte plus le dépôt.

On utilise la commande suivante :

`git revert id_commit`

Soit

`git revert f606c743503d127`

### Supprimer le dernier commit
Pour supprimer définitivement un commit (le dernier dans notre cas) effectué, on utlise la commande `git reset` avec l'option `--hard` (qui permet de détruire, supprimer définitivement les fichiers, donc faire attention!). Soit :

`git reset HEAD^ --hard` et ensuite `git push` pour mettre à jour le dépôt distant.



`HEAD` utilisé avec `^` permet de déplacer la référence du pointeur de git qui se trouvait sur le dernier commit vers le commit parent.
