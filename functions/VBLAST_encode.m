function [X_vblast, X_bit] = VBLAST_encode(model, mod)
%VBLAST_ENCODE Summary of this function goes here
%   Detailed explanation goes here
X_bit = randi([0, 1], model.N*model.L, model.Nb);
X_dec = bi2de(X_bit);
X_symbole = mod(X_dec);
X_vblast = reshape(X_symbole, [model.N, model.L]);
end

