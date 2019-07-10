# mkr-mom
Safety wrapper for the MKR token so that MKR can govern MKR.

Hides all authed MKR functions save `mint` and `burn`. Crucially, this includes
the `stop` function which could be used to completely disable system governance.
