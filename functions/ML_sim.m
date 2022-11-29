function [ber, fer] = ML_sim(model)
%ML_SIM simule une communication MIMO et retourne les taux d'erreurs
%binaire (ber) et paquet (fer) associes. Le decodage est realise par
%maximum de vraisemblance (Maximum Likelihood)
%
%   ML_sim(model) utilise les parametres definis dans 'model' pour derouler
%   la simulation. Le modele est a initialiser avec la fonction
%   'init_model()'
%
%   ber = ML_sim(model) permet de recuperer le taux d'erreur binaire a
%   l'issue de la simulation
%
%   [ber, fer] = ML_sim(model) permet de recuperer les taux d'erreurs
%   binaire et paquet a l'issue de la simulation

% -- allocation memoire
ber = zeros(size(model.SNRdB));
fer = zeros(size(model.SNRdB));

% -- mod/demod qpsk
qpskmod = comm.QPSKModulator;
qpskdemod = comm.QPSKDemodulator;

% -- generation des colonnes du code
C1 = mod((0:2^(2*model.Nb)-1), 4);
C2 = fix((0:2^(2*model.Nb)-1)/4);
C = [qpskmod(C1.').'; qpskmod(C2.').'];

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
        if strcmp(model.type, 'alamouti')
            [X, X_bit] = alamouti_encode(qpskmod);
        else
            [X, X_bit] = vblast_encode(model.N, model.L, model.Nb, qpskmod);
        end
        % canal
        H = randn(model.M, model.N, "like", 1i);
        V = sqrt(model.sigma2(i_sigma2)) * randn(model.M, model.L, "like", 1i);
        Y = H * X + V;

        % récepteur
        if strcmp(model.type, 'alamouti')
            C_ML = Alamouti_decode_ML(Y, H, A);
        else
            C_ML = VBLAST_decode_ML(Y, H, C);
        end
        Y_symb = qpskdemod(C_ML(:));
        Y_bit = de2bi(Y_symb(:), model.Nb);

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

