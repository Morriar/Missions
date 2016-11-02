Brainfuck est un langage ésotérique, il est conçu pour être difficile à écrire par un humain.

En revanche, l'extrême simplicité du modèle mémoire et des instructions en font un langage facile à interpréter.

On vous demande ici d'écrire un interpréteur pour le langage.

Voici les spécifications de l'interpréteur:

* La mémoire (données) est composée d'un tableau de n bytes
* Un pointeur d'instruction servira à pointer sur la prochaine instruction à exécuter
* Un pointeur de données servira à pointer sur la case actuelle dans les données
* Les deux pointeurs commencent à 0
* Le programme est une chaîne de caractères

Spécification du langage lui-même:
* `>` : Incrémente le pointeur de données
* `<` : Décrémente le pointeur de données
* `+` : Incrémente la valeur de la case actuelle
* `-` : Décrémente la valeur de la case actuelle
* `[` : Saute au `]` correspondant si la case actuelle vaut 0
* `]` : Saute au `[` correspondant si la case actuelle ne vaut pas 0
* `.` : Affiche le caractère correspondant à la valeur de la case actuelle
* `,` : Saisie d'un caractère et stockage dans la case actuelle
* Tout caractère autre que ceux cités précédemment sont considérés comme des commentaires.

Exemple:

~~~
Input: ++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.

Output: Hello World!
~~~
