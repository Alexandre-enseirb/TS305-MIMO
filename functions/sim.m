function [ber, fer] = sim(model, encodeur, decodeur, canal_estime)
%SIM simule une communication MIMO et retourne les taux d'erreurs
%binaire (ber) et paquet (fer) associes.
%
%   sim(model, encoder, decodeur) utilise les parametres definis dans 
%   'model' pour dérouler la simulation. Le modèle est à initialiser avec
%   la fonction 'init_model()'
%
%   [ber, fer] = sim(model, encodeur, decodeur, canal_estime) permet de
%   preciser si le canal doit être estimé (true) ou non (false: par défaut)
%
%   ber = sim(model, ...) permet de recuperer le taux d'erreur binaire à
%   l'issue de la simulation
%
%   [ber, fer] = sim(model, ...) permet de recuperer les taux d'erreurs
%   binaire et paquet a l'issue de la simulation

print_simulation_details(decodeur)

% -- Allocation memoire
ber = zeros(size(model.SNRdB));
fer = zeros(size(model.SNRdB));

% -- Mod/demod QPSK
qpskmod = comm.QPSKModulator;
qpskdemod = comm.QPSKDemodulator;

% -- Ensemble de comparaison pour le décodage
A_dec = 0:2^model.Nb-1;  % alphabet
A = qpskmod(A_dec.');
if strcmp(func2str(decodeur), "VBLAST_decode_ML")
    C1 = mod((0:2^(2*model.Nb)-1), 4);
    C2 = fix((0:2^(2*model.Nb)-1)/ 4);
    A = [qpskmod(C1.').'; qpskmod(C2.').'];
end

% -- Sequence d'apprentissage
if exist("canal_estime", "var") && canal_estime == true
    fprintf("Canal estimé par séquence d'apprentissage\n")
    S = generate_mat_learn_seq(model.N, model.L);
    S_invGramS = S/(S'*S);
    get_H = @(~, Y_learn) Y_learn * S_invGramS;
else
    S = zeros(model.L, model.N);  % pas de sequence d'apprentissage,
    get_H = @(H, ~) H;            % le vrai canal est renvoye
end

% -- Simulation
tic;
for i_sim = 1:model.nSim
    for i_sigma2 = 1:length(model.SNRdB)
        count.err_bit = 0;  % nb d'erreurs binaires
        count.err_fra = 0;  % nb d'erreurs paquet
        count.bit     = 0;  % nb de bits envoyes
        count.fra     = 0;  % nb de paquets envoyes
        while (count.err_bit < model.min_err) && (count.bit < model.min_bits)
            % emetteurs
            [X, X_bit] = encodeur(model, qpskmod);

            % canal
            H = randn(model.M, model.N, "like", 1i);
            V = sqrt(model.sigma2(i_sigma2)) * randn(model.M, model.L, "like", 1i);
            Y = H * X + V;
            V_learn = sqrt(model.sigma2(i_sigma2)) * randn(model.M, model.L, "like", 1i);
            Y_learn = H * S' + V_learn;

            % récepteur
            H = get_H(H, Y_learn);
            C_ML = decodeur(Y, H, A, model.sigma2(i_sigma2));
            Y_symb = qpskdemod(C_ML(:));
            Y_bit = de2bi(Y_symb(:), model.Nb);

            % évaluation des erreurs
            nErr = sum(Y_bit ~= X_bit, "all");

            count.err_bit = count.err_bit + nErr;
            count.err_fra = count.err_fra + (nErr>0);
            count.bit     = count.bit + numel(X_bit);
            count.fra     = count.fra + 1;
        end
        ber(i_sigma2) = ber(i_sigma2) + count.err_bit / count.bit;
        fer(i_sigma2) = fer(i_sigma2) + count.err_fra / count.fra;
    end
end
t = toc;

% Lissage
fprintf("Temps d'exécution: %.2f s\nTemps moyen: %.4f s\n\n",t,t/model.nSim);
ber = ber/model.nSim;
fer = fer/model.nSim;

end

function print_simulation_details(decodeur)
    func_words = strsplit(func2str(decodeur), "_");
    encodeur_str = func_words(1);
    decodeur_str = func_words(end);
    fprintf("## -- " + encodeur_str + " | " + decodeur_str + "\n\n");
end