---
layout: post
title: Accès simplifié aux données avec Spring data
---
### Présentation de spring data
[Spring data](http://projects.spring.io/spring-data) est un projet cadre dont le but est de réduire la complexité des couches d'accès 
aux données.Il contient un [portfolio de projets](http://projects.spring.io/spring-data/#toc_0) 
permettant d'adresser au mieux chaque type de base de données, allant des bases de données relationnelles à ceux de la mouvance NoSql. 
Il permet notamment de s'affranchir de l'implémentation du pattern 
[DAO](http://fr.wikipedia.org/wiki/Objet_d'acc%C3%A8s_aux_donn%C3%A9es) utilisé dans la plupart des projets pour encapsuler l'accés aux 
données.

### Le problème avec les [DAO](http://www.oracle.com/technetwork/java/dataaccessobject-138824.html)
Alors, c'est bien beau, on veut s'affranchir de l'implémentation des DAO, mais quel est au juste le problème avec les DAO et dont 
spring data nous offre la solution? Eh bien si vous avez jamais développé une application avec accès aux bases de données, vous avez 
sans doute souffert de l'écriture des méthodes permettant d'effectuer des opérations sur les bases de données, les fameux CRUD 
(Create,Read,Update,Delete), des plus simples au plus complexes. Pour chaque entité(représentant une table dans la base de données), il faut 
écrire les méthodes d'accés au bases qui pour la plupart à des différences près se ressemblent toutes. Ce qui fait qu'un des problèmes 
majeur au niveau des DAO est le code répétitif que celà implique.

Un exemple de DAO :
{% highlight java %}

    @Override
    public List<Speaker> findAll() {
        return em.createQuery("select s from Speaker s",
				 Speaker.class).getResultList();
    }

    @Override
    public List<Speaker> findByLastname(String lastname, int page, int pageSize) {
        TypedQuery<Speaker> query = em.createQuery("select s from Speaker s 
				where s.lastname = ?1", Speaker.class);

        query.setParameter(1, lastname);
        query.setFirstResult(page * pageSize);
        query.setMaxResults(pageSize);

        return query.getResultList();
    }
{% endhighlight %}

Cet exemple est tiré du code présenté lors de ma présentation de spring data lors du [JCertif Abidjan 2014](http://jcertif.com/cotedivoire/).

## La solution de spring data
Dans l'exemple précédent,à part les requêtes d'interrogation de la base de données, le traitement est pareil 
quelque soit la méthode d'accès aux données: récupération des résultats de la requêtes, traitements(pagination et autre..) retour du 
résultat. Dans une moindre mesure les requêtes aussi peuvent comporter des parties redondantes mis à part les noms des entités. Et 
lorsque les requêtes deviennent de plus en plus complexe,le développeur perd du temps sur le code d'accés aux données que de 
se concentrer sur la logique métier de son application.

Avec spring data, le code présenté plus haut revient à ceci:
{% highlight java %}
public interface SpeakerRepository extends CrudRepository<Speaker, Long>{
    Page<Speaker> findByLastname(String lastname, Pageable pageable);
}
{% endhighlight %}

Euh...c'est tout? Vous vous demandez sûrement si je me moque de vous n'est-ce pas? En fait, c'est tout, spring data nous permet de 
faire abstraction de l'implémentation de nos DAO, c'est là toute la magie de spring data, il s'occupe de générer le code pour nous!Les 
méthodes basique de CRUD sont intégrés dans l'api de spring data, ce qui explique que nous ayons juste une seule méthode dans le code 
maintenant.

Grosso modo, spring data permet d'éviter les codes répétitifs ds DAO,écrire facilement des requêtes d'accès aux données complexe, 
permet une bonne gestion de la pagination et surtout, facilite la vie des développeurs avec un peu de magie en rendant le code plus 
simple,facile à tester.

## Conclusion

Ce post est juste une introduction à spring data, une petite ouverture sur ce qu'il est possible de faire avec. Je vous prépare bientôt 
une série de tutoriels pour sa prise en main, on est ensemble ;)
Mais déjà, voici une liste de ressources pour en savoir plus sur ce magnifique projet :

[spring data doc](http://docs.spring.io/spring-data/jpa/docs/1.7.0.RELEASE/reference/html/),
[spring data guide](http://spring.io/guides/gs/accessing-data-jpa/),
[ma présenation sur github](https://github.com/Centonni/jcertif2014-spring-data).
