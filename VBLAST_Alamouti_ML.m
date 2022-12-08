%% Init
close all; clear; clc; dbstop if error;
addpath("functions")

%% Paramètres
model = init_model();
M = [2 4 8];

%% Simulations
fprintf("nSim = %d\n\n", model.nSim);

ber_ML_vblast   = zeros(1, length(model.SNRdB), length(M));
ber_ML_alamouti = zeros(1, length(model.SNRdB), length(M));

for i=1:length(M)
    model.M = M(i);
    [ber_ML_vblast(:, :, i)] = sim(model, @VBLAST_encode, @VBLAST_decode_ML);
    [ber_ML_alamouti(:,:,i)] = sim(model, @Alamouti_encode, @Alamouti_decode_ML);
end

save("resultats/VBLAST_Alamouti_ML.mat", "model", "M", "ber_ML_vblast", "ber_ML_alamouti");

%% Affichage
load resultats/VBLAST_Alamouti_ML.mat

colors = ["#0072BD", "#D95319", "#77AC30"];
figure("Name", "Performance ML Alamouti - VBLAST")
hold on
for i = 1:size(ber_ML_vblast, 3)
    semilogy(model.SNRdB, ber_ML_vblast(: ,: , i), 'Color', colors(i), 'Marker', 'v');
    semilogy(model.SNRdB, ber_ML_alamouti(:,:, i), 'Color', colors(i), 'Marker', 's');
end

set(gca, "YScale", "log")
axis tight
grid on
xlabel("SNR")
ylabel("BER")

legend(["VBLAST"; "Alamouti"] + " M=" + num2cell(M), "Location", "best")