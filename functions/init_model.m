function model = init_model()
%INIT_MODEL charge toutes les donnees necessaires aux simulations.
%
%   init_model() cree un modele avec toutes les constantes necessaires a 
%   la simulation et les stocke comme attributs d'un objet.

% -- Parametres MIMO
model.N  = 2; % antennes a l'emission
model.M  = 2; % antennes a la reception
model.L  = 2; % nb de symboles pour lesquels H est constant/coherent
model.Nb = 2; % nb de bits/symboles

% -- Parametres de SNR
SNRdB_min  = -4;
SNRdB_step = 0.25;
SNRdB_max  = 12;

model.SNRdB  = SNRdB_min:SNRdB_step:SNRdB_max;
model.SNR    = 10.^(model.SNRdB/10);
model.sigma2 = 1./model.SNR;

% -- Parametres de simulation
model.min_bits = 100e6;
model.min_err  = 100;

% -- nombre de simulations (pour lisser les courbes)
model.nSim = 100;

end