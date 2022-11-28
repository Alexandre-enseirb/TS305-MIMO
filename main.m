%% init
close all; clear; clc; dbstop if error;
addpath("functions")

%% paramètres

model_vblast   = init_model('vblast');
model_alamouti = init_model('alamouti');

%% simulation -- vblast

[ber_ML, fer_ML] = ML_sim(model_vblast);
[ber_ZF, fer_ZF] = ZF_sim(model_vblast);
[ber_MMSE, fer_MMSE] = MMSE_sim(model_vblast);
[ber_SIC, fer_SIC] = SIC_sim(model_vblast);

%% Comparaison Vblast -- Alamouti

for m = [2 4 8]
    model_vblast.M   = m;
    model_alamouti.M = m;
    [ber_ML_vblast, fer_ML_vblast]     = ML_sim(model_vblast);
    [ber_ML_alamouti, fer_ML_alamouti] = ML_sim(model_alamouti);
end


%% chargement de donnees

if ~exist("ber_ML", "var")
    load simulations ber_ML fer_ML
end

if ~exist("ber_ZF", "var")
    load simulations ber_ZF fer_ZF
end

if ~exist("ber_MMSE", "var")
    load simulations ber_MMSE fer_MMSE
end

if ~exist("ber_SIC", "var")
    load simulations ber_SIC fer_SIC
end

%% figures
figure

% -- ML
semilogy(model_vblast.SNRdB, ber_ML, 'Color', '#0072BD', 'Marker', '+');
grid on;
hold on;
semilogy(model_vblast.SNRdB, fer_ML, 'Color', '#0072BD', 'LineStyle','--', 'Marker', '+');

% -- ZF
semilogy(model_vblast.SNRdB, ber_ZF, 'Color', '#D95319', 'Marker', 'o');
semilogy(model_vblast.SNRdB, fer_ZF, 'Color', '#D95319', 'LineStyle','--', 'Marker', 'o');

% -- MMSE
semilogy(model_vblast.SNRdB, ber_MMSE, 'Color', '#EDB120', 'Marker', 'v');
semilogy(model_vblast.SNRdB, fer_MMSE, 'Color', '#EDB120', 'LineStyle','--', 'Marker', 'v');

% -- SIC
semilogy(model_vblast.SNRdB, ber_SIC, 'Color', '#7E2F8E', 'Marker', '<');
semilogy(model_vblast.SNRdB, fer_SIC, 'Color', '#7E2F8E', 'LineStyle','--', 'Marker', '<');

xlabel("SNR")
ylabel("TEB")
legend(["BER ML-VBLAST"...
        "FER ML-VBLAST"...
        "BER ZF-VBLAST"...
        "FER ZF-VBLAST"...
        "BER MMSE-BLAST"...
        "FER MMSE-VBLAST"...
        "BER SIC-BLAST"...
        "FER SIC-VBLAST"])
title("Salut,")


