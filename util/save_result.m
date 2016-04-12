function [] = save_result( trained_pars,type )
% save trained parameters into mat file
%   
    fname_prefix = sprintf('../result/type%s_base1_%d',...
                    type,trained_pars(1).pars.num_bases);
    fname_mat  = sprintf('%s.mat', fname_prefix);
    fprintf('Save file to %s\n',fname_mat);
%     mkdir(fileparts(fname_save));
    save(fname_mat,'trained_pars')
end

