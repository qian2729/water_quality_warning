function [ferr,dW_total,dh_total,dv_total, poshidprobs, poshidstates, negdata, stat] = ...
    fobj_tirbm_CD_LB_sparse_audio(imdata, W, hbias_vec, vbias_vec, pars, CD_mode, bias_mode, spacing, l2reg)
% imdata:sample_size * 1 * 80; W��6*80*300 hbias_vec��300* 1 vbasis_vec:80*1,spacing:3
ws = size(W,1);% ws:6
% poshidexp:(sample_size - ws + 1) * 1 * 300 ���Ӳ���о��֮��Ľ��
poshidexp = tirbm_inference_fixconv_1d(imdata, W, hbias_vec, pars);
% ���֮�����sample 
%����ִ�еĲ���û�п����ף����Ƿ��صĽ��Ϊpositive �����ز��״̬�����ز�ĸ���

if(size(poshidexp,1) == 0)
    disp(size(poshidexp));
end
[poshidstates,poshidprobs] = tirbm_sample_multrand_1d(poshidexp, spacing);
if strcmp(CD_mode, 'mf'), poshidstates = poshidprobs; end
% �õ�positive��item
posprods = tirbm_vishidprod_fixconv_1d(imdata, poshidprobs, ws);
poshidact = squeeze(sum(sum(poshidprobs,1),2));
posvisact = squeeze(sum(sum(imdata,1),2));

% ����negative��item
neghidstates = poshidstates;
% for j=1:pars.K_CD  commented as K_CD = 1
% ��hidden_state�ؽ�inputdata����Ϊnegdata
negdata = tirbm_reconstruct_LB_fixconv_1d(neghidstates, W, pars);
% ��negdata���ƶϳ�neghidden
neghidexp = tirbm_inference_fixconv_1d(negdata, W, hbias_vec, pars);
% ����neghidden��state��prob
[neghidstates,neghidprobs] = tirbm_sample_multrand_1d(neghidexp, spacing);
% CD_mode = 'exp' - hence commented
%if strcmp(CD_mode, 'mf'), neghidstates = neghidprobs; end
%end
% ����negative��term�Ľ��
negprods = tirbm_vishidprod_fixconv_1d(negdata, neghidprobs, ws);
neghidact = squeeze(sum(sum(neghidprobs,1),2));
negvisact = squeeze(sum(sum(negdata,1),2));
% ƽ�������������ݺ��ؽ����ݵģ�
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
% ����CD����dW������ϡ���Ե�Ҫ��
dW_total1 = (posprods-negprods)/numcases1;
dW_total2 = - l2reg*W;
dW_total3 = - pars.pbias_lambda*dW;
dW_total = dW_total1 + dW_total2 + dW_total3;

stat = [];
stat.dWnorm_CD = norm(vec(dW_total1));
stat.dWnorm_l2 = norm(vec(dW_total2));

% ����ƫ��
dh_total = (poshidact-neghidact)/numcases1 - pars.pbias_lambda*dhbias;
dv_total = (posvisact-negvisact)/numcases2;