function [ h_state,h_prob ] = inference( imdata,W,hbias_vec, vbias_vec,pars )
%INFERENCE Summary of this function goes here
%   Detailed explanation goes here
    ws = pars.ws;
    spacing = pars.spacing;
    l2reg = pars.l2reg;

    % these conditions have been used and changed to reduce branches! 
    CD_mode = pars.CD_mode;
    bias_mode = pars.bias_mode;
   
    % 保证imdata的列数满足mod(size(imdata,2)-ws+1, spacing)==0，否则将剩余列去除
    imdata = trim_audio_for_spacing_fixconv(imdata, ws, spacing);
    % 将imdata转置，每一行为一个时刻的feature
    imdatatr = imdata'; % sample_size * 80:
    % 将imdata转换为3D的，shape为 样本数 * 1 *
    % channel_size(80),每个channel为一个卷积的处理单元
    imdatatr = reshape(imdatatr, [size(imdatatr,1), 1, size(imdatatr,2)]);
    % imdata:sample_size * 1 * 80; W：6*80*300 hbias_vec：300* 1 vbasis_vec:80*1,spacing:3
    [ferr dW dh dv h_prob h_state negdata stat]= fobj_tirbm_CD_LB_sparse_audio(imdatatr, W, hbias_vec, vbias_vec, pars, CD_mode, bias_mode, spacing, l2reg);

end

