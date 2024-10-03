classdef MatrixOperations
    % MATRIXOPERATIONS This class performs matrix operations such as
    % reordering rows for diagonal dominance and checking for diagonal dominance.

    properties
        A       % The matrix to operate on
        SizeA   % The size of matrix A
        C       % The constant matrix (const_matrix)
        SizeC   % The size of matrix C
    end

    methods (Access = {?LinearEquationSolvers, ?MatrixOperationsTest})
        function obj = MatrixOperations(A_matrix, C_matrix)
            % Constructor for MatrixOperations class

            % Check for valid input
            if nargin == 0
                obj.A = [];
                obj.SizeA = [0, 0];
                obj.C = [];
                obj.SizeC = [0, 0];
            else
                % Validate A_matrix
                if ~isnumeric(A_matrix) || ~ismatrix(A_matrix)
                    error('Input must be a numeric matrix');
                end

                obj.A = A_matrix;
                obj.SizeA = size(A_matrix);

                % Validate const_matrix (C)
                if nargin >= 2 && ~isempty(C_matrix)
                    if ~isnumeric(C_matrix) || ~ismatrix(C_matrix)
                        error('const_matrix must be a numeric matrix');
                    end
                    obj.C = C_matrix;
                    obj.SizeC = size(C_matrix);
                else
                    obj.C = [];
                    obj.SizeC = [0, 0];
                end
            end
        end

        function isDominant = CheckDominance(obj, matrix)
            % CHECKDOMINANCE Checks if a matrix is diagonally dominant
            %
            % This function determines whether the provided matrix is diagonally dominant.
            % If no matrix is provided, it uses obj.A.

            if nargin < 2
                matrix = obj.A;
            end

            % Update size based on the provided matrix
            matrixSize = size(matrix);

            % Initialize flags
            isDominant = true;
            strictlyDominant = false;

            % Iterate through each row of the matrix
            for i = 1:matrixSize(1)
                % Get the absolute value of the diagonal element
                diagonal_element = abs(matrix(i, i));

                % Calculate the sum of absolute values of other elements in the row
                sum_of_other_elements = sum(abs(matrix(i, :))) - diagonal_element;

                % Check for strict diagonal dominance in this row
                if diagonal_element > sum_of_other_elements
                    strictlyDominant = true;
                end

                % Check if the row violates diagonal dominance
                if diagonal_element < sum_of_other_elements || diagonal_element == 0
                    fprintf('The matrix is not diagonally dominant due to row %d\n', i);
                    isDominant = false;
                    return;
                end
            end

            % Check if at least one row is strictly diagonally dominant
            if ~strictlyDominant
                fprintf('The matrix does not contain one row that is strictly dominant\n');
                isDominant = false;
            else
                fprintf('The matrix is diagonally dominant\n');
            end
        end

        function [A, C] = makeDiagDominant(obj, C)
            % makeDiagDominant Reorders the matrix A to make it as
            % diagonally dominant as possible and ensures no zeros on the diagonal
            %
            % Inputs:
            %   C - Constant vector (right-hand side vector)
            %
            % Outputs:
            %   A - Reordered coefficient matrix A
            %   C - Reordered constant vector C
            %
            % The method attempts to rearrange the rows of A (and corresponding entries in C)
            % to make the matrix diagonally dominant. If diagonal dominance cannot be achieved,
            % it issues a warning.
        
            A = obj.A;
            n = size(A, 1);
        
            % Init L for warnings
            L = 0;
            check = zeros(n, 1);
            check(:, 1) = C(:, 1);
        
            for i = 1:n
                % If the diagonal element is zero or not dominant, attempt to swap rows
                if A(i, i) == 0 || abs(A(i, i)) < sum(abs(A(i, :))) - abs(A(i, i))
                    best_row = -1;
                    max_diagonal_value = 0;
                    
                    % First, search for a suitable row to swap from the rows below the current row
                    for j = i+1:n
                        if A(j, i) ~= 0
                            potential_diagonal_value = abs(A(j, i));
                            off_diagonal_sum = sum(abs(A(j, :))) - potential_diagonal_value;
                            
                            % Select the row that has a non-zero value in the current column and
                            % maximizes diagonal dominance or at least eliminates zero on the diagonal
                            if potential_diagonal_value > off_diagonal_sum && potential_diagonal_value > max_diagonal_value
                                best_row = j;
                                max_diagonal_value = potential_diagonal_value;
                            elseif best_row == -1 && A(j, i) ~= 0
                                % If no dominant candidate found, pick any row that eliminates zero on the diagonal
                                best_row = j;
                                max_diagonal_value = potential_diagonal_value;
                            end
                        end
                    end
                    
                    % If no suitable row is found below, search from the rows above the current row
                    if best_row == -1
                        for j = 1:i-1
                            if A(j, i) ~= 0
                                potential_diagonal_value = abs(A(j, i));
                                off_diagonal_sum = sum(abs(A(j, :))) - potential_diagonal_value;
                                
                                % Select the row that has a non-zero value in the current column and
                                % maximizes diagonal dominance or at least eliminates zero on the diagonal
                                if potential_diagonal_value > off_diagonal_sum && potential_diagonal_value > max_diagonal_value
                                    best_row = j;
                                    max_diagonal_value = potential_diagonal_value;
                                elseif best_row == -1 && A(j, i) ~= 0
                                    % If no dominant candidate found, pick any row that eliminates zero on the diagonal
                                    best_row = j;
                                    max_diagonal_value = potential_diagonal_value;
                                end
                            end
                        end
                    end
                    
                    % Swap rows if a better row is found
                    if best_row ~= -1
                        A([i, best_row], :) = A([best_row, i], :);
                        C([i, best_row], :) = C([best_row, i], :);
                    else
                        % If no suitable row is found to make the diagonal element non-zero
                        if A(i, i) == 0
                            error('The matrix has a zero on the diagonal, and no suitable row swap could be found to eliminate it.');
                        end
                    end
                end
            end
        
            % Verify if any diagonal element is zero after attempts to swap
            if any(diag(A) == 0)
                error('The matrix has a zero on the diagonal, and no suitable row swap could be found to eliminate it.');
            end
        
            % Check if rows have been rearranged
            if ~isequal(C, check)
                fprintf('\nThe rows have been re-arranged so that it would at best be diagonally dominant, making sure the system will achieve convergence:\n');
                disp(A);
                disp(C);
            end
        end


        function [A_scaled, C_scaled] = scaleMatrices(obj, C)
            
            % Create a copy of A and C
            A_scaled = obj.A;
            C_scaled = C;

            % Get the number of rows for A
            nRows = obj.SizeA(1);
            nCols = obj.SizeA(2);

            % Iterate throught the rows and scale each entry by a(i, i)
            for i = 1:nRows

                % Get a(i,i) element
                diagonal_element = A_scaled(i, i);

                if diagonal_element == 0
                    disp(A);
                    error("0 found on diagonal, will lead to undefined behaviour");
                end

                % Iterate over the elements in A and scale them
                for j = 1:nCols
                    
                    % Scale the items in the current row
                    A_scaled(i, j) = A_scaled(i, j) / diagonal_element;
                    C_scaled(i) = C_scaled(i) / diagonal_element;
                end
            end

            fprintf('Matrix has been scaled to help with convergance.');
        end
    end
end
