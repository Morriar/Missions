Un carré magique est un carré possèdant plusieurs propriétés:

* La somme des chiffres de sa diagonale sont un point de référence => `diagsum`
* La somme des éléments de chaque ligne doit être égale à `diagsum`
* La somme des éléments de chaque colonne doit être égale à `diagsum`
* La somme des éléments de l'anti-diagonale doit être égale à `diagsum`

Pour plus d'informations visitez: <http://mathworld.wolfram.com/MagicSquare.html>

On vous demande dans cet exercice de vérifier la validité d'un carré magique.

Vous devrez afficher les contrevenants à la règle en utilisant un système de numérotation:

* L'anti-diagonale sera numérotée 0
* Les colonnes seront identifiées par un entier négatif, commençant à -1 et finissant par -n
* Les lignes seront identifiées par un entier positif, commençant à 1 et finissant par n

Affichez les potentiels contrevenants dans l'ordre croissant.

Vous devrez saisir la matrice 3x3 à l'entrée standard.

Exemple:

```
8 1 6
3 5 7
4 9 2
```

```
1 8 6
3 5 7
4 9 2
0
1
2
3
-1
-2
-3
```
