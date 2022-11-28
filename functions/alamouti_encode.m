function [X, X_bit] = alamouti_encode(mod)
%ALAMOUTI_ENCODE Summary of this function goes here
%   Detailed explanation goes here

% Parametres
N  = 2;
L  = 2;
Nb = 2;

X_bit = randi([0, 1], N, Nb);
X_dec = bi2de(X_bit);
X_symbole = mod(X_dec);
X = [X_symbole(1) -conj(X_symbole(2)); ...
     X_symbole(2)  conj(X_symbole(1))];
end

