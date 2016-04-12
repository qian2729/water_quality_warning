function [S P] = multrand2(P)
% P poshidprobs_mult' : ((conv_sample_size * 1 * 300 / 3),spacing + 1)
% P is 2-d matrix: 2nd dimension is # of choices

% sumP = row_sum(P); 
% 按行进行加和
sumP = sum(P,2);% sumP: ((conv_sample_size * 1 * 300 / 3), 1)
% P中的每一行进行归一化，除以该行的总和
P = P./repmat(sumP, [1,size(P,2)]);
% 求去每一行的累加和，每个元素都是它与该行在它前面的元素的总和
cumP = cumsum(P,2);
% rand(size(P));
% a random number from conv_sample_size * 1 * 300 / 3)
unifrnd = rand(size(P,1),1);
% cumP中的元素大于随机数的为1
temp = cumP > repmat(unifrnd,[1,size(P,2)]);
% 计算temp每行，两两之间的差值
Sindx = diff(temp,1,2);
% S 为返回结果
S = zeros(size(P));
% S的第一列的每一个值为1 － Sindx按行求和的结果
S(:,1) = 1-sum(Sindx,2);
% S的2:end列的每一个值为之前求得的两两之间的差值
S(:,2:end) = Sindx;

end
