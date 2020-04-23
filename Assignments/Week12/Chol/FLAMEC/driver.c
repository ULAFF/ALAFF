#include <stdio.h>
#include <math.h>
#include <time.h>

#include "FLAME.h"
#include "Chol_prototypes.h"

/* Various constants that control what gets timed */

#define TRUE 1
#define FALSE 0

#define OCTAVE        TRUE
#define TIME_UNB_VAR1 TRUE
#define TIME_UNB_VAR2 TRUE
#define TIME_UNB_VAR3 TRUE
#define TIME_BLK_VAR1 TRUE
#define TIME_BLK_VAR2 TRUE
#define TIME_BLK_VAR3 TRUE
#define TIME_LAPACK   FALSE

int main(int argc, char *argv[])
{
  int n, nfirst, nlast, ninc, nlast_unb, i, irep,
    nrepeats, nb_alg;

  double
    dtime, dtime_best, 
    gflops, max_gflops,
    diff, d_n;

  FLA_Obj
    A, Aref, Aold, delta;
  
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
  for ( n=nfirst; n<= nlast; n+=ninc ){
   
    /* Allocate space for the matrices */
    FLA_Obj_create( FLA_DOUBLE, n, n, 1, n, &A );
    FLA_Obj_create( FLA_DOUBLE, n, n, 1, n, &Aref );
    FLA_Obj_create( FLA_DOUBLE, n, n, 1, n, &Aold );
    FLA_Obj_create( FLA_DOUBLE, 1, 1, 1, 1, &delta );

    /* Generate random matrix A and save in Aold */
    FLA_Random_matrix( Aold );

    /* Add something large to the diagonal to make sure it isn't ill-conditionsed */
    d_n = ( double ) n;
    *( ( double * ) FLA_Obj_buffer_at_view( delta ) ) = d_n;
    FLA_Shift_diag( FLA_NO_CONJUGATE, delta, Aold );
    
    /* Set gflops = billions of floating point operations that will be performed */
    gflops = 1.0/3.0 * n * n * n * 1.0e-09;

    /* Time the reference implementation */
#if TIME_LAPACK == TRUE

#else
    //    if ( n <= nlast_unb )
#endif
    {
      for ( irep=0; irep<nrepeats; irep++ ){
	FLA_Copy( Aold, Aref );
    
	dtime = FLA_Clock();
    
	REF_Chol( TIME_LAPACK, Aref, nb_alg );
    
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

    /* Time FLA_Chol */

    for ( irep=0; irep<nrepeats; irep++ ){
      FLA_Copy( Aold, A );

      dtime = FLA_Clock();

      FLA_Chol( FLA_LOWER_TRIANGULAR, A );

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
    
    if ( n <= nlast_unb ){
      for ( irep=0; irep<nrepeats; irep++ ){

	FLA_Copy( Aold, A );
    
	dtime = FLA_Clock();

#if TIME_UNB_VAR1 == TRUE
	Chol_unb_var1( A );
#else
	REF_Chol( TIME_LAPACK, A, nb_alg );
#endif


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

    /* Variant 1 blocked */

    for ( irep=0; irep<nrepeats; irep++ ){
      FLA_Copy( Aold, A );
    
      dtime = FLA_Clock();

#if TIME_BLK_VAR1 == TRUE
      Chol_blk_var1( A, nb_alg );
#else
      REF_Chol( TIME_LAPACK, A, nb_alg );
#endif

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


    /* Variant 2 unblocked */
    if ( n <= nlast_unb ){
      for ( irep=0; irep<nrepeats; irep++ ){
	
	FLA_Copy( Aold, A );
	
	dtime = FLA_Clock();
	

#if TIME_UNB_VAR2 == TRUE
	Chol_unb_var2( A );
#else	
      REF_Chol( TIME_LAPACK, A, nb_alg );
#endif

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

    /* Variant 2 blocked */

    for ( irep=0; irep<nrepeats; irep++ ){
      FLA_Copy( Aold, A );
    
      dtime = FLA_Clock();

#if TIME_BLK_VAR2 == TRUE
      Chol_blk_var2( A, nb_alg );
#else
      REF_Chol( TIME_LAPACK, A, nb_alg );
#endif

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

    /* Variant 3 unblocked */
    if ( n <= nlast_unb ){
      for ( irep=0; irep<nrepeats; irep++ ){
	
	FLA_Copy( Aold, A );
	
	dtime = FLA_Clock();
	
#if TIME_UNB_VAR3 == TRUE
	Chol_unb_var3( A );
#else
      REF_Chol( TIME_LAPACK, A, nb_alg );
#endif

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

    /* Variant 3 blocked */

    for ( irep=0; irep<nrepeats; irep++ ){
      FLA_Copy( Aold, A );
    
      dtime = FLA_Clock();

#if TIME_BLK_VAR3 == TRUE
      Chol_blk_var3( A, nb_alg );
#else
      REF_Chol( TIME_LAPACK, A, nb_alg );
#endif

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


#if OCTAVE == TRUE
  /* Plot the performance of FLAME */
  printf( "plot( data_FLAME( :,1 ), data_FLAME( :, 2 ), '-k;libflame;' ); \n" );

  /* Indicate that you want to add to the existing plot */
  printf( "hold on\n" );

  /* Plot the performance of the reference implementation */
  printf( "plot( data_REF( :,1 ), data_REF( :, 2 ), '-m;reference;' ); \n" );

  /* Plot the performance of your implementations */
  printf( "plot( data_unb_var1( :,1 ), data_unb_var1( :, 2 ), \"-rx;UnbVar1;\" ); \n" );
  printf( "plot( data_unb_var2( :,1 ), data_unb_var2( :, 2 ), \"-go;UnbVar2;\" ); \n" );
  printf( "plot( data_unb_var3( :,1 ), data_unb_var3( :, 2 ), \"-b*;UnbVar3;\" ); \n" );
  printf( "plot( data_blk_var1( :,1 ), data_blk_var1( :, 2 ), \"-rx;BlkVar1;\", \"markersize\", 3 ); \n" );
  printf( "plot( data_blk_var2( :,1 ), data_blk_var2( :, 2 ), \"-go;BlkVar2;\", \"markersize\", 3  ); \n" );
  printf( "plot( data_blk_var3( :,1 ), data_blk_var3( :, 2 ), \"-b*;BlkVar3;\", \"markersize\", 3  ); \n" );

#else

  /* Plot the performance of FLAME */
  printf( "plot( data_FLAME( :,1 ), data_FLAME( :, 2 ), 'k--' ); \n" );

  /* Indicate that you want to add to the existing plot */
  printf( "hold on\n" );

  /* Plot the performance of the reference implementation */
  printf( "plot( data_REF( :,1 ), data_REF( :, 2 ), 'k-' ); \n" );

  /* Plot the performance of your implementations */
  printf( "plot( data_unb_var1( :,1 ), data_unb_var1( :, 2 ), 'r-.x' ); \n" );
  printf( "plot( data_unb_var2( :,1 ), data_unb_var2( :, 2 ), 'g-.o' ); \n" );
  printf( "plot( data_unb_var3( :,1 ), data_unb_var3( :, 2 ), 'b-.*' ); \n" );
  printf( "plot( data_blk_var1( :,1 ), data_blk_var1( :, 2 ), 'r-x'); \n" );
  printf( "plot( data_blk_var2( :,1 ), data_blk_var2( :, 2 ), 'g-o'); \n" );
  printf( "plot( data_blk_var3( :,1 ), data_blk_var3( :, 2 ), 'b-*'); \n" );
#endif

  printf( "hold off \n");

  printf( "xlabel( 'matrix dimension m=n' );\n");
  printf( "ylabel( 'GFLOPS/sec.' );\n");
  printf( "axis( [ 0 %d 0 %3.1f ] ); \n", nlast, max_gflops );

#if OCTAVE == TRUE
  printf( "legend( 2 ); \n" );

  printf(" print -landscape -solid -color -deps -F:24 Chol.eps\n" );
#else
  printf( "legend( 'FLA Chol', ...\n");
  printf( "        'Simple loops', ...\n");
  printf( "        'unb var1', ...\n");
  printf( "        'unb var2', ...\n");
  printf( "        'unb var3', ...\n");
  printf( "        'blk var1', ...\n");
  printf( "        'blk var2', ...\n");
  printf( "        'blk var3', 2);\n");

  printf( "print -r100 -dpdf Chol.pdf\n");
#endif

  FLA_Finalize( );

  exit( 0 );
}
