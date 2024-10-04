### Understanding of Concepts

1. **Kirchhoff’s Current and Voltage Laws (KCL & KVL)**:
   - KCL is applied at nodes, ensuring that the sum of currents at a node equals zero, representing the conservation of charge.
   - KVL is applied in loops, ensuring that the sum of voltage drops around any closed loop equals the sum of the electromotive forces (EMFs).

   Together, these laws generate a set of simultaneous linear equations, which can be solved using numerical methods like the Gauss-Seidel method.

2. **Gauss-Seidel Iterative Method**:
   - This is an iterative approach where the solution is updated step-by-step. Each unknown is solved sequentially using the latest available values of other variables.
   - Convergence is a critical aspect here, and diagonal dominance of the coefficient matrix plays a significant role in ensuring that the method converges.

3. **Relaxation Factors**:
   - Relaxation can be applied to speed up or stabilize the convergence process:
     - **Under-relaxation (λ < 1)** helps in slowing down the updates to ensure stability when the method tends to diverge.
     - **Over-relaxation (λ > 1)** accelerates the convergence for slowly converging systems.
     - A relaxation factor λ = 1 corresponds to the traditional Gauss-Seidel method.

4. **Pivoting**:
   - Pivoting is sometimes necessary to avoid division by zero or small numbers that could result in numerical instability. Partial pivoting helps in rearranging the equations to bring the largest available coefficient to the diagonal, enhancing stability.

### Application of Relaxation and Pivoting

1. **Relaxation**:
   In this project, the default relaxation factor used is λ = 1 (Gauss-Seidel). However, for systems where convergence was slow, I experimented with different values of λ (between 0 and 2). By testing various values, I found that in some cases, a slight over-relaxation (e.g., λ = 1.2) improved convergence speed without compromising stability. Conversely, under-relaxation (λ < 1) was helpful for circuits where the solution was oscillating.

2. **Diagonal Dominance and Pivoting**:
   One of the challenges with the Gauss-Seidel method is that it doesn't always converge unless the coefficient matrix is diagonally dominant. For this reason, I checked for diagonal dominance in the matrix using the `MatrixOperations` class. If the matrix was not dominant, row pivoting was applied to enhance convergence.

### Assumptions

1. **Initial Guess**:
   - The initial guess for the current and voltage values was set to a vector of zeros. This is a common approach when there is no prior information about the solution.
   - For certain circuits, when convergence was too slow, I adjusted the initial guess to closer approximations based on the expected behavior of the circuit (e.g., current values relative to the circuit's resistance).

2. **Stopping Criterion**:
   - A stopping criterion based on the relative error (`es = 1e-6`) was used. The iterative process stops once the error between successive iterations falls below this value, ensuring a sufficiently accurate solution.

3. **Matrix Properties**:
   - It is assumed that the matrix resulting from KCL and KVL equations can be manipulated (e.g., pivoting) without altering the physical meaning of the circuit’s equations. This allows me to reorder rows to achieve diagonal dominance when necessary.

### Justification of Assumptions

1. **Initial Guess of Zero**:
   Using an initial guess of zero simplifies the process and provides a neutral starting point. Since the Gauss-Seidel method relies on iterative improvement, starting with zero does not hinder convergence, though it may slow down in certain cases.

2. **Relaxation Factor (λ)**:
   Choosing an appropriate relaxation factor balances convergence speed and stability. Through experimentation, it was clear that for certain circuits with complex interactions, under-relaxation (λ < 1) could improve stability, while in simpler cases, over-relaxation (λ > 1) sped up convergence.

3. **Pivoting for Diagonal Dominance**:
   Ensuring diagonal dominance via pivoting is a well-established technique in numerical methods to improve convergence. This choice was justified because it leads to more stable and predictable convergence behavior in the iterative solver.

Overall, the combination of relaxation and pivoting, along with appropriate assumptions about the system's behavior, allowed the Gauss-Seidel method to successfully solve the circuit equations with reasonable convergence and accuracy.
