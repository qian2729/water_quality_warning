function [S P] = multrand2(P)
% P poshidprobs_mult' : ((conv_sample_size * 1 * 300 / 3),spacing + 1)
% P is 2-d matrix: 2nd dimension is # of choices

% sumP = row_sum(P); 
% ���н��мӺ�
sumP = sum(P,2);% sumP: ((conv_sample_size * 1 * 300 / 3), 1)
% P�е�ÿһ�н��й�һ�������Ը��е��ܺ�
P = P./repmat(sumP, [1,size(P,2)]);
% ��ȥÿһ�е��ۼӺͣ�ÿ��Ԫ�ض��������������ǰ���Ԫ�ص��ܺ�
cumP = cumsum(P,2);
% rand(size(P));
% a random number from conv_sample_size * 1 * 300 / 3)
unifrnd = rand(size(P,1),1);
% cumP�е�Ԫ�ش����������Ϊ1
temp = cumP > repmat(unifrnd,[1,size(P,2)]);
% ����tempÿ�У�����֮��Ĳ�ֵ
Sindx = diff(temp,1,2);
% S Ϊ���ؽ��
S = zeros(size(P));
% S�ĵ�һ�е�ÿһ��ֵΪ1 �� Sindx������͵Ľ��
S(:,1) = 1-sum(Sindx,2);
% S��2:end�е�ÿһ��ֵΪ֮ǰ��õ�����֮��Ĳ�ֵ
S(:,2:end) = Sindx;

end
