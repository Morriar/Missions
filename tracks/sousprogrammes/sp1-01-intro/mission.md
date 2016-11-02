### Notions théoriques

Comme dans les langages de haut-niveau, il est possible d'écrire des sous-programmes en Pep/8, la convention d'appel en revanche change un peu des langages de haut niveau.

En Pep/8, deux instructions sont disponibles pour travailler avec des sous-programmes : `CALL` et `RET0`.

`CALL` comme son nom l'indique, sert à appeler un sous-programme. Il fonctionne d'une façon analogue à `BR`, on lui donne un symbole ou une adresse, il va effectuer le branchement et garder un moyen de revenir au flux d'exécution avant l'appel.

On discutera plus en détail de quoi et comment les informations sont gardées ultérieurement.

`RET0` quant à lui sert lorque la fonction a fini d'éxécuter à retourner au point d'appel. Il est donc essentiel de l'appeler à la terminaison de la fonction pour revenir au lieu d'appel et continuer normalement le programme.

En d'autres mots, l'instruction `CALL` s'utilise comme un branchement inconditionnel (`BR`) mais sauvegarde l'adresse de la prochaine instruction à exécuter (celle qui suit le `CALL`). L'instruction `RET0` sert pour revenir d'un appel de sous-programme (`CALL`). Les deux instructions sont conçues pour fonctionner ensemble.

NOTE: Il est possible de passer autre chose que 0 comme paramètre à `RET`, en effet, `RET` peut être appelé avec des valeurs de `0` à `7`, on discutera de pourquoi plus tard dans le cours.

Pour passer des paramètres, on se contentera pour le moment de passer tout via des registres ou des variables globales. Par conséquent, la récursion est présentement impossible!

### Exemple:

~~~pep8
; Main, multiplies two integers
main:  	LDA	4, i
		LDX	5, i
		CALL	mul
		STA	prod, d
		DECO	prod, d
		STOP

; Product of the multiplication
prod:	.BLOCK	2

; Multiply sub-program
; NOTE: Only works with positive integers
;
; Parameters:
;	Register A: Multiplicand
;	Register X: Multiplier
;
; Return:
;	Register A: Product
;
; Symbol `inc` can and will be mutated and is
; supposed to be private to this function.

mul:	STA	inc, d
		LDA	0, i
mullp:	CPX	0, i
		BRLE	mulout
		ADDA	inc, d
		SUBX	1, i
		BR	mullp
mulout:	RET0

; Increment, is equal to the multiplicand
inc:	.BLOCK	2
~~~

Ici, nous utilisons les registres `A` et `X` pour passer les deux nombres à multiplier à notre sous-programme.
La valeur de retour (résultat de la multiplication) est renvoyé à l'appelant (morceau de programme qui a fait le `CALL`) via le registre `A`.

### Exercice

L'objectif de votre mission sera de faire un programme similaire mais qui additionnera deux valeurs. vous devrez donc:

 * Saisir deux nombres
 * Passer ces deux nombres à votre sous-programme via les registres `A` et `X`
 * Votre sous-programme calculera le résultat et le retournera via un registre
 * Imprimer votre résultat

Le but de la mission est volontairement simple afin de vous permettre de vous concentrer sur l'inclusion des nouvelles instructions `CALL` et `RET0` dans votre solution.
