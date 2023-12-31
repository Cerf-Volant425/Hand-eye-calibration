clc;clear;
%% load data


%% set data
% T_b_t can be any value. No effection on results
R_b_t = [1, 0, 0;
        0, 1, 0;
        0, 0, 1];
t_b_t = [0, 0, 0]';
T_b_t = [R_b_t, t_b_t;
        0,0,0,  1];

% give "T_c_g" (or T_g_c) to generate the T_b_g
theta_x = pi/5;
theta_y = pi/6;
theta_z = pi/9;

rotX = [1, 0, 0;
        0, cos(theta_x), sin(theta_x);
        0, -sin(theta_x), cos(theta_x)];
rotY = [cos(theta_y), 0, -sin(theta_y);
        0, 1, 0;
        sin(theta_y), 0, cos(theta_y)];
rotZ = [cos(theta_z), sin(theta_z), 0;
        -sin(theta_z), cos(theta_z), 0;
        0, 0, 1];

R_c_g =  rotZ * rotY * rotX;
t_c_g = [1, 2, 3]';
T_c_g = [R_c_g, t_c_g; 
        0,0,0, 1];
T_g_c = inv(T_c_g);


%% generate grigper2base
N = 10;
T_b_g_list = zeros(4, 4, N);
T_t_c_list = zeros(4, 4, N);

for i = 1:10
%     fprintf("%d\n", i);
    T_c_t = read_matrix_from_txt(strcat('000', num2str(i-1), '.txt'));
    T_t_c = inv(T_c_t);

    T_b_g = T_b_t * T_t_c * T_c_g;      % generate T_b_g based on chain mul.
    
    T_t_c_list(:,:,i) = T_t_c;
    T_b_g_list(:,:,i) = T_b_g;
end

%% calculate Gij and Cij
Gij_list = [];
Cij_list = [];
i_idx = [1,2,3,4,5];
j_idx = [6,7,8,9,10];
for k = 1:length(i_idx)
    i = i_idx(k);
    j = j_idx(k);
    Gij = inv(T_b_g_list(:,:,i)) * T_b_g_list(:,:,j);
    Cij = inv(T_t_c_list(:,:,i)) * T_t_c_list(:,:,j);
    Gij_list = [Gij_list, Gij];
    Cij_list = [Cij_list, Cij];
end

X = tsai(Gij_list, Cij_list);

% X is T_g_c when given GX = XC
X
T_g_c
Error = norm(X - T_g_c)


