function [ferr,dW_total,dh_total,dv_total, poshidprobs, poshidstates, negdata, stat] = ...
    fobj_tirbm_CD_LB_sparse_audio(imdata, W, hbias_vec, vbias_vec, pars, CD_mode, bias_mode, spacing, l2reg)
% imdata:sample_size * 1 * 80; W：6*80*300 hbias_vec：300* 1 vbasis_vec:80*1,spacing:3
ws = size(W,1);% ws:6
% poshidexp:(sample_size - ws + 1) * 1 * 300 可视层进行卷积之后的结果
poshidexp = tirbm_inference_fixconv_1d(imdata, W, hbias_vec, pars);
% 卷积之后进行sample 
%具体执行的操作没有看明白，但是返回的结果为positive 的隐藏层的状态和隐藏层的概率

if(size(poshidexp,1) == 0)
    disp(size(poshidexp));
end
[poshidstates,poshidprobs] = tirbm_sample_multrand_1d(poshidexp, spacing);
if strcmp(CD_mode, 'mf'), poshidstates = poshidprobs; end
% 得到positive的item
posprods = tirbm_vishidprod_fixconv_1d(imdata, poshidprobs, ws);
poshidact = squeeze(sum(sum(poshidprobs,1),2));
posvisact = squeeze(sum(sum(imdata,1),2));

% 计算negative的item
neghidstates = poshidstates;
% for j=1:pars.K_CD  commented as K_CD = 1
% 由hidden_state重建inputdata，作为negdata
negdata = tirbm_reconstruct_LB_fixconv_1d(neghidstates, W, pars);
% 由negdata在推断出neghidden
neghidexp = tirbm_inference_fixconv_1d(negdata, W, hbias_vec, pars);
% 计算neghidden的state和prob
[neghidstates,neghidprobs] = tirbm_sample_multrand_1d(neghidexp, spacing);
% CD_mode = 'exp' - hence commented
%if strcmp(CD_mode, 'mf'), neghidstates = neghidprobs; end
%end
% 计算negative的term的结果
negprods = tirbm_vishidprod_fixconv_1d(negdata, neghidprobs, ws);
neghidact = squeeze(sum(sum(neghidprobs,1),2));
negvisact = squeeze(sum(sum(negdata,1),2));
% 平方和误差（输入数据和重建数据的）
ferr = mean( (imdata(:)-negdata(:)).^2 );

% if strcmp(bias_mode, 'none')
%     dhbias = 0;
%     dvbias = 0;
%     dW = 0;
% elseif strcmp(bias_mode, 'simple')
%     dhbias = squeeze(mean(mean(poshidprobs,1),2)) - pars.pbias;
%     dvbias = 0;
%     dW = 0;
% else 
%     error('wrong adjust_bias mode!');
% end

% bias_mode = 'simple'
dhbias = squeeze(mean(mean(poshidprobs,1),2)) - pars.pbias;
dvbias = 0;
dW = 0;

numcases1 = size(poshidprobs,1)*size(poshidprobs,2);
numcases2 = size(imdata,1)*size(imdata,2);
% 根据CD计算dW，加入稀疏性的要求
dW_total1 = (posprods-negprods)/numcases1;
dW_total2 = - l2reg*W;
dW_total3 = - pars.pbias_lambda*dW;
dW_total = dW_total1 + dW_total2 + dW_total3;

stat = [];
stat.dWnorm_CD = norm(vec(dW_total1));
stat.dWnorm_l2 = norm(vec(dW_total2));

% 计算偏置
dh_total = (poshidact-neghidact)/numcases1 - pars.pbias_lambda*dhbias;
dv_total = (posvisact-negvisact)/numcases2;