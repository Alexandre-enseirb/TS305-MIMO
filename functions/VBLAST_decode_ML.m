function X_hat = VBLAST_decode_ML(Y, H, C)
    N = size(C, 1);  % nb d'antennes à l'émission
    L = size(H, 2);  % nb de symboles pour lesquels H est cste
    X_hat = zeros(N, L);  % estimation des symboles émis
    for i_y = 1:L
        symbole_rec = Y(:, i_y);  % les symboles reçus sur les M antennes
        cout = sqrt(sum((abs(symbole_rec - H*C)).^2));
        [~, ind_min] = min(cout);
        X_hat(:, i_y) = C(:, ind_min);
    end
end
