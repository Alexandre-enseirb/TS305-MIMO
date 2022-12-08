%% Init
close all; clear; clc; dbstop if error;
addpath("functions")

%% Parametres
model = init_model();

%% Simulations
fprintf("nSim = %d\n\n", model.nSim);

[ber_ML, fer_ML]     = sim(model, @VBLAST_encode, @VBLAST_decode_ML);
[ber_ZF, fer_ZF]     = sim(model, @VBLAST_encode, @VBLAST_decode_ZF);
[ber_MMSE, fer_MMSE] = sim(model, @VBLAST_encode, @VBLAST_decode_MMSE);
[ber_SIC, fer_SIC]   = sim(model, @VBLAST_encode, @VBLAST_decode_SIC);

save("resultats/VBLAST_ML_ZF_MMSE_SIC.mat", "model", "ber_ML", "fer_ML", "ber_ZF", "fer_ZF", "ber_MMSE", "fer_MMSE", "ber_SIC", "fer_SIC");

%% Affichage
load resultats/VBLAST_ML_ZF_MMSE_SIC.mat

colors = ["#0072BD", "#D95319", "#77AC30", "#7E2F8E"];
figure("Name", "Performance ML Alamouti - VBLAST")
hold on

% -- ML
semilogy(model.SNRdB, ber_ML, "Color", colors(1))
semilogy(model.SNRdB, fer_ML, "Color", colors(1), "LineStyle", "--")

% -- ZF
semilogy(model.SNRdB, ber_ZF, "Color", colors(2))
semilogy(model.SNRdB, fer_ZF, "Color", colors(2), "LineStyle", "--")

% -- MMSE
semilogy(model.SNRdB, ber_MMSE, "Color", colors(3))
semilogy(model.SNRdB, fer_MMSE, "Color", colors(3), "LineStyle", "--")

% -- SIC
semilogy(model.SNRdB, ber_SIC, "Color", colors(4))
semilogy(model.SNRdB, fer_SIC, "Color", colors(4), "LineStyle", "--")

set(gca, "YScale", "log")
axis tight
grid on
xlabel("SNR")
ylabel("TEB / FER")
legend(["BER"; "FER"] + " " +["ML", "ZF", "MMSE", "SIC"])