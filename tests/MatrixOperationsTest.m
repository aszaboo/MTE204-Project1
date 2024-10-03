classdef MatrixOperationsTest < matlab.unittest.TestCase
    properties
        MatrixOps
    end

    methods (TestMethodSetup)
        function createMatrixOperations(testCase)
            % Initialize MatrixOperations with empty matrices
            testCase.MatrixOps = MatrixOperations([], []);
        end
    end

    methods (Test)
        function testConstructor(testCase)
            % Test empty constructor
            emptyOps = MatrixOperations();
            testCase.verifyEqual(emptyOps.A, []);
            testCase.verifyEqual(emptyOps.SizeA, [0, 0]);
            testCase.verifyEqual(emptyOps.C, []);
            testCase.verifyEqual(emptyOps.SizeC, [0, 0]);

            % Test with valid input
            validA = [1 2; 3 4];
            validC = [5; 6];
            validOps = MatrixOperations(validA, validC);
            testCase.verifyEqual(validOps.A, validA);
            testCase.verifyEqual(validOps.SizeA, [2, 2]);
            testCase.verifyEqual(validOps.C, validC);
            testCase.verifyEqual(validOps.SizeC, [2, 1]);
        end

        function testCheckDominance(testCase)
            % Define test cases with descriptions
            testCases = {
                {[4 1 2; 1 3 0; 2 0 5], 'DD, strictly dominant'},
                {[3 2 1; 2 3 2; 1 2 3], 'Not DD, but dominant if rearranged'},
                {[0 1; 1 0], 'Not DD, zeros on diagonal'},
                {[-2 1 0; 1 -3 2; 0 2 -2], 'DD, negative diagonal elements'},
                {[1 2 3; 4 5 6; 7 8 9], 'Not DD, cannot be made DD'}
            };

            for i = 1:length(testCases)
                matrix = testCases{i}{1};
                description = testCases{i}{2};

                % Set up MatrixOps object
                testCase.MatrixOps.A = matrix;
                testCase.MatrixOps.SizeA = size(matrix);

                % Check dominance
                isDominant = testCase.MatrixOps.CheckDominance(matrix);

                % Print result
                fprintf('Test Case %d: %s\n', i, description);
                fprintf('Result: %s\n\n', testCase.iif(isDominant, 'Diagonally Dominant', 'Not Diagonally Dominant'));

                % Verify result based on expected dominance
                if any(strcmp(description, {'DD, strictly dominant', 'DD, negative diagonal elements'}))
                    testCase.verifyTrue(isDominant, sprintf('Matrix should be diagonally dominant: %s', description));
                else
                    testCase.verifyFalse(isDominant, sprintf('Matrix should not be diagonally dominant: %s', description));
                end
            end
        end

        function testMakeDiagDominant(testCase)
            % Define test cases with descriptions and expected outcomes
            testCases = {
                % matrix, description, expected dominance after reordering
                {[4 1 2; 1 3 0; 2 0 5], 'Already DD', true},
                {[1 2; 4 3], 'Not DD, can be made DD', true},
                {[0 1; 1 0], 'Not DD, zeros on diagonal, can swap', true},
                {[1 2 3; 4 5 6; 7 8 9], 'Not DD, cannot be made DD', false},
                {[0 0 1; 0 0 1; 1 1 0], 'Not DD, zeros on diagonal, cannot swap', false}
            };

            for i = 1:length(testCases)
                matrix = testCases{i}{1};
                description = testCases{i}{2};
                expectedDominance = testCases{i}{3};

                % Create a random constant vector C
                n = size(matrix, 1);
                C = rand(n, 1);

                % Apply makeDiagDominant
                testCase.MatrixOps.A = matrix;
                testCase.MatrixOps.SizeA = size(matrix);
                [A_reordered, C_reordered, isDominant] = testCase.MatrixOps.makeDiagDominant(C);

                % Print result
                fprintf('Test Case %d: %s\n', i, description);
                fprintf('Result after reordering: %s\n\n', testCase.iif(isDominant, 'Diagonally Dominant', 'Not Diagonally Dominant'));

                % Verify whether the matrix is diagonally dominant after reordering
                testCase.verifyEqual(isDominant, expectedDominance, sprintf('Unexpected dominance result for case: %s', description));

                % Verify that A_reordered and C_reordered have the correct sizes
                testCase.verifySize(A_reordered, size(matrix), 'Reordered A should have the same size as original A');
                testCase.verifySize(C_reordered, size(C), 'Reordered C should have the same size as original C');

                % If expected to be diagonally dominant, verify that it actually is
                if isDominant
                    testCase.verifyTrue(testCase.MatrixOps.CheckDominance(A_reordered), sprintf('Matrix should be diagonally dominant after reordering: %s', description));
                end
            end
        end
    end

    methods (Access = private)
        function result = iif(~, condition, trueVal, falseVal)
            % Helper function for ternary-like operation
            if condition
                result = trueVal;
            else
                result = falseVal;
            end
        end
    end
end
