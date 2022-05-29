clear ;
close all;
clc;
rng(2)
global wind
flag = inputdlg('是否有风：');
if flag=="yes"
    wind = true;
else
    wind = false;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%设置环境矩阵%%%%%%%%%%%%%%%%%%%%%%%%%
environment =[-5,-5,-5,-5,-5,-5,-5,-5,-5;
    -5,-2,-1,-1,-5,-5,-5,-5,-5;
    -5,-1,-1,-1,-5,-5,-5,-5,-5;
    -5,-20,-1,-1,-5,-5,-5,-5,-5;
    -5,-1,-1,-1,-5,-5,-5,-5,-5;
    -5,-1,-1,-1,-5,-5,-5,-5,-5;
    -5,-1,-1,-1,-5,-5,-5,-5,-5;
    -5,-1,-1,-20,-1,-1,-1,-1,-5;
    -5,-1,-1,-1,-1,-1,-1,-1,-5;
    -5,-1,-1,-1,-1,-5,-5,-1,-5;
    -5,-1,-1,-1,-5,-5,-5,15,-5;
    -5,-5,-5,-5,-5,-5,-5,-5,-5;
    ];
start = [1,1];
[environment,res]= sol(environment,start);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%画图%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
%绘制
for i = 1:12
    for j =1:9
        if environment(i,j)==100
            plot(i,j,'k+')
            hold on
        elseif environment(i,j)==15 ||environment(i,j)==-2
            plot(i,j,'b+')
            hold on
       elseif environment(i,j)==-5
            plot(i,j,'g+')
            hold on
       elseif environment(i,j)==-20
            plot(i,j,'r+')
            hold on
        end
    end
end
axis([1,12,1,9]);
figure
plot(1:length(res),res)