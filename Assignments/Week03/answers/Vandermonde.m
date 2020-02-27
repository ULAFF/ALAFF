clear
close all

m = 5000;
    
% Generate a m x n Vandermonde matrix
for n=2:10  
	% Create a vector x with equally spaced entries in the interval [0,1]
	x = zeros( m, 1 );
h = 1/(m-1);
x( 1 ) = 0;
for i=2:m
        x( i ) = x( i-1 ) + h;
    end

    % Create the Vandermonde matrix
    X = zeros( m, n );
    
    % Set first column to ones
    X(:,1) = ones( m,1 );
    
    % Use the recurrence that column j equals column j-1 times x
    % (elementwise)
    for j=2:n
	    X(:,j) = X(:,j-1) .* x; 
    end
    
    % Compute the condition number
    kappa( n, 1 ) = cond( X );
end

% Plot the parent functions 1, x, x^2, etc

  plot( x, X(:,1) );
hold on
plot( x, X(:,2) );
plot( x, X(:,3) );
plot( x, X(:,4) );
plot( x, X(:,5) );
plot( x, X(:,6) );

title('Basis functions for Vandermonde matrix');
legend( '1', 'x', 'x^2', 'x^3', 'x^4', 'x^5', 'Location','southeast');
axis( [0,1,-0.2,1.2] );


figure

% Plot the condition numbers as a function of n
semilogy( [1:n], kappa )


title('Condition number');
xlabel( 'n' );
ylabel( '\kappa( X )' );
legend( 'Vandermonde', 'Location', 'northwest')
