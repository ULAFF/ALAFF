%% Performance of a simple implementation
% If are viewing the ".mlx" file, you are looking at a Live Script.  If you 
% are viewing the ".m" file, you are looking at that Live Script file, but converted 
% to a regular ".m" file.  In that case, some of the comments may not apply!
%% What is a Live Script?
% A Live Script is a file that allows one to mix comments, including mathematical 
% text, with executable code (in the light gray boxes).  This allows exercises, 
% like this one, to be naturally intertwined with executable code.  How do you 
% execute?  If you are viewing this, you will see "Run Section", "Run to End", 
% etc. at the top. Clicking on these when your cursor is in some part of this 
% file will have the obvious effect.  So does clicking on "Run All", which is 
% what you will want to do most of the time.
%% This Live Script
% This Live Script helps you visualize the performance of the very simple implementation 
% of matrix-matrix multiplication in Gemm_IJP.c.
% 
% To gather the performance data, in the command (terminal) window change 
% the directory to Assignments/Week1/C/ and execute 
% 
%        make IJP
% 
% This compiles and executes a driver routine (the source of which is in 
% driver.c) that collects accuracy and performance data for the implementation 
% in Gemm_IJP.c.  
% 
% When completed, various data is in output file 'output_IJP.m' in the same 
% directory where you found this Live Script (LAFF-On-HPC/Assignments/Week1/C/data/).  
% This Life Script then creates graphs from that timing data.  Go ahead and click 
% on "Run All".  It executes all the code in the rest of this file.  You will 
% want to look at the graphs this creates.
%% Load timing data

output_IJP
%% Make sure you are getting the right answer
% In output_IJP.m, for different matrix sizes, timing data is collected as well 
% as how close the answer is to the answer attained by the reference implementation.  
% Here we look at the maximum difference over all experiments.  This should be 
% somewhere on the order of  $10^{-11}$  or smaller.  You can expect some difference 
% between the two implementations, due to round-off error and the order in which 
% computations are performed.

assert( max(abs(data(:,6))) < 1.0e-10, 'Hmmm, better check if there is an accuracy problem');
%% Plot the timing data.
% A first graph shows the execution time of the implementation in Gemm_IJP.m 
% for various matrix sizes $m = n = k$.

% Close all existing figures. (This is important for the ".m" version of this file.)
close all

% Create figure
figure1 = figure( 'Name', 'Time' );

% Create axes, labels, legends
axes1 = axes( 'Parent', figure1 );
hold( axes1, 'on' );
ylabel( 'Time (in sec.)', 'FontName', 'Helvetica Neue' );
xlabel( 'matrix dimension m=n=k', 'FontName', 'Helvetica Neue' );
box( axes1, 'on');
set( axes1, 'FontName', 'Helvetica Neue', 'FontSize', 18);
             
% Plot time data for IJP                
plot( data(:,1), data(:,4), 'MarkerSize', 8, 'LineWidth', 2, ...
      'DisplayName', 'IJP', 'Marker', 'o', 'LineStyle', '-.', 'Color', [0 0 1] );          

% Optionally show the reference implementation timing data
if ( 0 )
  plot( data(:,1), data(:,2), 'MarkerSize', 8, 'LineWidth', 2, ...
        'DisplayName', 'Reference', 'Color', [0 0 0] );
end

% Adjust the x-axis and y-axis range to start at 0
v = axis;                  % extract the current ranges of the graph
axis( [ 0 v(2) 0 v(4) ] )  % start the x axis and y axis at zero

legend1 = legend( axes1, 'show' );
set( legend1, 'Location', 'northwest', 'FontSize', 18) ;

% Uncomment if you want to create a pdf for the graph
% print( 'Plot_IJP_Timing.pdf', '-dpdf' );
%% Plotting performance (rate of computation)
% We will often examine the rate at which Gemm_IJP.c  compute rather than the 
% time required for completing the computation.
% 
% * When all matrices are $n \times n$, we know that a matrix-matrix  multiplication$ 
% A B + C$ requires $2n^3$ floating point operations (flops).  
% * This means that the number of operations performed per second is given by 
% ${2 n^3}/{t}$ flops, where $t$ is the time, in seconds, for computing the multiplication.  
% * Now, a typical current core can perform billions of flops per second, so 
% instead we report performance in GFLOPS. (billions of flops per second): ${2 
% n^3}/{t} \times 10^{-9}$.  This is reported computed in the third (for the reference 
% implementation) and fifth colum (for IJP) of the data file. 

% Create figure
figure2 = figure('Name','GFLOPS');

% Create axes, labels, legends.  In future routines for plotting performance, 
% the next few lines will be hidden in the script.
axes2 = axes('Parent',figure2);
hold(axes2,'on');
ylabel( 'GFLOPS', 'FontName', 'Helvetica Neue' );
xlabel( 'matrix dimension m=n=k', 'FontName', 'Helvetica Neue' );
box(axes2,'on');
set( axes2, 'FontName', 'Helvetica Neue', 'FontSize', 18);
             
% Plot time data for IJP  
% Important: the myplot routine is a wrapper to plot that gets around 
% a incompatibility between MATLAB and Octave regarding the 'DisplayName'
% parameter.  It is important to keep the list of parameters exactly as is,
% with the exact some number of parameters.
plot( data(:,1), data(:,5), 'DisplayName', 'IJP', 'MarkerSize', 8, 'LineWidth', 2, ...
      'Marker', 'o', 'LineStyle', '-.', 'Color', [0 0 1] );

% Optionally show the reference implementation performance data
if ( 0 )
  plot( data(:,1), data(:,3), 'MarkerSize', 8, 'LineWidth', 2, ...
        'DisplayName', 'Ref', 'Color', [0 0 0] );
end

% Adjust the x-axis and y-axis range to start at 0
v = axis;                   % extract the current ranges
axis( [ 0 v(2) 0 v(4) ] )   % start the x axis and y axis at zero

% Optionally change the top of the graph to capture the theoretical peak
if ( 0 )
    turbo_clock_rate = 2.6;
    flops_per_cycle = 16;
    peak_gflops = turbo_clock_rate * flops_per_cycle;

    axis( [ 0 v(2) 0 peak_gflops ] )  
end

legend2 = legend( axes2, 'show' );
set( legend2, 'Location', 'northwest', 'FontSize', 18) ;

% Uncomment if you want to create a pdf for the graph
% print( 'Plot_IJP_GFLOPS.pdf', '-dpdf' );
%%