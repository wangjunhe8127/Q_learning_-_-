function [environment,res]= sol(environment,start)
ori = environment;

global wind
Q_table = zeros(108,4); % Q表
gamma = 0.5;% 折扣率
alpha = 0.01;% 学习率
epsilon = 1;% 初始epsilon
decay = 0.99;% epsilon衰减率
x = start(1)+1;% 起始位置
y = start(2)+1;
state = com_state(x,y);% 起始状态
episode = 8000;% 每个任务的总训练回合数
res = [];
%%%%%%%%%%%%%%%%%训练过程%%%%%%%%%%%%%%%%
for i=1:episode
    var = ori;
    done = false;
    number = 0;
    rr = 0;
    if epsilon>0.02
        epsilon = epsilon*decay;% epsilon衰减
    end
    while done==false && number<300% 程序设定最多探索的步长
        number=number+1;
        if rand(1)<epsilon
            action = round(rand(1,1)*3)+1;%随机选取动作
        else
            [~,action] = max(Q_table(state,:),[],2);%最大的动作
        end
        [x,y] = move(x,y,action);% 计算下一步x,y
        if rand(1)<0.2 && wind==true
            action = round(rand(1,1)*3)+1;%随机选取动作
            [x,y] = move(x,y,action);% 计算下一步x,y
            if x==0 || y==0 ||x==13 ||y ==10
                done = true;
                max_Q = 0;
                x = start(1)+1;
                y = start(2)+1;
                new_state = com_state(x,y);
                r = -5;
            else
                r = environment(x,y);% 计算奖励
                if r>10 || r<-4
                    done = true;
                    max_Q = 0;
                    x = start(1)+1;
                    y = start(2)+1;
                    new_state = com_state(x,y);
                else
                    new_state = com_state(x,y);
                    [max_Q,~] = max(Q_table(new_state),[],2);% Q_target
                end
            end
            
        else
            r = var(x,y);
            if r>10 || r<-4% 
                done = true;
                max_Q = 0;
                x = start(1)+1;
                y = start(2)+1;
                new_state = com_state(x,y);
            else
                var(x,y)=-5;
                new_state = com_state(x,y);
                [max_Q,~] = max(Q_table(new_state),[],2);% Q_target
            end
        end
        % 更新Q
        Q_table(state,action) = Q_table(state,action)+alpha*(r+gamma*max_Q-Q_table(state,action));
        state = new_state;
        rr = rr*gamma+r;
    end
res = [res rr];
end
%%%%%%%%%%测试过程（也就是实际的路径）%%%%%%%%%%
done = false;
number = 0;
x = start(1)+1;
y = start(2)+1;
state = com_state(x,y);
while done==false && number<100

    number = number + 1;
    [~,action] = max(Q_table(state,:),[],2);%直接选取最大的动作而不是仿真
    [x,y] = move(x,y,action)%计算下一步x,y
    r = environment(x,y);%计算奖励
    if r<-4 || r>10
        done = true;
        max_Q = 0;
    else
        environment(x,y)=100;
        new_state = com_state(x,y);%换算成状态
        [max_Q,~] = max(Q_table(new_state),[],2);
    end
    Q_table(state,action) = Q_table(state,action)+alpha*(r+gamma*max_Q-Q_table(state,action));
    state = new_state;
end