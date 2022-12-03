function C_hat = VBLAST_decode_ML(Y, H, C)
    C_hat = zeros(size(C, 1), size(Y, 2));
    for i_y = 1:size(Y, 2)
        cout = zeros(1, size(C, 2));
        for i_c = 1:size(C, 2)
            cout(i_c) = norm(Y(:, i_y) - H*C(:, i_c), "fro");
        end
        [~, ind_min] = min(cout);
        C_hat(:, i_y) = C(:, ind_min);
    end
end
