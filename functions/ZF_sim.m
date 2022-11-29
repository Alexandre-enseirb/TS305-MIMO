function [ber, fer] = ZF_sim(model)
%ZF_SIM simule une communication MIMO et retourne les taux d'erreurs
%binaire (ber) et paquet (fer) associes. Le decodage est realise par
%zero-forcing (ZF)
%
%   ZF_sim(model) utilise les parametres definis dans 'model' pour derouler
%   la simulation. Le modele est a initialiser avec la fonction
%   'init_model()'
%
%   ber = ZF_sim(model) permet de recuperer le taux d'erreur binaire a
%   l'issue de la simulation
%
%   [ber, fer] = ZF_sim(model) permet de recuperer les taux d'erreurs
%   binaire et paquet a l'issue de la simulation

% -- allocation memoire
ber = zeros(size(model.SNRdB));
fer = zeros(size(model.SNRdB));

% -- mod/demod qpsk
qpskmod = comm.QPSKModulator;

% -- generation de l'alphabet
A_dec = 0:2^model.Nb-1;
A     = qpskmod(A_dec.');

% -- simulation
for i_sigma2 = 1:length(model.SNRdB)
    count.err_bit = 0; % nb d'erreurs binaires
    count.err_fra = 0; % nb d'erreurs paquet
    count.bit     = 0; % nb de bits envoyes
    count.fra     = 0; % nb de paquets envoyes
    while (count.err_bit < model.min_err) && (count.bit < model.min_bits)
        % emetteurs
        [X_vblast, X_bit] = vblast_encode(model.N, model.L, model.Nb, qpskmod);

        % canal
        H = randn(model.M, model.N, "like", 1i);
        V = sqrt(model.sigma2(i_sigma2)) * randn(model.M, model.L, "like", 1i);
        Y = H * X_vblast + V;

        % récepteur
        Y_ZF = VBLAST_decode_ZF(Y, H, A);
        Y_bit = de2bi(Y_ZF.', model.N);

        % évaluation des erreurs
        nErr = sum(Y_bit ~= X_bit, "all");

        count.err_bit = count.err_bit + nErr;
        count.err_fra = count.err_fra + (nErr>0);
        count.bit     = count.bit + numel(X_bit);
        count.fra     = count.fra + 1;
    end
    ber(i_sigma2) = count.err_bit / count.bit;
    fer(i_sigma2) = count.err_fra / count.fra;
    %disp(teb(i_sigma2));
end


end

