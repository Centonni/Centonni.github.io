---
layout: post
title: Débuter avec spring data
date: "2015-11-15 20:25:02"
categories: [tutoriel,java,spring]
tags: [java, spring,spring data,jpa]
---
Une partie essentielle pour toute application, quel que soit le langage utilisé est la gestion des données, entendez par là l'enregistrement, la récupération et tout traitement qui peut être effectué.
En java, vous avez **l'API JDBC** qui est une première couche pour l'accès aux base de données relationneles, ensuite vient **JPA** qui apporte une couche d'abstraction nécessaire pour permettre de faire un mapping objet-relationnel entre nos objets java et la base de donnée!
Le but de cet article est de montrer comment utiliser **Spring data JPA**, une librairie qui facilite l'accès aux données et qui se positionne au dessus de **JPA**. J'en ai déjà fait une présentation dans [un article précédent](http://centonni.com/Spring-data/), aussi je vais ici montrer comment le mettre en oeuvre dans un projet!

### Le projet
Nous allons créer une application dont le but sera d'enregistrer des articles d'un magasin dans une base de donnée! Ci-après le diagramme de classe pour montrer un peu ce que seront nos objets métiers.
![Initialiser un dépôt local]({{ site.baseurl }}/images/diagram.png)

Vous l'aurez sans doute compris, ce n'est pas une application complète de gestion de stock que nous allons mettre sur pied mais juste un exemple pour vous permettre de débuter avec **spring data**.

### Créer son projet sous maven

Pour commencer nous allons créer un projet java sous **maven**. Les IDE actuels vous offrent cette possibilité de choisir le type de projet que vous voulez créer alors, je suppose que là pas de soucis pour vous chers lecteurs ;)

### Modifier le fichier pom.xml pour ajouter les dépendances nécessaires
Pour pouvoir utiliser **spring data** il nous faut ajouter la librairie correspondante dans nos dépendances et bien entendu intégrer le connecteur adéquat pour la base de donnée dans laquelle on souhaite sauvegarder les données. Pour notre exemple, nous allons utiliser **mysql** mais vous pouvez utiliser une autre base de données sans problème, **spring data** supporte la majorité des bases de données relationnelles.

Aussi, le fichier de configuration doit ressembler à ce qui suit:

{% highlight xml %}

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.centonni.</groupId>
  <artifactId>debut-spring-data</artifactId>
  <version>0.0.1-SNAPSHOT</version>
  <name>Debuter avec spring data</name>

    <!-- Spring boot pour l'ajout automatique des dépendances nécessaires et l'autoconfiguration -->
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.3.0.RELEASE</version>
    </parent>

    <properties>
        <java.version>1.8</java.version>
    </properties>

    <dependencies>
        <!-- Spring data jpa -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <!-- Le connecteur mysql pour java -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
    </dependencies>

</project>
{% endhighlight %}

### Définir les classes entités
Les classes entités sont les objets de notre application qui vont en fait devenir des tables dans notre base de données. Dans notre modèle, nous avons deux classes, **Article** et **Categorie**.

La **classe Article** :

{% highlight java %}

package com.centonni.debutspringdata;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

@Entity
public class Article {

    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    private Long id;
    private String designation;
    private Double prix;
    @ManyToOne
    private Categorie categorie;

    protected Article() {
    }

