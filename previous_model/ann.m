
meature = 2; % ����ѵ���Ĳ��Բ����±�
P=Xdata_normal_train{meature}';
t=Ydata_normal_train{meature}';
net=newff(minmax(P),[30,1],{'tansig','purelin'},'traingdx');%traingdm,traingdm,traingdx,trainrp
net=init(net);
net.trainparam.epochs=300;   %���ѵ������(ǰȱʡΪ10,��trainrp��ȱʡΪ100)
net.trainparam.lr=0.05;     %ѧϰ��(ȱʡΪ0.01)
net.trainparam.show=50;     %��ʱѵ����������(NaN��ʾ����ʾ��ȱʡΪ25)
net.trainparam.goal=1e-5; %ѵ��Ҫ�󾫶�(ȱʡΪ0)
[net,tr]=train(net,P,t);     %����ѵ��

net_s = sim(net,Xdata_normal_test{meature}');                %������� 
net_1 = sim(net2,Xdata_normal_test{meature}');

x = 1:length(Ydata_normal_test{meature});
y_range = minmax(Ydata_normal_test{meature}');
% ���Ʊ�׼��������Ԥ�⣬ԭʼ����Ԥ��
subplot(311);
plot(x,Ydata_normal_test{meature});
title(strcat(num2str(meature),'-��׼���'));
subplot(312);
plot(x,net_s);
title(strcat(num2str(meature),'-��ģ�����'));
ylim(y_range);
subplot(313);
plot(x,net_1);
title(strcat(num2str(meature),'-ԭʼģ�����'));
ylim(y_range);

