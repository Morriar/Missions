## Saisir les contraintes OCL

Pour définir des post-conditions, on précise la signature de la méthode concernée dans le contexte:

	context Canard::cancaner(i: Integer): String

On utilise le mot-clé `post` pour spécifier les post-conditions dans le contexte:

	context Canard::cancaner(i: Integer): String
		post: result.size() = 'coin'.size() * i

### Exercice

Ajoutez les contraintes ci-dessous au modèle suivant:

![Diagramme de classes](uml_exercice.svg)

Nommez vos contraintes avec les identifiants notés `cX`.

#### Methode Vaisseau::charger(objet)

* `c1`: une fois l'objet chargé, son poids est soustrait à la capacité du vaisseau
* `c2`: une fois l'objet chargé, il se trouve dans les objets du vaisseau
