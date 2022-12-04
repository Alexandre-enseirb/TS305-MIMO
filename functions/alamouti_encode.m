function [X, X_bit] = alamouti_encode(~, mod)
%ALAMOUTI_ENCODE Summary of this function goes here
%   Detailed explanation goes here

X_bit = randi([0, 1], 2, 2);  % N=2 et L=2 sont constants pour Alamouti
X_dec = X_bit * [1; 2];  % conversion bin -> dec (plus rapide que bi2de)
X_symbole = mod(X_dec);
X = [X_symbole(1) -conj(X_symbole(2)); ...
     X_symbole(2)  conj(X_symbole(1))];
end
