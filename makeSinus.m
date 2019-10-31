function [new_signal] = makeSinus(base_signal, amplitude, freq, start_i, stop_i)
%MAKESINUS Summary of this function goes here
%   Detailed explanation goes here

new_signal = base_signal;

base_part = base_signal(start_i:stop_i);
x_length = length(base_part);

sin_base = 1:1:x_length;
sin_base = 2*pi/x_length*sin_base;

signal = amplitude*sin(freq*sin_base);

new_signal([start_i:stop_i]) = signal;



end

