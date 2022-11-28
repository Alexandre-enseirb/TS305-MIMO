function Y_MMSE = VBLAST_decode_MMSE(Y, H, sigma2, A)
%VBLAST_DECODE_MMSE decode les observations Y par minimisation de l'erreur
%quadratique moyenne (MMSE) par rapport a la matrice du canal H et a 
%l'alphabet A.

% -- Parametres
[M, N] = size(H);
[~, L] = size(Y);     % taille du message
Cov_sig = eye(N); % covariance des symboles emis (supposee Identite)

F_MMSE = Cov_sig'*H' / (H*Cov_sig*H' + sigma2*eye(M)); % filtre MMSE

% -- mise en forme de l'alphabet
A = A.';
A = repmat(A,N*L,1);

% -- decodage
Z = F_MMSE*Y;

Z_diff = (repmat(Z(:),1,4) - A).^2;
[~, Y_MMSE] = min(Z_diff,[],2);

% compensation de l'indice matlab
Y_MMSE = Y_MMSE - ones(size(Y_MMSE));

end