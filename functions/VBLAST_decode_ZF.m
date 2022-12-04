function Y_ZF = VBLAST_decode_ZF(Y, H, A, ~)
%VBLAST_DECODE_ZF decode les observations Y par la methode du forcage a
%zero (ZF) par rapport a la matrice du canal H et a l'alphabet A.

% -- matrice pseudo-inverse
H_pinv = pinv(H);

% -- decodage
Z = H_pinv*Y;
rep_Z = (repmat(Z(:), 1, numel(A)));
Z_diff = abs(rep_Z - A.').^2;
[~, ind_min] = min(Z_diff,[], 2);

% récupération des symboles
Y_ZF = A(ind_min);

end
