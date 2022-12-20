# Codage spatio-temporel pour les systèmes MIMO
<p align="center">
     <img src="https://github.com/Alexandre-enseirb/TS305-MIMO/blob/main/doc/fig/Logo_ENSEIRB-MATMECA-Bordeaux_INP.svg" width=50% height=50% title="Logo ENSEIRB">
</p>

## Sommaire
[1. Introduction](#introduction)\
[2. Codes VBLAST](#codes-vblast)\
[3. Décodage ML](#decodage-ml)\
       [3.1 Expression du maximum de vraissemblance](#expression-du-maximum-de-vraissemblance)\
       [3.2 Inconvénient du décodage ML](#inconvenient-du-decodage-ml)\
[4. Décodage ZF](#decodage-zf)\
       [4.1 Expression du filtre ZF](#expression-du-filtre-zf)\
       [4.2 Loi du signal ZF pré-filtré](#loi-du-signal-zf-pre-filtre)\
       [4.3 Energie du bruit ZF filtré](#energie-du-bruit-zf-filtre)\
       [4.4 Performance du décodeur ZF](#performance-du-decodeur-zf)\
[5. Décodage MMSE](#decodage-mmse)\
       [5.1 Expression du filtre MMMSE](#expression-du-filtre-mmse)\
       [5.2 Démonstration du filtre MMSE](#demonstration-du-filtre-mmse)\
       [5.3 Loi du signal pré-filtré](#loi-du-signal-mmse-pre-filtre)\
       [5.4 Energie du bruit MMSE filtré](#energie-du-bruit-mmse-filtre)\
       [5.5 Comparaison des performances des décodeurs ZF-MMSE](#comparaison-des-performances-des-decodeurs-zf-mmse)\
[6. Decodage SIC](#decodage-sic)\
       [6.1 Expression du filtre SIC](#expression-du-filtre-sic)\
       [6.2 Loi du signal SIC pré-filtre](#loi-du-signal-sic-pre-filtre)\
       [6.3 Energie du bruit SIC pré-filtré](#energie-du-bruit-sic-pre-filtre)\
       [6.4 Comparaison des performances du décodeurs SIC avec ZF et MMSE](#comparaison-des-performances-du-decodeurs-sic-avec-zf-et-mmse)\
[7. Code Alamouti](#code-alamouti)\
       [7.1 Decodage Alamouti](#decodage-alamouti)\
       [7.2 Loi du signal pré-filtré](#loi-du-signal-pre-filtre)\
       [7.3 Comparaison entre Alamouti VBLAST](#comparaison-entre-alamouti-vblast)\
[8. Performance sur canal estimé](#performance-sur-canal-estime)\
       [8.1 Propriete de la séquence d’apprentissage](#propriete-de-la-sequence)\
       [8.2 Choix de la sequence d'apprentissage](#choix-de-la-sequence)\
       [8.3 Performances](#performances)\
[9. Conclusion](#conclusion)

## Introduction
Les techniques de communication multi-antennes consistent à augmenter le nombre d’antennes à l’émission et à la réception. Elles permettent par exemple d’améliorer la qualité du signal reçu, d’augmenter le débit de la communication ou d’appliquer des techniques de traitement d’antenne pour focaliser le signal dans une certaine
direction.

Dans ce TP, on se propose d’étudier les méthodes de codage spatio-temporel VBLAST (pour Vertical Bell Lab Space Time) et d’Alamouti pour un système ayant N = 2 antennes à l’émission et M = 2 antennes à la réception. Plusieurs méthodes de décodage sont comparées pour le codage VBLAST, puis les performances des deux codes sont comparées pour un décodage par maximum de vraisemblance. Enfin, on s’intéresse au cas où le canal n’est pas connu du récepteur et doit être estimé.

## Codes VBLAST
Le codage spatio-temporel consiste à répartir les symboles à émettre en temps (par rapport à la durée d’une trame) et en espace (en choisissant quelle antenne émet le symbole en question). La méthode de codage VBLAST en particulier consiste à répartir les symboles dans une matrice N ×L, où L est le nombre de symboles à émettre. Chaque colonne de la matrice représente alors un temps symbole, et chaque ligne rassemble les symboles émis
par une même antenne. On appelle cette matrice "mot de code".
En notant $s_l^n$
le symbole émis à l’instant l par l’antenne n, cette matrice est donnée par:

$$
\mathbf{C} =
\left[\begin{array}{cc}
     s_0^{(0)} & s_1^{(0)} & \ldots & s_{L-1}^{(0)} \\
     \vdots & \vdots & \ddots & \vdots \\
     s_0^{(N-1)} & s_1^{(N-1)} & \ldots & s_{L-1}^{(N-1)}
\end{array}\right]
$$

L'ensemble de ces mots de code $\mathbf{C}$ est appelé le "code" et est noté $\mathcal{C}$.
Dans la suite de cette section, quatre méthodes de décodage sont comparées. Elles sont présentées une à une, puis une courbe de taux d'erreur binaire permettant la comparaison de leurs performances est donnée. Dans la suite, on considère que le canal est parfaitement connu du récepteur. Ce qui signifie que l'on s'autorise à utiliser la matrice $\mathbf{H}$ simulant le canal lors du décodage.

## Decodage ML
### Expression du maximum de vraissemblance
Le premier décodeur est le "décodeur par maximum de vraisemblance" (**M**aximum **L**ikelihood). Il consiste à comparer tous les mots de code possibles avec le message reçu du canal, et à ne retenir que le plus "vraisemblable".

Pour cela, on exprime tout d'abord le message reçu $\mathbf{Y}$ comme suit :

$$
    \mathbf{Y} = \mathbf{HX} + \mathbf{V}
$$

où $\mathbf{H}$ est la matrice de convolution du canal, dont tous les éléments suivent une loi normale complexe standard; $X$ est le message émis à retrouver; et $V$ est un bruit blanc gaussien complexe de variance $\sigma^2 = \frac{1}{SNR}$.

La vraisemblance s'écrit alors:

$$
    f(\mathbf{Y}; \mathbf{H}, \mathbf{X}, \sigma^2) = \left(\frac{1}{\sigma^2\pi}\right)^{M \times L} \exp\left(-\frac{1}{\sigma^2}\left|\left| \mathbf{Y} - \mathbf{HX} \right|\right|^2_F\right)
$$

où $\left|\left|.\right|\right|_F$ désigne la norme de Frobenius.

En notant $\mathbf{Y}_{i,j}$ l'élément à la ligne $i$ et à la colonne $j$ de $\mathbf{Y}$, la vraisemblance s'étend à l'ensemble des observations sur les $M$ antennes de réceptions pour les $N$ instants où le canal $\mathbf{H}$ est supposé constant:

$$
\begin{align}
    f(\mathbf{Y}) &= \prod_{i,j} f(\mathbf{Y}_{i,j})\nonumber\\
    %
    &= \prod_{i,j} \frac{1}{\sigma^2\pi} \exp\left( -\frac{1}{\sigma^2} \left| \mathbf{Y}_{i,j} - \left[\mathbf{HX}\right]_{i,j} \right| ^2 \right)\nonumber\\
    %
    &= \left( \frac{1}{\sigma^2 \pi} \right) ^ {M \times L} \exp\left( - \frac{1}{\sigma^2} \sum_{i,j} \left| \mathbf{Y}_{i,j} - \left[ \mathbf{HX} \right]_{i,j} \right|^2 \right)\nonumber\\
    %
    &= \left( \frac{1}{\sigma^2 \pi} \right) ^ {M \times L} \exp\left( - \frac{1}{\sigma^2} \left|\left| \mathbf{Y} - \mathbf{HX} \right|\right|^2_F \right)
\end{align}
$$

La vraissemblance est maximale lorsque lorsque l'argument de la fonction $\exp$ est maximal. L'estimateur du maximum de vraisemblance est finalement donné par:

$$
    \hat{\mathbf{X}} = \underset{\mathbf{C} \in \mathcal{C}}{\mathrm{argmin}} \left|\left| \mathbf{Y} - \mathbf{HC} \right|\right|^2_F
$$

Ses performances en fonction du rapport signal à bruit sont présentés sur la Figure suivante:
<p align="center">
     <img src="https://github.com/Alexandre-enseirb/TS305-MIMO/blob/main/doc/fig/ML.png" width=50% height=50% title="Taux d'erreur du ML">
</p>

### Inconvénient du décodage ML
Ce décodeur minimise l'erreur binaire. Néanmoins, c'est aussi le plus coûteux en calculs. En notant $\mathcal{A}$ l'alphabet des symboles possibles, le décodeur ML compare la sortie du canal aux $\left|\mathcal{A}\right|^{N \times L}$ mots de code possibles.

Même pour des cas de figure où $N = M = L = 2$, cette complexité reste conséquente, notamment par rapport aux prochains décodeurs étudiés.

Dans le cadre du VBLAST, il est tout fois possible d'améliorer ce décodage. Dans cette configuration particulière, le même symbole est émis à l'instant $l$ sur toutes les $N$ antennes. Il est alors possible de travailler le critère (\ref{eq:max_vraissemblance}) par colonnes:

$$
    \forall l \in [1, L], \quad \hat{x}_l = \underset{\mathbf{C}_l \in \mathcal{C}_l}{\mathrm{argmin}}  ||\mathbf{y}_l - \mathbf{H}\mathbf{c}_l||^2_2
$$

La complexité passe alors de $\mathcal{O}\left(\left|\mathcal{A}\right|^{N \times L}\right)$ à $\mathcal{O}\left( L \times \left|\mathcal{A}\right|^{N}\right)$.



## Decodage ZF
### Expression du filtre ZF
Le décodeur ZF (pour **Z**ero **F**orcing utilise la connaissance de la matrice $\mathbf{H}$ du canal pour en construire un filtre $\mathbf{F_{ZF}}$ minimisant les interférences entre symboles (IES). Ce filtre s'applique sur les observations $\mathbf{Y}$ pour vérifier:

$$
\begin{align}
    \mathbf{Z} & = \mathbf{F_{ZF}}\mathbf{Y}\nonumber\\
    &= \mathbf{F_{ZF}} \mathbf{H} \mathbf{X} + \mathbf{F_{ZF}^*} \mathbf{V}\\
    &= \mathbf{I} \mathbf{X} + \mathbf{F_{ZF}} \mathbf{V}\nonumber
\end{align}
$$

Où $\mathbf{I}$ désigne l'identité matricielle. Pour y parvenir, l'erreur quadratique $\left|\left|\mathbf{F_{ZF}^*}\mathbf{H} - \mathbf{I}\right|\right|^2_F$ est mise à zéro. Le filtre $\mathbf{F_{ZF}}$ est alors le transposé conjugué de la pseudo-inverse de $\mathbf{H}$ et s'écrit, sous l'hypothèse que $\mathbf{H}$ est de rang plein :

$$
\mathbf{F}_{ZF} = \left(\mathbf{H}^+\right)^*
                = \mathbf{H}\left(\mathbf{H}^*\mathbf{H}\right)^{-1}
$$

### Loi du signal ZF pre filtre
Comme $\mathbf{Z} = \mathbf{X} + \mathbf{F_{ZF}V}$, le signal $\mathbf{Z}$ suit la même loi que $\mathbf{F_{ZF}V}$ avec un décalage moyen de $\mathbb{E}[\mathbf{X}] = 0$ dans le cas d'une QPSK. De plus comme $\mathbf{V}$ est un vecteur gaussien centré, alors $\mathbf{F_{ZF}V}$ qui est une combinaison linéaire de vecteur gaussienne centré est également un vecteur gaussienne centré. Sa matrice de covariance notée $\mathbf{R_{Z, ZF}}$ se développe:

$$
\begin{align}
    \mathbf{R_{Z, ZF}} &=  \mathbb{E}[\mathbf{F_{ZF}^+}\mathbf{V}(\mathbf{F_{ZF}^+}\mathbf{V})^+] \\
    &= \mathbf{F^+_{ZF}}\mathbb{E}[\mathbf{V} \mathbf{V}^+]\mathbf{F_{ZF}} \\
    &= \sigma^2(\mathbf{H}^+\mathbf{H})^{-1}\mathbf{H}^+\mathbf{H}(\mathbf{H}^+\mathbf{H})^{-1} \\
    &= \sigma^2(\mathbf{H}^+\mathbf{H})^{-1} \\
    &= \sigma^2\mathrm{Gram}(\mathbf{H})^{-1} \\
    &= \sigma^2\mathbf{V}
          \left[\begin{array}{cc}
               \sigma_1(\mathbf{H}) & \dots  & 0\\
               \vdots               & \ddots & \vdots\\
               0                    & \dots  & \sigma_{\mathrm{rg}(\mathbf{H})}(\mathbf{H})
          \end{array}\right]^{-1/2}\mathbf{U^+}
\end{align}
$$

Le passage entre la dernière et l'avant dernière ligne se fait en décomposant en valeur singulière la matrice de Gram de $\mathbf{H}$. La matrice diagonale fait alors apparaître les valeurs singulières de $\mathbf{H}$.

La covariance obtenue ne correspond plus celle d'un processus blanc, car elle n'est pas diagonale.

### Energie du bruit ZF filtre

L'énergie du bruit filtré est donnée par:

$$
\begin{align}
        \mathbb{E}[||\mathbf{F_{ZF}^+}\mathbf{V}||_{F}^2] &= L\sigma^2||\mathbf{F_{ZF}}||^2_F \\
        &= L\sigma^2\mathrm{tr}[\mathbf{H}^+(\mathbf{H}^+)^+] \\
        &= L\sigma^2\sum_{i=1}^{\mathrm{rg}(\mathbf{H})}\frac{1}{\sigma_i(\mathbf{H})^2}
\end{align}
$$

Avec $(\sigma(\mathbf{H}))_{i\in[1, \mathrm{rg}(\mathbf{H})]}$ les valeurs singulières de $\mathbf{H}$.
Si ces valeurs $\sigma(\mathbf{H})_i$ sont petites, alors l'énergie du bruit augmente en conséquence.

### Performance du decodeur ZF
La figure suivante donne les taux d'erreur paquet et taux d'erreur binaire suite à un décodage ZF:
<p align="center">
     <img src="https://github.com/Alexandre-enseirb/TS305-MIMO/blob/main/doc/fig/ZF.png" width=50% height=50% title="Taux d'erreur du ZF">
</p>


## Decodage MMSE
### Expression du filtre MMSE
En supposant que les symboles émis sont indépendants les uns des autres, l'expression du filtre MMSE est donnée par:

$$
    \begin{split}
        \mathbf{F_{MMSE}} &= (\mathbf{HH^+} + \sigma^2\mathbf{I})^{-1}\mathbf{H}\\
        &= \mathbf{V \Sigma^{-1} U^+}\mathbf{H}
    \end{split}
$$

en décomposant en valeur singulière $(\mathbf{HH^+} + \sigma^2\mathbf{I})$ par $\mathbf{U \Sigma V^+}$ où

$$
    \mathbf{\Sigma} =
          \left[\begin{array}{cc}
               \sigma_1(\mathbf{H}) + \sigma^2 & \dots & 0\\
               \vdots & \ddots & \vdots\\
               0 & \dots & \sigma_{\mathrm{rg}(\mathbf{H})}(\mathbf{H}) + \sigma^2
          \end{array}\right]
$$

### Demonstration du filtre MMSE
Partons de la relation

$$
    \mathbf{Y} = \mathbf{HX} + \mathbf{V}    
$$

On peut définir notre filtre $\mathbf{F}_{\text{MMSE}}$ comme étant le filtre $\mathbf{F}$ minimisant l'erreur quadratique moyenne suivante.

$$
    \mathbf{F}_{\text{MMSE}} = \underset{\mathbf{F} \in \mathcal{M}_N(\mathbb{C})}{\mathrm{argmin}} \mathbb{E} ||\mathbf{F}^+\mathbf{Y} - \mathbf{X}||^2
$$

Développons ce terme d'erreur.

$$
    \begin{split}
        ||\mathbf{F}^+\mathbf{Y} - \mathbf{X}||^2 &= \left< \mathbf{F}^+\mathbf{Y} - \mathbf{X}, \mathbf{F}^*\mathbf{Y} - \mathbf{X} \right>\\
        &= \left( \mathbf{F}^+\mathbf{Y} - \mathbf{X} \right) \left( \mathbf{F}^+\mathbf{Y} - \mathbf{X} \right) ^+\\
        &= \mathbf{F}^+ \mathbf{YY}^+ \mathbf{F} - \mathbf{F}^+ \mathbf{Y} \mathbf{X}^+ - \mathbf{X} \mathbf{Y}^+ \mathbf{F} + \mathbf{XX}^+\\
    \end{split}
$$

En réappliquant l'espérance sur ce terme et en tirant profit de la linéarité, on trouve

$$
    \mathbb{E} ||\mathbf{F}^+\mathbf{Y} - \mathbf{X}||^2 = \mathbf{F}^+ \mathbb{E}\left[\mathbf{YY}^+\right] \mathbf{F} - \mathbf{F}^+ \mathbb{E}\left[\mathbf{Y} \mathbf{X}^+\right] - \mathbb{E}\left[\mathbf{X} \mathbf{Y}^+\right] \mathbf{F} + \mathbb{E}[\mathbf{XX}^+]
$$

Développons ces termes séparément. D'une part,

$$
    \begin{split}
        \mathbf{F}^+ \mathbb{E}[\mathbf{YY}^+] \mathbf{F} &= \mathbf{F}^+ \mathbb{E}\left[\left(\mathbf{HX} + \mathbf{V}\right)\left(\mathbf{HX} + \mathbf{V}\right)^+\right] \mathbf{F}\\
        &= \mathbf{F}^+ \mathbf{H}\mathbb{E} \left[\mathbf{XX}^+\right]\mathbf{H}^+\mathbf{F} + \mathbf{F}^+ \mathbb{E}\left[\mathbf{VV}^+\right]\mathbf{F}\\
        &= \mathbf{F}^+\mathbf{HQH}^+\mathbf{F} + \sigma^2\mathbf{F}^+\mathbf{IF}
    \end{split}
$$

avec $\mathbf{Q}$ la matrice de covariance du signal envoyé $\mathbf{X}$ et $\sigma^2\mathbf{I}$ celle du bruit. D'autre part,

$$
\begin{split}
    \mathbb{E}\left[\mathbf{XY}^+ \right] &= \mathbb{E} \left[\mathbf{X}\left( \mathbf{HX}+\mathbf{V}\right)^+\right]\\
    &= \mathbb{E}\left[\mathbf{XX}^+\right]\mathbf{H}^+ + \mathbb{E}\left[\mathbf{X}\right]\mathbb{E}\left[\mathbf{V}^+\right]\\
    &= \mathbf{QH}^+
\end{split}
$$

L'erreur moyenne se réécrit donc

$$
    \mathbb{E} ||\mathbf{F}^+\mathbf{Y} - \mathbf{X}||^2 = \mathbf{F}^+\mathbf{HQH}^+\mathbf{F} + \sigma^2\mathbf{F}^+\mathbf{IF} - 2\mathbf{QH}^+\mathbf{F} + \mathbf{Q}
$$

En dérivant selon $\mathbf{F}$ puis en annulant la dérivée, on trouve finalement la formule du filtre MMSE optimal.

$$
    \begin{alignedat}{2}
        &\quad&\frac{\partial \mathbb{E} \left|\left| \mathbf{F}^+\mathbf{Y} - \mathbf{X}\right|\right|^2}{\partial \mathbf{F}} = 2 \mathbf{HQH}^+\mathbf{F} + 2\sigma^2\mathbf{I}\mathbf{F} - 2\mathbf{HQ}^+ &= 0\\
        \Leftrightarrow&& 2 \mathbf{HQH}^*\mathbf{F} + 2\sigma^2\mathbf{I}\mathbf{F} &= 2\mathbf{HQ}^+\\
        \Leftrightarrow&& \mathbf{F}_{\text{MMSE}} &= \left(\mathbf{HQH}^+ + \sigma^2\mathbf{I}\right)^{-1} \mathbf{HQ}^+\\
        \Leftrightarrow&& \mathbf{F}_{\text{MMSE}} &= \left(\mathbf{HQH}^+ + \sigma^2\mathbf{I}\right)^{-1} \mathbf{HQ}
    \end{alignedat}
$$

La dernière ligne s'obtient en exploitant le fait que $\mathbf{Q}$ est une matrice de covariance, donc symétrique et réelle. Enfin, en remplaçant $\mathbf{Q}$ par $\mathbf{I}$ dans l'expression précédente, on retrouve l'expression du filtre MMSE énoncée.


### Loi du signal MMSE pre-filtre
De manière analogue à l'analyse du signal pré-filtré ZF, $\mathbf{Z}$ est un vecteur gaussien centré. Sa matrice de covariance notée $\mathbf{R_{Z, MMSE}}$ est donnée par:

$$
\begin{align}
        \mathbf{R_{Z, MMSE}} &= \mathbb{E}[\mathbf{F_{MMSE}^+}\mathbf{v}_l(\mathbf{F_{MMSE}^+}\mathbf{v})^+] \\
        &= \mathbf{F^+_{MMSE}}\mathbb{E}[\mathbf{v}\mathbf{v}^+]\mathbf{F_{MMSE}} \\
        &=\sigma^2\mathbf{H^+U\Sigma}^{-1}\mathbf{V^+V\Sigma}^{-1}\mathbf{U^+H} \\
        &= \sigma^2\mathbf{H^+U\Sigma}^{-2}\mathbf{U^+H} \\
        &= \sigma^2\mathbf{H^+U}
        \left[\begin{array}{cc}
            \sigma_1(\mathbf{H}) + \sigma^2 & \dots & 0\\
            \vdots & \ddots & \vdots\\
            0 & \dots & \sigma_{\mathrm{rg}(\mathbf{H})}(\mathbf{H}) + \sigma^2
        \end{array}\right]^{-2}
        \mathbf{U^+H}
\end{align}
$$

### Energie du bruit MMSE filtre
L'énergie du bruit pré-filtrée est:

$$
    \begin{split}
        \mathbb{E}[||\mathbf{F_{MMSE}^+}\mathbf{V}||_{F}^2] &= L\sigma^2||\mathbf{F_{MMSE}}||^2_F\\
        &= L\sigma^2\mathrm{tr}[(\mathbf{V\Sigma^{-1}U^*H})^+\mathbf{V\Sigma^{-1}U^+H}]\\
        &= L\sigma^2\mathrm{tr}[\mathbf{H}^+\mathbf{U\Sigma^{-1}V^+}\mathbf{V\Sigma^{-1}U^+H}]\\
        &= L\sigma^2\mathrm{tr}[\mathbf{H}^+\mathbf{U\Sigma^{-2}U^+H}]\\
        &= L\sigma^2\sum_{i=1}^{\mathrm{rg}(\mathbf{H})}\left(\frac{\sigma_i(\mathbf{H})}{\sigma_i(\mathbf{H})^2 + \sigma^2}\right)^2
    \end{split}
$$

La présence du terme $\sigma^2$ au dénominateur des fractions évite que le bruit deviennent trop important. En revanche, le filtre MMSE n'annule pas toutes les interférences entre symboles.

### Comparaison des performances des decodeurs ZF MMSE
La Figure suivante compare les performances du MMSE à celles du ZF précédemment présentées. Sur l'ensemble des SNR testés, le décodage MMSE obtient de meilleurs résultats.
<p align="center">
     <img src="https://github.com/Alexandre-enseirb/TS305-MIMO/blob/main/doc/fig/ZF-MMSE.png" width=50% height=50% title="Comparasion du taux d’erreur du ZF avec le MMS">
</p>

A fort SNR $\sigma^2$ est négligeable devant chacune des valeurs singulières $\sigma_i({\mathbf{H}})$. En négligeant $\sigma$, l'expression du MMSE correspond au ZF.

## Decodage SIC
### Expression du filtre SIC
Le filtrage SIC (**S**uccessive **I**nterference **C**ancellation) repose sur la matrice triangulaire supérieure $\mathbf{R}$ issue de la décomposition $\mathbf{QR}$ du canal $\mathbf{H}$. Cette méthode de décodage permet de considérer que l'effet du canal sur le signal d'intérêt se résume à une matrice triangulaire supérieure, puis en démarrant du dernier échantillon, à estimer et annuler les différentes influences du canal sur le signal.

### Loi du signal SIC pre filtre
Le signal $\mathbf{Z}$ est gaussien centré de covariance $\mathbf{R_{zz}}$ détaillée ci-dessous. Il suit la même loi que le bruit $\mathbf{R^*V}$.

$$
    \begin{split}
        \mathbf{R_{zz}} &= \mathbb{E}[\mathbf{F^+_{SIC} V(\mathbf{F^+_{SIC}}V})^+] \\
        &= \mathbf{F^+_{SIC}} \mathbb{E}[\mathbf{VV^+}] \mathbf{F_{SIC}} \\
        &= \sigma^2 \mathbf{R^+R} \\
        &= \sigma^2 \mathbf{I}
    \end{split}
$$

Les symboles $\mathbf{z}_l$ suivent donc la loi $\mathcal{N}(0, \sigma^2\mathbf{I})$.

### Energie du bruit SIC pre filtre
$$
    \begin{split}
        \mathbb{E}[||\mathbf{R^+V||_F^2}] &= \mathrm{tr}(\mathbf{R^+VV^+R}) \\
        &= \sigma^2 \mathrm{tr}(I) \\
        &= L\sigma^2
    \end{split}
$$

L'énergie du bruit $\mathbf{v}_l$ est donc $\sigma^2$. Il est indépendant des valeurs singulières du canal $\mathbf{H}$.

### Comparaison des performances du decodeurs SIC avec ZF et MMSE
La figure suivante montre que les performances du SIC relativement aux performances du MMSE et du ZF.

<p align="center">
     <img src="https://github.com/Alexandre-enseirb/TS305-MIMO/blob/main/doc/fig/ZF-MMSE-SIC.png" width=50% height=50% title="Comparaison du taux d’erreur du SIC avec le MMSE et le ZF">
</p>

Le décodeur SIC réalise un compromis entre le décodeur MMSE et le décodeur ZF en terme de taux d'erreur binaire pour un SNR faible. Pour un SNR plus important, il est équivalent au décodeur MMSE. Du point de vue du taux d'erreur paquet, il est toujours équivalent ou meilleur que le MMSE.

Une différence majeure avec les précédents décodeurs est que le décodeur SIC décode de manière récursive les symboles. Dès lors, lorsque des interférence par symbole ne sont pas corrigées sur le premier symbole, elles se propagent sur les suivants.



## Code Alamouti
### Decodage Alamouti
Le code d'Alamouti est un autre exemple de code spatio-temporel. Celui-ci est spécifique au cas $N=L=2$ et répartit dans un mot de code deux symboles $x_1$ et $x_2$ comme suit :

$$
    \mathbf{X} =  \left[\begin{array}{cc}
                       x_1 & -\overline{x_2} \\
                       x_2 & \overline{x_1}
                  \end{array}\right]
$$

On peut donc écrire le message $\mathbf{Y}$ reçu par le récepteur comme suit, pour $M=2$ :

$$
\begin{split}
    \mathbf{Y} &= \mathbf{HX} + \mathbf{V}\\
    &= \begin{bmatrix}
        h_{11} & h_{21} \\
        h_{12} & h_{22}
    \end{bmatrix}
    \begin{bmatrix}
    x_1 & -\overline{x_2} \\
    x_2 & \overline{x_1}
    \end{bmatrix} +
    \begin{bmatrix}
    v_1 & v_2\\
    v_3 & v_4
    \end{bmatrix}\\
    &= \begin{bmatrix}
    h_{11}x_1 + h_{21}x_2 + v_1 & -h_{11}\overline{x_2} + h_{21}\overline{x_1} + v_2 \\
    h_{12}x_1 + h_{22}x_2 + v_3 & -h_{12}\overline{x_2} + h_{22}\overline{x_1} + v_4
    \end{bmatrix}
\end{split}
$$

Posons maintenant $z_1 = \mathbf{h}_1^+\mathbf{y}_1 + \mathbf{y}_2^+\mathbf{h}_2$ et $z_2 = \mathbf{h}_2^+\mathbf{y}_1 - \mathbf{y}_2^+\mathbf{h}_1$, où $\mathbf{h}_1, \mathbf{h}_2, \mathbf{y}_1, \mathbf{y}_2,$ sont les colonnes $1$ et $2$ respectivement de $\mathbf{H}$ et $\mathbf{Y}$. Pour simplifier les calculs, on se place dans un cas sans bruit.

Détaillons tout d'abord $z_1$ :

$$
\begin{split}
    z_1 &= \left[\begin{array}{cc}
    \overline{h_{11}} & \overline{h_{12}}
    \end{array}\right]
    \left[\begin{array}{cc}
    h_{11}x_1 + h_{21}x_2 \\
    h_{12}x_1 + h_{22}x_2
    \end{array}\right] +
    \left[\begin{array}{cc}
    -\overline{h_{11}}x_2 + \overline{h_{21}}x_1 & -\overline{h_{12}}x_2 + \overline{h_{22}}x_1
    \end{array}\right]
    \left[\begin{array}{cc}
    h_{21} \\ h_{22}
    \end{array}\right]\\
    &= \overline{h_{11}}(h_{11}x_1 + h_{21}x_2) + \overline{h_{12}}(h_{12}x_1 + h_{22}x_2) + h_{21}(-\overline{h_{11}}x_2 + \overline{h_{21}}x_1) + h_{22}(-\overline{h_{12}}x_2 + \overline{h_{22}}x_1)\\
    &= \left|h_{11}\right|^2x_1 + \left|h_{12}\right|^2x_1 + \left|h_{21}\right|^2x_1 + \left|h_{22}\right|^2x_1 + \overline{h_{11}}h_{21}x_2 + \overline{h_{12}}h_{21}x_2 - h_{21}\overline{h_{11}}x_2 - h_{22}\overline{h_{12}}x_2\\
    &= (\left|h_{11}\right|^2 + \left|h_{12}\right|^2 + \left|h_{21}\right|^2 + \left|h_{22}\right|^2)x_1\\
    &= \left|\left|\mathbf{H}\right|\right|^2_Fx_1
\end{split}
$$

Par un calcul analogue, $z_2$ s'écrit

$$
    z_2 = ||\mathbf{H}||^2_Fx_2
$$

Par conséquent, notre estimation $\hat{\mathbf{X}} = [\hat{x}_1, \hat{x}_2]^t$ sera la plus vraisemblable lorsque

$$
    |z_1 - ||\mathbf{H}||^2_F\hat{x}_1|^2 = 0 \quad \text{ et } \quad |z_2 - ||\mathbf{H}||^2_F\hat{x}_2||^2 = 0
$$

D'où les estimateurs suivants :

$$
    \hat{x}_1 = \underset{z \in \mathcal{A}}{\mathrm{argmin}} |z_1 - ||\mathbf{H}||^2_F\hat{x}_1 |^2 \quad \text{ et } \quad \hat{x}_2 = \underset{z \in \mathcal{A}}{\mathrm{argmin}}| z_2 - ||\mathbf{H}||^2_F\hat{x}_2|^2
$$


### Loi du signal pre filtre
Comme $\mathbf{Y}$ suit une loi gaussienne et $\mathbf{H}$ est connue du récepteur, le signal $\mathbf{Z}$ est distribué selon une loi gaussienne. Celle-ci est centrée car la distribution de $\mathbf{Y}$ l'est également. Le développement suivant conduit à la variance de $z_1$:

$$
    \begin{split}
        \mathbb{E}[z_1z_1^+] &= \mathbb{E}[\mathbf{h_1^+y_1y_1^+h_1}] + \mathbb{E}[\mathbf{y_2^+h_2h_2^+y_2}]\\
        &= \mathbb{E}[\mathbf{h_1^+y_1y_1^+h_1}] + \mathbb{E}[\mathbf{h_2^+y_2y_2^+h_2}]\\
        &= \mathbf{h_1^+}\mathbb{E}[\mathbf{y_1y_1^+}]\mathbf{h_1} + \mathbf{h_2^+}\mathbb{E}[\mathbf{y_2y_2^+}]\mathbf{h_2}\\
        &= \sigma^2(|\mathbf{h_1}|^2 + |\mathbf{h_2}|^2)
    \end{split}
$$

Donc $z_1 \sim \mathcal{N}\left(0, \sigma^2(|\mathbf{h_1}|^2 + |\mathbf{h_2}|^2)\right)$. Et avec un raisonnement analogue: $z_2 \sim \mathcal{N}\left(0, \sigma^2(|\mathbf{h_2}|^2 - |\mathbf{h_1}|^2)\right)$.


### Comparaison entre Alamouti VBLAST
La figure suivante compare le taux d'erreur binaire des codes Alamouti et VBLAST sur un décodage maximisant la vraissemblance pour un nombre croissant d'antennes de réceptions ($M$). Dans les 3 cas de figure, le décodage sur Alamouti est meilleur en terme de taux d'erreur.
<p align="center">
     <img src="https://github.com/Alexandre-enseirb/TS305-MIMO/blob/main/doc/fig/VBLAST-Alamouti.png" width=50% height=50% title="Comparaison des performances des codes VBLAST - Alamouti">
</p>

La différence de performances entre le code VBLAST et le code d'Alamouti s'explique notamment par la présence de redondance.


## Performance sur canal estime
### Propriete de la sequence
La matrice $\mathbf{S}$ des symboles d'apprentissage doit vérifier la proprieté:

$$
    \lim_{L \to \infty} \frac{\mathbf{S^+S}}{L} = \mathbf{I}
$$

Comme $(\mathbf{S^+S})/L$ est la matrice de corrélation du processus collectant l'ensemble des symboles d'apprentissage, la proprieté garantit d'explorer au mieux le canal $\mathbf{H}$. En effet, comme il n'existe aucun à priori sur le canal, il est en moyenne inutile d'utiliser des séquences spécifiques de symboles (impliquant donc une corrélation) pour étudier un certain de type de matrice $\mathbf{H}$.

### Estimateur du canal
Le critère issu du maximum de vraisemblance est:

$$
    \mathbf{\hat{G}} = \underset{\mathbf{G}}{\mathrm{argmin}} ||\mathbf{Y^+} - \mathbf{SG}||^2
$$

En supposant $\mathbf{S}$ de rang plein: $\mathbf{\hat{G}} = (\mathbf{S^+S})^{-1}\mathbf{S^+Y^+}$.

Comme $\mathbf{\hat{H}} = \mathbf{\hat{G}^+}$, l'estimateur du canal est:

$$
    \mathbf{\hat{H}} = \mathbf{YS(S^+S)^{-1}}
$$

### Choix de la sequence
Soit $\mathbf{\Sigma}$ la matrice de covariance de la séquence d'apprentissage. Trouver la meilleur distribution des symboles revient à évaluer $\mathbf{\Sigma}_{opt}$ pour que l'erreur entre $\mathbf{\hat{H}}$ et $\mathbf{H}$ soit minimale, sous la contrainte d'une puissance $P$ à ne pas dépasser:

$$
\begin{align}
    \mathbf{\Sigma}_{opt} &= \underset{\substack{\mathbf{\Sigma} \text{; } \mathrm{tr}(\mathbf{\Sigma}) \leq NP}}{\mathrm{argmin}} \mathbb{E}||\mathbf{\hat{H} - H}||_F^2 \\
    &= \underset{\substack{\mathbf{\Sigma} \text{; } \mathrm{tr}(\mathbf{\Sigma}) \leq NP}}{\mathrm{argmin}} \frac{1}{N}\mathrm{tr}(\mathbf{\Sigma}^{-1})
\end{align}
$$

En notant $\left(\frac{1}{\lambda_n}\right)_{n\in[1, N]}$ les valeurs propres de $\mathbf{\Sigma}^{-1}$, la trace se développe. Puis, l'inégalité de Jensen est utilisée:

$$
\begin{align}
    \frac{1}{N}\mathrm{tr}(\mathbf{\Sigma}^{-1}) &= \frac{1}{N} \sum_{n=1}^N \frac{1}{\lambda_n} \\
    &\geq \left(\sum_{n=1}^N\frac{1}{N} \lambda_i\right)^{-1}
\end{align}
$$

Le cas d'égalité est obtenu lorsque $\mathbf{\Sigma} = P\mathbf{I}$, ce qui implique que la séquence d'apprentissage doit être la réalisation d'un bruit blanc.


### Performances
La prochaine figure compare les performances d'un codage VBLAST couplé à un décodage par maximum de vraissemblance lorsque le décodeur connaît parfaitement le canal $\mathbf{H}$ ou dispose seulement d'une estimation pour différentes valeurs de $L$.

<p align="center">
     <img src="https://github.com/Alexandre-enseirb/TS305-MIMO/blob/main/doc/fig/canal_estime.png" width=50% height=50% title="Comparaison du BER entre un canal estimé et un canal parfaitement connu">
</p>

Sans surprise, les performances réalisées avec un canal estimé sont moins bonnes. Néanmoins, lorsque $N \rightarrow \infty$ les courbes se rapprochent car le récepteur dispose de plus symbole pour estimer la matrice $\mathbf{H}$.


# Conclusion
Au cours de ce travail, quatre méthodes de décodage pour des codes spatiotemporels ont été analysées, ainsi que deux modèles de codes. L'impact de l'estimation du canal a aussi été étudié.

Les quatre décodeurs étudiés sont le décodeur du maximum de vraisemblance (MV), le décodeur par forçage à zéro (ZF), le décodeur des moindres carrés (MMSE) et le décodeur par annulation d'interférences successives (SIC). Tous ces décodeurs ont été étudiés pour des codes VBLAST avec $N=2, L=2, M=2$.

Le décodeur MV est le plus coûteux calculatoirement mais aussi celui qui minimise la probabilité d'erreur binaire, en comparant le message reçu à tous les mots de code possibles. Cependant, dans notre cas on a pu exploiter la séparabilité par colonnes pour simplifier le décodage.
Les décodeurs ZF et MMSE cherchent à compenser la convolution du canal pour extraire le mot de code. La différence entre les deux est que le décodeur ZF ne prend pas en compte le bruit, ce qui pose un risque d'explosion du module du filtre adapté si ses valeurs singulières sont proche de 0.
Enfin, le décodeur SIC est le plus performant en terme de taux d'erreur binaire à haut SNR. Il ramène l'impact du canal à une matrice triangulaire supérieure puis annule récursivement les contributions du canal à partir des symboles décodés, en partant du dernier. Cependant cet aspect récursif fait que la moindre erreur de décodage se propage sur tous les symboles suivants, le rendant peu viable à bas SNR.

Le code VBLAST a également été comparé au code d'Alamouti pour un décodeur MV et un nombre $M$ d'antennes à la réception allant de $2$ à $8$. Le code d'Alamouti a un rendement moindre par rapport au VBLAST puisqu'il ne contient que deux symboles répétés deux fois contre quatre symboles pour le VBLAST. Cependant, il a de bien meilleures performances en terme de taux d'erreur binaire pour un même nombre d'antennes à la réception.

Enfin, l'impact de l'estimation du canal à partir d'une séquence pilote connue a été analysé pour des valeurs de $L$ allant de $2$ à $15$. Les performances sont amoindries lorsque $H$ est inconnue, mais finissent par converger vers la situation où $H$ est connue lorsque $L$ est grand.
