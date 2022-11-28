function [X_vblast, X_bit] = vblast_encode(N, L, Nb, mod)
%VBLAST_ENCODE Summary of this function goes here
%   Detailed explanation goes here
X_bit = randi([0, 1], N*L, Nb);
X_dec = bi2de(X_bit);
X_symbole = mod(X_dec);
X_vblast = reshape(X_symbole, [N, L]);
end

