## Préconditions

Pour définir les préconditions, on précise la signature de la méthode concernée dans le contexte:

	context Canard::cancaner(i: Integer): String

On utilise ensuite le mot-clé `pre` pour spécifier les préconditions dans le contexte:

	context Canard::cancaner(i: Integer): String
		pre: i > 0

### Exercice

Ajoutez les contraintes ci-dessous au modèle suivant:

![Diagramme de classes](uml_exercice.svg)

Nommez vos contraintes avec les identifiants notés `cX`.

#### Methode Vaisseau::charger(objet)

* `c1`: le vaisseau ne contient pas déjà l'objet à charger
* `c2`: l'objet à charger ne dépasse pas la capacité restante du vaisseau
