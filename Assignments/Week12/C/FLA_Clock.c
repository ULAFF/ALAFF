#if defined(__APPLE__) || defined(__MACH__)
#include <AvailabilityMacros.h>
  #include <mach/mach_time.h>
#else
  #include <time.h>
#endif

double FLA_Clock_helper( void );

// A global variable used when FLA_Clock_helper() is defined in terms of
// clock_gettime()/gettimeofday().
double gtod_ref_time_sec = 0.0;

double FLA_Clock( void )
{
	return FLA_Clock_helper();
}

#if defined(__APPLE__) || defined(__MACH__)

double FLA_Clock_helper()
{
    mach_timebase_info_data_t timebase;
    mach_timebase_info( &timebase );

    uint64_t nsec = mach_absolute_time();

    double the_time = (double) nsec * 1.0e-9 * timebase.numer / timebase.denom;

    if ( gtod_ref_time_sec == 0.0 )
        gtod_ref_time_sec = the_time;

    return the_time - gtod_ref_time_sec;
}

#else

double FLA_Clock_helper()
{
    double the_time, norm_sec;
    struct timespec ts;

    clock_gettime( CLOCK_MONOTONIC, &ts );

    if ( gtod_ref_time_sec == 0.0 )
        gtod_ref_time_sec = ( double ) ts.tv_sec;

    norm_sec = ( double ) ts.tv_sec - gtod_ref_time_sec;

    the_time = norm_sec + ts.tv_nsec * 1.0e-9;

    return the_time;
}

#endif
