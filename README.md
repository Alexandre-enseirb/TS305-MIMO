# TS305: codage pour les systèmes MIMO

## Scripts
Trois scripts indépendants sont disponibles:
1. [VBLAST_ML_ZF_MMSE_SIC](https://github.com/Alexandre-enseirb/TS305-MIMO/blob/main/VBLAST_ML_ZF_MMSE_SIC.m): décodage VBLAST sous différentes techniques (ML, MMSE, SIC, ZF)
2. [VBLAST_Alamouti_ML](https://github.com/Alexandre-enseirb/TS305-MIMO/blob/main/VBLAST_Alamouti_ML.m): compare les codes VBLAST et Alamouti lors d'un décodage ML avec un nombre d'antennes de réception croissant.
3. [Estimation_Canal](https://github.com/Alexandre-enseirb/TS305-MIMO/blob/main/Estimation_Canal.m): considère le cas où le canal n'est pas connu et doit être est estimé à l'aide d'une séquence d'apprentissage

Dans ces trois scripts, une seule fonction générique de [simulation](https://github.com/Alexandre-enseirb/TS305-MIMO/blob/main/functions/sim.m) est utilisée. Les méthodes de codage et de décodage lui sont passées en argument.

## Résultat
Le dossier [resultat](https://github.com/Alexandre-enseirb/TS305-MIMO/tree/main/resultats) stocke les dernières simulations réalisées. Ces dernières sont analysées en détails dans le [rapport](https://github.com/Alexandre-enseirb/TS305-MIMO/blob/main/doc/rapport.md).
