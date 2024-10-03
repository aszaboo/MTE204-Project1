% Circuit 1 Data

% Row Format: [I12, I32, I43, I52, I54, I65]
A_circuit1 = [10 0 0 -5 0 -15;
              0 -20 -2 5 -5 0;
              1 1 0 1 0 0;
              0 0 0 -1 -1 1;
              0 -1 1 0 0 0;
              0 0 -1 0 1 0];

% Column Format: [I12, I32, I43, I52, I54, I65]
X_circuit1 = [5;
              -0.8;
              -0.8;
              -4;
              -0.8;
              -5];


% Column Format: [C1; C1; C3; ... ; C6]
C_circuit1 = [200;
              0;
              0;
              0;
              0;
              0];

lambda_circuit1 = 1;

% Create a struct to hold the data
circuit1_data.A = A_circuit1;
circuit1_data.X = X_circuit1;
circuit1_data.C = C_circuit1;
circuit1_data.lambda = lambda_circuit1;

% Save the struct
save('circuit1_data.mat', 'circuit1_data');

% Circuit 2 Data

% Row Format: [I12, I23, I25, I35, I43]
A_circuit2 = [5 0 15 0 0;
              0 -10 15 -25 0;
              0 0 0 25 20;
              1 -1 -1 0 0;
              0 1 0 -1 1];

% Column Format: [I12; I23; I25; I35; I43]
X_circuit2 = [5;
              1;
              4;
              2;
              1];


% Column Format: [C1; C1; C3; ... ; C5]
C_circuit2 = [80;
              0;
              50;
              0;
              0];

% Create a struct to hold the data
circuit2_data.A = A_circuit2;
circuit2_data.X = X_circuit2;
circuit2_data.C = C_circuit2;

% Save the struct
save('circuit2_data.mat', 'circuit2_data');

% Circuit 3 Data

% Row Format: [I12, I13, I23, I24, I34]
A_circuit3 = [4 0 0 2 0;
              -4 6 -8 0 0;
              0 0 8 -2 5;
              1 0 -1 -1 0;
              0 1 1 0 -1];

% Column Format: [I12; I13; I23; I24; I34]
X_circuit3 = [1;
              0.7;
              0.3;
              1.2;
              0.9];


% Column Format: [C1; C1; C3; ... ; C5]
C_circuit3 = [20;
              0;
              0;
              0;
              0];

% Create a struct to hold the data
circuit3_data.A = A_circuit3;
circuit3_data.X = X_circuit3;
circuit3_data.C = C_circuit3;

% Save the struct
save('circuit3_data.mat', 'circuit3_data');

