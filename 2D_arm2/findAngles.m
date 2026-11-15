close all; clear; clc;

%% Find range of motion

L1 = 80;
L2 = 100;

theta1 = linspace(0, pi, 50);
theta2 = theta1;
x = zeros(numel(theta1),1);
y = zeros(numel(theta1),1);

figure; hold on;
ii = 1;
for t1 = theta1
    for t2 = theta2
        x(ii) = L1*cos(t1) + L2*cos(t1 + t2);
        y(ii) = L1*sin(t1) + L2*sin(t1 + t2);
        ii = ii+1;
    end
end

scatter(x, y, 'b', 'filled')
grid;
xlabel("X Range (mm)")
ylabel("Y Range (mm)")

%% draw possible rectangle, user input

% rectangle
w = 100;
h = 100;
dd = .25; % points per 1mm
btmLeft = [-150, -50];

xrect = [linspace(btmLeft(1), btmLeft(1)+w, w*dd), (btmLeft(1)+w)*ones(1, h*dd),...
    linspace(btmLeft(1)+w, btmLeft(1), w*dd), (btmLeft(1))*ones(1, h*dd)];
yrect = [(btmLeft(2))*ones(1, w*dd), linspace(btmLeft(2), btmLeft(2)+h, h*dd),...
    (btmLeft(2)+h)*ones(1, w*dd), linspace(btmLeft(2)+h, btmLeft(2), h*dd)];

scatter(xrect, yrect, 200, 'r', 'filled')

scatter(btmLeft(1), btmLeft(2), 250, 'g', 'filled')

%% Find angle values of two arms

th1 = zeros(1, numel(xrect));
th2 = th1;

for ii=1:1:numel(xrect)
    th3 = atan2(yrect(ii), xrect(ii));
    L3 = sqrt(xrect(ii)^2 + yrect(ii)^2);

    c_base  = (L1^2 + L3^2 - L2^2) / (2*L1*L3);    % angle at base
    c_elbow = (L1^2 + L2^2 - L3^2) / (2*L1*L2);    % interior angle at elbow
    alpha = acos(max(-1, min(1, c_base)));
    gamma = acos(max(-1, min(1, c_elbow)));

    th1(ii) = mod(th3 - alpha, 2*pi);   % wrap into [0, 2*pi)
    th2(ii) = pi - gamma;    

end

writematrix(th1, 'outTheta1.csv');
writematrix(th2, 'outTheta2.csv');

%disp(th1)
%disp(th2)


%% Re-visualize

theta1new = th1;
theta2new = th2;
xnew = zeros(numel(theta1new),1);
ynew = zeros(numel(theta1new),1);

ii = 1;
for t1 = theta1new
    t2 = theta2new(ii);
    xnew(ii) = L1*cos(t1) + L2*cos(t1 + t2);
    ynew(ii) = L1*sin(t1) + L2*sin(t1 + t2);
    ii = ii+1;
    
end

scatter(xnew, ynew, 75, 'k', 'filled')
