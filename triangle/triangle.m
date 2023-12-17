%线性三角形单元
%{
线性三角形单元解决平面应力、应变问题
假设一个梯形材料（程序中已经画出），其厚度h=1，泊松比μ=0，杨氏模量E=1，
左端为固定约束,外力F沿x轴负方向加载于节点4
%}
clc;clear;
X=[0 0 4 4];%1-4节点的x轴坐标
Y=[0 -2 -1 0];%1-4节点的y轴坐标
plot([X 0 4],[Y 0 -1],'k','linewidth',3);
E=1;%杨氏模量
miu=0;%泊松比
h=1;%厚度
F=1;%4节点处的集中外载荷
Z1=[2 3 1];
Z2=[3 4 1];
%单元1三个节点的坐标:
x11=X(Z1(1));y11=Y(Z1(1));x12=X(Z1(2));y12=Y(Z1(2));x13=X(Z1(3));y13=Y(Z1(3));
%单元2三个节点的坐标:
x21=X(Z2(1));y21=Y(Z2(1));x22=X(Z2(2));y22=Y(Z2(2));x23=X(Z2(3));y23=Y(Z2(3));
%求解Be矩阵；Be1和Be2分别为单元1和单元2的B矩阵
cc1=[1 x11 y11;1 x12 y12;1 x13 y13];
ste1=inv(cc1);%U(x,y)=N*ste
cc2=[1 x21 y21;1 x22 y22;1 x23 y23];
ste2=inv(cc2);
Be1=[ste1(2,1) 0 ste1(2,2) 0 ste1(2,3) 0
    0 ste1(3,1) 0 ste1(3,2) 0 ste1(3,3)
    ste1(3,1) ste1(2,1) ste1(3,2) ste1(2,2) ste1(3,3) ste1(2,3)];
Be2=[ste2(2,1) 0 ste2(2,2) 0 ste2(2,3) 0
    0 ste2(3,1) 0 ste2(3,2) 0 ste2(3,3)
    ste2(3,1) ste2(2,1) ste2(3,2) ste2(2,2) ste2(3,3) ste2(2,3)];
%求解D矩阵
D=(E/(1-miu^2))*[1 miu 0;miu 1 0;0 0 (1-miu)/2];
%求解单元刚度矩阵Ke
Ae1=(1/2)*det(cc1);%单元1三角形的面积
Ae2=(1/2)*det(cc2);%单元2三角形的面积
ke1=h*Ae1*Be1'*D*Be1;
ke2=h*Ae2*Be2'*D*Be2;
%装载系统总刚度矩阵K
K=zeros(2*length(X),2*length(X));
for i=1:length(Z1)
    for j=1:length(Z1)
        K(Z1(i)*2-1,Z1(j)*2-1)=K(Z1(i)*2-1,Z1(j)*2-1)+ke1(i*2-1,j*2-1);
        K(Z1(i)*2,Z1(j)*2-1)=K(Z1(i)*2,Z1(j)*2-1)+ke1(i*2,j*2-1);
        K(Z1(i)*2-1,Z1(j)*2)=K(Z1(i)*2-1,Z1(j)*2)+ke1(i*2-1,j*2);
        K(Z1(i)*2,Z1(j)*2)=K(Z1(i)*2,Z1(j)*2)+ke1(i*2,j*2);
        K(Z2(i)*2-1,Z2(j)*2-1)=K(Z2(i)*2-1,Z2(j)*2-1)+ke2(i*2-1,j*2-1);
        K(Z2(i)*2,Z2(j)*2-1)=K(Z2(i)*2,Z2(j)*2-1)+ke2(i*2,j*2-1);
        K(Z2(i)*2-1,Z2(j)*2)=K(Z2(i)*2-1,Z2(j)*2)+ke2(i*2-1,j*2);
        K(Z2(i)*2,Z2(j)*2)=K(Z2(i)*2,Z2(j)*2)+ke2(i*2,j*2);
    end
end
%求解自由端位移
df=K(5:end,5:end)\[0 0 0 -F]';%u3,v3,u4,v4
%d
d=[[0 0 0 0]';df];%节点1和2的位移为0
%de
de1=[];
de2=[];
for i=1:length(Z1)
    de1=[de1;d(Z1(i)*2-1:Z1(i)*2)];
    de2=[de2;d(Z2(i)*2-1:Z2(i)*2)];
end
%求单元应力SIGMA
SIGMAe1=D*Be1*de1;%SIGMAxx,SIGMAyy,SIGMAxy
SIGMAe2=D*Be2*de2;
disp('单元1的应力为：')
disp(SIGMAe1);
disp('单元2的应力为：')
disp(SIGMAe2);