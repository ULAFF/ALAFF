function ReportConvergence( lambdas, CurTitle )
    %ReportConvergence Report the convergence history of various
    %    eigenvalue/eigenvector solvers.
    
    [ n, k ] = size( lambdas );
        
    % Create new figure
    figure
     
    % Plot the difference between the estimates to the eigenvalues and
    % the eigenvalues

    for i =1:n
        CurLegend = sprintf( "\\lambda_%d", i-1 );
        semilogy( [1:k], abs(lambdas( i, 1:k)-lambdas(i,k)), 'LineWidth', ...
            3, "DisplayName", CurLegend );
        hold on
    end
    title( CurTitle );
    xlabel( 'iteration' );
    ylabel( 'abs(v_i^T A v_i - \lambda_i)' );
    legend()
    
    hold off

    % Create new figure
    figure
    
    % Plot progress towards computing the eigenvalues
    for i =1:n
        CurLegend = sprintf( "\\lambda_%d", i-1 );
        plot( [1:k], abs(lambdas( i, 1:k)), 'LineWidth', 3, "DisplayName", ...
            CurLegend );
        hold on
    end
    title( CurTitle );
    xlabel( 'iteration' );
    ylabel( 'v_i^T A v_i' );
    legend();
        
    hold off
    
end