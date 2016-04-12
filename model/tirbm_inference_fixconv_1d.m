function [poshidexp2,poshidprobs2] = tirbm_inference_fixconv_1d(imdata, W, hbias_vec, pars)

ws = size(W,1);  % ws:6
numbases = size(W,3); % numbase:300
numchannel = size(W,2); % numchannel:80
% poshidexp2:(sample_size - 6 + 1) * 1 * 300
poshidexp2 = zeros(size(imdata,1)-ws+1, 1, numbases);
% nargout  = 1
% if nargout>1
%     poshidprobs2 = zeros(size(poshidprobs2));
% end

% poshidexp2 = zeros(size(imdata,1)-ws+1, size(imdata,2)-ws+1, numbases);
% 先进行卷积
for c=1:numchannel
    % H : 6 * 1 * 300(W:reverse order)
    H = reshape(W(end:-1:1, c, :),[ws,1,numbases]);
    %  imdata:sample_size * 1 * 80
    % conv2_mult( sample_size * 1 * 1 for every channel,H,6 * 1 * 300)
    % conv2_mult return (sample_size - 6 + 1) * 1 * 300
    % 所以卷积操作把各个channel的卷积结果求和得到300个base的卷积的输出
    poshidexp2 = poshidexp2 + reshape(conv2_mult(imdata(:,:,c), H, 'valid'), size(poshidexp2));
end
%加上偏置
for b=1:numbases
    poshidexp2(:,:,b) = pars.C_sigm/(pars.std_gaussian^2).*(poshidexp2(:,:,b) + hbias_vec(b));
% nargout = 1
    if nargout>1
        poshidprobs2(:,:,b) = 1./(1 + exp(-poshidexp2(:,:,b)));
    end
end

