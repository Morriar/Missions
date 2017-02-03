## Saisir les contraintes OCL

Pour définir les contraintes OCL, on commence par déclarer la section `constraints` dans le fichier de modèle:

	model Animaux

	-- modèle USE

	constraints

	-- contraintes OCL

Chaque contrainte OCL doit être définie dans un contexte:

	context Animal
		-- contraintes sur la classe Animal

Pour définir des invariants, on utilise le mot clé `inv`:

	context Animal
		inv: nom <> null

Afin de simplifier la lecture des rapports d'erreurs, il est préférable de nommer ses contraintes:

	context Animal
		inv NomNotNul: nom <> null

### Exercice

Ajoutez les invariants ci-dessous au modèle présenté:

![Diagramme de classes](uml_exercice.svg)

Nommez vos contraintes avec les identifiants notés `cX`.

* `c1`: le poids d'un objet est toujours strictement suppérieur à 0
* `c2`: si une arme se trouve dans la liste des `armes` d'un vaisseau, elle doit aussi se trouver dans la liste de ses `objets`.
