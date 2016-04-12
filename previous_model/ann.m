
meature = 2; % 进行训练的测试参数下标
P=Xdata_normal_train{meature}';
t=Ydata_normal_train{meature}';
net=newff(minmax(P),[30,1],{'tansig','purelin'},'traingdx');%traingdm,traingdm,traingdx,trainrp
net=init(net);
net.trainparam.epochs=300;   %最大训练次数(前缺省为10,自trainrp后，缺省为100)
net.trainparam.lr=0.05;     %学习率(缺省为0.01)
net.trainparam.show=50;     %限时训练迭代过程(NaN表示不显示，缺省为25)
net.trainparam.goal=1e-5; %训练要求精度(缺省为0)
[net,tr]=train(net,P,t);     %网络训练

net_s = sim(net,Xdata_normal_test{meature}');                %网络仿真 
net_1 = sim(net2,Xdata_normal_test{meature}');

x = 1:length(Ydata_normal_test{meature});
y_range = minmax(Ydata_normal_test{meature}');
% 绘制标准，新网络预测，原始网络预测
subplot(311);
plot(x,Ydata_normal_test{meature});
title(strcat(num2str(meature),'-标准输出'));
subplot(312);
plot(x,net_s);
title(strcat(num2str(meature),'-新模型输出'));
ylim(y_range);
subplot(313);
plot(x,net_1);
title(strcat(num2str(meature),'-原始模型输出'));
ylim(y_range);

