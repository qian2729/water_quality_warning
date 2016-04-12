function [ descriptor ] = get_descriptor_with_matrix( h_state )
% return descriptor from h_state
%   h_state: a matrix time sequence size * 1 * bases size
    seq_size = size(h_state,1);
    descriptor =  sum(squeeze(h_state))/seq_size;
end

