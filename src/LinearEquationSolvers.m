classdef LinearEquationSolvers
    % LINEAREQUATIONSOLVERS Class for solving linear equations using iterative methods
    %
    % This class provides methods to solve linear equations, such as the Gauss-Seidel method.
    % It works in conjunction with the MatrixOperations class for matrix manipulations.
    
    properties
        A          % Coefficient matrix
        SizeA      % Size of matrix A
        X          % Solution vector or initial guess
        SizeX      % Size of vector X
        C          % Constant matrix (right-hand side vector)
        SizeC      % Size of matrix C
        lambda     % Relaxation factor (for SOR)
    end
    
    methods
        function obj = LinearEquationSolvers(Ain, Cin, Xin, lambdaIn)
            % Constructor for LinearEquationSolvers class
            %
            % Inputs:
            %   Ain      - Coefficient matrix A
            %   Cin      - Constant matrix C (right-hand side vector)
            %   Xin      - Initial guess vector X
            %   lambdaIn - Relaxation factor (optional, default is 1 for Gauss-Seidel)
            %
            % The constructor initializes the properties of the class.
            
            % Validate and assign A
            if nargin >= 1 && ~isempty(Ain)
                if ~isnumeric(Ain) || ~ismatrix(Ain)
                    error('Ain must be a numeric matrix.');
                end
                obj.A = Ain;
                obj.SizeA = size(Ain);
            else
                obj.A = [];
                obj.SizeA = [0, 0];
            end
            
            % Validate and assign C
            if nargin >= 2 && ~isempty(Cin)
                if ~isnumeric(Cin) || ~iscolumn(Cin)
                    error('Cin must be a numeric column vector.');
                end
                obj.C = Cin;
                obj.SizeC = size(Cin);
            else
                obj.C = [];
                obj.SizeC = [0, 0];
            end
            
            % Validate and assign X (initial guess)
            if nargin >= 3 && ~isempty(Xin)
                if ~isnumeric(Xin) || ~iscolumn(Xin)
                    error('Xin must be a numeric column vector.');
                end
                obj.X = Xin;
                obj.SizeX = size(Xin);
            else
                % If no initial guess provided, use zeros
                if ~isempty(obj.C)
                    obj.X = zeros(size(obj.C));
                    obj.SizeX = size(obj.X);
                else
                    obj.X = [];
                    obj.SizeX = [0, 0];
                end
            end
            
            % Validate and assign lambda
            if nargin >= 4 && ~isempty(lambdaIn)
                if ~isnumeric(lambdaIn) || lambdaIn <= 0 || lambdaIn > 2
                    error('lambdaIn must be a numeric value in the range (0, 2].');
                end
                obj.lambda = lambdaIn;
            else
                obj.lambda = 1; % Default relaxation factor for Gauss-Seidel
            end
        end
        
        function [X, iterations, converged] = GaussSeidel(obj, es, imax)
            % GAUSSSEIDEL Solve the system using the Gauss-Seidel method
            %
            % Inputs:
            %   es    - Stopping criterion (desired relative error in percent)
            %   imax  - Maximum number of iterations
            %
            % Outputs:
            %   X          - Solution vector
            %   iterations - Number of iterations performed
            %   converged  - Boolean indicating if the method converged
            %
            % The method uses the properties A, C, X, and lambda of the class.
            
            % Validate inputs
            if isempty(obj.A) || isempty(obj.C)
                error('Coefficient matrix A and constant vector C must be provided.');
            end
            if nargin < 2 || isempty(es)
                es = 1e-6; % Default stopping criterion
            end
            if nargin < 3 || isempty(imax)
                imax = 1000; % Default maximum iterations
            end
            
            n = obj.SizeA(1);
            A = obj.A;
            C = obj.C;
            X = obj.X;
            lambda = obj.lambda;
            
            % Initialize variables
            iterations = 0;
            converged = false;
            ea = Inf(n, 1); % Approximate relative errors
            
            % Ensure that A is square and dimensions match
            if obj.SizeA(1) ~= obj.SizeA(2)
                error('Coefficient matrix A must be square.');
            end
            if obj.SizeA(1) ~= obj.SizeC(1)
                error('Size of A and C must match.');
            end
            if obj.SizeA(1) ~= obj.SizeX(1)
                error('Size of A and X must match.');
            end
            
            % Make sure the matrix is diagonally dominant
            % Use MatrixOperations to check and reorder if necessary
            matOps = MatrixOperations(A, C);
            [A_reordered, C_reordered] = matOps.makeDiagDominant(C);
            A = A_reordered;
            C = C_reordered;

            % Scale the Matricies

            %[A_scaled, C_scaled] = matOps.scaleMatrices(C);

            %A = A_scaled;
            %C = C_scaled;

            %disp(A);
            %disp(C);
            
            % Start iterations
            while iterations < imax
                X_old = X;
                for i = 1:n
                    sum = C(i);
                    for j = 1:n
                        if j ~= i
                            sum = sum - A(i, j) * X(j);
                        end
                    end
                    X(i) = lambda * (sum / A(i, i)) + (1 - lambda) * X_old(i);
                    
                    % Compute approximate relative error
                    if X(i) ~= 0
                        ea(i) = abs((X(i) - X_old(i)) / X(i)) * 100;
                    end
                end
                
                iterations = iterations + 1;
                
                % Check convergence
                if max(ea) < es
                    converged = true;
                    break;
                end
            end
            
            if ~converged
                warning('Gauss-Seidel method did not converge within the maximum number of iterations.');
            end
            
            % Update the object's X property with the computed solution
            obj.X = X;
        end
    end
end
