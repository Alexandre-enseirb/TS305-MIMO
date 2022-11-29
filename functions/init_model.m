function model = init_model(type)
%INIT_MODEL permet de charger toutes les donnees necessaires aux
%simulations.
%
%   init_model(SF, size_BER) cree un modele avec toutes les constantes
%   necessaires a la simulation depuis le fichier constantes.m
%   et les stock comme attributs d'un objet model.

% -- Parametres MIMO
model.N  = 2; % antennes a l'emission
model.M  = 2; % antennes a la reception
model.L  = 2; % nb de symboles pour lesquels H est cste
model.Nb = 2; % bits/symboles

% -- Parametres de SNR
SNRdB_min  = -4;
SNRdB_step = .25;
SNRdB_max  = 12;

model.SNRdB  = SNRdB_min:SNRdB_step:SNRdB_max;
model.SNR    = 10.^(model.SNRdB/10);
model.sigma2 = 1./model.SNR;

% -- Parametres de simulation
model.min_bits = 1e12;
model.min_err  = 1000;

% -- type du modele
if ~any(strcmp(type, ["alamouti" "vblast"]))
    error("Modèle inconnu. Veuillez spécifier 'alamouti' ou 'vblast'.")
end

model.type = type;
end