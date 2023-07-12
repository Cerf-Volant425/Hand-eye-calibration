% Hand-eye calibration  
%
% cam2target.csv format: 1 index, 2-4 rvec, 5-7 tvec. 
% cam2target, transfer a point in camera frame to target(chessboard) frame.
% gripper2base, transfer a point in gripper frame to base frame.
% rvec: the axis-angle notation. rvec's direction is rotation direction, norm is the rotation angle (in rad)
% tvec: unit: mm
% 
% Dong Yan  2022.01.4


clc;clear;

%% load data
N = 10;
T_b_g_list = zeros(4, 4, N);
T_t_c_list = zeros(4, 4, N);

for i = 1:10
%     fprintf("%d\n", i);
    T_c_t = read_matrix_from_txt(strcat('c000', num2str(i-1), '.txt'));
    T_b_g = read_matrix_from_txt(strcat('r000', num2str(i-1), '.txt'));
    
    T_t_c_list(:,:,i) = inv(T_c_t);
    T_b_g_list(:,:,i) = T_b_g;
end


%% calculate Gij and Cij
Cij_list = [];
Gij_list = [];
for k = 1:N-1
    i = k;
    j = k+1;
    Cij = inv(T_t_c_list(:,:,i)) * T_t_c_list(:,:,j);
    Gij = inv(T_b_g_list(:,:,i)) * T_b_g_list(:,:,j);
    Cij_list = [Cij_list, Cij];
    Gij_list = [Gij_list, Gij];
end

% X is T_g_c when given GX = XC
T_g_c = tsai(Gij_list, Cij_list)
formattedMatrix = sprintf('%.10f\n', T_g_c);
disp(formattedMatrix);
% Ground-truth (measured by a ruler)
% R: Identity matrix (I)
% t: [-57, 65, 20] mm

for k = 1:N
    T_t_b = T_b_g_list(:,:,k) * T_g_c * inv(T_t_c_list(:,:,k));
    T_t_b
end
