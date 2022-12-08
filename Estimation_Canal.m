%% Init
close all; clear; clc; dbstop if error;
addpath("functions")

%% Parametres
model = init_model();
L = [2, 5, 10, 15];

%% Simulations
fprintf("nSim = %d\n\n", model.nSim);

ber_H_estim = zeros(1, length(model.SNRdB), length(L));
ber_H_known = zeros(1, length(model.SNRdB), length(L));

for i = 1:length(L)
    model.L = L(i);
    [ber_H_estim(:, :, i)] = sim(model, @VBLAST_encode, @VBLAST_decode_ML, true);
    [ber_H_known(:, :, i)] = sim(model, @VBLAST_encode, @VBLAST_decode_ML, false);
end

save("resultats/Estimation_Canal.mat", "model", "L", "ber_H_estim", "ber_H_known")

%% Affichage
load resultats/Estimation_Canal.mat

colors = ["#0072BD", "#D95319", "#77AC30" "#7E2F8E"];
figure("Name", "Performance ML avec un canal estimé")
hold on
for i = 1:length(L)
    semilogy(model.SNRdB, ber_H_estim(:, :, i), "Color", colors(i), "LineStyle", "-")
end
for i = 1:length(L)
    semilogy(model.SNRdB, ber_H_known(:, :, i), "Color", colors(i), "LineStyle", "--")
end

set(gca, "YScale", "log")
axis tight
grid on
xlabel("SNR")
ylabel("BER")
legend(["H estimation", "H known"] + " L=" + num2cell(L).', "Location", "best")
