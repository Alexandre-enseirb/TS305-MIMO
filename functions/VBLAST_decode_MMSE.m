function Y_MMSE = VBLAST_decode_MMSE(Y, H, A, sigma2)
%VBLAST_DECODE_MMSE décode les observations Y par minimisation de l'erreur
%quadratique moyenne (MMSE) par rapport à la matrice du canal H et à 
%l'alphabet A.

% -- Paramètres
[N, L] = size(Y);     % taille du message reçus

% -- Filtrage
Q = eye(N); % covariance des symboles émis (supposée identite)
F_MMSE = Q'*H' / (H*Q*H' + sigma2*eye(N)); % filtre MMSE
Z = F_MMSE*Y;

% -- décodage
A_map  = repmat(A.', N*L, 1);  % mise en forme de l'alphabet
erreur = abs(Z(:) - A_map).^2;
[~, ind_min] = min(erreur, [], 2);

% Récupération des symboles
Y_MMSE = A(ind_min);
end
