#include <stdio.h>
#include <math.h>
#include <time.h>

#include "FLAME.h"
FLA_Error REF_LU( FLA_Obj, int );

FLA_Error LU_unb_var1( FLA_Obj );
FLA_Error LU_unb_var2( FLA_Obj );
FLA_Error LU_unb_var3( FLA_Obj );
FLA_Error LU_unb_var4( FLA_Obj );
FLA_Error LU_unb_var5( FLA_Obj );

FLA_Error LU_blk_var1( FLA_Obj, int );
FLA_Error LU_blk_var2( FLA_Obj, int );
FLA_Error LU_blk_var3( FLA_Obj, int );
FLA_Error LU_blk_var4( FLA_Obj, int );
FLA_Error LU_blk_var5( FLA_Obj, int );


/* Various constants that control what gets timed */

#define TRUE 1
#define FALSE 0


/* Indicate which versions to time */
#define TIME_UNB_VAR1 FALSE
#define TIME_UNB_VAR2 FALSE
#define TIME_UNB_VAR3 FALSE
#define TIME_UNB_VAR4 FALSE
#define TIME_UNB_VAR5 TRUE
#define TIME_BLK_VAR1 FALSE
#define TIME_BLK_VAR2 FALSE
#define TIME_BLK_VAR3 FALSE
#define TIME_BLK_VAR4 FALSE
#define TIME_BLK_VAR5 TRUE

