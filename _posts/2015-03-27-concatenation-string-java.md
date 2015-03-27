---
layout: post
title: Concaténation de String avec java 8
categories: [tutoriel, cours, java]
tags: [java, java8, String,StringBuilder,StringJoiner]
---
Il existe plusieurs méthodes pour effectuer la concaténation de chaînes de caractères avec java, mais depuis la version 8, java nous propose un nouveau moyen bien plus efficace pour le faire!
Je vais dans ce post vous présenter les méthodes existantes c'est à dire bien avant la sortie de java 8 et les nouveautés que java 8 apporte pour travailler avec les String.

### Utilisation de la classe String
Supposons qu'on veuille formater une chaîne de caractère de la manière suivante : **{un, deux , trois}**.
Pour cette chaîne, on a préfixe "**{**" ,un suffixe " **}**", un séparateur "**,**" et les données.
En utilisant la classe **String** , On peut procéder comme suit :

{% highlight java %}

String prefixe="{";
String suffixe="}";
String separateur=",";
String un="un";
String deux="deux";
String trois="trois";
	
String chaine=prefixe+un+separateur+deux+separateur+trois+suffixe;

System.out.println(chaine); //affiche {un,deux,trois}

{% endhighlight %}

L'exemple ci-dessus nous permet d'arriver à nos fins, mais java dispose d'une autre classe qui permet de manipuler les chaînes de caractères.

### Utilisation de la classe StringBuilder
Toujours avec le même exemple, nous allons utiliser la classe **StringBuilder** pour arriver à nos fins :

{% highlight java %}

StringBuilder chaine = new StringBuilder();

chaine.append("{")
      .append("un")	
      .append(",")
      .append("deux") 
      .append(",")
      .append("trois")
      .append("}");

System.out.println(chaine.toString()); //affiche {un,deux,trois}

{% endhighlight %}

L'utilisation de  **StringBuilder** ne change pas grand chose par rapport à l'exemple précédent sinon de réduire la création d'instances de la classe **String**. 

### Les apports de java 8 : la classe String
La classe **String** a été dotée de deux méthodes statiques qui permettent de facilement effectuer la concaténation de chaine de caractères.
En reprenant les exmples précédents, on aurait avec les nouvelle méthodes de la classe **String** :

{% highlight java %}

String chaine = "{" +  String.join(", ","un", "deux", "trois")  +  "}";
System.out.println(chaine); //affiche {un,deux,trois}

{% endhighlight %}

Alors ici, le code est un peux moins verbeux par rapport aux deux exemples précédents.La méthode **la méthode statique [join](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html#join-java.lang.CharSequence-java.lang.CharSequence...-) ** prend en paramètre le séparateur et la liste des éléments à concaténer.
La limite à ce niveau est qu'il n'y a pas de mécanisme pour lier de manière intrinsèque les délimiteurs de fin et de début pour la chaîne.

### Les apports de java 8 : la classe StringJoiner
La classe [StringJoiner](http://bit.ly/1F0C8Qw)  nouvelle classe introduite dans java 8 est utilisée pour construire une séquence de caractères séparés par un séparateur et éventuellement commençant par un préfixe fourni et se terminant par le suffixe fourni.
En pratique , une solution à notre problème avec cette classe serait la suivante :

{% highlight java %}
/*Dans le constructeur, on précise le séparateur,le préfixe et le suffixe de notre chaîne*/
StringJoiner chaine = new StringJoiner(",", "{", "}");
/*On ajoute les différents éléments de notre chaîne*/
chaine.add("un")
      .add("deux")
      .add("trois"); 

System.out.println(chaine.toString()); //affiche {un,deux,trois}

{% endhighlight %}

 Le code est toujours moins verbeux par rapport aux deux  premiers exemples.Le séparateur, le suffixe et le préfixe défini lors de l'instanciation de notre **StringJoiner** nous permettent de nous concentrer juste sur l'ajout des données,la séparation des données et l'ajout des délimiteurs de début et de fin sont gérés notre **StringJoiner**.

###Limite de la classe StringJoiner

Ce nouvel ajout est des plus intéressant pour java mais on découvre vite les limites lorsqu'on veut l'utiliser à fond. Prenons un exemple simple, supposons qu'on veuille passer une liste de String à formatter, la méthode pour le faire est la suivante :

{% highlight java %}
/*Dans le constructeur, on précise le séparateur,le préfixe et le suffixe de notre chaîne*/
StringJoiner joiner = new StringJoiner(",", "{", "}");

for (String str : list) {
   joiner.add(str);
 } 
 
String chaine=joiner.toString();

{% endhighlight %}

Cette méthode nous demande de parcourir la liste d'élément et les ajouter un par un à pour être concaténés.Il aurait été intéressant d'avoir une méthode dans la classe **StringBuilder** qui permette d'ajouter directement une liste de chaine à concaténer un peu comme celle-ci, à la manière de la méthode **join** de la classe **String** :

{% highlight java %} 
/*Ce qui est fait pour la classe String*/
String chaine = String.join("- ", list);

/*Ce qui aurait été intéressant  pour la classe StringJoiner*/
StringJoiner chaine = new StringJoiner(",", "{", "}");
chaine.join(list); 

{% endhighlight %}
 
###Conclusion

Les nouveux ajouts pour la manipulation des chaînes de caractères en java sont assez intéressants, bien qu'à mon avis beaucoup plus aurait pu être fait, l'utilisation de **StringJoiner** me laisse toujours avec un goût d'inachevé...je ne sais pas trop pourquoi :/ 