    public Article(String designation, Double prix, Categorie categorie) {
        this.designation = designation;
        this.prix = prix;
        this.categorie = categorie;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public Double getPrix() {
        return prix;
    }

    public void setPrix(Double prix) {
        this.prix = prix;
    }

    public Categorie getCategorie() {
        return categorie;
    }

    public void setCategorie(Categorie categorie) {
        this.categorie = categorie;
    }

}

{% endhighlight %}

La **classe Categorie**

{% highlight java %}

package com.centonni.debutspringdata;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Categorie {

    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    private Long id;
    private String libele;

    protected Categorie() {
    }

    public Categorie(String libele) {
        this.libele = libele;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getLibele() {
        return libele;
    }

    public void setLibele(String libele) {
        this.libele = libele;
    }

}

{% endhighlight %}


Les classes **Article et Categorie** sont annotées avec `@Entity`, ceci pour indiquer à **JPA** que cette classe est une entité et sera donc crée dans la base de donnée comme une table.

Les différents attributs de ces classes seront mappés par **JPA** pour devenir les champs des différentes tables qui seront crées dans la base de données.

L'annotation `@Id` permet de préciser le champ qui sera l'identifiant de la table dans la base de données et `@GeneratedValue` permet de spécifier que l'identifiant devra être généré automatiquement.

### Configurer la base de données

Nous allons nous intéresser à la base de données maintenant, pour que notre application puisse se connecter à la base, nous devons lui fournir les informations d'accès (nom de la base, utilisateurs etc..).

Pour ce faire nous allons créer un fichier nommé `application.properties`, il est à placer dans le répertoire de ressources (`src/main/resources`) de votre projet maven. Il devra avoir les valeurs ci-après:

{% highlight properties %}
#chemin d'accès à la base de donnée
spring.datasource.url=jdbc:mysql://localhost/demodata
#utilisateur de la base de données
spring.datasource.username=root
#mot de passe de l'utilisateur de la base de données
spring.datasource.password=root
{% endhighlight %}

Et voilà, c'est tout ce qu'il nous faut pour configurer la base de données! **spring boot** que nous avons ajouté comme librairie dans les  dépendances de notre projet va se charger de toute la configuration permettant la communication avec la base de données, donc sur ce plan là, notre tâche est terminée.

### Créer nos requêtes d'interrogation de la base de données
Pour nous permettre d'interroger la base de données,il nous faut créer des **Repository** et spring data nous forunit un ensemble d'interfaces CRUD à étendre pour cela.

Nous alons utiliser dans le cadre de ce post l'interface 
`CrudRepository` . Il nous faut l'étendre et lui fournir deux paramètres :

* Le type de l'entité (dans notre cas ce sera **Article** ou **Categorie**)
* Le type de la propriété faisant ofice de clé primaire pour nos entités, ici les deux entité ont pour clé primaire un type **Long**

Le code source de nos interfaces d'accès aux données ressemble au final à ceci :

{% highlight java %}
import org.springframework.data.repository.CrudRepository;

public class ArticleRepository extends CrudRepository<Article,Long> {

}
{% endhighlight java %}

{% highlight java %}
import org.springframework.data.repository.CrudRepository;

public class CategorieRepository extends CrudRepository<Categorie,Long> {

}
{% endhighlight java %}

Et voilà, nous sommes prêts pour faire les opérations de base sur nos entités grâce à l'interface 
`CrudRepository` forunie par **spring data**. Cette interface contient les méthodes CRUD de base et spring data s'occupe de leur implémentation pour nous!
Ci-après un aperçu de cette interface :

{% highlight java %}
/*
 * Copyright 2008-2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.springframework.data.repository;

import java.io.Serializable;

/**
 * Interface for generic CRUD operations on a repository for a specific type.
 * 
 * @author Oliver Gierke
 * @author Eberhard Wolff
 */
@NoRepositoryBean
public interface CrudRepository<T, ID extends Serializable> extends Repository<T, ID> {

	/**
	 * Saves a given entity. Use the returned instance for further operations as the save operation might have changed the
	 * entity instance completely.
	 * 
	 * @param entity
	 * @return the saved entity
	 */
	<S extends T> S save(S entity);

	/**
	 * Saves all given entities.
	 * 
	 * @param entities
	 * @return the saved entities
	 * @throws IllegalArgumentException in case the given entity is (@literal null}.
	 */
	<S extends T> Iterable<S> save(Iterable<S> entities);

	/**
	 * Retrieves an entity by its id.
	 * 
	 * @param id must not be {@literal null}.
	 * @return the entity with the given id or {@literal null} if none found
	 * @throws IllegalArgumentException if {@code id} is {@literal null}
	 */
	T findOne(ID id);

	/**
	 * Returns whether an entity with the given id exists.
	 * 
	 * @param id must not be {@literal null}.
	 * @return true if an entity with the given id exists, {@literal false} otherwise
	 * @throws IllegalArgumentException if {@code id} is {@literal null}
	 */
	boolean exists(ID id);

	/**
	 * Returns all instances of the type.
	 * 
	 * @return all entities
	 */
	Iterable<T> findAll();

	/**
	 * Returns all instances of the type with the given IDs.
	 * 
	 * @param ids
	 * @return
	 */
	Iterable<T> findAll(Iterable<ID> ids);

	/**
	 * Returns the number of entities available.
	 * 
	 * @return the number of entities
	 */
	long count();

	/**
	 * Deletes the entity with the given id.
	 * 
	 * @param id must not be {@literal null}.
	 * @throws IllegalArgumentException in case the given {@code id} is {@literal null}
	 */
	void delete(ID id);

	/**
	 * Deletes a given entity.
	 * 
	 * @param entity
	 * @throws IllegalArgumentException in case the given entity is (@literal null}.
	 */
	void delete(T entity);

	/**
	 * Deletes the given entities.
	 * 
	 * @param entities
	 * @throws IllegalArgumentException in case the given {@link Iterable} is (@literal null}.
	 */
	void delete(Iterable<? extends T> entities);

	/**
	 * Deletes all entities managed by the repository.
	 */
	void deleteAll();
}
{% endhighlight java %}

### Tester notre code

Nous allons profiter des facilités offertes par **spring boot** pour tester le code sans trop souffrir!

{% highlight java %}
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class Application {

	private static final Logger log = LoggerFactory.getLogger(Application.class);

	public static void main(String[] args) {
		SpringApplication.run(Application.class);
	}

	@Bean
	public CommandLineRunner demo(CategorieRepository repository) {
		return (args) -> {
			// enregistrer des categories
			repository.save(new Categorie("accessoires"));
			repository.save(new Categorie("habits hommes"));
			repository.save(new Categorie("habits femmes"));
			repository.save(new Categorie("electromenager"));
			repository.save(new Categorie("jeunesse"));

			// Recuperer toutes les categories
			log.info("Categories trouves avec findAll():");
			log.info("-------------------------------");
			for (Categorie categorie : repository.findAll()) {
				log.info(categorie.toString());
			}
			log.info("");

			// Recuperer une categorie par ID
			Categorie categorie = repository.findOne(1L);
			log.info("Categorie trouvé avec findOne(1L):");
			log.info("--------------------------------");
			log.info(categorie.toString());

			log.info("");
		};
	}

}
{% endhighlight java %}

### Conclusion
Dans cet article, nous avons appris ces différentes choses :

* Configurer un projet pour utiliser java

* Défini un repository basique pour nos entités.

Vous pouvez visiter ces différents liens pour plus d'approfondissement :

* [spring data guide](http://spring.io/guides/gs/accessing-data-jpa/)

* [spring data doc](http://docs.spring.io/spring-data/jpa/docs/1.7.0.RELEASE/reference/html/)
