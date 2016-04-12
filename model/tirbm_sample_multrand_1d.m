function [H,HP] = tirbm_sample_multrand_1d(poshidexp, spacing)
% poshidexp is 3d array sample_size - ws + 1  * 1 * 300
poshidexp = max(min(poshidexp,20),-20); % DEBUG: This is for preventing NAN values
poshidprobs = exp(poshidexp);% do exponent for every element in poshidexp
% poshidprobs_mult: (spacing + 1, (conv_sample_size * 1 * 300 / 3))
poshidprobs_mult = zeros(spacing+1, size(poshidprobs,1)*size(poshidprobs,2)*size(poshidprobs,3)/spacing);
%set last row in poshidprobs_mult = 1
poshidprobs_mult(end,:) = 1;
% TODO: replace this with more realistic activation, bases..
% �õ�1:spaceing��imdata��(conv_sample_size * 1 * 300 / 3)������
for r=1:spacing
    temp = poshidprobs(r:spacing:end, :, :);
    poshidprobs_mult(r,:) = temp(:);
end
% poshidprobs_mult' : ((conv_sample_size * 1 * 300 / 3),spacing + 1)
% RETURN %Todo S1�����û��д��۲� P1ΪP�е�ÿһ�н��й�һ�������Ը��е��ܺ�
[S1,P1] = multrand2(poshidprobs_mult');
% S and P:(spacing + 1,(conv_sample_size * 1 * 300 / 3))
S = S1';
P = P1';
clear S1 P1

% convert back to original sized matrix
% �����ԭ���ľ���
% poshidexp is 3d array sample_size - ws + 1  * 1 * 300
H = zeros(size(poshidexp));
HP = zeros(size(poshidexp));
for r=1:spacing
    H(r:spacing:end, :, :) = reshape(S(r,:), [size(H,1)/spacing, size(H,2), size(H,3)]);
    HP(r:spacing:end, :, :) = reshape(P(r,:), [size(H,1)/spacing, size(H,2), size(H,3)]);
end

% if nargout >2
%     Sc = sum(S(1:end-1,:));
%     Pc = sum(P(1:end-1,:));
%     Hc = reshape(Sc, [size(poshidexp,1)/spacing,size(poshidexp,2),size(poshidexp,3)]);
%     HPc = reshape(Pc, [size(poshidexp,1)/spacing,size(poshidexp,2),size(poshidexp,3)]);
% end

return
