function S = generate_mat_learn_seq(N, L)
% GENERATE_MAT_LEARNING_SEQ renvoie la matrice d'une sequence
% d'apprentissage bien formee pour une modulation QPSK.
% N: nombre d'antennes à l'émission
% L: longueur de coherence du canal
    
    qpskmod = comm.QPSKModulator;
    S = zeros(L, N);
    Gram_S = zeros(N, N);

    while det(Gram_S) == 0
        learning_seq = qpskmod(bi2de(randi([0, 1], L, N)));
        for i = 1:N
            S(:, i) = [learning_seq(i:end); learning_seq(1:i-1)];
        end
        Gram_S = S'*S;
    end
end
