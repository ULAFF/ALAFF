clear
close all

m = 5000;
    
% Generate a m x n Vandenmonde matrix
for n=2:10
    % Create a vector x with equally spaced entries in the interval [0,1]
    x = zeros( m, 1 );
    h = 1/(m-1);
    x( 1 ) = 0;
    for i=2:m
        x( i ) = x( i-1 ) + h;
    end

    % Create the Vandenmonde matrix
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

title('Basis functions for Vandenmonde matrix');
legend( '1', 'x', 'x^2', 'x^3', 'x^4', 'x^5', 'Location','southeast');
axis( [0,1,-0.2,1.2] );

% Generate a m x n where each column equals a samples shifted Legendre
% polynomial
    
for n=2:10 
    x = zeros( m, 1 );
    h = 1/(m-1);
    x( 1 ) = 0;
    for i=2:m
        x( i ) = x( i-1 ) + h;
    end

    X = zeros( m, n );
    
    % Set first column to ones  (P_0(x) = 1)
    X(:,1) = ones( m,1 );
    
    % Set the second column to 2x-1 (P_1(x) = 2x-1 )
    X(:,2) = 2*x-1;
    
    % Use the recurrence (i+1) P_j+1 = (2j+1)(2x-1)P_j(x) - jP_j-1(x) to
    % compute the next column (which is stored in X(:,j+2) since matlab
    % starts indexing at one)
    for j=1:n-2
       X(:,j+2) = ((2*j+1)*(2*x-1).*X(:,j+1)-j*X(:,j))/(j+1);
    end
    
    % Compute the condition number
    kappa( n, 2 ) = cond( X );
end

figure

% Plot the basis functions P_0(x), P_1(x), etc

plot( x, X(:,1) );
hold on
plot( x, X(:,2) );
plot( x, X(:,3) );
plot( x, X(:,4) );
plot( x, X(:,5) );
plot( x, X(:,6) );

title('Shifted Legendre polynomials');
xlabel('x');
ylabel('P_j(x)');
legend( 'P_0(x)', 'P_1(x)', 'P_2(x)', 'P_3(x)', 'P_4(x)', 'P_5(x)', ...
    'Location','southeast');
axis( [0,1,-1.2,1.2] );

figure

% Plot the condition numbers for both methods, as a function of n
semilogy( [1:n], kappa )


title('Condition number');
xlabel( 'n' );
ylabel( '\kappa( X )' );
legend( 'Vandenmonde', 'Shifted Legendre', 'Location', 'northwest')

% Check whether the columns of X are approximately orthogonal
disp( "X^T * X for n = 5:")
round(X(:,1:5)' * X(:,1:5))


 







