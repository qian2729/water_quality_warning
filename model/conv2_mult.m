function y = conv2_mult(a, B, convopt)
% a:data sample_size * 1 * 1, B: w,6 * 1 * 300
% y: (sample_size - 6 + 1) * 1 * 300
% for each base ,compute convolution
y = zeros((size(a,1)-size(B,1))+1,1,size(B,3));
for i=1:size(B,3)
    % 卷积操作是一个channel一个channel做的
    y(:,:,i) = conv2(a, B(:,:,i), convopt);
end
return
