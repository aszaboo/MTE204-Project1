% mainScript.m

% Add src directory to the MATLAB path
currentDir = fileparts(mfilename('fullpath'));
srcDir = fullfile(currentDir, 'src');
addpath(srcDir);

% Load the data
load('circuit1_data.mat');
load('circuit2_data.mat');
load('circuit4_data.mat');

% Set lambda values to iterate over
lambda_values = 0.1:0.1:2.0;

% Set stopping criterion and maximum iterations
es = 1e-5;  % Desired relative error (%)
imax = 1000; % Maximum number of iterations

% Store circuit data in a struct array
circuit_data = {circuit1_data, circuit2_data, circuit4_data};

% Create results directory if it doesn't exist
resultsDir = fullfile(currentDir, 'results');
if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

% Initialize table to store results
resultsTable = table();

% Iterate over each lambda value and solve for each circuit
for lambda = lambda_values
    fprintf('Lambda = %.1f\n', lambda);
    
    for circuit_idx = 1:numel(circuit_data)
        circuit_number = [1, 2, 4];  % Circuit numbers to match the loaded data
        % Access the data for the current circuit
        A = circuit_data{circuit_idx}.A;
        X_initial = circuit_data{circuit_idx}.X; % Initial guess
        C = circuit_data{circuit_idx}.C;
        
        % Create an instance of LinearEquationSolvers
        solver = LinearEquationSolvers(A, C, X_initial, lambda);
        
        % Solve using Gauss-Seidel method
        [X_solution, iterations, converged] = solver.GaussSeidel(es, imax);
        
        % Calculate error if not converged
        if ~converged
            final_error = norm(A * X_solution - C) / norm(C);
        else
            final_error = NaN;
        end
        
        % Store results in the table (ensure solution is stored as a cell for consistency)
        newRow = {lambda, circuit_number(circuit_idx), converged, iterations, final_error, {X_solution'}};
        resultsTable = [resultsTable; newRow];
    end
end

% Set table column names
resultsTable.Properties.VariableNames = {'Lambda', 'Circuit', 'Converged', 'Iterations', 'Error', 'Solution'};

% Write results to a file
resultsFile = fullfile(resultsDir, 'results_summary.csv');
writetable(resultsTable, resultsFile);

% Optionally, remove src directory from the path
rmpath(srcDir);