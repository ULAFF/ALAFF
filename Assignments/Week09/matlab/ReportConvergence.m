function ReportConvergence( lambdas, lambda, CurLegend )
    %ReportConvergence Report the convergence history of various
    %    eigenvalue/eigenvector solvers.  
    % lambdas is a 1 x k vector of the history of approximations to the
    % exact eigenvalue lambda
    
    [ n, k ] = size( lambdas );
        
    % Create new figure
    figure(1)
     
    % Plot the difference between the estimates to the eigenvalues and
    % the eigenvalues

    semilogy( [1:k], abs(lambdas( 1, 1:k)-lambda), 'LineWidth', ...
            3, "DisplayName", CurLegend );
    hold on

    xlabel( 'iteration' );
    ylabel( 'abs(v_i^T A v_i - \lambda_i)' );
    legend()

    % Create new figure
    figure(2)
    
    % Plot progress towards computing the eigenvalues
    plot( [1:k], abs(lambdas( 1, 1:k)), 'LineWidth', 3, "DisplayName", ...
            CurLegend );
    hold on
    
    xlabel( 'iteration' );
    ylabel( 'approximation to lambda' );
    legend();    
end