---
layout: post
title: Stratégies d'héritage avec jpa
categories: [tutoriel, java]
tags: [java, jpa]
---

Les bases de données relationnelles n'ont pas une fonctionnalité permettant de traduire ou mapper une hiérachie de classe en tables de bases de données, or l'héritage est un des concepts clefs en java en particulier et de la progrmmation orientée objet en général. JPA et ses différentes implémentations avec doivent donc fournir un moyen pour traduire ce concept clef en un concept compréhensible par les bases de données relationnelles.

Pour résoudre ce problème, JPA propose  plusieurs stratégies :

* `MappedSuperclass` : les classes parentes ne peuvent être des entités.
* `Single Table` : les entités de la hiérachie de classe sont placées dans une seule table.
* `Table-Per-Class` : une table par classe.
* `Joined Table` : chaque classe a sa table et effectuer une requête sur une sous-classe de la hiérachie implique de faire une jointure sur les tables.

Chacune des stratégies implique une structure différente de la base de données.

### MappedSuperclass
Cette stratégie permet de partager les propriétés entre plusiseurs entités. Elle permet de mapper chaque classe vers une table dédiée. La classe mère sur laquelle est définie la stratégie `MappedSuperclass` n'est pas une entité et aucune table ne sera crée dans la base de données pour elle.

Créons la classe `Personne` qui va représenter la classe mère :

{% highlight java %}
@MappedSuperclass
public class Personne {
 
    @Id
    protected  long Id;
    protected  String nom;
    protected  String prenom;
 
    // constructeur, getters, setters
}
{% endhighlight java %}

La classe `Personne` n'a pas d'annotaion `@Entity` parce qu'elle ne sera pas persistée dans la base de données.

Les classes filles ressembleront donc à ceci : 

{% highlight java %}
@Entity
public class Formateur extends Personne {
 
    private String matiere;
 
    // constructeur, getters, setters
}
{% endhighlight java %}

{% highlight java %}
@Entity
public class Etudiant extends Personne {
 
    private double note;
 
    // constructeur, getters, setters
}
{% endhighlight java %}

Dans la base de données, on aura une table `etudiant` et une table `formateur` qui en plus de leurs propriétés auront les propriétés de la classe mère comme champs.

Avec la stratégie `MappedSuperclass`, les classes mère ne peuvent pas définir de relations avec d'autres entités.

### Single Table

C'est la stratégie par défaut utilisée par JPA lorsqu'aucune stratégie n'est implicitement définie et que la classe mère de la hiérachie est une entité.

Avec cette stratégie, une seule table est créée et partage par toutes les classes de la hiérachie.

L'annotation `@Inheritance`  est utilisée sur la classe mère pour préciser à JPA la stratégie d'héritage à utiliser.

Notre classe mère devient donc :

{% highlight java %}
@Entity
public class Personne {
 
    @Id
    protected  long Id;
    protected  String nom;
    protected  String prenom;
 
    // constructeur, getters, setters
}
{% endhighlight java %}

Ou bien en précisant la stratégie : 

{% highlight java %}
@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
public class Personne {
 
    @Id
    protected  long Id;
    protected  String nom;
    protected  String prenom;
 
    // constructeur, getters, setters
}
{% endhighlight java %}