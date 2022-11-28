function Y_ZF = VBLAST_decode_ZF(Y, H, A)
%VBLAST_DECODE_ZF decode les observations Y par la methode du forcage a
%zero (ZF) par rapport a la matrice du canal H et a l'alphabet A.

% -- parametres
[N,L] = size(Y);

% -- mise en forme de l'alphabet
A = A.';
A = repmat(A,N*L,1);

% -- matrice pseudo-inverse
H_pinv = pinv(H);

% -- decodage
Z = H_pinv*Y;
Z_diff = abs((repmat(Z(:),1,4) - A)).^2;
[~, Y_ZF] = min(Z_diff,[],2);

% compensation de l'indice matlab
Y_ZF = Y_ZF - ones(size(Y_ZF));


end
