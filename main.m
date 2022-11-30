%% init
close all; clear; clc; dbstop if error;
addpath("functions")

%% paramètres

model_vblast   = init_model('vblast');
model_alamouti = init_model('alamouti');

%% simulation -- vblast

fprintf("nSim = %d\n\n", model_vblast.nSim);

[ber_ML, fer_ML] = ML_sim(model_vblast);
[ber_ZF, fer_ZF] = ZF_sim(model_vblast);
[ber_MMSE, fer_MMSE] = MMSE_sim(model_vblast);
[ber_SIC, fer_SIC] = SIC_sim(model_vblast);

%% Comparaison Vblast -- Alamouti

M = [2 4 8];
ber_ML_vblast = zeros(1, length(model_vblast.SNRdB), length(M));
ber_ML_alamouti = zeros(1, length(model_alamouti.SNRdB), length(M));
fer_ML_vblast = zeros(1, length(model_vblast.SNRdB), length(M));
fer_ML_alamouti = zeros(1, length(model_alamouti.SNRdB), length(M));

for i=1:length(M)
    model_vblast.M   = M(i);
    model_alamouti.M = M(i);
    [ber_ML_vblast(:,:,i)]   = ML_sim(model_vblast);
    [ber_ML_alamouti(:,:,i)] = ML_sim(model_alamouti);
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

% ---- Lines

% -- ML
semilogy(model_vblast.SNRdB, ber_ML, 'Color', '#0072BD');
grid on;
hold on;
semilogy(model_vblast.SNRdB, fer_ML, 'Color', '#0072BD', 'LineStyle','--');

% -- ZF
semilogy(model_vblast.SNRdB, ber_ZF, 'Color', '#D95319');
semilogy(model_vblast.SNRdB, fer_ZF, 'Color', '#D95319', 'LineStyle','--');

% -- MMSE
semilogy(model_vblast.SNRdB, ber_MMSE, 'Color', '#EDB120');
semilogy(model_vblast.SNRdB, fer_MMSE, 'Color', '#EDB120', 'LineStyle','--');

% -- SIC
semilogy(model_vblast.SNRdB, ber_SIC, 'Color', '#7E2F8E');
semilogy(model_vblast.SNRdB, fer_SIC, 'Color', '#7E2F8E', 'LineStyle','--');

% ---- Markers

semilogy(model_vblast.SNRdB(1:5:end), ber_ML(1:5:end), 'Color', '#0072BD', 'LineStyle','none', 'Marker', '+');
semilogy(model_vblast.SNRdB(1:5:end), fer_ML(1:5:end), 'Color', '#0072BD', 'LineStyle','none', 'Marker', '+');

% -- ZF
semilogy(model_vblast.SNRdB(1:5:end), ber_ZF(1:5:end), 'Color', '#D95319', 'LineStyle','none', 'Marker', 'o');
semilogy(model_vblast.SNRdB(1:5:end), fer_ZF(1:5:end), 'Color', '#D95319', 'LineStyle','none', 'Marker', 'o');

% -- MMSE
semilogy(model_vblast.SNRdB(1:5:end), ber_MMSE(1:5:end), 'Color', '#EDB120', 'LineStyle','none', 'Marker', 'v');
semilogy(model_vblast.SNRdB(1:5:end), fer_MMSE(1:5:end), 'Color', '#EDB120', 'LineStyle','none', 'Marker', 'v');

% -- SIC
semilogy(model_vblast.SNRdB(1:5:end), ber_SIC(1:5:end), 'Color', '#7E2F8E', 'LineStyle','none', 'Marker', '<');
semilogy(model_vblast.SNRdB(1:5:end), fer_SIC(1:5:end), 'Color', '#7E2F8E', 'LineStyle','none', 'Marker', '<');


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


%% figures comparaison

figure(2)
semilogy(model_vblast.SNRdB, ber_ML_vblast(:,:,1), 'Color', '#0072BD', 'Marker', '<');
hold on;
grid on;

semilogy(model_vblast.SNRdB, ber_ML_vblast(:,:,2), 'Color', '#D95319', 'Marker', '>');

semilogy(model_vblast.SNRdB, ber_ML_vblast(:,:,3), 'Color', '#EDB120', 'Marker', 'v');

semilogy(model_alamouti.SNRdB, ber_ML_alamouti(:,:,1), 'Color', '#7E2F8E', 'Marker', '+');

semilogy(model_alamouti.SNRdB, ber_ML_alamouti(:,:,2), 'Color', '#77AC30', 'Marker', 'o');

semilogy(model_alamouti.SNRdB, ber_ML_alamouti(:,:,3), 'Color', '#4DBEEE', 'Marker', '*');


xlabel("SNR");
ylabel("BER/FER");
title("Salut,");

legend(["BER VBLAST M=2"...
        "BER VBLAST M=4"...
        "BER VBLAST M=8"...
        "BER ALAMOUTI M=2"...
        "BER ALAMOUTI M=4"...
        "BER ALAMOUTI M=8"])