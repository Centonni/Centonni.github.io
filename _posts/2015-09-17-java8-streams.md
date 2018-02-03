---
layout: post
title: Un aperçu sur les Streams de java 8
date: "2015-09-17 05:50:27"
categories: [java]
tags: [java, java8, Api Stream]
---
Chaque version de java apporte son lot de nouveautés et java 8 n'échappe pas à la règle, plus, cette dernière version en date bouleverse même java en cela qu'elle introduit un nouveau paradigme de programmation au sein du langage qu'est [la programmation fonctionnelle](https://fr.wikipedia.org/wiki/Programmation_fonctionnelle), autant dire un souffle nouveau pour java.

Ce billet va parler d'un des apports de java 8 que sont ***les Streams*** et qui croyez moi devraient grandement simplifier la vie des développeurs java et bien sûr être apprécié de bon nombre de développeurs habitués à des langages comme ***groovy***,***scala*** et autres ***langages à paradigme fonctionnels***

###Les streams, qu'est ce que c'est?
Les streams sont un ajout à la plateforme java depuis la version 8 qui permettent de manipuler des structures de données de manière déclarative, plutôt que d'écrire ou implémenter en dur un code pour le faire (impératif).Et en plus, ils permettent d'effectuer des tâches en parallèle de manière transparente sans pour autant avoir besoin de créer un processus dédié (**Thread**).

Un bon bout de code vaut mieux que de longues explications n'est-ce pas? Alors supposons que pour une collection de noms donnée,

* serge
* Mathilda
* Noel
* Herman
* Rose
* Christian

on souhaite récupérer une liste ordonnée de ceux qui contiennent la lettre **a**.

Avec java 7

{% highlight java %}

List<String> list = Arrays.asList("serge","Mathilda","Noel", "Herman","Rose","Christian");

List<String> listeFiltree=new ArrayList<>();
//on filtre la liste pour récupérer les noms contenant la lettre a (1)
for(String s:list){
    if(s.contains("a")){
        listeFiltree.add(s);
    }
}
//on retourne une liste ordonnée
Collections.sort(listeFiltree);

{% endhighlight %}

Et avec java 8

{% highlight java %}

List<String> list = Arrays.asList("serge","Mathilda","Noel", "Herman","Rose","Christian");

List<String> listeFiltree==list.stream()
                                 .filter(d->d.contains("a"))
                                 .sorted()
                                 .collect(Collectors.toList());

{% endhighlight %}

### Java 7 vs Java 8

Les deux exemples qui précèdent permettent d'avoir le même résultat mais la version avec java 8 est plus élégante et tient en deux lignes!!
Mais ce n'est pas tant la réduction du nombre de lignes ou l'élégance de la présentation qui font la force des streams.L'API Stream permet en fait au développeur de spécifier ce qu'il attend sans dire **comment** le faire, c'est pareil en fait que d'écrire une requête sql!
Dans le cas de la version avec **java 7**, le développeur est dans l'obligation d'écrire lui même son algorithme pour arriver au résultat souhaité.

### Le mot de fin...

Alors ceci n'est qu'une présentation rapide de **l'API Stream**, nous ne sommes pas entrés en profondeur mais je vous prépare une série d'articles pour découvrir les possibilités immenses qu'elle offre!