int main(int argc, char *argv[])
{
  int 
    n,             // current problem size being timed
    nfirst,        // smallest problem size to be timed
    nlast,         // largest problem size to be timed
    ninc,          // increment between problem sizes
    nlast_unb,     // largest problem size for unblocked 
    i,             // index into array of timing data
    irep,          // index for the repeated experiments
    nrepeats,      // number of repeats
    nb_alg;        // algorithmic block size

  double
    dtime,         // time for current experiment
    dtime_best,    // best time so far for current problem size
    gflops,        // total billions of floating point operations performed
    max_gflops,     // max gflops attainable by processor
    diff,          // maximum different between reference and current implementation
    d_n;           // holds double precision number n to shift the diagonal of the matrix
      
  
  FLA_Obj
    A,             // A for current experiment
    Aref,          // A computed by reference implementation
    Aold,          // Original contents of A
    delta;         // Shift so that A needs not be pivoted
  /* Initialize FLAME */
  FLA_Init( );

  /* Every time trial is repeated "repeat" times and the fastest run in recorded */
  printf( "%% number of repeats:" );
  scanf( "%d", &nrepeats );
  printf( "%% %d\n", nrepeats );

  /* Enter the max GFLOPS attainable 
     This is used to set the y-axis range for the graphs. Here is how
     you figure out what to enter (on Linux machines):
     1) more /proc/cpuinfo   (this lists the contents of this file).
     2) read through this and figure out the clock rate of the machine (in GHz).
     3) Find out (from an expert of from the web) the number of floating point
        instructions that can be performed per core per clock cycle.
     4) Figure out if you are using "multithreaded BLAS" which automatically
        parallelize calls to the Basic Linear Algebra Subprograms.  If so,
        check how many cores are available.
     5) Multiply 2) x 3) x 4) and enter this in response to the below.

     If you enter a value for max GFLOPS that is lower that the maximum that
     is observed in the experiments, then the top of the graph is set to the 
     observed maximum.  Thus, one possibility is to simply set this to 0.0.
  */

  printf( "%% enter max GFLOPS:" );
  scanf( "%lf", &max_gflops );
  printf( "%% %lf\n", max_gflops );

  /* Enter the algorithmic block size */
  printf( "%% enter nb_alg:" );
  scanf( "%d", &nb_alg );
  printf( "%% %d\n", nb_alg );

  /* Timing trials for matrix sizes n=nfirst to nlast in increments 
     of ninc will be performed.  Unblocked versions are only tested to
     nlast_unb */
  printf( "%% enter nfirst, nlast, ninc, nlast_unb:" );
  scanf( "%d%d%d%d", &nfirst, &nlast, &ninc, &nlast_unb );
  printf( "%% %d %d %d %d\n", nfirst, nlast, ninc, nlast_unb );

  i = 1;
  /* Time a range of problem sizes */
  for ( n=nfirst; n<= nlast; n+=ninc ){
   
    /* Allocate space for the matrices */
    FLA_Obj_create( FLA_DOUBLE, n, n, 1, n, &A );
    FLA_Obj_create( FLA_DOUBLE, n, n, 1, n, &Aref );
    FLA_Obj_create( FLA_DOUBLE, n, n, 1, n, &Aold );
    FLA_Obj_create( FLA_DOUBLE, 1, 1, 1, 1, &delta );

    /* Generate random matrix A and save in Aold */
    FLA_Random_matrix( Aold );

    /* Add something large (n) so that no pivoting is required */
    d_n = ( double ) n;
    *( ( double * ) FLA_Obj_buffer_at_view( delta ) ) = d_n;
    FLA_Shift_diag( FLA_NO_CONJUGATE, delta, Aold );
    
    /* Set gflops = billions of floating point operations that will be performed */
    gflops = 2.0/3.0 * n * n * n * 1.0e-09;

    /* Time the reference implementation */
    if ( n <= nlast_unb )
    {
      for ( irep=0; irep<nrepeats; irep++ ){
	FLA_Copy( Aold, Aref );
    
	dtime = FLA_Clock();
    
	REF_LU( Aref, nb_alg );
    
	dtime = FLA_Clock() - dtime;
    
	if ( irep == 0 ) 
	  dtime_best = dtime;
	else
	  dtime_best = ( dtime < dtime_best ? dtime : dtime_best );
      }
  
      printf( "data_REF( %d, 1:2 ) = [ %d %le ];\n", i, n,
	      gflops / dtime_best );
      fflush( stdout );
    }  

    /* Time FLA_LU_nopiv */

    for ( irep=0; irep<nrepeats; irep++ ){
      FLA_Copy( Aold, A );

      dtime = FLA_Clock();

      FLA_LU_nopiv( A );

      dtime = FLA_Clock() - dtime;

      if ( irep == 0 ) 
	dtime_best = dtime;
      else
	dtime_best = ( dtime < dtime_best ? dtime : dtime_best );
    }

    printf( "data_FLAME( %d, 1:2 ) = [ %d %le ];\n", i, n,
            gflops / dtime_best );

    if ( gflops / dtime_best > max_gflops ) 
      max_gflops = gflops / dtime_best;

    fflush( stdout );


    /* Time the your implementations */


    /* Variant 1 unblocked */
    
#if TIME_UNB_VAR1 == TRUE
    if ( n <= nlast_unb ){
      for ( irep=0; irep<nrepeats; irep++ ){

	FLA_Copy( Aold, A );
    
	dtime = FLA_Clock();

	LU_unb_var1( A );

	dtime = FLA_Clock() - dtime;

	if ( irep == 0 ) 
	  dtime_best = dtime;
	else
	  dtime_best = ( dtime < dtime_best ? dtime : dtime_best );
      }    

      diff = FLA_Max_elemwise_diff( A, Aref );

      printf( "data_unb_var1( %d, 1:3 ) = [ %d %le  %le];\n", i, n,
	      gflops / dtime_best, diff );
      fflush( stdout );
    }
#endif
    
    /* Variant 1 blocked */

#if TIME_BLK_VAR1 == TRUE
    for ( irep=0; irep<nrepeats; irep++ ){
      FLA_Copy( Aold, A );
    
      dtime = FLA_Clock();

      LU_blk_var1( A, nb_alg );

      dtime = FLA_Clock() - dtime;

      if ( irep == 0 ) 
	dtime_best = dtime;
      else
	dtime_best = ( dtime < dtime_best ? dtime : dtime_best );
    }

    diff = FLA_Max_elemwise_diff( A, Aref );

    printf( "data_blk_var1( %d, 1:3 ) = [ %d %le  %le];\n", i, n,
            gflops / dtime_best, diff );
    fflush( stdout );
#endif


    /* Variant 2 unblocked */

#if TIME_UNB_VAR2 == TRUE
    if ( n <= nlast_unb ){
      for ( irep=0; irep<nrepeats; irep++ ){
	
	FLA_Copy( Aold, A );
	
	dtime = FLA_Clock();

	LU_unb_var2( A );

	dtime = FLA_Clock() - dtime;
	
	if ( irep == 0 ) 
	  dtime_best = dtime;
	else
	  dtime_best = ( dtime < dtime_best ? dtime : dtime_best );
      }    
      
      diff = FLA_Max_elemwise_diff( A, Aref );
      
      printf( "data_unb_var2( %d, 1:3 ) = [ %d %le  %le];\n", i, n,
	      gflops / dtime_best, diff );
      fflush( stdout );
    }
#endif

    /* Variant 2 blocked */

#if TIME_BLK_VAR2 == TRUE
    for ( irep=0; irep<nrepeats; irep++ ){
      FLA_Copy( Aold, A );
    
      dtime = FLA_Clock();

      LU_blk_var2( A, nb_alg );

      dtime = FLA_Clock() - dtime;

      if ( irep == 0 ) 
	dtime_best = dtime;
      else
	dtime_best = ( dtime < dtime_best ? dtime : dtime_best );
    }

    diff = FLA_Max_elemwise_diff( A, Aref );

    printf( "data_blk_var2( %d, 1:3 ) = [ %d %le  %le];\n", i, n,
            gflops / dtime_best, diff );
    fflush( stdout );
#endif

    /* Variant 3 unblocked */

#if TIME_UNB_VAR3 == TRUE
    if ( n <= nlast_unb ){
      for ( irep=0; irep<nrepeats; irep++ ){
	
	FLA_Copy( Aold, A );
	
	dtime = FLA_Clock();
	
	LU_unb_var3( A );

	dtime = FLA_Clock() - dtime;
	
	if ( irep == 0 ) 
	  dtime_best = dtime;
	else
	  dtime_best = ( dtime < dtime_best ? dtime : dtime_best );
      }    
      
      diff = FLA_Max_elemwise_diff( A, Aref );
      
      printf( "data_unb_var3( %d, 1:3 ) = [ %d %le  %le];\n", i, n,
	      gflops / dtime_best, diff );
      fflush( stdout );
    }
#endif

    /* Variant 3 blocked */

#if TIME_BLK_VAR3 == TRUE
    for ( irep=0; irep<nrepeats; irep++ ){
      FLA_Copy( Aold, A );
    
      dtime = FLA_Clock();

      LU_blk_var3( A, nb_alg );

      dtime = FLA_Clock() - dtime;

      if ( irep == 0 ) 
	dtime_best = dtime;
      else
	dtime_best = ( dtime < dtime_best ? dtime : dtime_best );
    }

    diff = FLA_Max_elemwise_diff( A, Aref );

    printf( "data_blk_var3( %d, 1:3 ) = [ %d %le  %le];\n", i, n,
            gflops / dtime_best, diff );
    fflush( stdout );
#endif

    /* Variant 4 unblocked */

#if TIME_UNB_VAR4 == TRUE
    if ( n <= nlast_unb ){
      for ( irep=0; irep<nrepeats; irep++ ){
	
	FLA_Copy( Aold, A );
	
	dtime = FLA_Clock();
	
	LU_unb_var4( A );

	dtime = FLA_Clock() - dtime;
	
	if ( irep == 0 ) 
	  dtime_best = dtime;
	else
	  dtime_best = ( dtime < dtime_best ? dtime : dtime_best );
      }    
      
      diff = FLA_Max_elemwise_diff( A, Aref );
      
      printf( "data_unb_var4( %d, 1:3 ) = [ %d %le  %le];\n", i, n,
	      gflops / dtime_best, diff );
      fflush( stdout );
    }
#endif

    /* Variant 4 blocked */

#if TIME_BLK_VAR4 == TRUE
    for ( irep=0; irep<nrepeats; irep++ ){
      FLA_Copy( Aold, A );
    
      dtime = FLA_Clock();

      LU_blk_var4( A, nb_alg );

      dtime = FLA_Clock() - dtime;

      if ( irep == 0 ) 
	dtime_best = dtime;
      else
	dtime_best = ( dtime < dtime_best ? dtime : dtime_best );
    }

    diff = FLA_Max_elemwise_diff( A, Aref );

    printf( "data_blk_var4( %d, 1:3 ) = [ %d %le  %le];\n", i, n,
            gflops / dtime_best, diff );
    fflush( stdout );
#endif

    /* Variant 5 unblocked */

#if TIME_UNB_VAR5 == TRUE
    if ( n <= nlast_unb ){
      for ( irep=0; irep<nrepeats; irep++ ){
	
	FLA_Copy( Aold, A );
	
	dtime = FLA_Clock();
	
	LU_unb_var5( A );

	dtime = FLA_Clock() - dtime;
	
	if ( irep == 0 ) 
	  dtime_best = dtime;
	else
	  dtime_best = ( dtime < dtime_best ? dtime : dtime_best );
      }    
      
      diff = FLA_Max_elemwise_diff( A, Aref );
      
      printf( "data_unb_var5( %d, 1:3 ) = [ %d %le  %le];\n", i, n,
	      gflops / dtime_best, diff );
      fflush( stdout );
    }
#endif

    /* Variant 5 blocked */

#if TIME_BLK_VAR5 == TRUE
    for ( irep=0; irep<nrepeats; irep++ ){
      FLA_Copy( Aold, A );
    
      dtime = FLA_Clock();

      LU_blk_var5( A, nb_alg );

      dtime = FLA_Clock() - dtime;

      if ( irep == 0 ) 
	dtime_best = dtime;
      else
	dtime_best = ( dtime < dtime_best ? dtime : dtime_best );
    }

    diff = FLA_Max_elemwise_diff( A, Aref );

    printf( "data_blk_var5( %d, 1:3 ) = [ %d %le  %le];\n", i, n,
            gflops / dtime_best, diff );
    fflush( stdout );
#endif


    FLA_Obj_free( &A );
    FLA_Obj_free( &Aold );
    FLA_Obj_free( &Aref );
    FLA_Obj_free( &delta );
    printf( "\n" );

    i++;
  }

  /* Print the MATLAB commands to plot the data */

  /* Delete all existing figures */
  printf( "close all\n" );


/* Plot the performance of FLAME */
printf( "plot( data_FLAME( :,1 ), data_FLAME( :, 2 ), 'k--', 'DisplayName', 'LUnopiv' ); \n" );

/* Indicate that you want to add to the existing plot */
printf( "hold on\n" );

/* Plot the performance of the reference implementation */
printf( "plot( data_REF( :,1 ), data_REF( :, 2 ), 'k-', 'DisplayName', 'REF'  ); \n" );

  /* Plot the performance of your implementations */
#if TIME_UNB_VAR1 == TRUE
  printf( "plot( data_unb_var1( :,1 ), data_unb_var1( :, 2 ), 'y-.x', 'DisplayName', 'unbVar1' ); \n" );
#endif
#if TIME_UNB_VAR2 == TRUE
  printf( "plot( data_unb_var2( :,1 ), data_unb_var2( :, 2 ), 'g-.o', 'DisplayName', 'unbVar2' ); \n" );
#endif
#if TIME_UNB_VAR3 == TRUE
  printf( "plot( data_unb_var3( :,1 ), data_unb_var3( :, 2 ), 'b-.+', 'DisplayName', 'unbVar3' ); \n" );
#endif
#if TIME_UNB_VAR4 == TRUE
  printf( "plot( data_unb_var4( :,1 ), data_unb_var4( :, 2 ), 'm-.v', 'DisplayName', 'unbVar4' ); \n" );
#endif
#if TIME_UNB_VAR5 == TRUE
  printf( "plot( data_unb_var5( :,1 ), data_unb_var5( :, 2 ), 'r-.^', 'DisplayName', 'unbVar5' ); \n" );
#endif
#if TIME_BLK_VAR1 == TRUE
  printf( "plot( data_blk_var1( :,1 ), data_blk_var1( :, 2 ), 'y-x', 'DisplayName', 'blkVar1' ); \n" );
#endif
#if TIME_BLK_VAR2 == TRUE
  printf( "plot( data_blk_var2( :,1 ), data_blk_var2( :, 2 ), 'g-o', 'DisplayName', 'blkVar2' ); \n" );
#endif
#if TIME_BLK_VAR3 == TRUE
  printf( "plot( data_blk_var3( :,1 ), data_blk_var3( :, 2 ), 'b-+', 'DisplayName', 'blkbVar3'); \n" );
#endif
#if TIME_BLK_VAR4 == TRUE
  printf( "plot( data_blk_var4( :,1 ), data_blk_var4( :, 2 ), 'm-v' 'DisplayName', 'blkbVar4'); \n" );
#endif
#if TIME_BLK_VAR5 == TRUE
  printf( "plot( data_blk_var5( :,1 ), data_blk_var5( :, 2 ), 'r-^', 'DisplayName', 'blkbVar5'); \n" );
#endif


  printf( "xlabel( 'matrix dimension m=n' );\n");
  printf( "ylabel( 'GFLOPS/sec.' );\n");

  printf( "legend();\n" );
  
//  printf( "axis( [ 0 %d 0 %3.1f ] ); \n", nlast, max_gflops );

  printf( "hold off \n");
  FLA_Finalize( );

  exit( 0 );
}
